Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3163304BBF;
	Tue, 30 Sep 2025 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243829; cv=none; b=WqQlqRDW7pNMtAEDIImJCjBAPGmSHVm1qTtAeY63h78+w4B32BNbq0/AsKVRNPLO46OHqIEAVZ1Hz/hyUV32btV/Q4DhZ+E8QDWW1LHmmVChiIyPPuYakRRoswzW/0/5G8Hyr7YvauxnxnBQvoDNfxjl4YoquhXp7/mIHXsmyrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243829; c=relaxed/simple;
	bh=NMDoufS/QkGyJFlI1ZpdR0Z8OLSkXvJ29rBSmAPnkV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGwDH9/cFG5UOOzoFZNjJsR44D8tpBIF53IMF7V/5Y4gsbkhjxIcMYBSvR8qawUPbXDrQQhhB9jhpjg93X6ejQFfWfaj1RY949xU5rXdXn6Rzlc5ZkvuvvjM4DqRk7M+xEjn2bYf/I8nHE8xi1qeS6ukNMLNzlERWhf/nGDxKNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icIGPYsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icIGPYsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22414C4CEF0;
	Tue, 30 Sep 2025 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243829;
	bh=NMDoufS/QkGyJFlI1ZpdR0Z8OLSkXvJ29rBSmAPnkV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icIGPYswW4hM675D0enlJoi+UZcZnT2/11SMcj1v62Ix758dVJQkQIKglV0spi6qy
	 SbK0BT6UQO9pC0ReuWlqLSlM/qBGqYRh36+i0s1tZScPdrbTo7tUtDoRK/7v7kntnS
	 qYIevY7+GiKu5xcnQUXAMO1Xk20gfMy1EpU3XWAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 07/81] mtd: rawnand: stm32_fmc2: fix ECC overwrite
Date: Tue, 30 Sep 2025 16:46:09 +0200
Message-ID: <20250930143819.966712071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1037,9 +1037,21 @@ static int stm32_fmc2_sequencer_write(st
 
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


