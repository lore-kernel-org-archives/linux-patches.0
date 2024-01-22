Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA17F5680;
	Tue, 23 Jan 2024 00:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968411; cv=none; b=UNtIdzwP0zJJs3jzhI1gapCQms7MIBnY62Zf5pwclDoLl1Tqeb+EhM/Vu4QGY0o8tTtcmTOSLhqZpbdIjTzBJMjr4FnTakWMAB8awZNJGemJeHWRJCs7qkKOY9Q7pK1JsMaFl2LykBwefcnFdMEq/kqm+PLZQ+hTXyUKhmLnwjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968411; c=relaxed/simple;
	bh=ocNRXW4si3hems3gWKFGJRjO4/TrLg5FrEBQPRiHzvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChuMGrWLbVcPjUFEG/HKUSZJEvkAEwIFb5J2tZFjUWu7ACAq0/1eJy3qGFvUTP6xjthnFYaWAIBW2IaOQAgx3Y5PMBh1emR9D0s3u8Zb9OiddqyTjedxZhkaA5RuWiwseroM07n9CJnKxugveVsVFtVqDC22sDWuOCWyZE2Kk9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNUD82Vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNUD82Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E890C433C7;
	Tue, 23 Jan 2024 00:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968411;
	bh=ocNRXW4si3hems3gWKFGJRjO4/TrLg5FrEBQPRiHzvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNUD82Vw2aoAy/CYCeXBSqXN7C9znia4cBf2wc1sBL0fhse1iSk7OnrR9yGQXucBb
	 VfqSrBOjrN0e0o0CR6yNewVjKxdCs6v3fj02f1eGY6i3j22cl/TJSRJilrtECMqDdi
	 KB7fU2vLpBjAj8MfjAiOWr187Gpobw2du/saC0FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Lehner <dev@der-flo.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/148] bpf, lpm: Fix check prefixlen before walking trie
Date: Mon, 22 Jan 2024 15:57:00 -0800
Message-ID: <20240122235714.987370226@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1a8b208f6c55..fcd3a15add41 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -194,6 +194,9 @@ static void *trie_lookup_elem(struct bpf_map *map, void *_key)
 	struct lpm_trie_node *node, *found = NULL;
 	struct bpf_lpm_trie_key *key = _key;
 
+	if (key->prefixlen > trie->max_prefixlen)
+		return NULL;
+
 	/* Start walking the trie from the root node ... */
 
 	for (node = rcu_dereference(trie->root); node;) {
-- 
2.43.0



