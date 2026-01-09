Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF08336EDA;
	Fri,  9 Jan 2026 12:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962001; cv=none; b=I06UlvAK0VGxAdrb2coag/H+ASZ9jidliZTd9lRm83PaWlAL9eV1PHrB9tHjPhNcyJlCFsp17mibYRDjtVCcfgExlmHzWs2Qy99dfLiC8SSRko/7Y9XhxUs8bHvYyzHY0l/2VBLhlZxLvATnqk3ZzUReHqJlwQxMJaN6fNLKlh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962001; c=relaxed/simple;
	bh=ztB4m1A0+DqpJI07mmYlCjqI+oXX2M03lfZjMM7N4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYa/OWHZrzKeg/D7Rjomuxwm1RXgKavJ6rq2tH1zrGV+gYnMugfaQu2fnF1wKriDhvhgFIrOGO0XrwY14qRMU2CORDSg2JxUXLJXvZmmkFe1gCaC5RFYkwrJlH3LEoGZyv9E4OceR4GM4KXLaEJT8OZTRqgZfRwn3g7zIsHqJc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2n7GWDRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2n7GWDRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D34DC4AF09;
	Fri,  9 Jan 2026 12:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962000;
	bh=ztB4m1A0+DqpJI07mmYlCjqI+oXX2M03lfZjMM7N4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2n7GWDRMPd7AM5vv98JNQTW4a8C1t12VhKW2mDfjv5NkqXp6NCdf5rldTUyvcOApg
	 9I0sU8BXctfVIfAGZ51gdx43FjZ/pG9ipUgLrEx0D5b2TYfMFzS25cE/TP7kH4GQhx
	 FftYLKp1H7Y73bEbnXKNcLCKM6HP3nu+WX3+h4/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/634] mtd: lpddr_cmds: fix signed shifts in lpddr_cmds
Date: Fri,  9 Jan 2026 12:37:36 +0100
Message-ID: <20260109112124.141367985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee063baed136c..5c39c9c653233 100644
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
@@ -562,7 +562,7 @@ static int lpddr_point(struct mtd_info *mtd, loff_t adr, size_t len,
 			break;
 
 		if ((len + ofs - 1) >> lpddr->chipshift)
-			thislen = (1<<lpddr->chipshift) - ofs;
+			thislen = (1UL << lpddr->chipshift) - ofs;
 		else
 			thislen = len;
 		/* get the chip */
@@ -578,7 +578,7 @@ static int lpddr_point(struct mtd_info *mtd, loff_t adr, size_t len,
 		len -= thislen;
 
 		ofs = 0;
-		last_end += 1 << lpddr->chipshift;
+		last_end += 1UL << lpddr->chipshift;
 		chipnum++;
 		chip = &lpddr->chips[chipnum];
 	}
@@ -604,7 +604,7 @@ static int lpddr_unpoint (struct mtd_info *mtd, loff_t adr, size_t len)
 			break;
 
 		if ((len + ofs - 1) >> lpddr->chipshift)
-			thislen = (1<<lpddr->chipshift) - ofs;
+			thislen = (1UL << lpddr->chipshift) - ofs;
 		else
 			thislen = len;
 
-- 
2.51.0



