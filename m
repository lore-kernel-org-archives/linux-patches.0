Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5B6513567;
	Wed, 30 Sep 2026 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784750; cv=none; b=Qg7IDRVSOT9ifOSpt5hCrgEXQXCReHDK7gbeblsVyd72zVnRWN2MxWKsKN9KXA4qRgqLWjRJFDpEjPFNY7LHDtsDtmi3HFEvripMVvjK4sFnKZgeP7z7uzaLgb36Y+KxiYIAmKTUuPXCVeIioXE6n8Q/1avarHaHNRO8LuDciMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784750; c=relaxed/simple;
	bh=zcChnpeaQ+TR6egnHmrpJOBcGIttyUQUECe/Y8rYCZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNBTFjnx5hmtNZdt6JGxFaq/tcXMCYqNwka9IAl8akP/e+FS28L+sQOU1CedBGctYfeArbVKCby0JQS9u6OB930aDnJAWqsdRuYj83GBEr3oKTK7f3fuV4q0O1LdzqyhmGbyEUhrTY8Xj0IO4XYD90UakvBg6qGoT2JrBS/5/fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEpjWMsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEpjWMsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE551F00898;
	Wed, 30 Sep 2026 16:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784742;
	bh=qCRpac8XZiCRvXhtY2CxAvyAZKSL6PhNQIfhveg7UJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hEpjWMsHJ96B8hNJjfllWIQ0PZiu+wzrYVKqKX7dNgX37evnbmd3wXq7J70wCCkQn
	 3RxrdrPkFMGWphaJyhykqWtSUNT2eEf4GJ0brLQdrKxdOiSXE1Z8uhx9Uv8oIcE6SQ
	 v8Bn1aJhW3Bt+QGexqIQ6bn0dannc4FafAXkAk2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 264/982] btrfs: fix reloc root cleanup in merge_reloc_roots()
Date: Wed, 30 Sep 2026 17:16:40 +0200
Message-ID: <20260930152422.472721599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ffd1319a9155d..84b153eb9d6b8 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2084,11 +2084,10 @@ void merge_reloc_roots(struct reloc_control *rc)
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



