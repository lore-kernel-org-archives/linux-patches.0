Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041269;
	b=gvx1wR+hDtFi0miJggYvIjm+PMOwX7xnJH2if7hU3X5qcy8D/3SiyN6Jf9fBqSP5aLgR
	 QvvquvLn1csX0zdcmigdPwylJ8K9zEyddqMpxvT6dBzC//I+vRxjwwbZRWy5w49CSklxD
	 0lOOOPzC1c38aDzRy8ePcnRnWpgj1SXcll3FPhHf9Lcp4Eqgcct7agsLecRSbUSZhM1pU
	 ct1JcAcePpxb8Et4EGt0iQElgMFgDMxHEgrmOPTF2IRlxDzTV/HrazyOOpkCNpJL0RavT
	 FbddaeIkz+GkBZMEWTUBD4t4EbCoO9EwHddrsHwoS42iBvvNTW7MsDchGOJylEYTd+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzECCraXRFuc/bBlBwGOI6VGhU1+Kl65kKjN5J2omY0=;
	b=e+fDgbcKM/ZC7s1vSyL0r8DheDsqcoymnemJInGWV4DwWlyzQz9qqZGOgl+I17Y+IxPS
	 r0QBGcAPSY+xN2Y+m0HtZIKc7lnrYtrRincltujaFnkWMNJdE/QrUS7fefX069BQYk5la
	 xxSndtmOmPy8fYkYwCqX1CmE5RIXgh6MTx7CeEwBeKpWpU2IfgSc0l6+hezrHGqKmuQcV
	 egbsvwAL41XetT24qMib/P/L2eItJAIULp2vIsnT5T8JaeP3CeeMYPUI9i9Tj/wvITpSz
	 fH8V4dDKZKapfVt6cgbzDO8i3t5jMh01LOrQZP2d94yrtrOlxcSPD8ifTLK3aEm+68g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqNd8gbf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A858B606A320;
	Wed, 18 Nov 2026 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqNd8gbf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7F51F000C4;
	Wed, 18 Nov 2026 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041269;
	bh=OzECCraXRFuc/bBlBwGOI6VGhU1+Kl65kKjN5J2omY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqNd8gbfkwR5mzkG+lsfpk/iG8wy6+rNVfM+OfdY0Bmoa+f1YoSSk14HcTykCP3go
	 BkBPkj7PyVdCGx9Dz2xUipqE4au0Un9aFJZrUmU1lvsBI3bspcnveloKVMa95Sdr3u
	 +5PKY8e4GB+45VF7CW051+AGywDe1VqtV40Rjh6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2752/3318] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Wed, 18 Nov 2026 15:56:14 +0100
Message-ID: <20261118150443.315833156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1743aa21fa6e5..ec849cb044d39 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -180,7 +180,7 @@ enum {
  */
 struct btrfs_qgroup_swapped_blocks {
 	spinlock_t lock;
-	/* RM_EMPTY_ROOT() of above blocks[] */
+	/* True if any of the rbtrees in the blocks array below is not empty. */
 	bool swapped;
 	struct rb_root blocks[BTRFS_MAX_LEVEL];
 };
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6aff9f85cba14..af702777f20a3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4432,7 +4432,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
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



