Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019607;
	b=40dt4mMEZRPxscZYXmHz7quFh5zd+Jrn0oIqZt3zFxfghPDoPUEBaaVcLdg09hhcM8MG
	 7+a/3GiAofzxvH9XGze8xWUbu6gxaqKKv0JbRaiBF00edB0gY30dCiiByAzN5Rd4AjUXY
	 AySTGNEvDa5aPqVy98CkYv64gTHM1/mVRJXxR8r2ysuwcrsrRiDkeUET48VmQUA3bxHP5
	 +FYPpHTs4tuMYOlXyWpwNWl7xmwQE2IeFCdTg7nFS8GdYYWWNeMKtFNK8Vp49GZgaxgdI
	 LVfRFv0KPH25Ut5zSMyLkpjrMup4wJ5Ak3pij/siEFxFydLkdxZVJlYpCdyaKzwDtwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bq+18r1XmY3D3iYwO5P2bWE+xESovOy3/U0Fbb4/0a8=;
	b=zI/E/56r62rTkMb2J6I2fa1OrDELuH9BegL4bQ7A16VZIHnTZV1KxCCgBwnvkqlTrxCc
	 IvnMpLafgTqVZlTRTqiLUHiwOi9bIRC2WveFc0Y9rB6wkpE0mMIdWT4dmzYOo2z+VA8LA
	 L1+hbHwTt/W6BHWvGb0suJTregBBGCsLyxP9NXaljpMuAZ3bb14+9Q3VazrYOiVaghhPz
	 oi8FqxfjLUEWuU7004m4zwpbLOC+hFUdl2GlrR8GvLRwMR04iu6Tj6OB/aQ5IVm8E+047
	 3fj4uVU/4b26klRT2N8iQkeWwMU86R3fYeVqOTba9l9x5a+L8om6n6vALnvF/YVO34A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohgCWtvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C16606A7D3;
	Wed, 18 Nov 2026 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohgCWtvR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13761F000D0;
	Wed, 18 Nov 2026 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019607;
	bh=bq+18r1XmY3D3iYwO5P2bWE+xESovOy3/U0Fbb4/0a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohgCWtvR2/A4jbuDIW2VIaeD/CNg1lfkX70Uectc1Jcd3Kd7Yn17sEYuHnybvMhrW
	 ou9m0qwC/3aXdMVVFUuLHo2bRyuvrr1KIVxk+XeveY53DTvW/7vna+ATaOruwbV/aJ
	 ff8Iem4BgPk9lKt471JTGaU03UQMW8wUIb2ehpHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1654/2651] btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
Date: Wed, 18 Nov 2026 15:48:14 +0100
Message-ID: <20261118150347.310696152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a8094928f4c9b..bfa348d6483f3 100644
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



