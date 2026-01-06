Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355E433291F;
	Tue,  6 Jan 2026 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719737; cv=none; b=K9OQttwWu5kdmTt/V4YcdZKS+xc7EBCFTF0Atyz+zFuqGKdeFkRV7pXtvmPQ2p6jSMRXbDh3SREWuVTAWCcM+8k4vuhJLugLiHT9+J7Jxdtuez0OxA0ptSH2XF3InucZvX6t5geuRZ9sA+vKGA/jrIrwtUW6rhq2DikAjzCaLag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719737; c=relaxed/simple;
	bh=ZC5E+HR3UE4V+6NLe6SyV+XiCBsFBuURu9aknOV/AJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqFmP8pLccH2KVyCuoMO0h5+jRH+l1/tN/P9yIFpZppwv83c9NwsSnwYxhDtWjyPq8XCe2mKfysyO4JdQpA2AoQpFsLq44GEkXv+5YyThOBAEy9fuM0BV0qF3wDqe7KJlYh6VFwl9KvZhTrQcBIH/upq0VfitTbBOL8BorUhTpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=011BdSEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="011BdSEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BC5C116C6;
	Tue,  6 Jan 2026 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719737;
	bh=ZC5E+HR3UE4V+6NLe6SyV+XiCBsFBuURu9aknOV/AJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=011BdSEfHDZaBIjzh60V4KK2CIrFwLdByveIG74wbZixqW0DvZr4tsP9FD5oL3AGj
	 Rah7nJCD/H67tyi6SmIhAGNYl4BlLuH4tvZ7L7GE/MMTjIIGO5LkM8xFGnJXcQblU5
	 JrVe8jsGTru3Aj6mz8vAVIUHrmTgVIuM8SgIxL4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+005d2a9ecd9fbf525f6a@syzkaller.appspotmail.com,
	Yang Chenzhi <yang.chenzhi@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/567] hfsplus: fix missing hfs_bnode_get() in __hfs_bnode_create
Date: Tue,  6 Jan 2026 17:56:46 +0100
Message-ID: <20260106170452.238284185@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa095e6fb20e8..c0089849be50e 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -481,6 +481,7 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 		tree->node_hash[hash] = node;
 		tree->node_hash_cnt++;
 	} else {
+		hfs_bnode_get(node2);
 		spin_unlock(&tree->hash_lock);
 		kfree(node);
 		wait_event(node2->lock_wq,
-- 
2.51.0



