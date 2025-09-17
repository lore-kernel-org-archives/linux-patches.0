Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF64C1E1E00;
	Wed, 17 Sep 2025 12:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113745; cv=none; b=LfWBvIfS7en68B/VkUz+o15mn/DcZsTTmZRbG4A2cEJlFFggmBjSiJlCu/DsiN/DBdsJuuRnGbID+hgXrGRGmYdm7yZmGIISBb36PqSIWFVoPySgqKy4WjzC5TJS2SysiOAkDWicx6THGaJnrWHhdp8dWQ5iiZkqObdJsBDhDFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113745; c=relaxed/simple;
	bh=+/iHHOehYI9h7rhFZSOmvoaQ+HvMKrk4vXdCXsogAd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4blR4VptnDYaCqQn0bPpsWHfJUoGKdVdCwfgk/IOYrOgTwWtuUXSt8t6BMzVVfMMCJrn42ohQx8ew4UyokMvIR/ARSkU5KHtsaDmfrXft+ZEhml1aKi1+z+7eIXxkpIrbbEfkHblouZrEBYp6gWH8nw/5LI04wp5aokgpxdD5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP7qh8pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP7qh8pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EC5C4CEF0;
	Wed, 17 Sep 2025 12:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113744;
	bh=+/iHHOehYI9h7rhFZSOmvoaQ+HvMKrk4vXdCXsogAd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP7qh8pk68n8P5j+0IKkSD9Yx7z+Dectd2PD6Xhv2qAPHS+L61XSU87FL7PzFKw9C
	 B3hwdJ826jEnvrbsOrLgc3YbF2DJuChi70h5YF7BHMa4LjVoxexS/zpNy7m+KtDXTR
	 AZ5qwcBr9CF2impaYtaLSz9odF3d26XbLFUudVLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 039/101] mtd: rawnand: stm32_fmc2: fix ECC overwrite
Date: Wed, 17 Sep 2025 14:34:22 +0200
Message-ID: <20250917123337.791143605@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Kerello <christophe.kerello@foss.st.com>

commit 811c0da4542df3c065f6cb843ced68780e27bb44 upstream.

In case OOB write is requested during a data write, ECC is currently
lost. Avoid this issue by only writing in the free spare area.
This issue has been seen with a YAFFS2 file system.

Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Cc: stable@vger.kernel.org
Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/stm32_fmc2_nand.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -968,9 +968,21 @@ static int stm32_fmc2_nfc_seq_write(stru
 
 	/* Write oob */
 	if (oob_required) {
-		ret = nand_change_write_column_op(chip, mtd->writesize,
-						  chip->oob_poi, mtd->oobsize,
-						  false);
+		unsigned int offset_in_page = mtd->writesize;
+		const void *buf = chip->oob_poi;
+		unsigned int len = mtd->oobsize;
+
+		if (!raw) {
+			struct mtd_oob_region oob_free;
+
+			mtd_ooblayout_free(mtd, 0, &oob_free);
+			offset_in_page += oob_free.offset;
+			buf += oob_free.offset;
+			len = oob_free.length;
+		}
+
+		ret = nand_change_write_column_op(chip, offset_in_page,
+						  buf, len, false);
 		if (ret)
 			return ret;
 	}


