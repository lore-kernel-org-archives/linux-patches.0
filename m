Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0283F1AD9;
	Wed, 20 May 2026 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298626; cv=none; b=TBC+Rzo9nks1iddkhgoU0CV7KfrBZQ3xp3hI+8+I5PYi1O3CwE5HRGzCKz0tWKkoAMGzJUccfAvGBIUD2xlxEWouO10UJDtfPI6//NRwb2sWlyxZMOjWPFLECXDWl+Mc9EMNughdLdlSuF4XHX6rDclG4jz2lC8BAJLDp1+SMTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298626; c=relaxed/simple;
	bh=lUeP3jxQvoNlDyiAecw8CWzyD106s94+dyayelWFuQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwpeUBUIhTNJ6W7YXU2yoQSgh+STwUl+RcocWz/pdOkIg/7UfBGdeAcV/QlPhre2QmFzr1YEp9X9LSthBwGHPYfEw99I7vP2dJrVMYbYiV06iB52sNd6VptiFnJZtwu/7Q84K85GV+9Bz+V3UZwpV+ReqaMuh3yXB6Lp26kGcKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRYDal6R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRYDal6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F27C1F000E9;
	Wed, 20 May 2026 17:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298622;
	bh=T8GdM7gyN8SSpF9Qgw17SuFqLJheRPY5EckH2ggm870=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRYDal6R95NQ0s86uqw+DaO9Z/pWE8KSj+/IjzgAvqnZNesbffcgRcVBqg5d1NTmu
	 U1YScTZ1o67ReNTmBW/ZXvC3+BHNrBuDBT/mhVby6cLyB+j7Kd4hMCjl4HpBxr57za
	 RdKKzjC8jo5nZAmF1tLV3Y36h31jWwmbR/Vg6QW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 479/957] mtd: spinand: Gather all the bus interface steps in one single function
Date: Wed, 20 May 2026 18:16:02 +0200
Message-ID: <20260520162144.913849614@linuxfoundation.org>
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

[ Upstream commit be0b86c648bf811237cc17e274e9f9488fccb772 ]

Writing the quad enable bit in one helper and doing the chip
configuration in another does not make much sense from a bus interface
setup point of view.

Instead, let's create a broader helper which is going to be in charge of
all the bus configuration steps at once. This will specifically allow to
transition to octal DDR mode, and even fallback to quad (if suppoorted)
or single mode otherwise.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 25a915fad503 ("mtd: spinand: winbond: Clarify when to enable the HS bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 62 ++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 5c1797946a047..b88f30ed746fc 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -177,18 +177,9 @@ static int spinand_init_cfg_cache(struct spinand_device *spinand)
 	return 0;
 }
 
-static int spinand_init_quad_enable(struct spinand_device *spinand)
+static int spinand_init_quad_enable(struct spinand_device *spinand,
+				    bool enable)
 {
-	bool enable = false;
-
-	if (!(spinand->flags & SPINAND_HAS_QE_BIT))
-		return 0;
-
-	if (spinand->op_templates->read_cache->data.buswidth == 4 ||
-	    spinand->op_templates->write_cache->data.buswidth == 4 ||
-	    spinand->op_templates->update_cache->data.buswidth == 4)
-		enable = true;
-
 	return spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
 			       enable ? CFG_QUAD_ENABLE : 0);
 }
@@ -1314,12 +1305,6 @@ static int spinand_manufacturer_init(struct spinand_device *spinand)
 			return ret;
 	}
 
-	if (spinand->configure_chip) {
-		ret = spinand->configure_chip(spinand);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 
@@ -1496,6 +1481,31 @@ static int spinand_detect(struct spinand_device *spinand)
 	return 0;
 }
 
+static int spinand_configure_chip(struct spinand_device *spinand)
+{
+	bool quad_enable = false;
+	int ret;
+
+	if (spinand->flags & SPINAND_HAS_QE_BIT) {
+		if (spinand->ssdr_op_templates.read_cache->data.buswidth == 4 ||
+		    spinand->ssdr_op_templates.write_cache->data.buswidth == 4 ||
+		    spinand->ssdr_op_templates.update_cache->data.buswidth == 4)
+			quad_enable = true;
+	}
+
+	ret = spinand_init_quad_enable(spinand, quad_enable);
+	if (ret)
+		return ret;
+
+	if (spinand->configure_chip) {
+		ret = spinand->configure_chip(spinand);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 static int spinand_init_flash(struct spinand_device *spinand)
 {
 	struct device *dev = &spinand->spimem->spi->dev;
@@ -1506,10 +1516,6 @@ static int spinand_init_flash(struct spinand_device *spinand)
 	if (ret)
 		return ret;
 
-	ret = spinand_init_quad_enable(spinand);
-	if (ret)
-		return ret;
-
 	ret = spinand_upd_cfg(spinand, CFG_OTP_ENABLE, 0);
 	if (ret)
 		return ret;
@@ -1522,19 +1528,25 @@ static int spinand_init_flash(struct spinand_device *spinand)
 		return ret;
 	}
 
+	ret = spinand_configure_chip(spinand);
+	if (ret)
+		goto manuf_cleanup;
+
 	/* After power up, all blocks are locked, so unlock them here. */
 	for (i = 0; i < nand->memorg.ntargets; i++) {
 		ret = spinand_select_target(spinand, i);
 		if (ret)
-			break;
+			goto manuf_cleanup;
 
 		ret = spinand_lock_block(spinand, BL_ALL_UNLOCKED);
 		if (ret)
-			break;
+			goto manuf_cleanup;
 	}
 
-	if (ret)
-		spinand_manufacturer_cleanup(spinand);
+	return 0;
+
+manuf_cleanup:
+	spinand_manufacturer_cleanup(spinand);
 
 	return ret;
 }
-- 
2.53.0



