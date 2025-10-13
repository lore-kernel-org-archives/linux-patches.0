Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBFA17A2EC;
	Mon, 13 Oct 2025 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369410; cv=none; b=PL9z+iHyKu+ae7NtCKqYG3Lze+PSP1HJ+kQSwMpgXXEPLV3w6WRqCWZa/T5aPc7vIZyktbHF757ghDUQ4skOhSsnmsmQgdTaaOEKNq2qjqkUUH5nIJGW9FLGPOlW90I20l8j+k46AkXzJa4zOiXY+cNX/lDO435VOJCdFxhfsLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369410; c=relaxed/simple;
	bh=dYibk2IFiJjfyiHYAAOReXL+eza/D96/iLZzJjwkQ6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pz5TUjsWs1ZK1s/j7BC2tJk+ffVWzcp7c9omv06DjPrUncTgd7vtIwmDoA7Q+EKboFp8RZuVcCDDcYDFwF4G0X7QERENfdLWDuMKtgXM4r+Li4b3vqsb13hPoJ4Fkp+RJwK3EgGEWtA1mOBoGnmwMedDeeq4sOAEPea2/eU9RDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5VrWrK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5VrWrK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1BBC4CEE7;
	Mon, 13 Oct 2025 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369410;
	bh=dYibk2IFiJjfyiHYAAOReXL+eza/D96/iLZzJjwkQ6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5VrWrK15F1mzkkZJhnOeP+avNGzdBCd+D7eC+UOmDkULSdbYV7SGNNx9gxqUNz/V
	 gGxflOvVVCaOHErAaOqYCz8nmVOGmwuXED0hv5hEqWGO83NsBSa0UCr3YSitEkyITE
	 6HiITL4QHQaEWnz6gNRQAjHvxgom56aNk8c0Yql0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 203/563] i2c: spacemit: check SDA instead of SCL after bus reset
Date: Mon, 13 Oct 2025 16:41:04 +0200
Message-ID: <20251013144418.640263538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit db7720ef50e0103be70a3887bc66e9c909933ad9 ]

After calling spacemit_i2c_conditionally_reset_bus(),
the controller should ensure that the SDA line is release
before proceeding.

Previously, the driver checked the SCL line instead,
which does not guarantee that the bus is truly idle.

This patch changes the check to verify SDA. This ensures
proper bus recovery and avoids potential communication errors
after a conditional reset.

Fixes: 5ea558473fa31 ("i2c: spacemit: add support for SpacemiT K1 SoC")
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-k1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-k1.c b/drivers/i2c/busses/i2c-k1.c
index 9bf9f01aa68bd..848dfaf634f63 100644
--- a/drivers/i2c/busses/i2c-k1.c
+++ b/drivers/i2c/busses/i2c-k1.c
@@ -172,9 +172,9 @@ static void spacemit_i2c_conditionally_reset_bus(struct spacemit_i2c_dev *i2c)
 	spacemit_i2c_reset(i2c);
 	usleep_range(10, 20);
 
-	/* check scl status again */
+	/* check sda again here */
 	status = readl(i2c->base + SPACEMIT_IBMR);
-	if (!(status & SPACEMIT_BMR_SCL))
+	if (!(status & SPACEMIT_BMR_SDA))
 		dev_warn_ratelimited(i2c->dev, "unit reset failed\n");
 }
 
-- 
2.51.0



