Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B90D1F1313;
	Mon, 13 Oct 2025 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367575; cv=none; b=WvK7Z/jaI6kqvvvbqlcLVkNa9PXbDjtJl7oVZup1V7no6mW7RNJUFk3l6eOxid23uVgXTnKEzmgVTHkhPmuC5ZV0o8hqv/ZBQi3bz4q7wg2Q8YpG6wSk28omvaZaez0rwTcTtlvDaYmqgNyEMHhs79oMbvmRa7amZs+AjAVb1p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367575; c=relaxed/simple;
	bh=jvjwU3UFKyakl6j35gy5D111aTt5mZEcu5Be5l1xUss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRRLIJr4abvWxP+wmPHrVtWXO3FL7kwJj9DcjwHhItsuTHYDWJlLxSPkL9rhgaDGH9wUsOQL4mOhWSAEinGLmCTadydDkd8UejFSPWD+FbeNeHmYtET6rL3eieyHV8Ot03ji6ipzqqpgKvKiDBt9ZYxcnmG+nIX/vsmmSLmYRlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+rZ3Fxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+rZ3Fxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE9BC4CEFE;
	Mon, 13 Oct 2025 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367575;
	bh=jvjwU3UFKyakl6j35gy5D111aTt5mZEcu5Be5l1xUss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+rZ3FxuE3nBUGRbbpGSXBj1s5umM2zKU8jjtc28Ifqy4Ixg0hmAtVIgzfMEeKQtE
	 OBL24tWX4S7u+VqJNRsNrQ/M+uOPO1YFxB2QQtEBxopQ9iPgcLBmUYEfm8GTU9wTsh
	 d4y/snXAz0Gjcf4VMn1OIXlj4wRx9H7bZztcs2m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Leilk.Liu" <leilk.liu@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/196] i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD
Date: Mon, 13 Oct 2025 16:44:09 +0200
Message-ID: <20251013144317.295419980@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leilk.Liu <leilk.liu@mediatek.com>

[ Upstream commit b492183652808e0f389272bf63dc836241b287ff ]

The old IC does not support the I2C_MASTER_WRRD (write-then-read)
function, but the current code’s handling of i2c->auto_restart may
potentially lead to entering the I2C_MASTER_WRRD software flow,
resulting in unexpected bugs.

Instead of repurposing the auto_restart flag, add a separate flag
to signal I2C_MASTER_WRRD operations.

Also fix handling of msgs. If the operation (i2c->op) is
I2C_MASTER_WRRD, then the msgs pointer is incremented by 2.
For all other operations, msgs is simply incremented by 1.

Fixes: b2ed11e224a2 ("I2C: mediatek: Add driver for MediaTek MT8173 I2C controller")
Signed-off-by: Leilk.Liu <leilk.liu@mediatek.com>
Suggested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 1a9b5a068ef1b..6b788bca64d54 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1243,6 +1243,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 {
 	int ret;
 	int left_num = num;
+	bool write_then_read_en = false;
 	struct mtk_i2c *i2c = i2c_get_adapdata(adap);
 
 	ret = clk_bulk_enable(I2C_MT65XX_CLK_MAX, i2c->clocks);
@@ -1256,6 +1257,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;
+			write_then_read_en = true;
 		}
 	}
 
@@ -1280,12 +1282,10 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 		else
 			i2c->op = I2C_MASTER_WR;
 
-		if (!i2c->auto_restart) {
-			if (num > 1) {
-				/* combined two messages into one transaction */
-				i2c->op = I2C_MASTER_WRRD;
-				left_num--;
-			}
+		if (write_then_read_en) {
+			/* combined two messages into one transaction */
+			i2c->op = I2C_MASTER_WRRD;
+			left_num--;
 		}
 
 		/* always use DMA mode. */
@@ -1293,7 +1293,10 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 		if (ret < 0)
 			goto err_exit;
 
-		msgs++;
+		if (i2c->op == I2C_MASTER_WRRD)
+			msgs += 2;
+		else
+			msgs++;
 	}
 	/* the return value is number of executed messages */
 	ret = num;
-- 
2.51.0



