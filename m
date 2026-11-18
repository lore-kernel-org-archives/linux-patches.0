Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031578;
	b=SonXF1/5mDgoREvBb+qXUHagN6xm1quCm/7AMtMWEeAf+4bHStaM21kuRStNhPrCfZli
	 9zyBWMenY23HMWlewG3mlUUvDfQvpH+uF7YlPEK+CK3Sr1d8O95tzGTE1yQ2AgW0ZZ3cn
	 VoUr6Bzcct8LWm/Pw9I3ipnKjc6hfCEy3jrWkv5wRklJNYqbiMGZeMWlX2oIDTjCdnjpx
	 ZeWE1xWnDJSWNsFMfrpUKhDHhhBqpr89inmyUUbU31zzxN/toGgzfI/RIkMgTnvZaRvDk
	 yb3ebGXoLILv3oEGEvGt4nUIzVq/zppXPacc0+XAhL3BlL+pRdu1XebvpOZPGsyjruA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LDfcF4oSZzfvN6lHUQV4R7FL9J3UPEUuwKlcTSb1cLM=;
	b=Y/ArexZAckt9Bc6U+VZYpXnNHWjGR9bLvxh1Wc4M2uQTY0VSyaP7/6Ww/VThbK/MG8PI
	 0quX+b5JepjFLUhC3JLObC1I7Ayodv66pKj2VtEhVOTim7lIC9pf8AcxEoefdBIx3lmRq
	 Engvh/fRSeiKk7Pi75Yxbgx8lOfNeqCOVw8qf0rP6ZTPFYW/x4nteJEnqasqizDKJBdhq
	 T7dhoAj83z+X1/y8kes3Ai5jVy6XY6eYph38XO24IL+HjoGEAfwkAM64SmjW2F228PYHB
	 f4VaA+bqyy3H7YAAzSfrOAXkK4AEANjwGILxn0iPCN0xhepESwCtamAsKDcpKV0sI7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="umZO/a0J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D17606A31C;
	Wed, 18 Nov 2026 19:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umZO/a0J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A34A1F000C4;
	Wed, 18 Nov 2026 19:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031578;
	bh=LDfcF4oSZzfvN6lHUQV4R7FL9J3UPEUuwKlcTSb1cLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umZO/a0JIFRKXTXbGqqYbvobtWXUI9y8+SB77op3zVrMHgIInlTuG4+NMJb0iDwoK
	 xdfWZDS6C4Cu2DTtqkfXfgu/dF+esR/X7uikLTXwET3UcEjN4pTfE2aLnXLyf92+eh
	 2V1IuAGQ3kb9IataWbZjQmUg6kRBmSz84fC1gjls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1066/1756] btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
Date: Wed, 18 Nov 2026 15:53:13 +0100
Message-ID: <20261118150052.700952564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 057e3c350a9185df598c88b4081168ed047c9247 ]

If in btrfs_tree_mod_log_insert_root() there is an error in the call to
tree_mod_log_insert() (the only possible error is -EEXIST, which means we
have a bug or some memory corruption maybe) we free all the nodes in the
'tm_list' array but we don't remove them from the tree-mod-log rbtree,
which can result in use-after-free bugs later.

So make sure we remove the nodes from the rbtree before freeing them after
an error.

Fixes: 5de865eebb83 ("Btrfs: fix tree mod logging")
Assisted-by: LLM (found the bug)
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-mod-log.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-mod-log.c b/fs/btrfs/tree-mod-log.c
index b382a4c443d42..13f58ed448422 100644
--- a/fs/btrfs/tree-mod-log.c
+++ b/fs/btrfs/tree-mod-log.c
@@ -446,10 +446,17 @@ int btrfs_tree_mod_log_insert_root(struct extent_buffer *old_root,
 		goto out_unlock;
 	}
 
-	if (tm_list)
+	if (tm_list) {
 		ret = tree_mod_log_free_eb(fs_info, tm_list, nritems);
-	if (!ret)
-		ret = tree_mod_log_insert(fs_info, tm);
+		if (ret)
+			goto out_unlock;
+	}
+
+	ret = tree_mod_log_insert(fs_info, tm);
+	if (ret && tm_list) {
+		for (i = 0; i < nritems; i++)
+			rb_erase(&tm_list[i]->node, &fs_info->tree_mod_log);
+	}
 
 out_unlock:
 	write_unlock(&fs_info->tree_mod_log_lock);
-- 
2.53.0



