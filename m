Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5E218A6CF;
	Wed, 17 Sep 2025 12:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112769; cv=none; b=m0WatkjYl3dO+A8UzjacJ1dbZE5vqPVeMKl2jYDWFLf/eOKFcJeBs/pnUQpRWPlbNxtAGuBeK3YZSix/9t5nuG+e260YZyAK7ZKzLyzLoayMl3ednkqvNiCSHCdLk3FtomMBqG1e99LGTgjH6mEZP6ZtWnlYEIaCEXNrtrOq60c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112769; c=relaxed/simple;
	bh=6xNcal+DbnP9qQ3z8fMXEl+MKUBT283kRCqMulhH4C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeZlfzf/Yx0yGf33UdG160pD20B5J8uh8o84jZ/SAaqYAR4+wzjbFNa3AvRscS+BlJmb15h+znn3RSxMQD6m3Nb9sw2z7zkkv3Hac+deL4ouuxfJ/tOqR+miJU4nlOE4Pem6PWfYng5RmEOZdxYqOO1MkIpye877i9VeedLrCNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VulEXuy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VulEXuy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAA8C4CEF0;
	Wed, 17 Sep 2025 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112769;
	bh=6xNcal+DbnP9qQ3z8fMXEl+MKUBT283kRCqMulhH4C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VulEXuy8wwXvkUyL+yyySh2sUzC3ytm4XbGagd5v5PSD/F6hkh3VK434/nKxhN0LZ
	 jHYzUpYQKhJn3KgMy5AXm0WjFeC0WkV5Y0Hi4/DJxBL+BL7BTqkc7uk2vr8u5IC8Gr
	 yih9HNmyBSv2OI03/Xwo65XIiH+N1mjHl4fkzyaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.16 072/189] mtd: rawnand: stm32_fmc2: fix ECC overwrite
Date: Wed, 17 Sep 2025 14:33:02 +0200
Message-ID: <20250917123353.630417575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -985,9 +985,21 @@ static int stm32_fmc2_nfc_seq_write(stru
 
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


