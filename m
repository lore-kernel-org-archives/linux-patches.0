Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2E93AF674;
	Wed, 30 Sep 2026 18:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794710; cv=none; b=cVOvRZatkmyFXrZE9p6f5KWGhbiE2frAW+K59UpLTG3ADuitBQL3Iw/PRJi1YHQhy3swVYOWDHeS3Z4Omk1dExzlBkJiP7w89xSPds1rQdBDrXh0vag3eqm2CHeEHzpbqZ1EvbAo/mSLcUq3WIx+8B7JKuyNDGRU0El5wZG7NCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794710; c=relaxed/simple;
	bh=4KJHFzNhYPcxhrDxlbJVrKjoGN5X/IO8S7P0uZroBx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNsHntfu4EDeZTywwLYw1ZYIxpQ+48A0ysbNup1WRdQvpE0KiXSrF455MuteQtVihBZt2Fh5J5miAAtFtIAI01q4etpiKMQpQlQIbysyGaXkKIgFsVkBEFJA/9j1IJhaLy3Ki9Ij54+xY9wPLW4uOCguI0mdwecqAzvmt0Z7SfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKBEgPIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKBEgPIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF981F00898;
	Wed, 30 Sep 2026 18:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794708;
	bh=7VQBStHBzAtRMDMCWjZUMhovJAUNYJBTiRl1zZW/AM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKBEgPIUM/ymTRcGnyn3O+jAhqDGkAka3pCGTpDBc8sUd3M67rq5v7yeprBl8q//6
	 GbJSfPf6uRndbIw212d7jGKWAqqnwcdjidLsfEFaZv5SY/eFlsSJ4dZl3rKZmc6oof
	 jziec1WMydajO1923m8Ue03fwbeXSAnDXhawInt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0305/1193] btrfs: fix reloc root cleanup in merge_reloc_roots()
Date: Wed, 30 Sep 2026 17:16:29 +0200
Message-ID: <20260930152440.927079683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 95fc3df73f4f2..fd9e674c13463 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2030,11 +2030,10 @@ void merge_reloc_roots(struct reloc_control *rc)
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



