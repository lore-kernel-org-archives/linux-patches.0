Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620377FE
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBLNxpkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0173C433CA;
	Mon, 23 Oct 2023 11:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060205;
	bh=9YPTS3GqGDl4AVek+uXP06hbAO4XDpq5G9MJAVTAkIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBLNxpkl7EGEeWG7Gy4JV4LVwEvE2G8bF1qkYyWb1Gw0ub+5uJTyJJwMkgkWXqe6/
	 9KaSIMQiKWKNnLvuszgQ43TRkCzxkwrFX/b9Ndv7R+K7dVd0gJnkcGe20ol+1rRObi
	 C8rhjqUfd7KvhBt9qhzgkQhBQN4cjL6VjN0AVaR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/196] btrfs: prevent transaction block reserve underflow when starting transaction
Date: Mon, 23 Oct 2023 12:55:59 +0200
Message-ID: <20231023104831.189181875@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a7ddeeb079505961355cf0106154da0110f1fdff ]

When starting a transaction, with a non-zero number of items, we reserve
metadata space for that number of items and for delayed refs by doing a
call to btrfs_block_rsv_add(), with the transaction block reserve passed
as the block reserve argument. This reserves metadata space and adds it
to the transaction block reserve. Later we migrate the space we reserved
for delayed references from the transaction block reserve into the delayed
refs block reserve, by calling btrfs_migrate_to_delayed_refs_rsv().

btrfs_migrate_to_delayed_refs_rsv() decrements the number of bytes to
migrate from the source block reserve, and this however may result in an
underflow in case the space added to the transaction block reserve ended
up being used by another task that has not reserved enough space for its
own use - examples are tasks doing reflinks or hole punching because they
end up calling btrfs_replace_file_extents() -> btrfs_drop_extents() and
may need to modify/COW a variable number of leaves/paths, so they keep
trying to use space from the transaction block reserve when they need to
COW an extent buffer, and may end up trying to use more space then they
have reserved (1 unit/path only for removing file extent items).

This can be avoided by simply reserving space first without adding it to
the transaction block reserve, then add the space for delayed refs to the
delayed refs block reserve and finally add the remaining reserved space
to the transaction block reserve. This also makes the code a bit shorter
and simpler. So just do that.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-ref.c | 9 +--------
 fs/btrfs/delayed-ref.h | 1 -
 fs/btrfs/transaction.c | 6 +++---
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 36a3debe94930..e08e3852c4788 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -141,24 +141,17 @@ void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans)
  * Transfer bytes to our delayed refs rsv
  *
  * @fs_info:   the filesystem
- * @src:       source block rsv to transfer from
  * @num_bytes: number of bytes to transfer
  *
- * This transfers up to the num_bytes amount from the src rsv to the
+ * This transfers up to the num_bytes amount, previously reserved, to the
  * delayed_refs_rsv.  Any extra bytes are returned to the space info.
  */
 void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
-				       struct btrfs_block_rsv *src,
 				       u64 num_bytes)
 {
 	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
 	u64 to_free = 0;
 
-	spin_lock(&src->lock);
-	src->reserved -= num_bytes;
-	src->size -= num_bytes;
-	spin_unlock(&src->lock);
-
 	spin_lock(&delayed_refs_rsv->lock);
 	if (delayed_refs_rsv->size > delayed_refs_rsv->reserved) {
 		u64 delta = delayed_refs_rsv->size -
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index d6304b690ec4a..712a6315e956b 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -383,7 +383,6 @@ void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
 int btrfs_delayed_refs_rsv_refill(struct btrfs_fs_info *fs_info,
 				  enum btrfs_reserve_flush_enum flush);
 void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
-				       struct btrfs_block_rsv *src,
 				       u64 num_bytes);
 int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans);
 bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1193214ba8c10..60db4c3b82fa1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -614,14 +614,14 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 			reloc_reserved = true;
 		}
 
-		ret = btrfs_block_rsv_add(fs_info, rsv, num_bytes, flush);
+		ret = btrfs_reserve_metadata_bytes(fs_info, rsv, num_bytes, flush);
 		if (ret)
 			goto reserve_fail;
 		if (delayed_refs_bytes) {
-			btrfs_migrate_to_delayed_refs_rsv(fs_info, rsv,
-							  delayed_refs_bytes);
+			btrfs_migrate_to_delayed_refs_rsv(fs_info, delayed_refs_bytes);
 			num_bytes -= delayed_refs_bytes;
 		}
+		btrfs_block_rsv_add_bytes(rsv, num_bytes, true);
 
 		if (rsv->space_info->force_alloc)
 			do_chunk_alloc = true;
-- 
2.40.1



