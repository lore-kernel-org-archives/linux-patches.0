Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAF44F8AE;
	Tue, 23 Jan 2024 01:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974406; cv=none; b=ugDHaemo0vqiNNvRk3QqL7dHuNGPUB6IeLmaTdtkGIA4wOWIo/9d0mjjK+lgcTKTD5RBSpgtXFwwMZZ4LPbpjPOU0pXZ2bBc3xDmqmMKXvF2TdwgVROVagZx9uDCo2e1D9c/ZeZfRBN7Lj80HyONrJ8pAfZRDcNZJD2QcLQGUzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974406; c=relaxed/simple;
	bh=uYgevHvhF9iyFnKVdjrQbFUZhScWt/xXu1V/ErO76eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0cIg47Kv87PNvszU0jA96JDV/r5ivaQX06D5Dx/gBL/V4gc5a8ntzOoYq8enPGV2Lfzv1YSdSQhyFkMAgxNn8CaUWv+7n3teR0h2kVGR7K0wWu52Ef6Qa5SX9pBdi32M1P5z0rDwQZEaPYsEV3vrzAutEfT0VjMBl02Hp3KYDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6uydr9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6uydr9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC751C433F1;
	Tue, 23 Jan 2024 01:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974406;
	bh=uYgevHvhF9iyFnKVdjrQbFUZhScWt/xXu1V/ErO76eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6uydr9v0XUqFx/0zsuu33Vmr1Pl8TMOd6MI2c73XFKV4HJ9F1JoN87HDimMf4FOX
	 jH1s2YFk72rYZNslSJPifBHfbZjblLgjtjfFnds7cLBXN9Vn1fid3uiLxgL8V2GMMB
	 cpY89wTU68j7YpqB0fG1k2Q5C+DrB8XA6h9ZHe4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Lehner <dev@der-flo.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/583] bpf, lpm: Fix check prefixlen before walking trie
Date: Mon, 22 Jan 2024 15:52:19 -0800
Message-ID: <20240122235814.861431869@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 17c7e7782a1f..b32be680da6c 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -231,6 +231,9 @@ static void *trie_lookup_elem(struct bpf_map *map, void *_key)
 	struct lpm_trie_node *node, *found = NULL;
 	struct bpf_lpm_trie_key *key = _key;
 
+	if (key->prefixlen > trie->max_prefixlen)
+		return NULL;
+
 	/* Start walking the trie from the root node ... */
 
 	for (node = rcu_dereference_check(trie->root, rcu_read_lock_bh_held());
-- 
2.43.0



