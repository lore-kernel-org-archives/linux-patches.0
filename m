Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A913DBB7;
	Tue, 23 Jan 2024 01:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971996; cv=none; b=l9dpbWC+di0n0/XyblrVf3W6ZmQE0Ij0ZdVOIHuJi7CFsCImPR2yrX6FXXwQMygtKDFHsGp8+MriIFL7Ol9tJ8nuAoRb5O4tcoOXcremuO1Cq1yg0phPanDHe2NjGkQmkTkFMD4cBDnJHYS8LS0/6Y4pg5l2Bps2G74ESxuFais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971996; c=relaxed/simple;
	bh=9OP6R7S7BLvOgYtITc+1faAYcFOEUT3MKAn9R2DRtRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar8NBMAIVEwbR3Dou+yAK5wxTcfb3QX15DIA+PLf/R/KCXUOpx7ymV/c+2I1KtMYGOboCrokIt18lf/seg5bD7P2BKq+OvU3MncJ0dzoEiU0D0afU6kTbEunjdUqlHAxTLtfObT33VLU33gMNAVcI6jC/WuBmzjuQkJe5xvErHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2Sy7Ryh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2Sy7Ryh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E763C433F1;
	Tue, 23 Jan 2024 01:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971996;
	bh=9OP6R7S7BLvOgYtITc+1faAYcFOEUT3MKAn9R2DRtRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2Sy7Ryhgp5tI627C5r4VOEqcFZhzP92ItMGUyb8KW1/ikbWK1ltIKP7byxXB5+5i
	 SAg2zlpVSDaIfL24jo0s7AJMwRY6dIwpACknourOrtbiKeAXPUOjLdoOXSGMfLWhag
	 bwMknUl0jAgGmHUPEyko52NNFmVmzrGJF2R+0lBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/286] i2c: s3c24xx: fix transferring more than one message in polling mode
Date: Mon, 22 Jan 2024 15:59:52 -0800
Message-ID: <20240122235743.066816523@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 990489e1042c6c5d6bccf56deca68f8dbeed8180 ]

To properly handle ACK on the bus when transferring more than one
message in polling mode, move the polling handling loop from
s3c24xx_i2c_message_start() to s3c24xx_i2c_doxfer(). This way
i2c_s3c_irq_nextbyte() is always executed till the end, properly
acknowledging the IRQ bits and no recursive calls to
i2c_s3c_irq_nextbyte() are made.

While touching this, also fix finishing transfers in polling mode by
using common code path and always waiting for the bus to become idle
and disabled.

Fixes: 117053f77a5a ("i2c: s3c2410: Add polling mode support")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-s3c2410.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 687588834fc8..fd0969cd7dc6 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -286,16 +286,6 @@ static void s3c24xx_i2c_message_start(struct s3c24xx_i2c *i2c,
 
 	stat |= S3C2410_IICSTAT_START;
 	writel(stat, i2c->regs + S3C2410_IICSTAT);
-
-	if (i2c->quirks & QUIRK_POLL) {
-		while ((i2c->msg_num != 0) && is_ack(i2c)) {
-			i2c_s3c_irq_nextbyte(i2c, stat);
-			stat = readl(i2c->regs + S3C2410_IICSTAT);
-
-			if (stat & S3C2410_IICSTAT_ARBITR)
-				dev_err(i2c->dev, "deal with arbitration loss\n");
-		}
-	}
 }
 
 static inline void s3c24xx_i2c_stop(struct s3c24xx_i2c *i2c, int ret)
@@ -702,7 +692,7 @@ static void s3c24xx_i2c_wait_idle(struct s3c24xx_i2c *i2c)
 static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
 			      struct i2c_msg *msgs, int num)
 {
-	unsigned long timeout;
+	unsigned long timeout = 0;
 	int ret;
 
 	ret = s3c24xx_i2c_set_master(i2c);
@@ -722,16 +712,19 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
 	s3c24xx_i2c_message_start(i2c, msgs);
 
 	if (i2c->quirks & QUIRK_POLL) {
-		ret = i2c->msg_idx;
+		while ((i2c->msg_num != 0) && is_ack(i2c)) {
+			unsigned long stat = readl(i2c->regs + S3C2410_IICSTAT);
 
-		if (ret != num)
-			dev_dbg(i2c->dev, "incomplete xfer (%d)\n", ret);
+			i2c_s3c_irq_nextbyte(i2c, stat);
 
-		goto out;
+			stat = readl(i2c->regs + S3C2410_IICSTAT);
+			if (stat & S3C2410_IICSTAT_ARBITR)
+				dev_err(i2c->dev, "deal with arbitration loss\n");
+		}
+	} else {
+		timeout = wait_event_timeout(i2c->wait, i2c->msg_num == 0, HZ * 5);
 	}
 
-	timeout = wait_event_timeout(i2c->wait, i2c->msg_num == 0, HZ * 5);
-
 	ret = i2c->msg_idx;
 
 	/*
-- 
2.43.0



