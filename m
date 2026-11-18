Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056049;
	b=jFQNPiLojYeg/Y7YomeH53Y6iF/VF64D5Zzb32d1CMdVKLxzt/vEhy+bBuiTK87U5xsn
	 DT5gyS9eH3O8V3fTLEUdQWn24VPI9Q2Ym9vviZsKtHRJbt0KqOOZCzPyUnPfWas+Cflku
	 Itg0Nrl2iFY6zC5ytAa3D40/toHl5VLEL/xKXJScR294Lxu9MwbsQ9v8AfGaJiNZs7ahB
	 4NMMOFUHfjnXMuysck1fQhjwTk/vuRpbqxJMCKEx5KGFbR1e4UGIP7A4Sdx87ZB6rJ7+w
	 VdVM+EtqT6O5R2MNSqPft23sEwpjdaZ1m+wutwNr9rPVIuzl0Dut3sVHTHYmpFGIZ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4PuWj5xv84XDHeyq5IQmdKTRaEJ8JU0XspQI1l5kQk=;
	b=yLQAMmUoAB7XBBkrnK83iuBCPNv1N2xjxzvyL7nmb/gVdR1dZH/J756//vfun0QL/Flz
	 RjFus8XTIOEJDv0RaTKFx4ZSI6SjYfQACzcXfHtNFkl/vVxgOctnLz0Mz5VcmOZRl/8Q6
	 P4P5bbjRGqcZIMLb/avV5cLbB6WWG1/A/2RyRkt49Ipxw3zo5gOpbgOss4HY5JtcrpYW+
	 TPnBoIDZyspKK6QEYnHbxOp5FsTSZw53kTr6AhXHXD/Gy0X9WfrN00qkJV0i2aigfdRM1
	 6mEErZYCv29nls0hHyw6YV2M23nqfk8wHyRTdFGObu2PhP4c3u88UNeZvSWs6hCYj+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b3H6iTJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3877606A31C;
	Thu, 19 Nov 2026 02:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b3H6iTJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418031F000C4;
	Thu, 19 Nov 2026 02:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056048;
	bh=Q4PuWj5xv84XDHeyq5IQmdKTRaEJ8JU0XspQI1l5kQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3H6iTJFwtV02769vrWfEqLV6JbXASNn3c8a2yeS8e1hTdUjwt9V1AnyI1T2PFPHe
	 T/De+P8Gvz/hBNI3BcNHvEGldKWRGipF1N8WbYEjjElplqMmMh87XXLE7ls6AwB1Je
	 moekFWl6JPH6GLCFe78a51BgTLOzL+RRAlp+DgY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1848/2214] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Wed, 18 Nov 2026 15:58:44 +0100
Message-ID: <20261118150125.320927765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 0388b5bd3a6eb8bcb20208c3b6dbee96fd30bbe0 ]

In btrfs_qgroup_trace_subtree_after_cow(), after we erase the swapped
block, iterate over all possible tree levels to check if we sill have
other swapped blocks. However the check is wrong, it considers that there
are other swapped blocks if any rbtree for any level is empty, instead of
not empty. As a consequence we set blocks->swapped to true basically every
time since we always find an empty rbtree at least at level 7, since in
practice it's nearly impossible to find such a huge btree. This makes
every future call to btrfs_qgroup_trace_subtree_after_cow() do an
unnecessary rbtree search instead of returning immediately.

Fix this by updating the condition to set swapped to true if we find an
rbtree that is not empty.

Fixes: f616f5cd9da7 ("btrfs: qgroup: Use delayed subtree rescan for balance")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h  | 2 +-
 fs/btrfs/qgroup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 61ec4ba5414d5..6b670e041b918 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1138,7 +1138,7 @@ static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
  */
 struct btrfs_qgroup_swapped_blocks {
 	spinlock_t lock;
-	/* RM_EMPTY_ROOT() of above blocks[] */
+	/* True if any of the rbtrees in the blocks array below is not empty. */
 	bool swapped;
 	struct rb_root blocks[BTRFS_MAX_LEVEL];
 };
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ca907ed7d337c..ff1f77a22eca7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4327,7 +4327,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 	/* Found one, remove it from @blocks first and update blocks->swapped */
 	rb_erase(&block->node, &blocks->blocks[level]);
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
-		if (RB_EMPTY_ROOT(&blocks->blocks[i])) {
+		if (!RB_EMPTY_ROOT(&blocks->blocks[i])) {
 			swapped = true;
 			break;
 		}
-- 
2.53.0



