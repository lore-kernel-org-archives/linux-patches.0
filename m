Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026235;
	b=yzJR9fGJdgaNi9gWRyJxHlgJR7wYA32gf5QCCyLLopQuCODW0a3mN8O8VpT8g/o/lObq
	 Bf2K4hmDwKzUxcQG1JGg4UQy8gYVgbSaKk/bjCy5vFxILcsNzE46LNVTqbL4C87zEicXI
	 Y5Az7XjIEt5YohTOgdjby6o4h64lrrBlk0Sepskzq/3egHFy/W9zWU4Tbx6ETmpMqu/i4
	 PiBUZ9Sn+s1oiiDtbCnO8/Nbyw3sedwMH1T3PToTiY76mjixplcPXxYHMTVnCxgOs1tJc
	 7NOV3wME4c1a9DukQTs06t8rEZPexLUbcEY0lfwGEn6FJlem6U9vjYZ8g5JTDVAdXXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dQz+wVispGIwgQAAcByebCDqnk7s7Ac6/mU07DYbQCE=;
	b=fWnFOglmnyMEhQ7n1V7iwgLvQMdew8hxEm++/PMWtatkLl/6HCdbCB9N5Glw9EQ5ZxDo
	 H+PKhO/kgQ2jnPefDTbfvC+mEHAbyEAmqttm2JlGjWCxaSq0hpNtMbdzVVmW9vHH2sTWg
	 9sAL4Ojp8iPRfhxNv1y7sxtdgP9rFAMOFSH3b9sMdacPqQtKP7nXahH/Qg/a65aQwOszg
	 CaF6fACGl48CcH9OO9DIeKY4JVIkIIV5ytsiKu1M/+BCqRtohdUGvCQtINuaEan2KnLs7
	 CJt9or8tUoIuCoTKxCude8SJhQAjSFJD3M8t/9JH2/TMkCicUf9i9cvN1BrrAJfXocQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IOdy14yU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D668560A2600;
	Wed, 18 Nov 2026 18:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IOdy14yU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E951F000C7;
	Wed, 18 Nov 2026 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026235;
	bh=dQz+wVispGIwgQAAcByebCDqnk7s7Ac6/mU07DYbQCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOdy14yUVVJzgJR0FlDdEGFYs+NPVqV/VU4pjF7jatcq5TUmzO4fdi7X1jRvdg5W/
	 MHofp9aH59Y1SgCj/mmwJbXFkR3eYdoqve3RqAV7tqC2Cp2PUFEbgSAjFYXKvZAChU
	 D73OjyBNyyG9S8iGHnbTkQ6Y6BnUYsA0nrOmyZco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1362/2151] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Wed, 18 Nov 2026 15:51:37 +0100
Message-ID: <20261118150211.642682531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 692370fc07b28..5e5856bd84d1f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -153,7 +153,7 @@ enum {
  */
 struct btrfs_qgroup_swapped_blocks {
 	spinlock_t lock;
-	/* RM_EMPTY_ROOT() of above blocks[] */
+	/* True if any of the rbtrees in the blocks array below is not empty. */
 	bool swapped;
 	struct rb_root blocks[BTRFS_MAX_LEVEL];
 };
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f87acc9966c0e..d434ffa1e6d2e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4889,7 +4889,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
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



