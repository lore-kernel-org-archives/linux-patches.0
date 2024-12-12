Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB68621E085;
	Thu, 12 Dec 2024 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017874; cv=none; b=UOUkoFwkSejgPrvIR7w2afMYAIwfW71+IwlqSn3l6p2a7O5ZiJS3HgPcI8vEblSGJO1cuBpVvqiBcCOD8ECbjXUAzlD4SwL0Pcv5KHIM6LY+lH6b5BvpEAMBZrQYM4DcHhUvh/MArdkqHMNvMpaRMY63b8mU5R75uzqHkvhEfH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017874; c=relaxed/simple;
	bh=6FZ2w0krYJuGiawEr4Efy9GKfPIvmIlYZVPIsladLmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aO4VqndGilKQezmv4VS8Bi0BXtQMQqJRIE7ND/9VOxgTf7NnYsOqQUSX4NrbTL/Vx2KJWakyP021j16KJavON4nkGT/6jevoFFjnpsvR6xYEPaHT+3BJIDA3tv6LdUUNCcH43M7s9Ybvw7FNqn48YpYu9mJrH3EOXW1pxR7iEpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsy8qOlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsy8qOlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D615C4CECE;
	Thu, 12 Dec 2024 15:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017873;
	bh=6FZ2w0krYJuGiawEr4Efy9GKfPIvmIlYZVPIsladLmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsy8qOlc7in1bZXMqA1liXwbAvuddQONeQ4jE1QTsE57VsgJAWAHxKiGKPdVb1X80
	 BXOwUYoVAIWXJZIpmmULd+0kVxZp/wJwH95Wyl7FhifMsE7yVq6cR+EJR/BAxzStot
	 Dvx72xWrid9iBV8xk1q5yI9qMS1rxt/FdwlAI/2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/356] bpf: Fix exact match conditions in trie_get_next_key()
Date: Thu, 12 Dec 2024 15:57:35 +0100
Message-ID: <20241212144250.018391184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 27abc7b3fa2e09bbe41e2924d328121546865eda ]

trie_get_next_key() uses node->prefixlen == key->prefixlen to identify
an exact match, However, it is incorrect because when the target key
doesn't fully match the found node (e.g., node->prefixlen != matchlen),
these two nodes may also have the same prefixlen. It will return
expected result when the passed key exist in the trie. However when a
recently-deleted key or nonexistent key is passed to
trie_get_next_key(), it may skip keys and return incorrect result.

Fix it by using node->prefixlen == matchlen to identify exact matches.
When the condition is true after the search, it also implies
node->prefixlen equals key->prefixlen, otherwise, the search would
return NULL instead.

Fixes: b471f2f1de8b ("bpf: implement MAP_GET_NEXT_KEY command for LPM_TRIE map")
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20241206110622.1161752-6-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/lpm_trie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 958f907cdaf0e..c4f1d465ae35c 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -638,7 +638,7 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
 	struct lpm_trie_node **node_stack = NULL;
 	int err = 0, stack_ptr = -1;
 	unsigned int next_bit;
-	size_t matchlen;
+	size_t matchlen = 0;
 
 	/* The get_next_key follows postorder. For the 4 node example in
 	 * the top of this file, the trie_get_next_key() returns the following
@@ -677,7 +677,7 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
 		next_bit = extract_bit(key->data, node->prefixlen);
 		node = rcu_dereference(node->child[next_bit]);
 	}
-	if (!node || node->prefixlen != key->prefixlen ||
+	if (!node || node->prefixlen != matchlen ||
 	    (node->flags & LPM_TREE_NODE_FLAG_IM))
 		goto find_leftmost;
 
-- 
2.43.0



