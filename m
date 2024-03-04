Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87FB3D0BA;
	Mon,  4 Mar 2024 21:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587776; cv=none; b=inUjgBu54GdsxJXfyH8tPLiaJViYOwmLLzkw1r3GgcKnFXhghMmbkE4pghRxc+3REYlQBvHdwQWgAxEYjSCHKfC4VplfrCH5QUbt6O8rwT7UsTh9uDUyar5Hrb0HCI/arD67zWG4RCF8cvNYg5FpfuN2ZDr3X/ltLnzw43Vrds4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587776; c=relaxed/simple;
	bh=nOvZY/ly/cAhPKXUeemfSe1tYOrpiSCZyNc9xlDfaJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3UpbKxwAG3P6qrIum4OIVt0uPde1MF035LWRV5K0KlO/RS9YU4o0byEy8BTaiBwgy26rHIEcqLpbM7a2kxhY1MJrMugWtYr07t/SQCVQxHSB5hNPySxV5Lr3LjUJCdB9tcyQtF0rsNgRQGlLsyeMiI9H31zBA96CkcaUV15lVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbUu/QLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbUu/QLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABCFC43390;
	Mon,  4 Mar 2024 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587776;
	bh=nOvZY/ly/cAhPKXUeemfSe1tYOrpiSCZyNc9xlDfaJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbUu/QLAd14iYRV9op+BcLPSe8nQLEdk2S0Ra25b/xCLJ9dQWesAwSr1LmTfut8wL
	 swhu6yVcRoDEsdteJnsZX6ib3Ql+CUL0V9kLTeOenQziV5KTMbWTGzkXpxkplCApgA
	 Tdj9igVcVGDrCsaw2fSGDs9qMXI/uuwGVcZmQrcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elad Nachman <enachman@marvell.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.7 085/162] mtd: rawnand: marvell: fix layouts
Date: Mon,  4 Mar 2024 21:22:30 +0000
Message-ID: <20240304211554.551712163@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Elad Nachman <enachman@marvell.com>

commit e6a30d0c48a1e8a68f1cc413bee65302ab03ddfb upstream.

The check in nand_base.c, nand_scan_tail() : has the following code:
(ecc->steps * ecc->size != mtd->writesize) which fails for some NAND chips.
Remove ECC entries in this driver which are not integral multiplications,
and adjust the number of chunks for entries which fails the above
calculation so it will calculate correctly (this was previously done
automatically before the check and was removed in a later commit).

Fixes: 68c18dae6888 ("mtd: rawnand: marvell: add missing layouts")
Cc: stable@vger.kernel.org
Signed-off-by: Elad Nachman <enachman@marvell.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/marvell_nand.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -290,16 +290,13 @@ static const struct marvell_hw_ecc_layou
 	MARVELL_LAYOUT( 2048,   512,  4,  1,  1, 2048, 32, 30,  0,  0,  0),
 	MARVELL_LAYOUT( 2048,   512,  8,  2,  1, 1024,  0, 30,1024,32, 30),
 	MARVELL_LAYOUT( 2048,   512,  8,  2,  1, 1024,  0, 30,1024,64, 30),
-	MARVELL_LAYOUT( 2048,   512,  12, 3,  2, 704,   0, 30,640,  0, 30),
-	MARVELL_LAYOUT( 2048,   512,  16, 5,  4, 512,   0, 30,  0, 32, 30),
+	MARVELL_LAYOUT( 2048,   512,  16, 4,  4, 512,   0, 30,  0, 32, 30),
 	MARVELL_LAYOUT( 4096,   512,  4,  2,  2, 2048, 32, 30,  0,  0,  0),
-	MARVELL_LAYOUT( 4096,   512,  8,  5,  4, 1024,  0, 30,  0, 64, 30),
-	MARVELL_LAYOUT( 4096,   512,  12, 6,  5, 704,   0, 30,576, 32, 30),
-	MARVELL_LAYOUT( 4096,   512,  16, 9,  8, 512,   0, 30,  0, 32, 30),
+	MARVELL_LAYOUT( 4096,   512,  8,  4,  4, 1024,  0, 30,  0, 64, 30),
+	MARVELL_LAYOUT( 4096,   512,  16, 8,  8, 512,   0, 30,  0, 32, 30),
 	MARVELL_LAYOUT( 8192,   512,  4,  4,  4, 2048,  0, 30,  0,  0,  0),
-	MARVELL_LAYOUT( 8192,   512,  8,  9,  8, 1024,  0, 30,  0, 160, 30),
-	MARVELL_LAYOUT( 8192,   512,  12, 12, 11, 704,  0, 30,448,  64, 30),
-	MARVELL_LAYOUT( 8192,   512,  16, 17, 16, 512,  0, 30,  0,  32, 30),
+	MARVELL_LAYOUT( 8192,   512,  8,  8,  8, 1024,  0, 30,  0, 160, 30),
+	MARVELL_LAYOUT( 8192,   512,  16, 16, 16, 512,  0, 30,  0,  32, 30),
 };
 
 /**


