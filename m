Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041258;
	b=5IuUrcTk9w3d8LOz/nVa4TswmJv8ECB4y1xEJmANrDm04OFZqpygVlpGSyq9KMPAEFLN
	 7glRDZ/SJRRh7ofTkQMU8METYh9Pa9eicosvhsdNxxJk453iLQksU4H/FTQOS+e74lLy0
	 0V+exKgx3xGB9y8xSuv9F44kToAvlKeYAfGRTNcPF4NOL9n5H7LVe80Supjy7zktn7pru
	 UyUQrrg/Ul81lhtZzCvO572KuTFNcpO0ELxgIYelwCa8x5nkw3LDcCOS4qocYqAS7A2+q
	 6G2/5fAl5Gl3KWIJXV/CqMGsfsGOri7Wq/oViM3EtkWPRTxP3LK95RQUWNg4NhS7eBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tB11fxXDzj8ssWGDSfpix0jkEwyc5FJWGkT9cv3KWNg=;
	b=PM5SVseTl5hetXZgzHSYCR0SrdBxbJpTTKmhYCtafFI0yyUe0KZq/n21Ea9FCCec7YoN
	 qFBmZnZEATCBeD8xLQcg4Zalj0Re7MnQcTHKA0hWaXNVkfwm191Fk/sfCNAi+T+wKNw3N
	 ejtG5qfu6032OoZ4xAIP+FqEb21mL/bl+MBnAazN0kngJXaiYFGd8W53gq50TPzreKDYB
	 KoFADf6OQFAsKxT/o/J6iGEbtY5I2IXSi9eTm3oHlBBwwbB0FbD+iy7tLv3xPp4zEHyx/
	 5jgX8HzkTWcKoNPT9PhKqGwgJ635SM5kfEOSo+Q4soASgLEOxg/Hfu81P5VB35hDphg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig++pxgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6590606A31C;
	Wed, 18 Nov 2026 22:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig++pxgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138C81F000C5;
	Wed, 18 Nov 2026 22:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041258;
	bh=tB11fxXDzj8ssWGDSfpix0jkEwyc5FJWGkT9cv3KWNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig++pxgOoLlb9rGDfpQBlTjjU9LTT3ZtnDdLl8gjxd62FwFGN/rM0xmtd6hPLDynY
	 fkOTgkNBKejv/O9jshryciDgnmg6NFpPRbC2w3p/fHk4W8aJjYecGa0V6lGyBQemXV
	 9VBdm/Uej1XodxuGWElQjKW0l+DfFbk9N5q17r/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2748/3318] btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
Date: Wed, 18 Nov 2026 15:56:10 +0100
Message-ID: <20261118150443.207557312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index febc014a510df..5d0e545a50834 100644
--- a/fs/btrfs/tree-mod-log.c
+++ b/fs/btrfs/tree-mod-log.c
@@ -447,10 +447,17 @@ int btrfs_tree_mod_log_insert_root(struct extent_buffer *old_root,
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



