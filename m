Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B122F17552;
	Mon,  1 Apr 2024 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987092; cv=none; b=FeW3yFhzWtDJA2sRI7J50+Diq4khVffaRLMs7VQ4LFEQBJbVShVz1nowzdQt+fWC8h02BmDTE3We3dy53eBK7XfUmI271Xv69T5NTSgHNnpx7mNlK0C6yJRnqcQir0L8bdHnS++oRlbg0smnVFdGnKtnOhAttYrixBiLOLx0vZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987092; c=relaxed/simple;
	bh=GtnW9puxxLvqVDoFsN+76B7Ab3d7bnZrJu0GXf3NoRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pH5MAHjttyNTaITz0N0zetsIlfFP8UOUkI4acHGui/Px5L0Spp03/88IXK3ZkInYgpG1fI8nMyweg9Cnrc0xh/n51DFsMh/cHKgzBC2NP/4NMSlhfXIQXJSMWzydXnnq8FB5INL/eNLrViQdr/YpW6zMSo2dB2JdUCRZuqj8XGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xclt6COc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xclt6COc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3BFC433C7;
	Mon,  1 Apr 2024 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987092;
	bh=GtnW9puxxLvqVDoFsN+76B7Ab3d7bnZrJu0GXf3NoRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xclt6COcyI7N9nvck/Nmqc/porWR6/CXYiFtRbDhE9mTRYcioIfAHRbxEoHqzIFee
	 ME2NZUZfo48iVvn79MxyyEK2DJE0ipM8exsf1K4swaag25cGWxxErZIGOakIYFLPK9
	 VhFoXhXGHeWLkp5RidLvDRWTv3eCRMO00o0dqirE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 182/399] mtd: rawnand: Fix and simplify again the continuous read derivations
Date: Mon,  1 Apr 2024 17:42:28 +0200
Message-ID: <20240401152554.608417208@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit c7ee7c8d4b60fe46d4861b1200bc1c7ab657960a ]

We need to avoid the first page if we don't read it entirely.
We need to avoid the last page if we don't read it entirely.
While rather simple, this logic has been failed in the previous
fix. This time I wrote about 30 unit tests locally to check each
possible condition, hopefully I covered them all.

Reported-by: Christophe Kerello <christophe.kerello@foss.st.com>
Closes: https://lore.kernel.org/linux-mtd/20240221175327.42f7076d@xps-13/T/#m399bacb10db8f58f6b1f0149a1df867ec086bb0a
Suggested-by: Christophe Kerello <christophe.kerello@foss.st.com>
Fixes: 828f6df1bcba ("mtd: rawnand: Clarify conditions to enable continuous reads")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Christophe Kerello <christophe.kerello@foss.st.com>
Link: https://lore.kernel.org/linux-mtd/20240223115545.354541-2-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 34 +++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 3b3ce2926f5d1..bcfd99a1699fd 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -3466,30 +3466,36 @@ static void rawnand_enable_cont_reads(struct nand_chip *chip, unsigned int page,
 				      u32 readlen, int col)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
-	unsigned int end_page, end_col;
+	unsigned int first_page, last_page;
 
 	chip->cont_read.ongoing = false;
 
 	if (!chip->controller->supported_op.cont_read)
 		return;
 
-	end_page = DIV_ROUND_UP(col + readlen, mtd->writesize);
-	end_col = (col + readlen) % mtd->writesize;
+	/*
+	 * Don't bother making any calculations if the length is too small.
+	 * Side effect: avoids possible integer underflows below.
+	 */
+	if (readlen < (2 * mtd->writesize))
+		return;
 
+	/* Derive the page where continuous read should start (the first full page read) */
+	first_page = page;
 	if (col)
-		page++;
-
-	if (end_col && end_page)
-		end_page--;
+		first_page++;
 
-	if (page + 1 > end_page)
-		return;
-
-	chip->cont_read.first_page = page;
-	chip->cont_read.last_page = end_page;
-	chip->cont_read.ongoing = true;
+	/* Derive the page where continuous read should stop (the last full page read) */
+	last_page = page + ((col + readlen) / mtd->writesize) - 1;
 
-	rawnand_cap_cont_reads(chip);
+	/* Configure and enable continuous read when suitable */
+	if (first_page < last_page) {
+		chip->cont_read.first_page = first_page;
+		chip->cont_read.last_page = last_page;
+		chip->cont_read.ongoing = true;
+		/* May reset the ongoing flag */
+		rawnand_cap_cont_reads(chip);
+	}
 }
 
 static void rawnand_cont_read_skip_first_page(struct nand_chip *chip, unsigned int page)
-- 
2.43.0



