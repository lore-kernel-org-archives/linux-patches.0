Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF55127456;
	Tue, 23 Jan 2024 00:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968697; cv=none; b=klYacs7sfJi3fnHgaRwl6jkRwO4B9TczV6q1I3Lnmz8FO2CPwfqj1EfJdQtHGDJBtGF5BxD7dqpBOSi5aI/QEgsvvaW80xS3IYTaEJ1/XWbznNgjdOhg9+VRzFYqOIA0SYWydLaYkBPCROGUVARNgL6m65iF/qLwmj6pZiXnba8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968697; c=relaxed/simple;
	bh=h5BkY5ud8kEgmcj8R2j8tFNrj7F+M6IcE3WmsBY+R6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mf7lbDWsZ5b9pQHAP8Bn2ISkOMuKpnZjf/pPqawypWM69apkEeJt1kPmuZAPXcDqH57byAIisUhVST1Hqsy5L4tXIQptIRJgMfXcSUP2L2vzMhVd6xbjRPtJ3IbleO5V/yFWMIHjNUE3sRLqQi1VUPCo5zXA00cFYTPiAivDR6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQO9wYaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQO9wYaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A71C433F1;
	Tue, 23 Jan 2024 00:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968697;
	bh=h5BkY5ud8kEgmcj8R2j8tFNrj7F+M6IcE3WmsBY+R6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQO9wYaOCkUx3HTrF99aawnkOoH6eNQ9YqUOEq/ZdSFqKHXT7WJOlQlzdLhb0MJxz
	 22q/dx0xLzR4PHj+HLL0qb0vqAYGNtfcxkCe4Vl1clvYgozbkAwcSQF08LXPFLjYvF
	 vq5s/BmRS7WgEs5z+KkTUTdSJhIV6DwXRZHGpdK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/148] i2c: s3c24xx: fix transferring more than one message in polling mode
Date: Mon, 22 Jan 2024 15:58:22 -0800
Message-ID: <20240122235718.526922690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8186af573a02..fe245dfdaf4d 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -296,16 +296,6 @@ static void s3c24xx_i2c_message_start(struct s3c24xx_i2c *i2c,
 
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
@@ -712,7 +702,7 @@ static void s3c24xx_i2c_wait_idle(struct s3c24xx_i2c *i2c)
 static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
 			      struct i2c_msg *msgs, int num)
 {
-	unsigned long timeout;
+	unsigned long timeout = 0;
 	int ret;
 
 	if (i2c->suspended)
@@ -735,16 +725,19 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
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



