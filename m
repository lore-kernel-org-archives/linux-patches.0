Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D83C1CC14B;
	Wed,  6 Nov 2024 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899029; cv=none; b=O7NN+8DN6pP4NftmOUJbY6PUrLg2PKk7RVsrePn/XLS3qBAlj+cbgfVe+P7WH5scuwO6kn590AMAIdkLYKrpBG7Z3Clw1buFBA/yHHBtWqb1VO7rIR747X2ur2rBYUcknaVSn+ggz5Q/U2/BIXVL5ecTpRnnusS1RAI30WJoJZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899029; c=relaxed/simple;
	bh=0mIu4kgkp69UPuIt94r8PFY6DT8fTxjTiB2pfVQfvyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIhmsY2F5X29Bbzd1fUUHGvBqQ+aSWLhDT0ww4bZnSCdJSxGwA5CL57HgcZwrEghbX1Bfv6X0p5h9XN7wPMVAWC5qcBUQP6ozjy324lLH3vg7Zah+9DeLbxSQ8LwURG08ABuaIX14Ixo/kYb8D3JGaLbNqE99cH6WsWcw2ifsMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxMT7NRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxMT7NRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F79C4CED5;
	Wed,  6 Nov 2024 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899029;
	bh=0mIu4kgkp69UPuIt94r8PFY6DT8fTxjTiB2pfVQfvyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxMT7NRhYFp89WPF21SJ+WiNYhQAza51nUh4ba456tREQJqybIjyYpDj9dllNIRgf
	 COD8ZiSiXeXGEX8XCHSwUfMIcNUJD9dA6qtxLvC9lNGCUS35avKaMkhKUCzPbJd3Hr
	 eDeZ2yET9FYhiZUUYcjMcP+ChtZRS6LlR4WEGVxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Byeonguk Jeong <jungbu2855@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 438/462] bpf: Fix out-of-bounds write in trie_get_next_key()
Date: Wed,  6 Nov 2024 13:05:31 +0100
Message-ID: <20241106120342.320705705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Byeonguk Jeong <jungbu2855@gmail.com>

[ Upstream commit 13400ac8fb80c57c2bfb12ebd35ee121ce9b4d21 ]

trie_get_next_key() allocates a node stack with size trie->max_prefixlen,
while it writes (trie->max_prefixlen + 1) nodes to the stack when it has
full paths from the root to leaves. For example, consider a trie with
max_prefixlen is 8, and the nodes with key 0x00/0, 0x00/1, 0x00/2, ...
0x00/8 inserted. Subsequent calls to trie_get_next_key with _key with
.prefixlen = 8 make 9 nodes be written on the node stack with size 8.

Fixes: b471f2f1de8b ("bpf: implement MAP_GET_NEXT_KEY command for LPM_TRIE map")
Signed-off-by: Byeonguk Jeong <jungbu2855@gmail.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@kernel.org>
Tested-by: Hou Tao <houtao1@huawei.com>
Acked-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/Zxx384ZfdlFYnz6J@localhost.localdomain
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/lpm_trie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index d78c1afe12737..c372be6df264e 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -660,7 +660,7 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
 	if (!key || key->prefixlen > trie->max_prefixlen)
 		goto find_leftmost;
 
-	node_stack = kmalloc_array(trie->max_prefixlen,
+	node_stack = kmalloc_array(trie->max_prefixlen + 1,
 				   sizeof(struct lpm_trie_node *),
 				   GFP_ATOMIC | __GFP_NOWARN);
 	if (!node_stack)
-- 
2.43.0



