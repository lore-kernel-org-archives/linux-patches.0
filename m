Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061470;
	b=ul44MB4DqNRlQkvQqrZLc6VTXgPHXJBIddfoRhj61VS939H2LOQV1JnjyQTjOTquAw/I
	 pjtawiP4sfZTve39DTfRx/QDsImvOcVsXBkM5s70HMFzW7SalvdjUxXnp+S8dUNCNfyLM
	 GY0BcG66eaMCrJ1UTrZMiAno/UvVOz+UYx0fH+Ui7gwNwQDhZd9E2GK97wbj6YAgXKLR/
	 J7TCfyaXtE2pB12ArkIX/h4Vu0rxAKKmhpebwlP228vj4RJT4K/uIvW2JN3GR9DYK/3VE
	 1mu+ssvqFuy1iODZ0jezwnAd9w65ifn8xLClpo9v6Dk4Xm0ciytDm4sCgSmfvaDiMvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=43duKzcmQ/fYQbxJS19Oktx6ciBRcf5r+uUqPA+M2VQ=;
	b=M8MkXzViE2fYskWgursUv/U3N5bSJHBremx35C6+d2gdF4R8mQrFra2tqLyKS6zQMqaS
	 KR4v5f+Ez7lUY5kfIsu8QXc4pcxXOvrpuAUPUqYpX+pQ2CE+jxfjmatapxEYuOTmEyy+Y
	 VtvUGg2Lc0lFU3AZmBF6G7a1yF7oE2DpLK/zzYCZyqvGkiGByixTGyrBZlQAyU2xwi9JL
	 /Zn4zblv9/MZOZZkDDzx7yKWGVqKxuL53MD3Zhw+OjaTR9qwAMJHcmbqe9y1QJUMqURVP
	 rn4rouj90J7xUp/LdQM6C36ZpSHflI0iI+7iNspISwtpJer++rXgksSNLnTeJujm3Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GKac35n3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C919606A326;
	Thu, 19 Nov 2026 04:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GKac35n3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29741F000C4;
	Thu, 19 Nov 2026 04:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061470;
	bh=43duKzcmQ/fYQbxJS19Oktx6ciBRcf5r+uUqPA+M2VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKac35n3y3Wg8uDgjdSSBLH4Qr/a5JOwm9tMW7S1uZbeHEZfqmDtS6AMfJnEf7Vnc
	 ElMWAn4BiInY5ICLR5Ehgq+YY++yDQH0oFFFMB6JWW8Yfd+8VmMwcA97h5u98gP1jd
	 QStTCh9l9fQ2InBLBXnmM70lteFrT/+Ff9zq//Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1565/1848] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Wed, 18 Nov 2026 16:00:03 +0100
Message-ID: <20261118150025.101836297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a9926fb10c491..e8cc823f9cc3b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1039,7 +1039,7 @@ enum {
  */
 struct btrfs_qgroup_swapped_blocks {
 	spinlock_t lock;
-	/* RM_EMPTY_ROOT() of above blocks[] */
+	/* True if any of the rbtrees in the blocks array below is not empty. */
 	bool swapped;
 	struct rb_root blocks[BTRFS_MAX_LEVEL];
 };
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d6ec4f6cee926..a9fea6f6597d0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4356,7 +4356,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
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



