Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BAD384232;
	Sat, 12 Sep 2026 10:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210337; cv=none; b=if2g4rUeySHfTvhoG8WOJMMjbxA1Bd60xd+2LUAhn2A0apXgc/y3K0V9KyqGnwOzHtf1Hi5YPKi/ZYxOO/UABuCn9/l8gMvfjDFwuN3hUfac2m8YGEHrn+s6gothYWm5p9YmXWI0EYmMQoFa5qV4OZezvVsn6Goyic8sA1a5GDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210337; c=relaxed/simple;
	bh=+eod9tt0r913cbRmcHAGPCjPM5hCo6vdI3P8s7aipc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkICH+lI4QOsCqAPeF2f+b0bdp1fvvdtqm6tlQ80c4MFdqcfyf/EE+GQxgFEyj2bKiPehQSGHodqH71Pi03j8CT4IyHp1e1l7Ow8N9ECu31JLGeTMqR7shtf1fo8dy6yVstTElenHkUYj6T/cewYs8bHu0OUfXcxg1mA2TG3A0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRVcYnnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRVcYnnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10BD1F000FF;
	Sat, 12 Sep 2026 10:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210335;
	bh=aiItq8SzeRDyODEFqV7el32Lf9hoOAwcONYWfce1XX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRVcYnnFf8wyTxvpz5lwPG0tz+5zDON0F/B9XkaGlVGtstJ93Ct9ZXzN+F9zEy85w
	 LN2et/VVR9eWtmBrRBhaBN2CRO4rURzMyxWAT55F+x9Gef5XubsBRiE45H4PRKAJ3b
	 fU9kQHCPM10fdsG+h/FmYnsXLi/8hxCdPyxY22hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Yichong Chen <chenyichong@uniontech.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1003/1518] btrfs: retry verity reads for not-uptodate Merkle folios
Date: Sat, 12 Sep 2026 08:52:52 +0200
Message-ID: <20260912065646.143291161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 8cc569696dac51fc62bb39b3b8f530582b916d29 ]

btrfs_read_merkle_tree_page() can find a folio in the mapping that is not
uptodate.  After taking the folio lock, the current code treats that state
as a read error and returns -EIO.

That can make a previous transient read failure sticky.  If the failed read
left a not-uptodate folio in the mapping, later callers find that folio and
fail instead of retrying the read.

Keep the existing page-cache insertion and locking order, but retry the
Merkle item read when a not-uptodate folio is found in the mapping.  Also
unlock the folio when read_key_bytes() fails so that a later caller can
lock it and retry the read.

Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/verity.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 46bd8ca586708..7fc30a58d8d9c 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -731,14 +731,18 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 			goto out;
 
 		folio_lock(folio);
-		/* If it's not uptodate after we have the lock, we got a read error. */
-		if (!folio_test_uptodate(folio)) {
+		/* Folio was truncated from mapping. */
+		if (!folio->mapping) {
 			folio_unlock(folio);
 			folio_put(folio);
-			return ERR_PTR(-EIO);
+			goto again;
 		}
-		folio_unlock(folio);
-		goto out;
+		/* Another reader may have filled the folio while we waited. */
+		if (folio_test_uptodate(folio)) {
+			folio_unlock(folio);
+			goto out;
+		}
+		goto read_folio;
 	}
 
 	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
@@ -755,6 +759,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 		return ERR_PTR(ret);
 	}
 
+read_folio:
 	/*
 	 * Merkle item keys are indexed from byte 0 in the merkle tree.
 	 * They have the form:
@@ -764,6 +769,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
 			     folio_address(folio), PAGE_SIZE, folio);
 	if (ret < 0) {
+		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(ret);
 	}
-- 
2.53.0



