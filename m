Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CDF2C21F4;
	Thu, 15 Jan 2026 17:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499118; cv=none; b=VPRgKPYoHZjRxVZ8KZXxzwujKhY+j7uR1zYJLEVX6FcpSL51ubFKlZGTwHjXeb60PYLdLcB3Wp1+bTfXs69B1zGfPOPAMdmd8p5EFZYpZ6QU4ljDXBxt4VzDceTATLH6oRw2iY9cFcVLAm+rlMc0gif1le9sN7THZQB6WoBXIsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499118; c=relaxed/simple;
	bh=Sv4eDXW++bJ3W4Sm8/kr7vMfpht6woAeR3GJbcOsPe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBWFFV81h+bt7p/WokBQzGTNWmnQwbTyS8Jirbnps++ADSgPV3E786DpWekTtWPKOPZxsFg3H4mxOw6sRWkIPrMKK0zoSfW4lcu3HrNjlcL8P4WidFA0eS7k3++B4DGYjeWHPVTCX7875kWVpyVoQu8IVdAn/08GdxZXvlAXe3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr3EF6SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr3EF6SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0497FC116D0;
	Thu, 15 Jan 2026 17:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499118;
	bh=Sv4eDXW++bJ3W4Sm8/kr7vMfpht6woAeR3GJbcOsPe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wr3EF6SYEMEiom5i3NoGa46PotZDU+/xG0Q392vp2Maw6KspJXZtdD08nrqO//RiM
	 Y+YNTEZ4D17EqFxYWSjassHZLq09a4m+cDXYAGw6cG8Gru9PY/zwSn++aopN4G6aWf
	 sSU4di2rKYPixuB8zkyMd9SWl2gwKbbVmvboJSzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/451] mtd: lpddr_cmds: fix signed shifts in lpddr_cmds
Date: Thu, 15 Jan 2026 17:45:15 +0100
Message-ID: <20260115164235.045669696@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



