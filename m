Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8879F13EFEC;
	Tue, 27 Feb 2024 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044100; cv=none; b=OWM7XGjzsTpOG0WFd+ebF/k08rb9/pVNbW1OWRy734TOBIUsZ4cB0ERV0XCYd6ZMb+VSdZ2AnFQ0EmzZayBBk38z1WjZH9zUJAqXncoy04MIak/gWfP9+dRf4Y1TcUPJaJzyZoMw7e9/OKmwG3iQ5CFotWUSNr2DZu3/ZwKI0Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044100; c=relaxed/simple;
	bh=qbpuj0WgGES7hcJxvhXLIfzV7L8F42Bj+LcGqUt1JJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vih1lfyDkVjylY8m98r7zPyZeALqHYWJfWSZx+84ak5MXPwdAnfHWGxL3j9m43Y/WYAbjP5lFN8EJMhrqQxgV5TT5q6aKsG6M/2FqEMTPP4YLNHJLqS6YHWDdwVRWA9/lgMAs/rmo++DIByPKKjLbcSeAEBNp8tFUtRZFKLDaX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1R3eEfqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R3eEfqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A43C433C7;
	Tue, 27 Feb 2024 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044100;
	bh=qbpuj0WgGES7hcJxvhXLIfzV7L8F42Bj+LcGqUt1JJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1R3eEfqG5DCL7HHZwBF+BLamgnjigTRCL0GK4eUY9Q6D017DR17nbshNSBR1JsDQd
	 8Q0jYEN/zZx5SpZVL76Wv2XgYdsJwABVExT1S334LA1fckIhmQEIfyoI9T+N+3IrWy
	 ni/74LR/KSd8hxsfJX+gr1S7+07ICvGU0xLkQW+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/122] btrfs: introduce btrfs_lookup_match_dir
Date: Tue, 27 Feb 2024 14:27:03 +0100
Message-ID: <20240227131600.733132161@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[ Upstream commit a7d1c5dc8632e9b370ad26478c468d4e4e29f263 ]

btrfs_search_slot is called in multiple places in dir-item.c to search
for a dir entry, and then calling btrfs_match_dir_name to return a
btrfs_dir_item.

In order to reduce the number of callers of btrfs_search_slot, create a
common function that looks for the dir key, and if found call
btrfs_match_dir_item_name.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8dcbc26194eb ("btrfs: unify lookup return value when dir entry is missing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dir-item.c | 76 +++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 863367c2c6205..1c0a7cd6b9b0a 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -171,6 +171,25 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, const char *name,
 	return 0;
 }
 
+static struct btrfs_dir_item *btrfs_lookup_match_dir(
+			struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, struct btrfs_path *path,
+			struct btrfs_key *key, const char *name,
+			int name_len, int mod)
+{
+	const int ins_len = (mod < 0 ? -1 : 0);
+	const int cow = (mod != 0);
+	int ret;
+
+	ret = btrfs_search_slot(trans, root, key, path, ins_len, cow);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret > 0)
+		return ERR_PTR(-ENOENT);
+
+	return btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
+}
+
 /*
  * lookup a directory item based on name.  'dir' is the objectid
  * we're searching in, and 'mod' tells us if you plan on deleting the
@@ -182,23 +201,18 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     const char *name, int name_len,
 					     int mod)
 {
-	int ret;
 	struct btrfs_key key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
+	struct btrfs_dir_item *di;
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_ITEM_KEY;
-
 	key.offset = btrfs_name_hash(name, name_len);
 
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0)
+	di = btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
+	if (IS_ERR(di) && PTR_ERR(di) == -ENOENT)
 		return NULL;
 
-	return btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
+	return di;
 }
 
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
@@ -212,7 +226,6 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 	int slot;
 	struct btrfs_path *path;
 
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -221,20 +234,20 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(name, name_len);
 
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-
-	/* return back any errors */
-	if (ret < 0)
-		goto out;
+	di = btrfs_lookup_match_dir(NULL, root, path, &key, name, name_len, 0);
+	if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		/* Nothing found, we're safe */
+		if (ret == -ENOENT) {
+			ret = 0;
+			goto out;
+		}
 
-	/* nothing found, we're safe */
-	if (ret > 0) {
-		ret = 0;
-		goto out;
+		if (ret < 0)
+			goto out;
 	}
 
 	/* we found an item, look for our name in the item */
-	di = btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
 	if (di) {
 		/* our exact name was found */
 		ret = -EEXIST;
@@ -275,21 +288,13 @@ btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 			    u64 objectid, const char *name, int name_len,
 			    int mod)
 {
-	int ret;
 	struct btrfs_key key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = objectid;
 
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0)
-		return ERR_PTR(-ENOENT);
-	return btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
+	return btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
 }
 
 struct btrfs_dir_item *
@@ -346,21 +351,18 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 					  const char *name, u16 name_len,
 					  int mod)
 {
-	int ret;
 	struct btrfs_key key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
+	struct btrfs_dir_item *di;
 
 	key.objectid = dir;
 	key.type = BTRFS_XATTR_ITEM_KEY;
 	key.offset = btrfs_name_hash(name, name_len);
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0)
+
+	di = btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
+	if (IS_ERR(di) && PTR_ERR(di) == -ENOENT)
 		return NULL;
 
-	return btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
+	return di;
 }
 
 /*
-- 
2.43.0



