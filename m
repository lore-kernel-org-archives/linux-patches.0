Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65AF2F44;
	Thu, 12 Dec 2024 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023161; cv=none; b=KDl1RK0vTfa5hM2nGiDPw89Bif+SYTWmO2e6zkvvoCfICrZvWqD3ORq+U2aissK+UsEWdbUmRdxrY6u6dcajE6ZoI4Aync9nhsM4ZExLbVKzaLsa7bEfG+tk/s9F76mDaX8MyZ76H2h2Y16KLPxDMv9mhHll7MKmfTqHB8Q8CpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023161; c=relaxed/simple;
	bh=dUg7lEErABV4duRgyFK3KdsT4Fyo40NJUE16Z6Rt2SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7PSGxG9lHmr3sspdJr2/TnnOUW4LfhjR+6h0+pqinupzAFPs8RCRyt+TR7iOwAU1D7wEzSbEFB4H4b32vYDpyT8oLXDui2uTkZr0Y6qjonmYz79CVMqUapAE7A9fk4xs9qitbp8F/jMdthAjWFTTC8wjNOKBnZLMzdJITLYVNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuNUAmKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuNUAmKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246F9C4CECE;
	Thu, 12 Dec 2024 17:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023161;
	bh=dUg7lEErABV4duRgyFK3KdsT4Fyo40NJUE16Z6Rt2SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuNUAmKQqiQ8XZpzZnvMRfEOT3ipiRU0PpHoL0qF6f4OU2JIuLlfUYB+qCDDK6hJT
	 OzX8Y+oWOYA2nc3akmn/wGDlngz2pTp+gqmFTqLxuRbxmKRN+G6gR7dqoKRIaHLm/z
	 wSKMgZkR58fZpQYNPJk7R8lFCUatiVrfiNmQbQG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/565] bpf: Handle BPF_EXIST and BPF_NOEXIST for LPM trie
Date: Thu, 12 Dec 2024 16:00:38 +0100
Message-ID: <20241212144329.209115895@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit eae6a075e9537dd69891cf77ca5a88fa8a28b4a1 ]

Add the currently missing handling for the BPF_EXIST and BPF_NOEXIST
flags. These flags can be specified by users and are relevant since LPM
trie supports exact matches during update.

Fixes: b95a5c4db09b ("bpf: add a longest prefix match trie map implementation")
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20241206110622.1161752-4-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/lpm_trie.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 6b2bf71f8de4b..0ab0ad989eaff 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -366,6 +366,10 @@ static int trie_update_elem(struct bpf_map *map,
 	 * simply assign the @new_node to that slot and be done.
 	 */
 	if (!node) {
+		if (flags == BPF_EXIST) {
+			ret = -ENOENT;
+			goto out;
+		}
 		rcu_assign_pointer(*slot, new_node);
 		goto out;
 	}
@@ -374,18 +378,31 @@ static int trie_update_elem(struct bpf_map *map,
 	 * which already has the correct data array set.
 	 */
 	if (node->prefixlen == matchlen) {
+		if (!(node->flags & LPM_TREE_NODE_FLAG_IM)) {
+			if (flags == BPF_NOEXIST) {
+				ret = -EEXIST;
+				goto out;
+			}
+			trie->n_entries--;
+		} else if (flags == BPF_EXIST) {
+			ret = -ENOENT;
+			goto out;
+		}
+
 		new_node->child[0] = node->child[0];
 		new_node->child[1] = node->child[1];
 
-		if (!(node->flags & LPM_TREE_NODE_FLAG_IM))
-			trie->n_entries--;
-
 		rcu_assign_pointer(*slot, new_node);
 		kfree_rcu(node, rcu);
 
 		goto out;
 	}
 
+	if (flags == BPF_EXIST) {
+		ret = -ENOENT;
+		goto out;
+	}
+
 	/* If the new node matches the prefix completely, it must be inserted
 	 * as an ancestor. Simply insert it between @node and *@slot.
 	 */
-- 
2.43.0



