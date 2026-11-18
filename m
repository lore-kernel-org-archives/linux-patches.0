Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026219;
	b=gio/l1k6EEzB71aZm2LedvF71lYJPTsDtgI/Pvfhn76Nqw8jzK0IcWLQs/BXFnXgbOaz
	 Vgpr1BHnd0R9+O20swaPgVfFTIJ0ajnmuEO+RxrdDMhZk9hTHuCQnHdhqeHWCRHNskSgJ
	 jCjWl6Q48no97n3KCCHZaCVxBKrS/6KygXzV1afHiGf3PHS6pAGO4JjzURJAA/X94X7s8
	 o4o+dMenPCBsRjt45NVaSMQN5NQRP15OIJVcmCa9XyJZdtLLdtBEa5vtkRQPkIky6JQtd
	 qtOSNYfdDlXOwbOgtXOOrO9Ktl37kSf284q98icVzs7PL9AirK+Yq+PF8t2+uDj4t+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZtB2a0VGYzZLMIH0BDf4OLkrLAoNZoVL3tQhe2Dy0r8=;
	b=Yy6thWaMkLdXf/gpd2uAD59UQuIS6Il26Yl0fTId54rSRyfyVpP+FFKGpF+SDUu+tNVw
	 8rfOgWab75Vs7amHfxSgAem3qvdHappYJJl8CtfmMURmOCIAVtp+DODytDKT2Fteah8kN
	 SKVt+Y5a2aV0AS1e+xpwM9vE2WQOSdWw4to6dcBP3RqLfU1UReEZhpkSN6wdmmXsE22SU
	 adaLKfXTfGO6nP1s7g9nO0bOwgLDG3k6BWUBGk62eWLZYjc8P2qFerD7PY/O3VMQj3mnx
	 9KXiP8AhgVXr8RmfyvuDd83kO+iG5NHqakpqVGOlnTn4spm6Zb7r1sBqKMH6/wl3W3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5eiix5Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0238C60A260F;
	Wed, 18 Nov 2026 18:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5eiix5Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277661F000C8;
	Wed, 18 Nov 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026218;
	bh=ZtB2a0VGYzZLMIH0BDf4OLkrLAoNZoVL3tQhe2Dy0r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5eiix5YoaulQ5uhMjXCEZt6ite3lx+8e3E3pQAvW7WGvmrQf1H1dYwT1k3kweSJw
	 aJa+lekb2ZPEGCJE1V0283XzmgV1VwPhQ119hFEJ2Ay67+bGgMdpa2YjVObap1T8go
	 gdxe3BCFXb9uW+pr+PUMRAaUGpsI+b07AUo70awo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1357/2151] btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
Date: Wed, 18 Nov 2026 15:51:32 +0100
Message-ID: <20261118150211.462338931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9e8cb3b7c0643..70e9daf2ce42a 100644
--- a/fs/btrfs/tree-mod-log.c
+++ b/fs/btrfs/tree-mod-log.c
@@ -483,10 +483,17 @@ int btrfs_tree_mod_log_insert_root(struct extent_buffer *old_root,
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



