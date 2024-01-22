Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B0F50A83;
	Tue, 23 Jan 2024 01:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974006; cv=none; b=LvfvAtEJXKsbaHfUCy2r9XMmiZRjPowfJg/39glTFEY4moDoLGWp+eQOamuAwOUEpHJ4omvDf+NJD5SBnNlI2/3SAmQR4fLXlN0at2gz1spH4W3B5zzKhPT99yVzyeJgERbX6NihmdY0cbcTjnhNXyHsuajcdNRnua7whp3JtEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974006; c=relaxed/simple;
	bh=9DAmlYOpz2ZBRTluw6J9RjaSAaOqYUqt871vAwlKYxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddDa8Vx5jWkpy2iKmYA07kY3x2Q4QvTTbHeh3nCvbcxCq68mnqcXaBaCeMKSEeHW2r7K9DcRbxbjppme5wTG1BuPE+sPH5IX8aJ8YttFM8YX7mIdo2RXP6xAc/cCpkFRihZzm+K/h6yY/Dvgzu0EYGxFGvh2jSCo1CaIpga3Xw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncqwU80l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncqwU80l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE7FC3278C;
	Tue, 23 Jan 2024 01:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974005;
	bh=9DAmlYOpz2ZBRTluw6J9RjaSAaOqYUqt871vAwlKYxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncqwU80lE2tRy4fU7ZqmRP1TufFtELzGUeJwif6NzSWvevXU+SK9AAJI7ISNbce3V
	 Gm+Zd/DRJaD04zn10X8i7+8w61yxmNmWN3KFeKFL5fplZuFBiG5hUB04kDQlBJD6zL
	 HIdJ51IkNXdP/f+ad7RfmO0cPuDef9J51911f3LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Lehner <dev@der-flo.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/374] bpf, lpm: Fix check prefixlen before walking trie
Date: Mon, 22 Jan 2024 15:56:14 -0800
Message-ID: <20240122235748.738294786@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 423549d2c52e..4ea7fb0ca1ad 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -230,6 +230,9 @@ static void *trie_lookup_elem(struct bpf_map *map, void *_key)
 	struct lpm_trie_node *node, *found = NULL;
 	struct bpf_lpm_trie_key *key = _key;
 
+	if (key->prefixlen > trie->max_prefixlen)
+		return NULL;
+
 	/* Start walking the trie from the root node ... */
 
 	for (node = rcu_dereference_check(trie->root, rcu_read_lock_bh_held());
-- 
2.43.0



