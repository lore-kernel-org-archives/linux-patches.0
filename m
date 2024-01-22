Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D1B12A17F;
	Tue, 23 Jan 2024 00:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968887; cv=none; b=U345/gO2iGH31R983uAPRugZ4DRCFeLhzfrkAS+TU5B0aNrXafFvMY0+KvbkYkWTSrX2iduMBSHk/R/gWLEdv2FVNmxyLvkcpQ4BZwzpRVUXtth3YDZx5skzSU9V1JsXjb+wVsGDQIbx++xPZbvk6Q2DQyJh/mVwur2bPz/xRcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968887; c=relaxed/simple;
	bh=PoOes07kUKASt+lewHiH05Yi0MIGG0GdayQMBibxD5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCF6mGfBnJLt2iyC05wXaEhMUovT4DFFvWAyaUuZbLjDFyzw1Qb447R9YlgeO+n0kPik53TrwTStT2wmV61BrFKu1efLtgcCiACTYzrt/W8gCm4WT5o3OzTZ8iFC5oGhkultSMbYKWsP7yhncSjNOj6eoKngLGGpxn6G6PFq2To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTC83Jh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTC83Jh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26949C43390;
	Tue, 23 Jan 2024 00:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968887;
	bh=PoOes07kUKASt+lewHiH05Yi0MIGG0GdayQMBibxD5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTC83Jh0P5v2mvgLOfBIUF6n3MNpdnpF/3eL6SXdfXLrmCenRVFzMxx36rsoSr0Nj
	 gCraD4GM7iC9cs93UbHvr1XbTTGy833GN4oWIfOJJjI/Zq01D43GqnkU7oi+klIUq8
	 sCz8PnCXnYmD/Jwr0GgAl5Ptra9ahNd9IADQ0jLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Lehner <dev@der-flo.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/194] bpf, lpm: Fix check prefixlen before walking trie
Date: Mon, 22 Jan 2024 15:56:51 -0800
Message-ID: <20240122235722.718197623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Lehner <dev@der-flo.net>

[ Upstream commit 9b75dbeb36fcd9fc7ed51d370310d0518a387769 ]

When looking up an element in LPM trie, the condition 'matchlen ==
trie->max_prefixlen' will never return true, if key->prefixlen is larger
than trie->max_prefixlen. Consequently all elements in the LPM trie will
be visited and no element is returned in the end.

To resolve this, check key->prefixlen first before walking the LPM trie.

Fixes: b95a5c4db09b ("bpf: add a longest prefix match trie map implementation")
Signed-off-by: Florian Lehner <dev@der-flo.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231105085801.3742-1-dev@der-flo.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/lpm_trie.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 56e6c75d354d..d78c1afe1273 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -230,6 +230,9 @@ static void *trie_lookup_elem(struct bpf_map *map, void *_key)
 	struct lpm_trie_node *node, *found = NULL;
 	struct bpf_lpm_trie_key *key = _key;
 
+	if (key->prefixlen > trie->max_prefixlen)
+		return NULL;
+
 	/* Start walking the trie from the root node ... */
 
 	for (node = rcu_dereference(trie->root); node;) {
-- 
2.43.0



