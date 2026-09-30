Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B42652758E;
	Wed, 30 Sep 2026 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790569; cv=none; b=SUpwJXeO7j5N/G4zb0N4BuZTqFeFmrpVpqdH2Lf6I86nOJi4WmTcMUgMS5BpJ1uQMt663PkOFmz3wemKbdB8O5R6XrSXgApX65guK199alaxq7lnxk1uh9N+mUIwrTcZawuzYvSdWkfsyoyDIypOx3Dup/trOFlW8F0+dRqfTkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790569; c=relaxed/simple;
	bh=QZIJsO9vBJPCW/Vlx9jnPL6ogGHCSkR6V9wSobSKU54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiQssPiiGsyx9pwInerJ77qKyzVzsG/ova4XhJJj86JlIRZJNQ8zI+xFpzgUbwol41Y2GfoYuqkrtm5qBS9qyDkOzC2RId9kAyU1NnwaJLd8htGMCKtmY/PC6SmbTtAm/kW+4tONbGq3CKEz7YKyLLzWIn/yUhc82J+MlSDK3LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK4zgX/N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK4zgX/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B5B1F000FF;
	Wed, 30 Sep 2026 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790568;
	bh=xlBa7hUIBjaKtNjvZqbfYKaKI1UbvCNvEWyYEcjiDmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gK4zgX/NJZd+l+YdTWSx8w1sI73IeCRV7n3NbsIO7aJ/zu6bxjSHQGmFWQum/3OAV
	 hm0T8xlTsR5l9JpDiABEpWDtSiQh64Vgpu1bSrx1nKCD3zUxFw+M/f51woTCf99rgA
	 1NXj5gRY2ZC88UYCvFld4lhg6gnhFMZCfEwGsDSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>,
	Michal Simek <michal.simek@amd.com>
Subject: [PATCH 6.12 873/877] mtd: rawnand: pl353: Fix debug prints
Date: Wed, 30 Sep 2026 17:29:44 +0200
Message-ID: <20260930152433.572622530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>

commit 2b7baaddf1bc3e39206a0354449fdc349945b86b upstream.

They are partially incorrect since "software" engine does not mean
hamming, the "none" cae is also falling into this print, and on-die
means there is some kind of hardware support; we prefer to use the
wording on-host vs. on-die.

Fix all those prints.

Fixes: 1e06dbfdfb85 ("mtd: rawnand: pl353: Add message about ECC mode")
Signed-off-by: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -972,17 +972,19 @@ static int pl35x_nand_attach_chip(struct
 
 	switch (chip->ecc.engine_type) {
 	case NAND_ECC_ENGINE_TYPE_ON_DIE:
-		dev_dbg(nfc->dev, "Using on-die ECC\n");
+		dev_dbg(nfc->dev, "Using on-die hardware ECC\n");
 		/* Keep these legacy BBT descriptors for ON_DIE situations */
 		chip->bbt_td = &bbt_main_descr;
 		chip->bbt_md = &bbt_mirror_descr;
 		fallthrough;
 	case NAND_ECC_ENGINE_TYPE_NONE:
+		dev_dbg(nfc->dev, "Using no ECC engine\n");
+		break;
 	case NAND_ECC_ENGINE_TYPE_SOFT:
-		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
+		dev_dbg(nfc->dev, "Using software ECC\n");
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
-		dev_dbg(nfc->dev, "Using hardware ECC\n");
+		dev_dbg(nfc->dev, "Using on-host hardware ECC\n");
 		ret = pl35x_nand_init_hw_ecc_controller(nfc, chip);
 		if (ret)
 			return ret;


