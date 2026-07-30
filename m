Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89ACA443A83;
	Thu, 30 Jul 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423436; cv=none; b=OGpwoKZ4Upd6FdlaHJvqKCREgjPQFayySdKvpDR38hSVeDethkDL4ACXJXZqq8Et/ACHhDH+P6WULP75oO43HbpVJV7U2YlN4Kq9RhAX+ob+eAKpnkyN29ZNIQ1fkh3mPN9VWWo2LbYDFJoK4f+P1Q384UNRTSQjYLfmPursLS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423436; c=relaxed/simple;
	bh=Xg/Rd0LVDnJ10VDAHCd7kZA4sQk9p1mkKttMnvn9f7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0vT0RDuj77TioXP7ihOk5d+2DDUYS+Dy0s2H4FlrOVp5LZLZZMM2T4bARx7xmjU/SLYOGMWlyF2lAEO+iaFeZ1hZZOFash4fVwI6UCBmeNYJa5gU6AUcbN1wimaYM0Zo8L/8Z0CsPCpeJm4lIp10FROQlEfbinSCJfwvehL8NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E55avvqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E55avvqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E541E1F000E9;
	Thu, 30 Jul 2026 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423435;
	bh=yJqa33pYLIiRUMx70a0ur+s8k5bWY1ImwaNhB2GDPds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E55avvqLKjvbT4ZA4ASmOK8D5Vlwj/sQf3zd69X4lZu0av/OhhsxtEece6qbl2qho
	 EkfeBxPfvZswJMWi3z5STdSD/8yU6TywZhSK2prsel404oR/008C1XBR3+4SriIOna
	 C2hDeQJt6KAMQtV0hD1fRQvz2zp/63FeGuCVn/sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/675] btrfs: fallback to transaction csum tree on a commit root csum miss
Date: Thu, 30 Jul 2026 16:06:14 +0200
Message-ID: <20260730141446.057167785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 3dcd50730814e5220072d2b26d0587af6bfb6dbe ]

We have been running with commit root csums enabled for some time and
have noticed a slight uptick in zero csum errors. Investigating those
revealed that they were same transaction reads of extents that were just
relocated, but the extent map generation was long ago.

It turns out that relocation intentionally does not update the extent
generation (replace_file_extents()), but must write a new csum since the
data has moved, so we must account for this with commit root csum reading.

Luckily this is a short lived condition: after the relocation transaction
the commit root will once again have the csum. So we can add a generic
fallback to the lookup to try again with the transaction csum root.

Fixes: f07b855c56b1 ("btrfs: try to search for data csums in commit root")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a2f851eaadca06..9b19b33e85b687 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -350,6 +350,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	const unsigned int nblocks = orig_len >> fs_info->sectorsize_bits;
 	int ret = 0;
 	u32 bio_offset = 0;
+	bool using_commit_root = false;
 
 	if ((inode->flags & BTRFS_INODE_NODATASUM) ||
 	    test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state))
@@ -423,6 +424,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	 * from across transactions.
 	 */
 	if (bbio->csum_search_commit_root) {
+		using_commit_root = true;
 		path->search_commit_root = true;
 		path->skip_locking = true;
 		down_read(&fs_info->commit_root_sem);
@@ -455,6 +457,28 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 		 * assume this is the case.
 		 */
 		if (count == 0) {
+			/*
+			 * If an extent is relocated in the current transaction
+			 * then relocation writes a new csum without updating
+			 * the extent map generation. Until the next commit, we
+			 * will see a hole in that case, so we need to fallback
+			 * to searching the transaction csum root.
+			 *
+			 * Note that a commit root lookup of a referenced extent can
+			 * only miss, not return a stale csum. A freed extent's csum
+			 * is deleted in the same transaction and its bytenr is not
+			 * reusable until that transaction has committed and the
+			 * extent is unpinned.
+			 */
+			if (using_commit_root) {
+				up_read(&fs_info->commit_root_sem);
+				using_commit_root = false;
+				path->search_commit_root = false;
+				path->skip_locking = false;
+				btrfs_release_path(path);
+				continue;
+			}
+
 			memset(csum_dst, 0, csum_size);
 			count = 1;
 
@@ -473,7 +497,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 		bio_offset += count * sectorsize;
 	}
 
-	if (bbio->csum_search_commit_root)
+	if (using_commit_root)
 		up_read(&fs_info->commit_root_sem);
 	return ret;
 }
-- 
2.53.0



