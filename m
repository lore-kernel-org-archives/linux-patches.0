Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCAB63122;
	Tue, 23 Jan 2024 00:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971196; cv=none; b=Cy1xEAmcqRcyfB4JaF+WWGA7oY39ZdS4uZc0/Prm+WA0OKpclvunMpdRkmSP204oe1dn+W0lVXzgnrL4ucXn42X6CG7HC8JJ0Jd1Vd6tIwmU8vayq5rWxruIRTvc5ZrDUEu6i/ltMe+o+lBjYsq2L4nP/qf7l6AdjndJfLHKjUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971196; c=relaxed/simple;
	bh=LGCayZVx0jy7CCG16T7QOxHHBzEmbKzTYgatr874bo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnXlwPmIfD/MS5JLXT135VQX7Jh19QlE7aDTkG152MdEIcHZL0tNQ8QTalX7xkDd/UBdXdTp8Iuh13MXIjwXWAaSHDRpHLo53XYUMF6vr3I0ypiJNxoLYgEmUtQ1OFG9OzruxJikkBSqeOxDLrTaTPVUTUxb9hwa/b5dEvQ+dX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZI6+4s9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZI6+4s9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74DBC43390;
	Tue, 23 Jan 2024 00:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971196;
	bh=LGCayZVx0jy7CCG16T7QOxHHBzEmbKzTYgatr874bo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZI6+4s9wwTLlMYkuNEIej3WHPHXX7stxgl3Kb5UlDxRUy6QwaItp9kdkENm8gB6SL
	 bJ6q/n7Ef0oMPikRxgELxTRk4TjSLUObXIOVJGtyuN0iCkLpjYxijN1rUBCV0tucNu
	 xD/jvh2FsES6vnFxtryYVwQS9CYNPjaEV5WSdoV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Lehner <dev@der-flo.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/286] bpf, lpm: Fix check prefixlen before walking trie
Date: Mon, 22 Jan 2024 15:56:55 -0800
Message-ID: <20240122235736.292838354@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 00e32f2ec3e6..3c2d8722d45b 100644
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



