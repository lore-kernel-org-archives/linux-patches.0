Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511DC21764F;
	Thu, 12 Dec 2024 15:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016052; cv=none; b=W5DuIeCjmn7Dz4etJ2I/qjtoe20UOrA6iU266qdFWQo/OvgXM+xsKtyj2tok0aSjfPfj78miwSEJu8zld25jV56kROUHD8d6GY9pCAbTMr0xrLlxGwX9xN27T6YGj27JlTHjBM9FW77IXBiSe+xgiRWFBPGHwdrKznQMcRFRHUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016052; c=relaxed/simple;
	bh=PfWzLpQt3oLK0wbKSqBdY+hmOqaCUtX+JtFZsSf1WOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZc6c52/o067kIVM3bMilKzDbNHIgHiMhhQgm6w4lt0uB0Mj9WT7UHoUg4J+BS4tnqVl7onUna4uQt6zLO0kyMAY+XVYctKosZC2+bVRSDaJZQ6EfQqOXX1WPfod4viHAwk8+j7RxJEU2fzmfFhks156L4qIhnVD10QEVFBpwyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgB8yP3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgB8yP3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F74C4CED0;
	Thu, 12 Dec 2024 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016052;
	bh=PfWzLpQt3oLK0wbKSqBdY+hmOqaCUtX+JtFZsSf1WOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgB8yP3LLOJh/xYAU5ZTf5FWE3bLSuUwxWMlOUpG1MXT0xRCRrpkNUvOpqG8INQ3U
	 MA/WdeURRvJOS715VVdIKLIPr6oYhElSR1yG6gYqM9JkSYZ5E7Z4usdneGyUkXdfzj
	 lxFy1a8iriW0dF+Ro0u17prkVj8Y4JQbHGN1nnbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/466] bpf: Handle in-place update for full LPM trie correctly
Date: Thu, 12 Dec 2024 15:54:47 +0100
Message-ID: <20241212144311.476240439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 532d6b36b2bfac5514426a97a4df8d103d700d43 ]

When a LPM trie is full, in-place updates of existing elements
incorrectly return -ENOSPC.

Fix this by deferring the check of trie->n_entries. For new insertions,
n_entries must not exceed max_entries. However, in-place updates are
allowed even when the trie is full.

Fixes: b95a5c4db09b ("bpf: add a longest prefix match trie map implementation")
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20241206110622.1161752-5-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/lpm_trie.c | 44 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 8a040f123e04a..fcc5cd358d7f9 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -310,6 +310,16 @@ static struct lpm_trie_node *lpm_trie_node_alloc(const struct lpm_trie *trie,
 	return node;
 }
 
+static int trie_check_add_elem(struct lpm_trie *trie, u64 flags)
+{
+	if (flags == BPF_EXIST)
+		return -ENOENT;
+	if (trie->n_entries == trie->map.max_entries)
+		return -ENOSPC;
+	trie->n_entries++;
+	return 0;
+}
+
 /* Called from syscall or from eBPF program */
 static long trie_update_elem(struct bpf_map *map,
 			     void *_key, void *value, u64 flags)
@@ -333,20 +343,12 @@ static long trie_update_elem(struct bpf_map *map,
 	spin_lock_irqsave(&trie->lock, irq_flags);
 
 	/* Allocate and fill a new node */
-
-	if (trie->n_entries == trie->map.max_entries) {
-		ret = -ENOSPC;
-		goto out;
-	}
-
 	new_node = lpm_trie_node_alloc(trie, value);
 	if (!new_node) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	trie->n_entries++;
-
 	new_node->prefixlen = key->prefixlen;
 	RCU_INIT_POINTER(new_node->child[0], NULL);
 	RCU_INIT_POINTER(new_node->child[1], NULL);
@@ -376,10 +378,10 @@ static long trie_update_elem(struct bpf_map *map,
 	 * simply assign the @new_node to that slot and be done.
 	 */
 	if (!node) {
-		if (flags == BPF_EXIST) {
-			ret = -ENOENT;
+		ret = trie_check_add_elem(trie, flags);
+		if (ret)
 			goto out;
-		}
+
 		rcu_assign_pointer(*slot, new_node);
 		goto out;
 	}
@@ -393,10 +395,10 @@ static long trie_update_elem(struct bpf_map *map,
 				ret = -EEXIST;
 				goto out;
 			}
-			trie->n_entries--;
-		} else if (flags == BPF_EXIST) {
-			ret = -ENOENT;
-			goto out;
+		} else {
+			ret = trie_check_add_elem(trie, flags);
+			if (ret)
+				goto out;
 		}
 
 		new_node->child[0] = node->child[0];
@@ -408,10 +410,9 @@ static long trie_update_elem(struct bpf_map *map,
 		goto out;
 	}
 
-	if (flags == BPF_EXIST) {
-		ret = -ENOENT;
+	ret = trie_check_add_elem(trie, flags);
+	if (ret)
 		goto out;
-	}
 
 	/* If the new node matches the prefix completely, it must be inserted
 	 * as an ancestor. Simply insert it between @node and *@slot.
@@ -425,6 +426,7 @@ static long trie_update_elem(struct bpf_map *map,
 
 	im_node = lpm_trie_node_alloc(trie, NULL);
 	if (!im_node) {
+		trie->n_entries--;
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -446,12 +448,8 @@ static long trie_update_elem(struct bpf_map *map,
 	rcu_assign_pointer(*slot, im_node);
 
 out:
-	if (ret) {
-		if (new_node)
-			trie->n_entries--;
+	if (ret)
 		kfree(new_node);
-	}
-
 	spin_unlock_irqrestore(&trie->lock, irq_flags);
 	kfree_rcu(free_node, rcu);
 
-- 
2.43.0



