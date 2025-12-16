Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F383396E4;
	Tue, 16 Dec 2025 11:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884714; cv=none; b=TQa2zPZPLvvokVaM94bXNpLIrcXvEXlHOz1qP5Hl44tURxMz70J1G39h1SZxkE6wsOo2RWpAXsQxjzZfo3sPCGD0CjaGMAW3VVM8l/AC+I7Fgr8OaYDN1bilOZXuhoC0cL8wj4P/2NuWrE7Q37GbgRswFNIYJjaHlSeuJJnBesI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884714; c=relaxed/simple;
	bh=KsJVfQlqoaBQwOIW5fcYL4oRBBGlDpgMeDduK+2i5Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZ+v8kakNHZki1fukuXu2NM/yvJ26i2JLhl/VJRzpU4KRCegF/gPxHkGlZr8X8p1pf00w/w5WQDuzO2XLDBpg9DDOGqMz0LGMkU9UtGD2e/tZYMSYZyxa78Fh9oGIKgzouBIDSTRpRrmKhQrW7tqJb0hHcxmzNSe+VWuUiTJOdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWZuslm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWZuslm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528BFC4CEF1;
	Tue, 16 Dec 2025 11:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884713;
	bh=KsJVfQlqoaBQwOIW5fcYL4oRBBGlDpgMeDduK+2i5Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWZuslm/doAvVuvjoSgASDotSjq8y1geaAz+KbVrx0ROhR8FurwlGLkn4Wt05EYGO
	 OWZ/3eQoikMqL/ufFi+GFJ8X1M/lfVK8LzdzY/gZTh/KskFbyMgrqqzBbFzz0Kq9Tu
	 hTkDZBzjPYg9to6gqAcC1FRm+9+N9JFRHWFeaJLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/354] mtd: lpddr_cmds: fix signed shifts in lpddr_cmds
Date: Tue, 16 Dec 2025 12:14:02 +0100
Message-ID: <20251216111330.877652283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Stepchenko <sid@itb.spb.ru>

[ Upstream commit c909fec69f84b39e63876c69b9df2c178c6b76ba ]

There are several places where a value of type 'int' is shifted by
lpddr->chipshift. lpddr->chipshift is derived from QINFO geometry and
might reach 31 when QINFO reports a 2 GiB size - the maximum supported by
LPDDR(1) compliant chips. This may cause unexpected sign-extensions when
casting the integer value to the type of 'unsigned long'.

Use '1UL << lpddr->chipshift' and cast 'j' to unsigned long before
shifting so the computation is performed at the destination width.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c68264711ca6 ("[MTD] LPDDR Command set driver")
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/lpddr/lpddr_cmds.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/lpddr/lpddr_cmds.c b/drivers/mtd/lpddr/lpddr_cmds.c
index 14e36ae71958f..bd76479b90e4a 100644
--- a/drivers/mtd/lpddr/lpddr_cmds.c
+++ b/drivers/mtd/lpddr/lpddr_cmds.c
@@ -79,7 +79,7 @@ struct mtd_info *lpddr_cmdset(struct map_info *map)
 		mutex_init(&shared[i].lock);
 		for (j = 0; j < lpddr->qinfo->HWPartsNum; j++) {
 			*chip = lpddr->chips[i];
-			chip->start += j << lpddr->chipshift;
+			chip->start += (unsigned long)j << lpddr->chipshift;
 			chip->oldstate = chip->state = FL_READY;
 			chip->priv = &shared[i];
 			/* those should be reset too since
@@ -559,7 +559,7 @@ static int lpddr_point(struct mtd_info *mtd, loff_t adr, size_t len,
 			break;
 
 		if ((len + ofs - 1) >> lpddr->chipshift)
-			thislen = (1<<lpddr->chipshift) - ofs;
+			thislen = (1UL << lpddr->chipshift) - ofs;
 		else
 			thislen = len;
 		/* get the chip */
@@ -575,7 +575,7 @@ static int lpddr_point(struct mtd_info *mtd, loff_t adr, size_t len,
 		len -= thislen;
 
 		ofs = 0;
-		last_end += 1 << lpddr->chipshift;
+		last_end += 1UL << lpddr->chipshift;
 		chipnum++;
 		chip = &lpddr->chips[chipnum];
 	}
@@ -601,7 +601,7 @@ static int lpddr_unpoint (struct mtd_info *mtd, loff_t adr, size_t len)
 			break;
 
 		if ((len + ofs - 1) >> lpddr->chipshift)
-			thislen = (1<<lpddr->chipshift) - ofs;
+			thislen = (1UL << lpddr->chipshift) - ofs;
 		else
 			thislen = len;
 
-- 
2.51.0



