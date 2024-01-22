Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3D050A77;
	Tue, 23 Jan 2024 00:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970379; cv=none; b=bqo1DLnAV0iNWOhCqoXHHzHE7sCA23pWawaEnZRsUxfutCUf73I3cLL3L6pAyskWQ5FC5pBN9utf5/xkDuGOFeaJjBNwo/stJx0jTrVsgpLiPf8yhSPTLt+iFVZDXN2x7PvCQ9Zx+wYcQccF9gtcKCTib/9ACq/NvjCmoOLrOf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970379; c=relaxed/simple;
	bh=RS/x/BOVIRZ8kzoRzmHvbAOJjtyAEzwHr1i0kQC3eCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kal7cvzrTWrpw87iGA2RxHVwa5u/abIRwfey+tJYWT9PSQzqxLMbptPVk1kvNQsi7GGBDgTw4P2cAEYtQx55dQH88zIwfYxxRKm3Tn+fSyUuBLFPNF6g/an1XLWzc/SOqARpZgtFa9A/EqZD4hG6ebOqpAZjFbQ5tVKoSUVZWUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8+Qy7H1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8+Qy7H1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DB8C433F1;
	Tue, 23 Jan 2024 00:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970379;
	bh=RS/x/BOVIRZ8kzoRzmHvbAOJjtyAEzwHr1i0kQC3eCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8+Qy7H1qdoAXWHunB+eioZ20zYtxYD9fqVBbebr7aGswCBfZpx35di2+YkRCdIQH
	 W7hE5jXkvwEMmBWcNXXHtO5dya+UjLh7zOHj3C4dNiWEaz0HQvKBeMayszbda44gfN
	 X7WZHAYewNXJ1MIftsEiTB1yjQQHmB5x5/wqBz7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Chanho Park <chanho61.park@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 640/641] i2c: s3c24xx: fix read transfers in polling mode
Date: Mon, 22 Jan 2024 15:59:04 -0800
Message-ID: <20240122235838.306631307@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 0d9cf23ed55d7ba3ab26d617a3ae507863674c8f ]

To properly handle read transfers in polling mode, no waiting for the ACK
state is needed as it will never come. Just wait a bit to ensure start
state is on the bus and continue processing next bytes.

Fixes: 117053f77a5a ("i2c: s3c2410: Add polling mode support")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-s3c2410.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index c56886af724e..bf9a5670ef33 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -216,8 +216,17 @@ static bool is_ack(struct s3c24xx_i2c *i2c)
 	int tries;
 
 	for (tries = 50; tries; --tries) {
-		if (readl(i2c->regs + S3C2410_IICCON)
-			& S3C2410_IICCON_IRQPEND) {
+		unsigned long tmp = readl(i2c->regs + S3C2410_IICCON);
+
+		if (!(tmp & S3C2410_IICCON_ACKEN)) {
+			/*
+			 * Wait a bit for the bus to stabilize,
+			 * delay estimated experimentally.
+			 */
+			usleep_range(100, 200);
+			return true;
+		}
+		if (tmp & S3C2410_IICCON_IRQPEND) {
 			if (!(readl(i2c->regs + S3C2410_IICSTAT)
 				& S3C2410_IICSTAT_LASTBIT))
 				return true;
-- 
2.43.0



