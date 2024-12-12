Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450FB213E6F;
	Thu, 12 Dec 2024 17:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024623; cv=none; b=HWMkPfMcFqwFYpTO4rg4uLwYLGzmlU0wufacTRKPZ94GHUo9Egap54mCpigA8LYVvl8pND6VYoS2p7SxjArvbngngBh8jp8xIwf0nDgQ3TZv7cXmPrifl7xWtArVbz7+TpfHDe43Y8a3QCvHdq6k6FfYqdhkS5UuNCJGb5IVuV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024623; c=relaxed/simple;
	bh=JNpoIy/uOglrZ5FNrxeL0SazAfpzedbv4cmAoSJQTnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kVFKo7Ka64GvKjefmIW1W6TB1ZRqV0AXeWbOre7NSGayKVngz7+kgH7j7kM9z/rOKbJEtX/X3WNnlrcTfUTagDmDKPlIZjA5UNWXzMQxs4Y3izSlS11UByXkmkk3doCyajP8S7yHf0hlwdKc6IipBgmTnSIGTdskTXdd4W8XBsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3L2bxQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3L2bxQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFADCC4CECE;
	Thu, 12 Dec 2024 17:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024623;
	bh=JNpoIy/uOglrZ5FNrxeL0SazAfpzedbv4cmAoSJQTnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3L2bxQsfLNTy9zRvm3EnZw/Q9zOXbwOnr+qkM/quhmYlD/j1oACWVtSpPzNviGv1
	 qhDunV1VUY5ZFUCVS1zX8zmmMoCaInAv6uDsKPW3eqDuNqvv+HbQ4I2BLHs5NFfUI4
	 RnxL1KXYMD0DKrsievDH0d6cBy9vKYYy92vpUdvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/459] bpf: Fix exact match conditions in trie_get_next_key()
Date: Thu, 12 Dec 2024 16:01:36 +0100
Message-ID: <20241212144307.808264381@linuxfoundation.org>
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
index 07f11f108f6ab..d833d74c1c673 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -650,7 +650,7 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
 	struct lpm_trie_node **node_stack = NULL;
 	int err = 0, stack_ptr = -1;
 	unsigned int next_bit;
-	size_t matchlen;
+	size_t matchlen = 0;
 
 	/* The get_next_key follows postorder. For the 4 node example in
 	 * the top of this file, the trie_get_next_key() returns the following
@@ -689,7 +689,7 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
 		next_bit = extract_bit(key->data, node->prefixlen);
 		node = rcu_dereference(node->child[next_bit]);
 	}
-	if (!node || node->prefixlen != key->prefixlen ||
+	if (!node || node->prefixlen != matchlen ||
 	    (node->flags & LPM_TREE_NODE_FLAG_IM))
 		goto find_leftmost;
 
-- 
2.43.0



