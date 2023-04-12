Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8442F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D6DC433EF;
	Wed, 12 Apr 2023 08:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289640;
	bh=3Bmj5DEqwhk4UzV4MjOOZWK5SBT2HbPo+gS41TZS4ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1bJiAgOcErZwmU6xRzXOQ8+ajE5Ma5cnOwcYI2uY8fupMvQS+uAxcZ1OsMrl+QpU
	 AmUrN5zZRji05YZkfY6/eFHgQNw524aBOScKegKBsZrcXEdqWoKyLfpwA6OIpvrJln
	 vklFcM1Rz513Dnfw10lQrhMvRWLFajCMrvBAQtls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 155/173] maple_tree: fix a potential concurrency bug in RCU mode
Date: Wed, 12 Apr 2023 10:34:41 +0200
Message-Id: <20230412082844.370739322@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit c45ea315a602d45569b08b93e9ab30f6a63a38aa upstream.

There is a concurrency bug that may cause the wrong value to be loaded
when a CPU is modifying the maple tree.

CPU1:
mtree_insert_range()
  mas_insert()
    mas_store_root()
      ...
      mas_root_expand()
        ...
        rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
        ma_set_meta(node, maple_leaf_64, 0, slot);    <---IP

CPU2:
mtree_load()
  mtree_lookup_walk()
    ma_data_end();

When CPU1 is about to execute the instruction pointed to by IP, the
ma_data_end() executed by CPU2 may return the wrong end position, which
will cause the value loaded by mtree_load() to be wrong.

An example of triggering the bug:

Add mdelay(100) between rcu_assign_pointer() and ma_set_meta() in
mas_root_expand().

static DEFINE_MTREE(tree);
int work(void *p) {
	unsigned long val;
	for (int i = 0 ; i< 30; ++i) {
		val = (unsigned long)mtree_load(&tree, 8);
		mdelay(5);
		pr_info("%lu",val);
	}
	return 0;
}

mt_init_flags(&tree, MT_FLAGS_USE_RCU);
mtree_insert(&tree, 0, (void*)12345, GFP_KERNEL);
run_thread(work)
mtree_insert(&tree, 1, (void*)56789, GFP_KERNEL);

In RCU mode, mtree_load() should always return the value before or after
the data structure is modified, and in this example mtree_load(&tree, 8)
may return 56789 which is not expected, it should always return NULL.  Fix
it by put ma_set_meta() before rcu_assign_pointer().

Link: https://lkml.kernel.org/r/20230314124203.91572-4-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3659,10 +3659,9 @@ static inline int mas_root_expand(struct
 		slot++;
 	mas->depth = 1;
 	mas_set_height(mas);
-
+	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	ma_set_meta(node, maple_leaf_64, 0, slot);
 	return slot;
 }
 


