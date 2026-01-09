Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59C8335561;
	Fri,  9 Jan 2026 12:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960075; cv=none; b=CL9IXFwHqIwzlZmuGQQyVUXVqtue7ESXalZf7iJUL7OfiJbN3IWV8BL1u+CFAz87NdmuQK+Ocj0IP4bHM1siavawDdHFwOBsECEe67PfxMHPi+R7AF0IVt5rJEKgRfFF+wsguc/0AV3yFMFzzF1Td1C+4cID68095xMASWnoDxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960075; c=relaxed/simple;
	bh=WV7/M9W/2XBcP5zxdVAkCUnwHGWawit4iEGdTA5GdjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOU1YjBcjRIFrXSUvQNyL6osEVlxJbGwjNs4XmZnhNyQlHb8EKa5LZWq1bnBlqp81UO+jsVGSpezCN2ERRIf2HRMa9g/gtbthaOYN5DlHRsCVemP/rIXgdWzaG6ijbGfpdwbA7It1yHyod4AFQyRWsxefWZzmrckKiUsnnME5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsngL6qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsngL6qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B64C4CEF1;
	Fri,  9 Jan 2026 12:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960075;
	bh=WV7/M9W/2XBcP5zxdVAkCUnwHGWawit4iEGdTA5GdjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsngL6qqMF+roR59SAORv/9fWKdBhwKZu1j0m4fxAI7Aru70n5asqdB8gS37UYjYX
	 mg+6kTNCrulgFpkn+CYPG8oZ7RL74St5OAa0qjJGwh0X0r/1Tjw7a9/qDIT9kdRe+a
	 9OuW7QxrrAqnJiCB4dsBOZ/lT4xp7CwuWNyivEhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/737] mtd: lpddr_cmds: fix signed shifts in lpddr_cmds
Date: Fri,  9 Jan 2026 12:36:28 +0100
Message-ID: <20260109112143.359777061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 3c3939bc2dadc..2a2318230936e 100644
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



