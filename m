Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065107;
	b=PmWp2M2+zHR8w74CIZg0QWeMQHg4ZcfwzSRuHmIv/CnnJ6Vtw5pqi7fgAzFgoLICGGVa
	 onTHUnGXUrM9O7amUm1X5Uz1iE8f7NPT0d4sH+C432adzSNfhjVbrM03CuzMLwbxfekqG
	 IAYb9M3qR3JSX5NZ+F4kDmlIQJwb8SUc1eOrn6s481fN1lYNWvVi7wt4zBQIjpaXYbVSh
	 Ad+6bOncTYXrbrK3XfNQLudFiGwaaoRJYwRjTFPjKXeSRN/H1I31eHJoUyOdQTb6VAQqc
	 NgNAY1GOG3IYIUQxfrw33KAC+/2JyemjffsZDvlVdp3UzxQxS/wIM6AiLAbZ58jjFTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MaIaIf284Jzciuh2+HQCAqAfd8vgoAXDBSdCYTFuDrI=;
	b=GmgGURtzxOvhMlDS/uNcZczB1BLZ21pXXm3Ay+1UCYrkP6Po3jdxU7CW/URMhiBGMtJ/
	 rWye+Cqm6RyPyv49P/E30bA9CBZZTK02sddHmhz/MKfCqf6oDlDLxPkYc0OFK8MFZljMJ
	 swcfJbzRSTFueTFc3LOIudV4aZ+NFmwFGJG1Jtag2dNAan00L3Zbuw+svtbOjo8L8UfKT
	 1yWtOIpzLjcnzMeGQDtUCeyeWta3tVfs7PKehxU2MRUXdk7hpb41GOLL0mrRM/74YLjEJ
	 88gZuCfnefgyba3xkTpV/3yhC8U+wWa25Dp5EVMIk4vJXkQMCG//jcz/pgn/G0jPJaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOcw3vMF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290EB606A32C;
	Sat,  7 Nov 2026 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOcw3vMF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7901F0089F;
	Sat,  7 Nov 2026 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065107;
	bh=MaIaIf284Jzciuh2+HQCAqAfd8vgoAXDBSdCYTFuDrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOcw3vMFUV2TCNrWN0bcNbdjiad9NZzvGm+LHSXOaKwoavhu+hpzcxD6hksM2NQqg
	 Lt89K6LuSqH5jYZAZN4ZtEs9xTRskdv7mfd3AglwKlmsCsh41GaeUCj4dUbv6a4X7v
	 nX5kGnT7ogahqlFuLHfYtS8YWDuSOZ21wVlmrwg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0936/1257] ntfs: balance the $MFT runlist lock in data extension error paths
Date: Sat,  7 Nov 2026 08:53:52 -0500
Message-ID: <20261107135005.209622630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 69ba74e8a5dfc6fd7ba3588e81d53e965566f3a4 ]

ntfs_mft_data_extend_allocation_nolock() drops the $MFT runlist lock
before allocating clusters, and every path into undo_alloc arrives
without it, except a map_mft_record() failure, which takes it first.
undo_alloc never releases it, so the lock leaks and the next $MFT
extension and $MFT writeback hang.  The restore_undo_alloc failure
path, on the other hand, releases the lock without holding it.  And
undo_alloc frees the clusters with ntfs_cluster_free() and truncates
the runlist without the lock, although both require it.

Enter undo_alloc without the lock on every path.  Merge the new clusters
with ntfs_runlists_merge_keep_src() and keep the runlist that
ntfs_cluster_alloc() returned until the extension is complete.  On
failure, undo_alloc truncates $MFT's runlist under the lock and, after
dropping it, frees the clusters from the kept runlist with
ntfs_cluster_free_from_rl().  That keeps lcnbmp_lock outside the runlist
lock, the order given by the comment before the cluster allocation.
Unlike ntfs_cluster_free() on a volume mounted with -o discard, this
does not issue discards for the clusters, which were never written; the
runlist merge failure path already frees them the same way.  If the
truncation fails, the runlist may still reference the clusters, so they
stay allocated and the volume is marked for chkdsk; at this call site
the truncation only shrinks the runlist and cannot fail today.

A shorter fix would keep calling ntfs_cluster_free() on the live
runlist without the lock, relying on $MFT's runlist being fully mapped
and changed only by this function under mrec_lock.  That breaks
ntfs_cluster_free()'s documented locking rule on an argument about the
rest of the driver, so this patch does not do that.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 892d27db22a3e..482a216ade2cb 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1771,7 +1771,7 @@ static int ntfs_mft_data_extend_allocation_nolock(struct ntfs_volume *vol)
 	s64 min_nr, nr, ll;
 	unsigned long flags;
 	struct ntfs_inode *mft_ni;
-	struct runlist_element *rl, *rl2;
+	struct runlist_element *rl, *rl2, *alloc_rl;
 	struct ntfs_attr_search_ctx *ctx = NULL;
 	struct mft_record *mrec;
 	struct attr_record *a = NULL;
