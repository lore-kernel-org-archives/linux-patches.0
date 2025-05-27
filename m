Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAAD27F4CB;
	Tue, 27 May 2025 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366637; cv=none; b=OHsZO728Qz7m3BE5Uq/zSSPZwYGdErO68pZaMjhtCFvrSoSfNcj8tksKKu/G+0/SIcKz4QSrIVJbuI6yJ8v/mn0jFuAdU68gakM/fh5yKZDNa0hXJPKCcSJppztGP2EUW+cdT6X4uSwcS9wKi5OIj8oMNxbYPcz1ANeDimtAmT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366637; c=relaxed/simple;
	bh=7doVSZOSS47QVYFIMItb6Z9WJTLNdrnuAOsqGkbkQS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beEebGXVnl2yZ8rfBXYIycZpa1NW4SBbD3IQM8bBIcH0zfJjfn3a4YVuxaUKJqTeD4KkyDo96QVu7RZvWuoM1Ix6pXmqUMFMFf5/sjv9bDZ9Lp1B9gKib4w+Ft5qzzKWNShx+A1QlcYbH+CbwJ1FabUsMjLQwXls+6TGnu/QYUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09aBQ8lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09aBQ8lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B890C4CEE9;
	Tue, 27 May 2025 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366636;
	bh=7doVSZOSS47QVYFIMItb6Z9WJTLNdrnuAOsqGkbkQS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09aBQ8lRDqlf2g7ouwoePWiDuW2jcIwuzPga94p6yzug5hq9D6uQ0nUQbbbqWfXRS
	 PoGoPNIqDlir7VHVFuMt0z5+vfuQLygFK86D+LjoQ9WrI4MuJCE6N6GrOo++2OxWfR
	 jZDWE+dNJ2EUt2x1h/K8d1Kcir7eF4/97pKt+nvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 133/783] i2c: pxa: fix call balance of i2c->clk handling routines
Date: Tue, 27 May 2025 18:18:50 +0200
Message-ID: <20250527162518.572808447@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Mordan <mordan@ispras.ru>

[ Upstream commit be7113d2e2a6f20cbee99c98d261a1fd6fd7b549 ]

If the clock i2c->clk was not enabled in i2c_pxa_probe(), it should not be
disabled in any path.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250212172803.1422136-1-mordan@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pxa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index cb69884826739..4415a29f749b9 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1503,7 +1503,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
 				i2c->adap.name);
 	}
 
-	clk_prepare_enable(i2c->clk);
+	ret = clk_prepare_enable(i2c->clk);
+	if (ret)
+		return dev_err_probe(&dev->dev, ret,
+				     "failed to enable clock\n");
 
 	if (i2c->use_pio) {
 		i2c->adap.algo = &i2c_pxa_pio_algorithm;
-- 
2.39.5



