Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019694;
	b=arn3al2nuG6TKX5o2g5ublm8nlZA6Yk/Mm3T6WJzgDTN6vrjXX7xkAYM3mRd6UjznSq2
	 faQS1r3C0onuaXAufLDdKPfzVj01U43HL1VThEEEFtvpd73QynV/BolT9f8ncfwDmtO2K
	 GVNa36pKqO4nh0qImgC34BsPsL+xxnzgX6Wm5rR+v0tZ+dchyQwc2XYpaeBRKWQ1ZwIXT
	 pJ5GuZQKfWyzo3ObCbhclnTgMsRl7Fe5o9vnvfOYgzwZ48i6CQmxPwH/JZqXl1/UpzDhu
	 s+NYy8cybQLMJFL6cpVlKzVbXOfoXD4qVKqI318D+Y2YC6UayZ3r8nDSmq4nucZ7wTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q5nK+63w8OYpIgw0JZkqb/PwBaDP1VDBdS8zipMqVug=;
	b=2UA+khb5Q0JqFlx0tQVvg6fyhZj8GzU2Fg6u77Xb7yJDoaNk0yWvVSIZuDGvp+sNz+an
	 m1DzvobKrbodbJeetI+VIiJ0C0ngLibkQkD7wW7WOYCq54ARIDZ1T30wg65083DALD6AQ
	 RZEi+mPJ7bP+S3SMMUhfZ+29kpDA5cfKza29kj4T+OagIrH32UpUPqR/L9Hnr+/PFFIBF
	 73ljiF5efZaKfnjDgcJ9JZhkN78ybqrjipfqd76dnIq4cQZD0NUm8O3jLqtBKrD+AtlqZ
	 dAvRKNC6VY/VUSU8M4YchMWpJ676t9klr6IevYsoVms44P8Wlaopgp31QjoOKOfL8Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQC6cRhU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA67E606A332;
	Wed, 18 Nov 2026 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQC6cRhU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A336D1F000C5;
	Wed, 18 Nov 2026 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019694;
	bh=q5nK+63w8OYpIgw0JZkqb/PwBaDP1VDBdS8zipMqVug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQC6cRhU/uxti703V6EdbteBfIm631eSAYfrwco/dfWCKfygctmqDIIMeEeuIxTHP
	 GJC2yugT17lJwT+hpXXXnBPIQhTyBnvKXP4W2ElQ+hpwfJyCCiL+seb20REkvD//Vm
	 IseDXqvbmwWPHDqoe3xXHAEQnVKsTEAkpbktbCSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1660/2651] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Wed, 18 Nov 2026 15:48:20 +0100
Message-ID: <20261118150347.502716466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 22ba2b4505b35..00d4c4184e76a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -160,7 +160,7 @@ enum {
  */
 struct btrfs_qgroup_swapped_blocks {
 	spinlock_t lock;
-	/* RM_EMPTY_ROOT() of above blocks[] */
+	/* True if any of the rbtrees in the blocks array below is not empty. */
 	bool swapped;
 	struct rb_root blocks[BTRFS_MAX_LEVEL];
 };
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index df8a0aa662478..5fd0292765082 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4887,7 +4887,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
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



