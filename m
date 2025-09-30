Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B58303C9B;
	Tue, 30 Sep 2025 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244173; cv=none; b=W+ArnZQFvHAz8v37fiMjsPC8khLQmcgzcxQyz+uKNCch61DJ4Uke5vibFiiKJJh6VxAVz8WM4uIxudeuIWCu+OP+tRwXllMm3gQ0mWbKhafTRIb5MbZn87lc1l2fNrlAIO/Ng9Podi3Sl9fAzVHBvTZeHXbQ3JPpaZuwzuCjapk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244173; c=relaxed/simple;
	bh=pOYSVZ6z/GoijlOsDh9i5sUJYnp7juc+yOGMVXLHAQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLei2NBzAKhcOqiNLO5lEZVeM1P+bGhawwLABNwTT1tUZEJ2d+xRUAuuKzOVIjJIbXFddLY5oQLrBTXh04ohaK6lzToG+a7z+Bs3tAJl58uAp4KvOpz4QRqnqSTJhMkA5HodaysYnK6cBaJNRTaVQ5WS3ha/5G+m5jZCjyo/ZJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWgvqBnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWgvqBnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EABC116B1;
	Tue, 30 Sep 2025 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244173;
	bh=pOYSVZ6z/GoijlOsDh9i5sUJYnp7juc+yOGMVXLHAQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWgvqBnqRDjy7WOFG5LKfH5OpEUl2WPnXUSosqX34BoVycPyHarQjvXw3Vjw3WG6q
	 WzdZNNTDzuyTk+Q0UxXwAjxtutCDtXTUPGFgztf9xBx3E/ve7oDizqjvr2XQce+Kbd
	 Ysd9Xcpcu+K0hoVySsoaiTxRrSZgv+smiIzC0Hk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 018/122] mtd: rawnand: stm32_fmc2: fix ECC overwrite
Date: Tue, 30 Sep 2025 16:45:49 +0200
Message-ID: <20250930143823.737275549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -973,9 +973,21 @@ static int stm32_fmc2_nfc_seq_write(stru
 
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


