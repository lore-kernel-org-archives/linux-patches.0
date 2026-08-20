Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E53272E53;
	Thu, 20 Aug 2026 16:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243634; cv=none; b=PN/ULuGSByKrK4YvJX3yP7a6M2+/pnG7VYg7NmPwdWZ5isDRt/wveOT/fpuA8vcmHS07TkdjYuUZwSsno2E8XNVMmhY0Psem4KKDmUGlBdm+1Y1iZZcOGhPiNddJgza0qT00S5oTLEML8Rfnk150JzdYlpoxG7AV7Bq/5wEHegc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243634; c=relaxed/simple;
	bh=awrjKMC7Yy+1vN9pdd6jicRiXbuym/X12qNVgI++xCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T29c3FDDMTV4gUdC81o47dUDaQ8SJe6AysZQH9uH3JtOT7UDJFiY9+yibFb/aVjT1svSn0gFNsUztuH8m3tIAM5UACoMGKIsbTWoufsAdEMVolkOZ4JdFqUBEB6D/w0HMLaVICmVPN/d/WMQRl6n+iqWyOG2KIMepkUYbxxfs/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr5rkzkL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr5rkzkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5851F000E9;
	Thu, 20 Aug 2026 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243633;
	bh=mkSBcYWxcCLmihPPnGU05enuHNA55SYngadeH2EsK4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vr5rkzkLiUwr89CLxq6JDylVezybTSjBuKir0KavQXwgOSlPRKRs6YGvLL0LehMHW
	 bcveszX6r/SKF2SvkWZvuK1QytGvtct40kzsjtKT89V0bq6v/9WAsKiM/pYLkGn2ke
	 1Bfxp3g60cUCLmQREr/gbYX1YRee3nCsU+3jEYqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/272] mtd: spi-nor: swp: Improve locking user experience
Date: Thu, 20 Aug 2026 16:54:58 +0200
Message-ID: <20260820145234.690744888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit e1d456b26bf23e30db305a6184e8abd9ab68bbf2 ]

In the case of the first block being locked (or the few first blocks),
if the user want to fully unlock the device it has two possibilities:
- either it asks to unlock the entire device, and this works;
- or it asks to unlock just the block(s) that are currently locked,
  which fails.

It fails because the conditions "can_be_top" and "can_be_bottom" are
true. Indeed, in this case, we unlock everything, so the TB bit does not
matter. However in the current implementation, use_top would be true (as
this is the favourite option) and lock_len, which in practice should be
reduced down to 0, is set to "nor->params->size - (ofs + len)" which is
a positive number. This is wrong.

An easy way is to simply add an extra condition. In the unlock() path,
if we can achieve the same result from both sides, it means we unlock
everything and lock_len must simply be 0. A comment is added to clarify
that logic.

Fixes: 3dd8012a8eeb ("mtd: spi-nor: add TB (Top/Bottom) protect support")
Cc: stable@kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/swp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -272,8 +272,15 @@ static int spi_nor_sr_unlock(struct spi_
 	/* Prefer top, if both are valid */
 	use_top = can_be_top;
 
-	/* lock_len: length of region that should remain locked */
-	if (use_top)
+	/*
+	 * lock_len: length of region that should remain locked.
+	 *
+	 * When can_be_top and can_be_bottom booleans are true, both adjacent
+	 * regions are unlocked, thus the entire flash can be unlocked.
+	 */
+	if (can_be_top && can_be_bottom)
+		lock_len = 0;
+	else if (use_top)
 		lock_len = nor->params->size - (ofs + len);
 	else
 		lock_len = ofs;


