Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9083B149010;
	Tue, 23 Jan 2024 00:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969206; cv=none; b=lo3Syy+a8jJFsAHSqbC5RLg5K9ICK9JpgTRJl8wiS0WHB7pmprFUA5lWQTg1tclHS8cx40/dO4WKBcuNwFun9bO1XcZLx9SnKH2a0H7e2A/hSvDpW/AuOfqxcVf9be1sf1k1UOsKulZUV0gN8Z2O9WtytzFTfEgIMqCcBJAQ60g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969206; c=relaxed/simple;
	bh=fXx4oljLH5IRx81DSymxpBu8lIjpICKi9kTzp0HNsEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPaRLAEFpQQSKFTOvKIYLOZJyCoinGShjSBlWS4hRKsgFiPokzFQUXi9MCIw3ECjM4JEz5jpzpZKdO0aBTKkeoqVPw8R/nmy9cbuYyFR+vnxxAYqCetRioafO25d4Iewj0HZJEMxNjA+dizezGzG2t0zzGOLPA0wGZMnU0fefiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obVO2iC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obVO2iC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A7CC43394;
	Tue, 23 Jan 2024 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969206;
	bh=fXx4oljLH5IRx81DSymxpBu8lIjpICKi9kTzp0HNsEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obVO2iC8lqWNMOQa9VXbOVxQirMw/hHg9HsQxOotBJOXP7LDYCb0agjDXKU6w3X3k
	 B66/KgIxY+YvQCsS1FQ8FWO39FbPszSPQPAAuMXb/KEsLwM5qHHHK2M/KAqJt12Nyf
	 kSCBCoUnmLnwGG3pR6RceP6bsKYRszWDom+0TT9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Lehner <dev@der-flo.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 098/641] bpf, lpm: Fix check prefixlen before walking trie
Date: Mon, 22 Jan 2024 15:50:02 -0800
Message-ID: <20240122235821.105226182@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



