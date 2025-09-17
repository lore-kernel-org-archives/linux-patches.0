Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09D21B3925;
	Wed, 17 Sep 2025 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113348; cv=none; b=bRwzIygy6t5Lf4mXAzFmU0b5A7puYq8cs2RxVoY9TOSQ8JWnGOj++G9cWWI8Ye0JVY2qLXiF4zJnYLFcPxuqOF43q8llBP/q6tBZ3vBhwfZQOMj9b2+NOSAwgjY1XwqvoyCYIA3hE1Fu4en0yWOkUeYYm8EW1oUC6MUdfcoyHek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113348; c=relaxed/simple;
	bh=ODZnXfLm9VI2YBUfUbR9bE2QcGeUchDE3o0zqlBID8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agqPXZeLavYK//sGY2c+OqGpjfSg6v7CxPKqkA6O0gj8DrhimnEN8CJoW6xitrWde4nrDm8JOXwFsmS1BgdRSTdqmPE66BWZEhIbVE5obA4vKL0ZYrMLotCcJB7AM6V3mrKBRehNxWD46OERbxwPXRxANd1hRFXD2dk5wAPuD3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYi9Te+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYi9Te+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704B8C4CEF0;
	Wed, 17 Sep 2025 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113347;
	bh=ODZnXfLm9VI2YBUfUbR9bE2QcGeUchDE3o0zqlBID8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYi9Te+zS30EMEuCedVF6ic0SxlO+O/vTzPCmTAsDdKQJMvHuH76wsLxb0kKsgE9w
	 dbVgWU7iCS4sjkt/La92pRkqUnJLL+/mVaBArQJ50pRNRidvUtUPpROc9jwr4OtDTJ
	 hNvwRV69rn++SxGeIT4HCeLIvnGJnj3dtW+8fg0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 058/140] mtd: rawnand: stm32_fmc2: fix ECC overwrite
Date: Wed, 17 Sep 2025 14:33:50 +0200
Message-ID: <20250917123345.723444990@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


