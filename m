Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1482D0C94;
	Sat, 12 Sep 2026 12:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217652; cv=none; b=YFFbGnbFuF/ZDHj6eq16FNufMuJ5BI6bQVx/+CFXlJ1UlvsL+4vJKzFow0E8Lqmn0ZiYfqUFMB3PWEiSaMu5Ze0QCdKU00qfSjz3gnmp0gqsJh3owg+uiuuv9SI+w+iz/ZjtVmDVNbic/npKNbd3T85qjPtDzT0043EVY7GcDmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217652; c=relaxed/simple;
	bh=TkZH6PlTbe3YwPLcYzmwz/oUJ3Mc61uohxivppElv60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMvKR0gBxH8+21zrUkEhdMcP/DwS2QjDe3cdA0c27QyNettQaVzcZtuviWqSOEq5mg5HQHCYueHzEnu17cZ0yx5ze3sZeb9FOB+Y6LOEw9qijPxVuJzze1JMR90I+5gSltoGdoI/kGzafS1Dhr28YhTqKAe6Ku4ezEDwGiTHyKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=si90OFs6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="si90OFs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8A71F000FF;
	Sat, 12 Sep 2026 12:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217651;
	bh=I9VuPlFHEw+Bc2U7jWfwwDMel8FeHv6QmU4TRKRsDy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=si90OFs6MM2oxXxOKN3ZugKUb1/y5xMTNJGKU+db4J6mgGxldekiiU5Z3i9IjsgQU
	 ik9mXJyI9BP2jGdmZJpfg3GCkPj5PL/O9Toow/Wpyw8kyj1zBrED3CAGUNnglsC/gx
	 nVJJVGwXkSEYr6DK1yRuXQ0ickIWd6Z3lsW2bP2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Yichong Chen <chenyichong@uniontech.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0984/1376] btrfs: retry verity reads for not-uptodate Merkle folios
Date: Sat, 12 Sep 2026 08:56:50 +0200
Message-ID: <20260912065629.498773804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index e97ad824ae16d..2e301f06c5731 100644
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



