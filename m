Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902603F104B;
	Sat, 12 Sep 2026 08:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201924; cv=none; b=crqybGFcYtLVHfHuim9SlhQBI0AXR4YxcfbcqxmfNLdMbZsuS8tjw9HOGZlsDz5Ml3mj+ClWGoJY2LlLvWT+ghTWEt01Sw17UJTWoznH6sIUiT2wSXpU9ZIgy4PcjJN0xtFr64VB/yaiaZAJc8JsKohO+SHrUgkI83TmXZeIjpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201924; c=relaxed/simple;
	bh=cCyV8mrMlg2vlNi53JJyOzbY7T46vPAA2AeyoP+bvtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krWGz8F3pUZaEtnUcD28ljwaoblJPhu+9h51J9yUvpC8MlRQcazQ6pEB4ABsdAvVWn3UYgf54ZaM762dn28mXL3Z9/AOXuBG3P6EheshwPuizXxYPv5QTnYhylsy48qHX+pdfZQBuZum6XFACR8qtK/2pLTAVgIpJ3+sHn45x8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFKyOtLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFKyOtLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC9A1F000FF;
	Sat, 12 Sep 2026 08:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201921;
	bh=nb4081AeAXh2132iPHnbRCCKb7gmZBBvCp7FnbJpbLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFKyOtLmRpdT3LvQuqErZqbVH9OdP+nKLDW4HG2qiqvX85UHIgbbsjZKY46IXTm3v
	 BggZYmsukGwSBHZFekwcnaJNV74YPCr/44Ge7vCQqkjcMKgdmF7r8+fgr6tWvzRI3C
	 UluKSxmv+Ib0X52reJomKiIjr55PUvUYMEuYLs8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1053/1815] block: handle nogenerate/noverify properly in fs-integrity
Date: Sat, 12 Sep 2026 08:46:43 +0200
Message-ID: <20260912065713.737354214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3bf9a21e7bccfd8c35b440efd114c61cc9838a41 ]

Check the BIP_CHECK flags before generating or verifying PI information,
otherwise this can be incorrectly called for non-PI metadata and
cause generation of incorrect metadata and crashed in the verification
handler.

The new behavior matches that of the block layer auto-generated
metadata.

Fixes: 0bde8a12b554 ("block: add fs_bio_integrity helpers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Link: https://patch.msgid.link/20260804123928.736596-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity-fs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 9c5fe5fa8f0da..692403dfa047b 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -46,7 +46,8 @@ void fs_bio_integrity_free(struct bio *bio)
 
 void fs_bio_integrity_generate(struct bio *bio)
 {
-	if (fs_bio_integrity_alloc(bio))
+	if (fs_bio_integrity_alloc(bio) &&
+	    (bio_integrity(bio)->bip_flags & BIP_CHECK_FLAGS))
 		bio_integrity_generate(bio);
 }
 EXPORT_SYMBOL_GPL(fs_bio_integrity_generate);
@@ -60,6 +61,9 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 		.bi_size	= size,
 	};
 
+	if (!bip || !(bip->bip_flags & BIP_CHECK_FLAGS))
+		return 0;
+
 	/*
 	 * Reinitialize bip->bip_iter.
 	 *
-- 
2.53.0



