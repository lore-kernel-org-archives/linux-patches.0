Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A575012B0;
	Thu, 17 Sep 2026 17:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664994; cv=none; b=M+8YU58VIOw9pOEcQA6elyZ7LrwG8wR0mzrdqF1rTdempeUuDlyk+PFKrySzpj1wwGALrpH9K+/O9mB+ZkZY6J7+6cyBgm4UsPGgimzgFlWGtzRDf9d/vFy8n1IOSKXNvSY/jxngmzv+CpLWn1sEip4ps9ikdBEmQbnxoxk7n4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664994; c=relaxed/simple;
	bh=JwM1PwTGcGZVjw6OieHw7TOqakDSuZrgGKPowVIKcPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF5ZPr9uWOjYm7r1NupAX9iwQ8MtPKRl8RIM+CrR0Ar4UBW20ddpzU4TOEJIBMIQ0LbZlnvGTSc1oAAR2mGIj6oEXBEtCD4FE5lhQqKAGhwMZ3vEUh9tYE8hDtyF+ViUcvzMefMGB2AJh4+ENhDuqFaEGrJ65/aqI2NU3rmDPrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpelgfYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpelgfYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC0B1F000FF;
	Thu, 17 Sep 2026 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664993;
	bh=0r44Ha+v6suTuLHVoNXyVDE7MZ/n4AVqHlJ2M+DvB4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpelgfYYlZuYAFDvtkxXnxv95pNcwLUFpIpU7SEFKcC3n7rUyvJ9Z7HqrepN7ke7t
	 toPtUj1WZZS/eCmV2f6MURLsCo1RTDzHy512UgoCGJUZrd5UXLMqIQ5P8d6+B5YSGH
	 pJiA13cFTp1zeukkUUv5X4zOZ8HxTtk0lJ6KABcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0517/1250] btrfs: fix reloc root cleanup in merge_reloc_roots()
Date: Thu, 17 Sep 2026 16:05:12 +0100
Message-ID: <20260917151605.965121293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit b78fe9563e2d5ae47805f1e5dc722c91fd30e1f8 ]

If the root we got has zero root refs in its root item, we are resetting
the root's ->reloc_root without using barriers like we do everywhere else.
Sashiko complained about this while reviewing another patch, and it's
correct (see the Link tag below).

Also, we should not clear BTRFS_ROOT_DEAD_RELOC_TREE from the root unless
the root points to the reloc root we have.

Fix this by using clear_reloc_root(), which issues the memory barrier
after setting the root's ->reloc_root to NULL and before clearing the bit
BTRFS_ROOT_DEAD_RELOC_TREE from the root.

Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana%40suse.com
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d780730c58643..5f05eb88a4fa3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1896,11 +1896,10 @@ void merge_reloc_roots(struct reloc_control *rc)
 		} else {
 			if (!IS_ERR(root)) {
 				if (root->reloc_root == reloc_root) {
-					root->reloc_root = NULL;
+					clear_reloc_root(root);
+					/* Drop the ref for root->reloc_root. */
 					btrfs_put_root(reloc_root);
 				}
-				clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
-					  &root->state);
 				btrfs_put_root(root);
 			}
 
-- 
2.53.0



