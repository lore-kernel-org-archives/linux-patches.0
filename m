Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED1F3D5D8A;
	Thu, 15 Jan 2026 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499351; cv=none; b=XnNAMZQNVydWl1EF5FGvsQg5ljf471MbTNcG7EKPWlg5pR4XhdTVSXrYnYXsa61LYc0jlZ3c1tjnBH6b1+Tg82EQC3NHw6ww9gq38tdCXsqsnBkyss5ZMEvlDqHrM2Q1bYbrP6Gr9egXS0U4NQ/yJ7nIO8c34cH94oszFX67GH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499351; c=relaxed/simple;
	bh=au3OXFUXInoKIrMjiWB6jXMP6+K4vy7u0+CS8JiR51E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L63Rdw/ZHJhQvepJ+Zokb8uL2sm4FeXrXmSbKjSx3Mpl7JDLUbPBk7dAeT+0EsuVQ4zew+9sbOhEKOLr9jxgrLu4VRWljGqFICDlKyun4cRVsg/a0tg7sNBQ1Wl1OEJAyrWuCs6tjgkJDFXJ2a+8cKl8u7vXZqEpWMfKY0K/sCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCSpKP2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCSpKP2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1752C19422;
	Thu, 15 Jan 2026 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499351;
	bh=au3OXFUXInoKIrMjiWB6jXMP6+K4vy7u0+CS8JiR51E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCSpKP2AG85LFhL3M4do4b7EIXIuANaVQ5Mj9EoT1/IAtlATuthpMuXSPI/TBcj++
	 Ii5dYm/aHuHKHwBAbjsdJh6uQxgOQXt92GLHZ4pdjcPBUl0ZkeUQnhk+nTwfA6K9MH
	 URRwC94N4M6LHE12CXEBCNP9k6tXQ7NQi07X+EK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+005d2a9ecd9fbf525f6a@syzkaller.appspotmail.com,
	Yang Chenzhi <yang.chenzhi@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/451] hfsplus: fix missing hfs_bnode_get() in __hfs_bnode_create
Date: Thu, 15 Jan 2026 17:46:04 +0100
Message-ID: <20260115164236.806596914@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Chenzhi <yang.chenzhi@vivo.com>

[ Upstream commit 152af114287851583cf7e0abc10129941f19466a ]

When sync() and link() are called concurrently, both threads may
enter hfs_bnode_find() without finding the node in the hash table
and proceed to create it.

Thread A:
  hfsplus_write_inode()
    -> hfsplus_write_system_inode()
      -> hfs_btree_write()
        -> hfs_bnode_find(tree, 0)
          -> __hfs_bnode_create(tree, 0)

Thread B:
  hfsplus_create_cat()
    -> hfs_brec_insert()
      -> hfs_bnode_split()
        -> hfs_bmap_alloc()
          -> hfs_bnode_find(tree, 0)
            -> __hfs_bnode_create(tree, 0)

In this case, thread A creates the bnode, sets refcnt=1, and hashes it.
Thread B also tries to create the same bnode, notices it has already
been inserted, drops its own instance, and uses the hashed one without
getting the node.

```

	node2 = hfs_bnode_findhash(tree, cnid);
	if (!node2) {                                 <- Thread A
		hash = hfs_bnode_hash(cnid);
		node->next_hash = tree->node_hash[hash];
		tree->node_hash[hash] = node;
		tree->node_hash_cnt++;
	} else {                                      <- Thread B
		spin_unlock(&tree->hash_lock);
		kfree(node);
		wait_event(node2->lock_wq,
			!test_bit(HFS_BNODE_NEW, &node2->flags));
		return node2;
	}
```

However, hfs_bnode_find() requires each call to take a reference.
Here both threads end up setting refcnt=1. When they later put the node,
this triggers:

BUG_ON(!atomic_read(&node->refcnt))

In this scenario, Thread B in fact finds the node in the hash table
rather than creating a new one, and thus must take a reference.

Fix this by calling hfs_bnode_get() when reusing a bnode newly created by
another thread to ensure the refcount is updated correctly.

A similar bug was fixed in HFS long ago in commit
a9dc087fd3c4 ("fix missing hfs_bnode_get() in __hfs_bnode_create")
but the same issue remained in HFS+ until now.

Reported-by: syzbot+005d2a9ecd9fbf525f6a@syzkaller.appspotmail.com
Signed-off-by: Yang Chenzhi <yang.chenzhi@vivo.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250829093912.611853-1-yang.chenzhi@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/bnode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfsplus/bnode.c b/fs/hfsplus/bnode.c
index 358294726ff17..7c127922ac0c7 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -488,6 +488,7 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 		tree->node_hash[hash] = node;
 		tree->node_hash_cnt++;
 	} else {
+		hfs_bnode_get(node2);
 		spin_unlock(&tree->hash_lock);
 		kfree(node);
 		wait_event(node2->lock_wq,
-- 
2.51.0



