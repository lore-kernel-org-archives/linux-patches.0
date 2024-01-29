Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D75157050;
	Mon, 29 Jan 2024 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548031; cv=none; b=fKEPlwZWydbBnaYBm07eDmwfC+ahXZ1AO2vQ853JXw2Bqoam8hZg7yeQqoAkaFKlw62P2wMcd199l7uJgHQsV+vP05tZdPQXhECJHvywosMHtagC9kGQwwpay2RYMZkqyBVuQHyojtRTZ8BVHc2pYlwIZHP51k5GGUzvrQhzrvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548031; c=relaxed/simple;
	bh=bxedaNkQdSBBvQ0Vj2VM5G4Och50/3wz0rbbOrtijI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLBeWQIJe6OLp4Q2j34jtjGdp8mpC+MqFlruFyL/1a5u0bG/F4Knlir/fJErOZE/6BTfTyyjoGBcoabPIwPs6tHbnnvdoJEtgrUXCU/JbDA/3E4UxcslYNhWQSfcBTwIAS87uzCio0llDm5D/v4y1+F/8+SL56/XAXNYZ9HK/i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUbxsw4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUbxsw4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E803FC433F1;
	Mon, 29 Jan 2024 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548031;
	bh=bxedaNkQdSBBvQ0Vj2VM5G4Och50/3wz0rbbOrtijI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUbxsw4b62TVdphnwDUyt9qdyWMMxmhvSpa4zeJv1rB2QKVlTgvNGH1/iFpPfC+5Q
	 FLr6OX5lUewnOGq4gCCA7Hf5Za1LBumfiLHAbx9nTdNYiKxI6XMXOFqfRYwL3RqOmz
	 8OcJg2e2ubUhbQl4M22aIaWlO+ptHEgSvi/yUzAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>
Subject: [PATCH 6.7 026/346] mtd: rawnand: Clarify conditions to enable continuous reads
Date: Mon, 29 Jan 2024 09:00:57 -0800
Message-ID: <20240129170017.146268005@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 828f6df1bcba7f64729166efc7086ea657070445 upstream.

The current logic is probably fine but is a bit convoluted. Plus, we
don't want partial pages to be part of the sequential operation just in
case the core would optimize the page read with a subpage read (which
would break the sequence). This may happen on the first and last page
only, so if the start offset or the end offset is not aligned with a
page boundary, better avoid them to prevent any risk.

Cc: stable@vger.kernel.org
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/linux-mtd/20231215123208.516590-5-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -3460,21 +3460,29 @@ static void rawnand_enable_cont_reads(st
 				      u32 readlen, int col)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
+	unsigned int end_page, end_col;
+
+	chip->cont_read.ongoing = false;
 
 	if (!chip->controller->supported_op.cont_read)
 		return;
 
-	if ((col && col + readlen < (3 * mtd->writesize)) ||
-	    (!col && readlen < (2 * mtd->writesize))) {
-		chip->cont_read.ongoing = false;
+	end_page = DIV_ROUND_UP(col + readlen, mtd->writesize);
+	end_col = (col + readlen) % mtd->writesize;
+
+	if (col)
+		page++;
+
+	if (end_col && end_page)
+		end_page--;
+
+	if (page + 1 > end_page)
 		return;
-	}
 
-	chip->cont_read.ongoing = true;
 	chip->cont_read.first_page = page;
-	if (col)
-		chip->cont_read.first_page++;
-	chip->cont_read.last_page = page + ((readlen >> chip->page_shift) & chip->pagemask);
+	chip->cont_read.last_page = end_page;
+	chip->cont_read.ongoing = true;
+
 	rawnand_cap_cont_reads(chip);
 }
 


