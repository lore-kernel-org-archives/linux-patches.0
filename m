Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B584223E6C;
	Thu, 12 Dec 2024 16:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020926; cv=none; b=QXS85NBFTlRzVAS7qB1DKV1SzDvnfV42KgNGnrI9jNhjZUauj6/4de/Qvaa1Cg6nYLO9ZKIMp5jijoTg6YGA18d5e8mSn+s3loRMPE0ZKMoReETZce9WmV/DAGF+9xm/h64K2Y6ohqbrCnWKaiErXDaay6KNUPWt8KLGj6MmZSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020926; c=relaxed/simple;
	bh=gBaXZs/F6GlsCG3bLIcSAxGatxz5oM3/UcHrDSJdkGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1eN7alrvBsacCVOhVl/xJwhFYI1ygA2qaLnYKjBCv1IirM8Bm3m9eiNpjXcB09yL3v8oISKDIx2PuASBm86n9v5DJpVg5vNjTIX7qzThiye4EjD3POh6AElTPl4jLxjfd+EmQ0cRJfaGG2wKCM5obe7kdhqVGh4fcqFEelr7rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dahr8e0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dahr8e0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0599C4CED0;
	Thu, 12 Dec 2024 16:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020926;
	bh=gBaXZs/F6GlsCG3bLIcSAxGatxz5oM3/UcHrDSJdkGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dahr8e0zVileP4u90rC17P7KiVrh/FTEMA0C2+VT0/XLzfr5tGHHbAd8zbml0QI+A
	 VQ1aYBUXMti5IAx01/lArGCRPsi+SiH5JZf3mDz8FmBWOUbIZHCa7AisgwF13y2+KN
	 BESO3433yS2sedu0zT3gDLwHY4XeKnAICvxeCUdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 600/772] bpf: Handle in-place update for full LPM trie correctly
Date: Thu, 12 Dec 2024 15:59:05 +0100
Message-ID: <20241212144414.720781961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 694fbf9891f4f..c5fa2a74de771 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -302,6 +302,16 @@ static struct lpm_trie_node *lpm_trie_node_alloc(const struct lpm_trie *trie,
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
 static int trie_update_elem(struct bpf_map *map,
 			    void *_key, void *value, u64 flags)
@@ -325,20 +335,12 @@ static int trie_update_elem(struct bpf_map *map,
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
@@ -368,10 +370,10 @@ static int trie_update_elem(struct bpf_map *map,
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
@@ -385,10 +387,10 @@ static int trie_update_elem(struct bpf_map *map,
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
@@ -400,10 +402,9 @@ static int trie_update_elem(struct bpf_map *map,
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
@@ -417,6 +418,7 @@ static int trie_update_elem(struct bpf_map *map,
 
 	im_node = lpm_trie_node_alloc(trie, NULL);
 	if (!im_node) {
+		trie->n_entries--;
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -438,12 +440,8 @@ static int trie_update_elem(struct bpf_map *map,
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



