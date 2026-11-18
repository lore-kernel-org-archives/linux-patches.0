Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049497;
	b=y3DAKK79h1NvKwx1UAQyTYmYlNU8RttS7d+8ZCJoIfAGQyMPdlVv5SDWNnWKr17GirM/
	 VaAM5lvi4irdKUiAUZXVSYXAOuQkzrp3wExfIumVXSOSAzvgIf2fN2VfblFLDmluyeNzy
	 93eIPlh3HkmrsjpT/sUCUqpypbRwuKhjfpePFiMeqi7nBj44DVSJiZgSQRh3FB+rba9/U
	 awZyY4XY7lecxM2fG9w9ad5lFOH2VqtGUoZvoUpDw9M2ei5Wp7oezHgqZmy9c+rQ1w2cU
	 WTSv7F2Ex6N9uXyb/u95CUpj4wH9JLmEiBWhgcvnASGGdMDlkvCsN46k/gVFC34DqKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q1avM48GGxTNWkvJSygMGHzCSZSV6f8iO3mM4ifUTHU=;
	b=0zi/7UhYoeRtQ4Zb+xR9wGtvihjgIk5IPqbjFA9J+G7cVg9A46k98ErQOaKXGds7zQl2
	 41YDs9UvhJq62m5LW5SKReXuEHGSQ9tRWHgoGE7fMa9T1VaBtAfq8xkG19QcX9HCYtskc
	 U5ZdMqrzOkA18ovpjEHZDjKW8VJhE69J8xEck1cig0hi+a1OmArBN5wlvt3TEnlwZtzr6
	 BRxcJHS+CNJ5OcJF2/J91K4sS8kMDd+OJmVPRe95gPpdzQJs1D8rswuR5bVxcm6HSBke8
	 /wsGuspxgx3uGZGUrDqRVgy924bdmyRP1snRdVcf1ccY+0nIoJDVG7cD97GNEaljoPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YdS9cUAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA84606A31C;
	Thu, 19 Nov 2026 00:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YdS9cUAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EC81F000C4;
	Thu, 19 Nov 2026 00:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049497;
	bh=q1avM48GGxTNWkvJSygMGHzCSZSV6f8iO3mM4ifUTHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdS9cUARRqt1I/lGOZatcpTcYd+QuYy/yemlXcPt6PCPfxqb4byozDqDKUpK84o33
	 HKJBgElFOxPjz/osIIi8k9ENCXC6kYEUtB8lrZrihn7Vdk3H+6xQMhSADrdeTlg8RZ
	 nJK0x3BmpmzYf4kHQhAhaFPG/eqVKncv4YLqNKOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2373/2857] btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
Date: Wed, 18 Nov 2026 15:56:47 +0100
Message-ID: <20261118150326.963516042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 73fc7d156383e..10ccaa6350d54 100644
--- a/fs/btrfs/tree-mod-log.c
+++ b/fs/btrfs/tree-mod-log.c
@@ -444,10 +444,17 @@ int btrfs_tree_mod_log_insert_root(struct extent_buffer *old_root,
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



