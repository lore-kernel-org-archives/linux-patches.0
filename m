Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05C7FBEF;
	Tue, 25 Jun 2024 09:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308130; cv=none; b=rbCRgtZflBrWaR3Gb8ndfFF6xqpNyKxvPQV4N+zyKw4f9MSw1ilLAXQFq0lqjpBkDPoOYB5KP6Vodce5qmadKDbP3zjowzhGvL8VFHxZyOBZExKqArjKvwpwnlXR8i02DuUg64hyvP1Rm3wzfcFLlAqkO+UIJaR1gLym6YkOE2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308130; c=relaxed/simple;
	bh=ZLoVhnd6wA/0LdsND8kyM6F3RboxjLBHFuC1/qbJgWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VK7SvxVBWQn/UgvDTo1lgI8NKWQqoLRdOdj9EHklvQFN0KUEpEewCtBxVC3L1iS0MIYIfpJc4TAs7btZHpSfYlfCecl3wuWoePct5nQuQlBZq0/Uvm1cI2gIczunC8pGVGIPz/Ak9K310MxNCRmQacxNayoJHSA20H3Q7cUqJ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4uQtlNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4uQtlNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25371C32781;
	Tue, 25 Jun 2024 09:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308129;
	bh=ZLoVhnd6wA/0LdsND8kyM6F3RboxjLBHFuC1/qbJgWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4uQtlNAd1Ol4fzXvfjWQ/r/Zxis3KSDTrxKmL5QEOT8KwgT+Ge2DORoNwE1rQ838
	 aoX5GFAquLfpTAqkssfSoEPr8+NE9qHkILPvJi5Mm0h1hEFwG6R3ipQGjmYq03MGvG
	 mOjQ9IQIHKsJIKjYq0e7bfUoCPHV/MF00mcxdKPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1fa663a2100308ab6eab@syzkaller.appspotmail.com,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 017/250] bpf: Avoid kfree_rcu() under lock in bpf_lpm_trie.
Date: Tue, 25 Jun 2024 11:29:35 +0200
Message-ID: <20240625085548.711318636@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 59f2f841179aa6a0899cb9cf53659149a35749b7 ]

syzbot reported the following lock sequence:
cpu 2:
  grabs timer_base lock
    spins on bpf_lpm lock

cpu 1:
  grab rcu krcp lock
    spins on timer_base lock

cpu 0:
  grab bpf_lpm lock
    spins on rcu krcp lock

bpf_lpm lock can be the same.
timer_base lock can also be the same due to timer migration.
but rcu krcp lock is always per-cpu, so it cannot be the same lock.
Hence it's a false positive.
To avoid lockdep complaining move kfree_rcu() after spin_unlock.

Reported-by: syzbot+1fa663a2100308ab6eab@syzkaller.appspotmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240329171439.37813-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/lpm_trie.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 050fe1ebf0f7d..d0febf07051ed 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -308,6 +308,7 @@ static long trie_update_elem(struct bpf_map *map,
 {
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
 	struct lpm_trie_node *node, *im_node = NULL, *new_node = NULL;
+	struct lpm_trie_node *free_node = NULL;
 	struct lpm_trie_node __rcu **slot;
 	struct bpf_lpm_trie_key_u8 *key = _key;
 	unsigned long irq_flags;
@@ -382,7 +383,7 @@ static long trie_update_elem(struct bpf_map *map,
 			trie->n_entries--;
 
 		rcu_assign_pointer(*slot, new_node);
-		kfree_rcu(node, rcu);
+		free_node = node;
 
 		goto out;
 	}
@@ -429,6 +430,7 @@ static long trie_update_elem(struct bpf_map *map,
 	}
 
 	spin_unlock_irqrestore(&trie->lock, irq_flags);
+	kfree_rcu(free_node, rcu);
 
 	return ret;
 }
@@ -437,6 +439,7 @@ static long trie_update_elem(struct bpf_map *map,
 static long trie_delete_elem(struct bpf_map *map, void *_key)
 {
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
+	struct lpm_trie_node *free_node = NULL, *free_parent = NULL;
 	struct bpf_lpm_trie_key_u8 *key = _key;
 	struct lpm_trie_node __rcu **trim, **trim2;
 	struct lpm_trie_node *node, *parent;
@@ -506,8 +509,8 @@ static long trie_delete_elem(struct bpf_map *map, void *_key)
 		else
 			rcu_assign_pointer(
 				*trim2, rcu_access_pointer(parent->child[0]));
-		kfree_rcu(parent, rcu);
-		kfree_rcu(node, rcu);
+		free_parent = parent;
+		free_node = node;
 		goto out;
 	}
 
@@ -521,10 +524,12 @@ static long trie_delete_elem(struct bpf_map *map, void *_key)
 		rcu_assign_pointer(*trim, rcu_access_pointer(node->child[1]));
 	else
 		RCU_INIT_POINTER(*trim, NULL);
-	kfree_rcu(node, rcu);
+	free_node = node;
 
 out:
 	spin_unlock_irqrestore(&trie->lock, irq_flags);
+	kfree_rcu(free_parent, rcu);
+	kfree_rcu(free_node, rcu);
 
 	return ret;
 }
-- 
2.43.0



