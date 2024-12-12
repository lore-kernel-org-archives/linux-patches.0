Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5E220A5EE;
	Thu, 12 Dec 2024 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025196; cv=none; b=jqzEDWFLwaXhzSRkTReMw+wmS2qPG85ZFr4Ki8aPLOXM9uforpcd5+no0kCP28C0c/DcHJ+YdeRQsIfvOrva6rF/Oou/8sEV4t2bWLgvP1Im7VtnweYesNHlRWsZA+Atl6gNhOtc8QahvwZt6MUcZu1F9Xh8xbUGFgNke3iHjBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025196; c=relaxed/simple;
	bh=KhFZsV/w7aj5eZ1pnUXHYtLI8kY6avQkUOqRBCPjCAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wv6uwmr0CCAswBiE8dLSu6eC8GQ6tqP0XBFLlfGf7WlNp2+9mBRA/fab49tkXEt/4vl5rRk/tOgMdtuF4LxcQVq9vFEup4mhH68+4RZWJK1eOJkM4Lyoh2/EpKSa0R7bk0jds+wEyuhfiCFibOXEsL1SFZl4BY/jowONKCmqiC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrjzEPZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrjzEPZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC57C4CECE;
	Thu, 12 Dec 2024 17:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025196;
	bh=KhFZsV/w7aj5eZ1pnUXHYtLI8kY6avQkUOqRBCPjCAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrjzEPZyr/zeI0AZhQ/ABpFGfd/+PYQTSNXH+6uYVOmOb/i0MbBujLmNr0zSE41cT
	 PYKRpnVzI/sFMKUWwEY/oUYE24c4D4546VwP7ur8eFpLqCVkeUGik/JnoXY2sOAeID
	 vwn6aHq1F+3P2QJkTWyvQdps9XFwurxWqKWHLWeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/321] mfd: da9052-spi: Change read-mask to write-mask
Date: Thu, 12 Dec 2024 16:00:07 +0100
Message-ID: <20241212144233.502426565@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 2e3378f6c79a1b3f7855ded1ef306ea4406352ed ]

Driver has mixed up the R/W bit.
The LSB bit is set on write rather than read.
Change it to avoid nasty things to happen.

Fixes: e9e9d3973594 ("mfd: da9052: Avoid setting read_flag_mask for da9052-i2c driver")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20240925-da9052-v2-1-f243e4505b07@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9052-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index 5faf3766a5e20..06c500bf4d57e 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -37,7 +37,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, da9052);
 
 	config = da9052_regmap_config;
-	config.read_flag_mask = 1;
+	config.write_flag_mask = 1;
 	config.reg_bits = 7;
 	config.pad_bits = 1;
 	config.val_bits = 8;
-- 
2.43.0



