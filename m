Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E58F21E085;
	Thu, 12 Dec 2024 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024621; cv=none; b=pNXrqtUjBPevGBkb3w+3633OfdGyEEVPvUoIQdqCL09a2NZnSzVrCkiZIvvqQP+P+lMrZClKuuSSAg+M8eMwsWd6EBvuH9SAFLIUUnpCU0IsZ8GxrCk86VDpq62Lg1uQPEp4SHb4ecOd8eCEEDtWHtuOHxZZcDrErIxBnGYEkFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024621; c=relaxed/simple;
	bh=oDHEtCPPmcGdgHuNza/Uk2d9p4EwzqB40Tx8Ucq4B1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGrCmtW96k/YIEnj7bzBOdsLb4Yfp5BVIpHCGmKUA0sdIwwVpR0ShVk6DkYgNWX2MYNkObAZssB3cEWxjK6/rxrhowFYwnEFkaU5jPpSDaPe0qrLbHpLlCgIPS/tnkZ9Ve1Viv04BB8JADbapetiZVg3m9B2afWZ4COm3P4pBp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNCROowy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNCROowy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C6CC4CECE;
	Thu, 12 Dec 2024 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024620;
	bh=oDHEtCPPmcGdgHuNza/Uk2d9p4EwzqB40Tx8Ucq4B1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNCROowyDJNFr3gfvR829+pMQGBVl6aRb7QuL+In6PV6L1dtxIiTrflD1GXOQAR1b
	 RSozoeiFwSSgqBorVuV3jkYPD77k4at17jGM3E3imo7WZWFIufUcHtsAJYc/QfK+Mg
	 gAuiMoZzxY3aWHr1ylAeFf/Dwd03+8KnXpYo+MeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/459] bpf: Handle BPF_EXIST and BPF_NOEXIST for LPM trie
Date: Thu, 12 Dec 2024 16:01:35 +0100
Message-ID: <20241212144307.767924306@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8370b391f1d6c..07f11f108f6ab 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -364,6 +364,10 @@ static int trie_update_elem(struct bpf_map *map,
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
@@ -372,18 +376,31 @@ static int trie_update_elem(struct bpf_map *map,
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



