Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418B9309DA0;
	Mon, 13 Oct 2025 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369405; cv=none; b=r+iH6MGLI/bvnuGdSgrahq9C2+OONvBQvnYl5RqXLmfbIC91O/t8GkD9dEKr+skFCWodeSDVFMp0YGb+QpDt735QqT3sOlJeAZmGAoaw4lXoIWTPysnisSNmD/viXgqGpJJXBn43NZ2yJSchX5Cqkgw4kw03wq7h9usw62pP1d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369405; c=relaxed/simple;
	bh=2JCPvpq5MqdDJ6dQlvYDKz+J392iaQjbpr15JaIelTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onPT5Pf8hX4m7pHMUhbrDBXt+mMWKe+M1wPthvJCtnYDLvk/D6bJx14ZFE2mDGdrBirnYwI3foAhNHZRzK/ddmiKEucgD1TQ5BnGpSlYk7YJUPqfxWS77W8A82lnT6umEWbuTEeYCP8p/RqZQKXoqCFh6bTxDRgoKUeIaHzdP4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtdHG3Bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtdHG3Bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97E0C4CEE7;
	Mon, 13 Oct 2025 15:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369405;
	bh=2JCPvpq5MqdDJ6dQlvYDKz+J392iaQjbpr15JaIelTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtdHG3BtvKVAJajH7S4avsmfrYM4t2Fnvc5YMS9iO7q/E65hGyEPJASJJR/RltPVF
	 NDMQY9JmN/RKvkGKWu3JC4+Z3jddS5+9YFMG9sByo91uYTx91T2uNdNBmhV0xtv99u
	 bNOHu0wfbXF9DCcFUUJJa61zCvMyDRdFcduxMSA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 201/563] i2c: spacemit: remove stop function to avoid bus error
Date: Mon, 13 Oct 2025 16:41:02 +0200
Message-ID: <20251013144418.568740203@linuxfoundation.org>
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

[ Upstream commit 445522fe7aad6131b2747ae8c76f77266054cd84 ]

Previously, STOP handling was split into two separate steps:
  1) clear TB/STOP/START/ACK bits
  2) issue STOP by calling spacemit_i2c_stop()

This left a small window where the control register was updated
twice, which can confuse the controller. While this race has not
been observed with interrupt-driven transfers, it reliably causes
bus errors in PIO mode.

Inline the STOP sequence into the IRQ handler and ensure that
control register bits are updated atomically in a single writel().

Fixes: 5ea558473fa31 ("i2c: spacemit: add support for SpacemiT K1 SoC")
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-k1.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/i2c/busses/i2c-k1.c b/drivers/i2c/busses/i2c-k1.c
index ee08811f4087c..84f132d0504dc 100644
--- a/drivers/i2c/busses/i2c-k1.c
+++ b/drivers/i2c/busses/i2c-k1.c
@@ -267,19 +267,6 @@ static void spacemit_i2c_start(struct spacemit_i2c_dev *i2c)
 	writel(val, i2c->base + SPACEMIT_ICR);
 }
 
-static void spacemit_i2c_stop(struct spacemit_i2c_dev *i2c)
-{
-	u32 val;
-
-	val = readl(i2c->base + SPACEMIT_ICR);
-	val |= SPACEMIT_CR_STOP | SPACEMIT_CR_ALDIE | SPACEMIT_CR_TB;
-
-	if (i2c->read)
-		val |= SPACEMIT_CR_ACKNAK;
-
-	writel(val, i2c->base + SPACEMIT_ICR);
-}
-
 static int spacemit_i2c_xfer_msg(struct spacemit_i2c_dev *i2c)
 {
 	unsigned long time_left;
@@ -412,7 +399,6 @@ static irqreturn_t spacemit_i2c_irq_handler(int irq, void *devid)
 
 	val = readl(i2c->base + SPACEMIT_ICR);
 	val &= ~(SPACEMIT_CR_TB | SPACEMIT_CR_ACKNAK | SPACEMIT_CR_STOP | SPACEMIT_CR_START);
-	writel(val, i2c->base + SPACEMIT_ICR);
 
 	switch (i2c->state) {
 	case SPACEMIT_STATE_START:
@@ -429,14 +415,16 @@ static irqreturn_t spacemit_i2c_irq_handler(int irq, void *devid)
 	}
 
 	if (i2c->state != SPACEMIT_STATE_IDLE) {
+		val |= SPACEMIT_CR_TB | SPACEMIT_CR_ALDIE;
+
 		if (spacemit_i2c_is_last_msg(i2c)) {
 			/* trigger next byte with stop */
-			spacemit_i2c_stop(i2c);
-		} else {
-			/* trigger next byte */
-			val |= SPACEMIT_CR_ALDIE | SPACEMIT_CR_TB;
-			writel(val, i2c->base + SPACEMIT_ICR);
+			val |= SPACEMIT_CR_STOP;
+
+			if (i2c->read)
+				val |= SPACEMIT_CR_ACKNAK;
 		}
+		writel(val, i2c->base + SPACEMIT_ICR);
 	}
 
 err_out:
-- 
2.51.0