@@ -1839,15 +1839,15 @@ static int ntfs_mft_data_extend_allocation_nolock(struct ntfs_volume *vol)
 	up_write(&mft_ni->runlist.lock);
 
 	do {
-		rl2 = ntfs_cluster_alloc(vol, old_last_vcn, nr, lcn, MFT_ZONE,
-				true, false, false);
-		if (!IS_ERR(rl2))
+		alloc_rl = ntfs_cluster_alloc(vol, old_last_vcn, nr, lcn,
+				MFT_ZONE, true, false, false);
+		if (!IS_ERR(alloc_rl))
 			break;
-		if (PTR_ERR(rl2) != -ENOSPC || nr == min_nr) {
+		if (PTR_ERR(alloc_rl) != -ENOSPC || nr == min_nr) {
 			ntfs_error(vol->sb,
 				"Failed to allocate the minimal number of clusters (%lli) for the mft data attribute.",
 				nr);
-			return PTR_ERR(rl2);
+			return PTR_ERR(alloc_rl);
 		}
 		/*
 		 * There is not enough space to do the allocation, but there
@@ -1858,17 +1858,22 @@ static int ntfs_mft_data_extend_allocation_nolock(struct ntfs_volume *vol)
 		ntfs_debug("Retrying mft data allocation with minimal cluster count %lli.", nr);
 	} while (1);
 
+	/*
+	 * Keep @alloc_rl until the extension is complete: it describes exactly
+	 * the new clusters, which undo_alloc frees if a later step fails.
+	 */
 	down_write(&mft_ni->runlist.lock);
-	rl = ntfs_runlists_merge(&mft_ni->runlist, rl2, 0, &new_rl_count);
+	rl = ntfs_runlists_merge_keep_src(&mft_ni->runlist, alloc_rl, 0,
+			&new_rl_count);
 	if (IS_ERR(rl)) {
 		up_write(&mft_ni->runlist.lock);
 		ntfs_error(vol->sb, "Failed to merge runlists for mft data attribute.");
-		if (ntfs_cluster_free_from_rl(vol, rl2)) {
+		if (ntfs_cluster_free_from_rl(vol, alloc_rl)) {
 			ntfs_error(vol->sb,
 				"Failed to deallocate clusters from the mft data attribute.%s", es);
 			NVolSetErrors(vol);
 		}
-		kvfree(rl2);
+		kvfree(alloc_rl);
 		return PTR_ERR(rl);
 	}
 	mft_ni->runlist.rl = rl;
@@ -1884,7 +1889,6 @@ static int ntfs_mft_data_extend_allocation_nolock(struct ntfs_volume *vol)
 	if (IS_ERR(mrec)) {
 		ntfs_error(vol->sb, "Failed to map mft record.");
 		ret = PTR_ERR(mrec);
-		down_write(&mft_ni->runlist.lock);
 		goto undo_alloc;
 	}
 	ctx = ntfs_attr_get_search_ctx(mft_ni, mrec);
@@ -1982,6 +1986,7 @@ static int ntfs_mft_data_extend_allocation_nolock(struct ntfs_volume *vol)
 	mark_mft_record_dirty(ctx->ntfs_ino);
 	ntfs_attr_put_search_ctx(ctx);
 	unmap_mft_record(mft_ni);
+	kvfree(alloc_rl);
 	ntfs_debug("Done.");
 	return 0;
 restore_undo_alloc:
@@ -1995,7 +2000,7 @@ static int ntfs_mft_data_extend_allocation_nolock(struct ntfs_volume *vol)
 		write_unlock_irqrestore(&mft_ni->size_lock, flags);
 		ntfs_attr_put_search_ctx(ctx);
 		unmap_mft_record(mft_ni);
-		up_write(&mft_ni->runlist.lock);
+		kvfree(alloc_rl);
 		/*
 		 * The only thing that is now wrong is ->allocated_size of the
 		 * base attribute extent which chkdsk should be able to fix.
@@ -2006,15 +2011,28 @@ static int ntfs_mft_data_extend_allocation_nolock(struct ntfs_volume *vol)
 	ctx->attr->data.non_resident.highest_vcn =
 			cpu_to_le64(old_last_vcn - 1);
 undo_alloc:
-	if (ntfs_cluster_free(mft_ni, old_last_vcn, -1, ctx) < 0) {
-		ntfs_error(vol->sb, "Failed to free clusters from mft data attribute.%s", es);
-		NVolSetErrors(vol);
-	}
-
+	/*
+	 * Entered without the runlist lock.  Take the new runs off the
+	 * runlist under it, and free their clusters from @alloc_rl once it
+	 * is dropped, as lcnbmp_lock nests outside it (see above).
+	 */
+	down_write(&mft_ni->runlist.lock);
 	if (ntfs_rl_truncate_nolock(vol, &mft_ni->runlist, old_last_vcn)) {
 		ntfs_error(vol->sb, "Failed to truncate mft data attribute runlist.%s", es);
 		NVolSetErrors(vol);
+		/*
+		 * The runlist may still reference the clusters, so leave them
+		 * allocated until chkdsk.
+		 */
+		kvfree(alloc_rl);
+		alloc_rl = NULL;
+	}
+	up_write(&mft_ni->runlist.lock);
+	if (ntfs_cluster_free_from_rl(vol, alloc_rl)) {
+		ntfs_error(vol->sb, "Failed to free clusters from mft data attribute.%s", es);
+		NVolSetErrors(vol);
 	}
+	kvfree(alloc_rl);
 	if (mp_extended && ntfs_attr_update_mapping_pairs(mft_ni, 0)) {
 		ntfs_error(vol->sb, "Failed to restore mapping pairs.%s",
 			   es);
-- 
2.53.0



