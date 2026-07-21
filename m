Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C268F45DF69;
	Tue, 21 Jul 2026 22:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672450; cv=none; b=HsMQcwg6Y6ZVC3ERDRHXRx1W2cc4h2Kggb7USYJZkZykoaYvZjyMFxxclPlO7mq/D2yWGwEawH+9Qb/hRJvXMPGEHe/6QM0xZ/zj6SLKx4uYxwCMjEmCiBHeq0xWHrKXl5HgPTPCsmiBWty/7q9rGaxFyJjEKD5Ri7n/f2+LjkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672450; c=relaxed/simple;
	bh=gnPLxCKtyUkcN136t0/oqiKE3tYAwSoFaby+QgiCMb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EC5RMfgbUc55/NHYvsY2KGsHX3z67yl/wp+ymiMnueQUM82vsQbG42Uam2SFf8SeuTSUVchOil/SJAy13E28PtdSavH9JPgqtXj57KbkQKfQTNZnQAmCgLCn3R27+pcuYUj8tztkdfXSoR/Pcd8cPJVfvThcDoGlxdp/71mB5hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osLNUKaW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osLNUKaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3C61F000E9;
	Tue, 21 Jul 2026 22:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672449;
	bh=1IbvXtWNlYtK4efSwOKVQWdg1CbS3Oc+mY9W5qBIVp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osLNUKaWoeSB0/9OxJ+JeFwoJDzB2fn71gk1bsjfta0B6/XiGzJemxJ5ttOirEMjG
	 hs51l7036cjQeWWxvnpX/lIxxB4T/DTiZB0Tgr/2CFy/Od3V7p3Gmz8aFofFORAiKI
	 U+dAH08qVgCPdC0c7asXKhFMngZzoU2l1QzcTAQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 627/843] mtd: rawnand: fix condition in nand_select_target()
Date: Tue, 21 Jul 2026 17:24:22 +0200
Message-ID: <20260721152420.166924433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Arseniy Krasnov <avkrasnov@rulkc.org>

commit 8507c2cc9e4fa402401819f44d1e8a5ef4d11d8b upstream.

'cs' here must be in range [0:nanddev_ntargets[.

Cc: stable@vger.kernel.org
Fixes: 32813e288414 ("mtd: rawnand: Get rid of chip->numchips")
Signed-off-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -175,7 +175,7 @@ void nand_select_target(struct nand_chip
 	 * cs should always lie between 0 and nanddev_ntargets(), when that's
 	 * not the case it's a bug and the caller should be fixed.
 	 */
-	if (WARN_ON(cs > nanddev_ntargets(&chip->base)))
+	if (WARN_ON(cs >= nanddev_ntargets(&chip->base)))
 		return;
 
 	chip->cur_cs = cs;


