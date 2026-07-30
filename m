Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C837C446062;
	Thu, 30 Jul 2026 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428184; cv=none; b=kSqYExwzWULiAGC5d1vbz8TRCVtJUMoE2SI98QgO/KeEQJ3GLnD45kltHx+0ktsom0wjpFg0Rbu3IMjpexeWFBGjaI5VNEIrx3AFzGi57ok7uIGVTObEji7nDYdJ3Qql+Gp/RLcHfFg8OK4pQgD+3Z5JwOGBHnb17ZLo+a0rljU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428184; c=relaxed/simple;
	bh=PX3btoh3MYu+KXhm41A0vFpjdss0ErSxYaBiUCE33xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhupqqTiS3svxZi6fqP9y6LJClN5qivzW/HoqJ1JVO984Wly4mRhS7m59pQ9AmotA3ywxGyxR9tp6WmJdMOo3JV5Vj3oKqV6jJZrcAVdK3+LDaCayt7CDOvuC5RXc2Z6zscexhV9MYUlmBo03GG64KPW+lKAf6lhx7MG7XWoF7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3ffkiBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3ffkiBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6671F00A3F;
	Thu, 30 Jul 2026 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428162;
	bh=mpWCysVniJpKPgBjf7noUAEDyiadTKI+3Rc7RwzVvkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3ffkiBPqcfgefHZJpZgxrmEWPIDAQnTtCCMf+udD6V1qKTh8KZ6oZ89X8PBTjEKF
	 SVf9RSYfDnSPd3DKQBgc+7ov+lkrniEfl/OM7gQGZ2JqrLRXZrQeC62WxuAKJTbS6F
	 p3K2b6c4KnkHA13WE7H7kM4sQRGP2K+ZV2vNf46I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 426/484] mtd: rawnand: Add a helper for calculating a page index
Date: Thu, 30 Jul 2026 16:15:23 +0200
Message-ID: <20260730141432.735292372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit df9803bf5a91e3599f12b53c94722f2c4e144a86 ]

For LUN crossing boundaries, it is handy to know what is the index of
the last page in a LUN. This helper will soon be reused. At the same
time I rename page_per_lun to ppl in the calling function to clarify the
lines.

Cc: stable@vger.kernel.org # v6.7
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240223115545.354541-3-miquel.raynal@bootlin.com
Stable-dep-of: 8e4531667d71 ("mtd: rawnand: Pause continuous reads at block boundaries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -1212,19 +1212,25 @@ static int nand_lp_exec_read_page_op(str
 	return nand_exec_op(chip, &op);
 }
 
+static unsigned int rawnand_last_page_of_lun(unsigned int pages_per_lun, unsigned int lun)
+{
+	/* lun is expected to be very small */
+	return (lun * pages_per_lun) + pages_per_lun - 1;
+}
+
 static void rawnand_cap_cont_reads(struct nand_chip *chip)
 {
 	struct nand_memory_organization *memorg;
-	unsigned int pages_per_lun, first_lun, last_lun;
+	unsigned int ppl, first_lun, last_lun;
 
 	memorg = nanddev_get_memorg(&chip->base);
-	pages_per_lun = memorg->pages_per_eraseblock * memorg->eraseblocks_per_lun;
-	first_lun = chip->cont_read.first_page / pages_per_lun;
-	last_lun = chip->cont_read.last_page / pages_per_lun;
+	ppl = memorg->pages_per_eraseblock * memorg->eraseblocks_per_lun;
+	first_lun = chip->cont_read.first_page / ppl;
+	last_lun = chip->cont_read.last_page / ppl;
 
 	/* Prevent sequential cache reads across LUN boundaries */
 	if (first_lun != last_lun)
-		chip->cont_read.pause_page = first_lun * pages_per_lun + pages_per_lun - 1;
+		chip->cont_read.pause_page = rawnand_last_page_of_lun(ppl, first_lun);
 	else
 		chip->cont_read.pause_page = chip->cont_read.last_page;
 }


