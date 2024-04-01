Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1130FC129;
	Mon,  1 Apr 2024 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988438; cv=none; b=omDxLcyaTbtW04mxI9I+4X6SmlgXMR9MfVpCXoEMRqrTx2j2XUIgZDsXonF3elmIIX24BwCLfEIJ9moaQ1l24JTCnZ/hhQHHm1JAtizafQX9WlA72xiHVLyzrHWXaGzGNpPj1Q5dgg/HvUscr3+UfnvsuiaJcTUPNOnT1xTsGFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988438; c=relaxed/simple;
	bh=J/KMqgUwLVUzo+OpiHSop+V5aDiJMzcHD2xC0hnXw5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjhkI9dYHdJz2caZsxEHkdyQw++FdpcmJCk/m4Ru+6yRV+DY+lGZ/DpMIkBTPYB4xU5CIc78o+hp/LgTmu2Hy5B0Hddb2d385ZFNVbQmyJW9rpBz6hBW/zIHhF9VtOygT6kukVf6cXVUMM0e1oEmhW0lbeYTgSHSwp0ivaZUJVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDFzqVIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDFzqVIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7701EC433F1;
	Mon,  1 Apr 2024 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988437;
	bh=J/KMqgUwLVUzo+OpiHSop+V5aDiJMzcHD2xC0hnXw5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDFzqVIhP/v1UJzKt4fpfIhF5WDvA5q+joLk9kU9ka7JPFylMRr0x2xU+z/uHQbQS
	 LaR5AhRSrGPF5FY0Zq9Ft+B5WcygO3IeWKJFdsYzJ51pNUeheR5HvrUGiJnMYJnfIr
	 A9/yKf8XBQ5eJACrSeyFo3FID4JIqmQ2+3nmseps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 184/432] mtd: rawnand: Ensure all continuous terms are always in sync
Date: Mon,  1 Apr 2024 17:42:51 +0200
Message-ID: <20240401152558.631281556@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 6fb075fca63c3486612986eeff84ed4179644038 ]

While crossing a LUN boundary, it is probably safer (and clearer) to
keep all members of the continuous read structure aligned, including the
pause page (which is the last page of the lun or the last page of the
continuous read). Once these members properly in sync, we can use the
rawnand_cap_cont_reads() helper everywhere to "prepare" the next
continuous read if there is one.

Fixes: bbcd80f53a5e ("mtd: rawnand: Prevent crossing LUN boundaries during sequential reads")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240223115545.354541-4-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index af37c2dea76b6..dc8f3551c9a91 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -1228,6 +1228,15 @@ static void rawnand_cap_cont_reads(struct nand_chip *chip)
 		chip->cont_read.pause_page = rawnand_last_page_of_lun(ppl, first_lun);
 	else
 		chip->cont_read.pause_page = chip->cont_read.last_page;
+
+	if (chip->cont_read.first_page == chip->cont_read.pause_page) {
+		chip->cont_read.first_page++;
+		chip->cont_read.pause_page = min(chip->cont_read.last_page,
+						 rawnand_last_page_of_lun(ppl, first_lun + 1));
+	}
+
+	if (chip->cont_read.first_page >= chip->cont_read.last_page)
+		chip->cont_read.ongoing = false;
 }
 
 static int nand_lp_exec_cont_read_page_op(struct nand_chip *chip, unsigned int page,
@@ -1294,12 +1303,11 @@ static int nand_lp_exec_cont_read_page_op(struct nand_chip *chip, unsigned int p
 	if (!chip->cont_read.ongoing)
 		return 0;
 
-	if (page == chip->cont_read.pause_page &&
-	    page != chip->cont_read.last_page) {
-		chip->cont_read.first_page = chip->cont_read.pause_page + 1;
-		rawnand_cap_cont_reads(chip);
-	} else if (page == chip->cont_read.last_page) {
+	if (page == chip->cont_read.last_page) {
 		chip->cont_read.ongoing = false;
+	} else if (page == chip->cont_read.pause_page) {
+		chip->cont_read.first_page++;
+		rawnand_cap_cont_reads(chip);
 	}
 
 	return 0;
@@ -3504,10 +3512,7 @@ static void rawnand_cont_read_skip_first_page(struct nand_chip *chip, unsigned i
 		return;
 
 	chip->cont_read.first_page++;
-	if (chip->cont_read.first_page == chip->cont_read.pause_page)
-		chip->cont_read.first_page++;
-	if (chip->cont_read.first_page >= chip->cont_read.last_page)
-		chip->cont_read.ongoing = false;
+	rawnand_cap_cont_reads(chip);
 }
 
 /**
-- 
2.43.0



