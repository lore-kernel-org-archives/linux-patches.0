Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD543F12CE;
	Tue, 21 Jul 2026 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654589; cv=none; b=mpZI7hHZLGzbBDhXb1ReRUDceEqRmbSY8GhTTLTg6IdYacJo7EAoBmcLTesyatlxYyb6oEFlIkoTbaC/9YfpQAei2Qo6zuSh2PRiZnQoLle49xG1eTQBSQ+QDxRf7bE54P4hFasA8JCDNs2kEiGJs8QWJvYop5HNYXNva5Ohe5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654589; c=relaxed/simple;
	bh=wmNyT2sh+HF3xz/vki+bVHTmAhgDlNEA87jGFDGKzFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlLiPcU8FmOR1SgnDc29jEOJKS8cB1EPrSBOvyPWqMxPrExiJWQ3PvHPw61voPNuwj9+z8SSFbOgCYHzB6dUTtn75DPaXoc2nxa60/Z/pzPnX3hcS9854vxMOgdQjLvVq9iTEr4Fl0Wk/7quedw3CFKoRYizVBXNaFnx7YSuCbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1as7zymk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1as7zymk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F04F1F000E9;
	Tue, 21 Jul 2026 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654588;
	bh=1DR49gD/pVofUpG146dy6ulqEft5xVY38Uc/1UdwbsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1as7zymkDWFvQelZqPpe6NvBLRJgWcex11Zr6APCr7o9wOE1wAYucozc8RjLNNxOf
	 dHG1eXscTipeYmCw8I21MKx6HSFg7lF1ECCtBIvRYKl+ze68aWVzgUIwSEkSX6Y6jg
	 kK1WkiJstqyF75EAAPCP3RSZQ2adu9Zj8M+MVq/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 7.1 1763/2077] mtd: spi-nor: swp: Improve locking user experience
Date: Tue, 21 Jul 2026 17:23:56 +0200
Message-ID: <20260721152634.329082386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit e1d456b26bf23e30db305a6184e8abd9ab68bbf2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/swp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -282,8 +282,15 @@ static int spi_nor_sr_unlock(struct spi_
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


