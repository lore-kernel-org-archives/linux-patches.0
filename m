Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031489;
	b=N3R/Eh94ov2gDWc55dC6IIPutABCR7fVtcbx8XycUNQxc5NuWWJar4AIRYllBnHwMbws
	 8VN5IQD7dmaBcMw5mKR0uEg1VP0ci4zN2FIKoA34n0EspSn8t/Y+7Wp39vXoKrniUon3h
	 jE20B/S0Q/SIBC5eT3cWDwwnK7HRBYQIWGw5Z2Q0j0lp+Ys3mPUI/J/wei0LylvxVHqrb
	 251OrXrt0n5POqwsL3QzTylLyO2gHz3f0E4509RhjhE0OHmb9qylao/xqLNYQU/d53AIU
	 iME5KE2+CENtHoZBHgeVckm+cJwIHVUPIW/9dParogzsYxV52yTphP74fU2VL2qnTIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yNTkOSxcVqEnz19Caefry9RO4fKM2K2sNfHbTP5g5QA=;
	b=CJ40ir5dxOQxgC/PxM/1AW7c6B6MXmb+4bPL7l6fsMlSf1mTZTCilN+S/89xtIqu3c7s
	 JiWm19ShvNoqFn6meS8XtMysx1218NbOY5hPgLRHHwrAynk9jVjsrshEElt9zXVmrrMfD
	 F1Kl8A+/C2otRtSuWqTkGv1ZUm51XFDcpK/lGG+FNskH2+vyzilsFGhPLRAqAz8vn3gkR
	 70oy0stk4pTUxvu6flaPgFbIiD3MTNeOgAqsM9+RyjHAfr9fRZ79xeEwXN+bAGCcL/Y+L
	 +X9Tz6MWUdT8gbhWzSMUoqf2d+qCLTlEKp2PJG5JeFr233lTSYZvWUH4ECcV/JTfweQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3RNotOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351E0606A32C;
	Wed, 18 Nov 2026 19:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3RNotOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8833F1F000C4;
	Wed, 18 Nov 2026 19:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031489;
	bh=yNTkOSxcVqEnz19Caefry9RO4fKM2K2sNfHbTP5g5QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3RNotOtNYWsmiUOVo4UOnVVDk8pDJ77vFOzqvwEBTi9pnyfBFy3fcK88/lIUA0RK
	 ax9z+tDFB4pMa/puGgOcOp1pUVHcBuIgw2Q81+1KLwyFsyJIcV5foWaNc1lXRKjYyV
	 c1aOYbrkwepKr+43m8SDPNwmdARWj9KVgyYX29/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1077/1756] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Wed, 18 Nov 2026 15:53:24 +0100
Message-ID: <20261118150053.104153767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 937f32e5ad72b..3a0c0ac0d1184 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -155,7 +155,7 @@ enum {
  */
 struct btrfs_qgroup_swapped_blocks {
 	spinlock_t lock;
-	/* RM_EMPTY_ROOT() of above blocks[] */
+	/* True if any of the rbtrees in the blocks array below is not empty. */
 	bool swapped;
 	struct rb_root blocks[BTRFS_MAX_LEVEL];
 };
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 68b2df4355766..de30aa41458c9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4918,7 +4918,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
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



