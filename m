Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D60481B8;
	Mon,  1 Apr 2024 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989819; cv=none; b=CdHcwIIEtw51qZ8+ODsuPXDDlB/gRH3C55Ui0/enwymJODizghP5WOIHdEzlUhSLSQDWdIQxI+5wYp3h85+fV1YfM+PQkbElbIlBnCBYMBlv8IZ7/PUPiGbgnnx7H0PPFwvReU81P6zINoXgrJvCJ+HA7zQIfDSTDyS6ZepoR7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989819; c=relaxed/simple;
	bh=r47pnePTRTnMWcBUD+42Tdfp+MGhu/CHx5yO+j3g2ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMGlZ7gH94C0/859z/6hOcw4Y71CDgoDw6Y8whNNaF9j2661ZKFJtbEEm+QmvH6HmnTPmUH5dO1SUuYaJea/mBIthCKTFBs+ajNN+gid9/zyjYjT3qgn07Y8E98S0UoaBDdThgtiksbY4XvKJtH5wCVgwali3L9bFgBISYgbV8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugfqDmxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugfqDmxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9B0C433F1;
	Mon,  1 Apr 2024 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989819;
	bh=r47pnePTRTnMWcBUD+42Tdfp+MGhu/CHx5yO+j3g2ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugfqDmxLsvNlCz00+mE1jY1/OOrbTZolzY9FwUfA4sdCVW1woNZ/TBeOebvSI+HRK
	 MB2n5Xq1v8K6WAo9u3hq4UoeF6joc2b2Pnm8yavbeXkqlpH6zUOsjCv7yJw1wYVpQg
	 ouBvr+Tgr5kp9MtAIUXICw9k0gpMeLl4tHv0OFtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/396] mtd: rawnand: Fix and simplify again the continuous read derivations
Date: Mon,  1 Apr 2024 17:43:32 +0200
Message-ID: <20240401152552.799872444@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 76167b8ca9dda..9118b5753c553 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -3461,30 +3461,36 @@ static void rawnand_enable_cont_reads(struct nand_chip *chip, unsigned int page,
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



