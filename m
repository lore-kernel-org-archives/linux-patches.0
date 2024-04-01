Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD19117552;
	Mon,  1 Apr 2024 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987101; cv=none; b=rL09nnnFLtxOxgGwztVlGC0hYQG5q/Pw+IVIgWH2j/PhvRDCDwDBpME4g3AyDW+EQE6SeRnAnRG5Cm78Gz4cbPnddkKgpz1nAytxDGw8vbGTAQlS6T1kiHk/plwDTUD6JHsVMaDfhDToDQkBV6SHD7ugRyIh0nkgaW0eBMade0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987101; c=relaxed/simple;
	bh=RR7vHwbmM6FNnRZBTHgOY99I/H7iF07afZMz5yhXrzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4+xBAEI9oOEf0KpLHksA48Eq7qi1EDxro5TcHFUA1nPdN2LAD05iZBr3nWKSJ7gpLNydPa2OH9Csnh793RmTFeJt/b99V+v7dAc1bT1JBZH68yr08r8L731DoZR7r4LCSD20jtzkSTd9jpqB0vLYcNIJaSrembTwZpJwV6Hqv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKdJOjKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKdJOjKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5796EC433F1;
	Mon,  1 Apr 2024 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987101;
	bh=RR7vHwbmM6FNnRZBTHgOY99I/H7iF07afZMz5yhXrzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKdJOjKY203NejaUu7qdemTwhL/92HPfwPM3cVwql4kJx4cbtOwqjNEvznltCHqml
	 +j40MVk5AlciKqxP4Kal+pLlUarj6SnTQoih4Hob++xImt4k9tXuLWsMoRXOebfSJ1
	 876aHScwqlQJ0irnavpZDYWZS5/Nc4RAap7VpIQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 184/399] mtd: rawnand: Ensure all continuous terms are always in sync
Date: Mon,  1 Apr 2024 17:42:30 +0200
Message-ID: <20240401152554.667679992@linuxfoundation.org>
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
index d6a27e08b1127..4d5a663e4e059 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -1232,6 +1232,15 @@ static void rawnand_cap_cont_reads(struct nand_chip *chip)
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
@@ -1298,12 +1307,11 @@ static int nand_lp_exec_cont_read_page_op(struct nand_chip *chip, unsigned int p
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
@@ -3510,10 +3518,7 @@ static void rawnand_cont_read_skip_first_page(struct nand_chip *chip, unsigned i
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



