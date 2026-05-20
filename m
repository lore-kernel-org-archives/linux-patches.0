Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3613D75C7;
	Wed, 20 May 2026 17:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298763; cv=none; b=nQYbNsW5i7e+/sfgMPbe9O8XcjJPu9EfGgXKVuR+FlMvoShKhOUIUPoasYf/vYIM0Z+c06lzK7B6cju/d1YEV1DCHM7IK+BlgQtfm4/9KInpi+x8Q1UccCev9knjSiyFMYH96xdCQOPO7ntL2uiKY1BGUC/FeN2m7npalCU6ch8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298763; c=relaxed/simple;
	bh=aK0AXmtmfeMCF/CsfqMCshwc6qa4A1rBnr8JSaMkyes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEPj3ldzncwf3+duSdO/OaDfl7bmFnFfhlzwOnTpmbfuhd4LUhVTGfyAByA1GulSzPAstjOoRilOEzBx7dT2Yo7ATErcgzF6CWqBOi5UX3ngg0Y/cH8G09eSbXt2UAbeVvkBJ2EbQ7wEisBmrP374Dd55jkxNbr1qz2u6oo/RLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycbjMcoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycbjMcoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0501F000E9;
	Wed, 20 May 2026 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298761;
	bh=h/iw333POFaarcsG2zrI1KalE81zt/pPvvLrX725/+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycbjMcozqIBRyrzH05QrKAzL5NVo5qFnXnZFCUWkAtte5Vn3aKcn5NbhsgakcYGF+
	 Z4wWClqGvGo5PLn290QtI/30nC+ESSeFW13T9YJbapln5wT1JepsYFH7HYHXtI/8PV
	 KRXppGTwYmw1SqyCp0sLHE/cPgCbbmEAJ2m4VhKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 482/957] mtd: spinand: winbond: Clarify when to enable the HS bit
Date: Wed, 20 May 2026 18:16:05 +0200
Message-ID: <20260520162144.977827682@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 25a915fad503c2678902075565d47ddc2aa45db9 ]

Above 104MHz when in fast dual or quad I/O reads, the delay between
address and data cycles is too short. It is possible to reach higher
frequencies, up to 166MHz, by adding a few more dummy cycles through the
setting of the HS bit. Improve the condition for enabling this bit, and
also make sure we set it at soon as we go over 104MHz.

Fixes: f1a91175faaa ("mtd: spinand: winbond: Enable high-speed modes on w25n0xjw")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/winbond.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/spi/winbond.c b/drivers/mtd/nand/spi/winbond.c
index 0ea5b1c97d33d..578924c98b90a 100644
--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -295,16 +295,19 @@ static int w25n0xjw_hs_cfg(struct spinand_device *spinand,
 	if (iface != SSDR)
 		return -EOPNOTSUPP;
 
+	/*
+	 * SDR dual and quad I/O operations over 104MHz require the HS bit to
+	 * enable a few more dummy cycles.
+	 */
 	op = spinand->op_templates->read_cache;
 	if (op->cmd.dtr || op->addr.dtr || op->dummy.dtr || op->data.dtr)
 		hs = false;
-	else if (op->cmd.buswidth == 1 && op->addr.buswidth == 1 &&
-		 op->dummy.buswidth == 1 && op->data.buswidth == 1)
+	else if (op->cmd.buswidth != 1 || op->addr.buswidth == 1)
 		hs = false;
-	else if (!op->max_freq)
-		hs = true;
-	else
+	else if (op->max_freq && op->max_freq <= 104 * HZ_PER_MHZ)
 		hs = false;
+	else
+		hs = true;
 
 	ret = spinand_read_reg_op(spinand, W25N0XJW_SR4, &sr4);
 	if (ret)
-- 
2.53.0



