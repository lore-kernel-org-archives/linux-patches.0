Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590630;
	b=qM9Nz6oi8JA6OWvFjamyaWPCLRxMEnYZ6S7HKUpPRkjr9hHMztBovZfq6rytscJdAE1a
	 11Q641y303plhhbgY19/D2CqoPY3yii3gn0iioDhwBBNOeKXEq/EpplaIzItqsOPNbEu1
	 JbhCJm/XzlTZRtvhghz77ce4OnEWYqVenJNeSHvo4Xf6OorGNYbqMiXQvm11qtD8kYPEy
	 EmCzG/jtvBl/x2zXCehNNjXnBv3BciJ6pW+uZDHZgqBZ2snqXXp0LCNJcfAvSAtN1bmU1
	 wflIMDSvQObvFRDY8Wo16yU9ig/+QbkGxyQG24XnXLq/DOjaUI/e+SaODu0fxW7K5lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ks1jBfMffCCwE8jOOknEWVtslRKnDepj+RZKEzYLGi8=;
	b=VzvBS/WNQwCMvr741LkkF4YGhjdDhgijlfIvid02l/7i/f5OOU5ILtrsnEamW4qnARTu
	 /1RVRJmgFdS+7yg0ytyAZ3Gt7Qj2DKylmBergJRuKPhLwg4ODmM2sanyB5ssxHIl4v6ok
	 WqaGQPA+wC28ReBj2NDrE9FunoQJ7b0+8zZo+uuPTBznL3Yl+2yXtq5DxTGkaplF3HaY8
	 rjwD9hwK6AQuBWeHNLJtWCB5hAh6+4gY654njDkUZUygYPuMMUI/kRiuZHuvN2Bm/VeK9
	 X9NvsihIEVJVyTPd80VZ1Eqoavdhr3hd5gmhkFmFoQKKfD1Zq6JOXMSn103mj29vk3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUO5XjYr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E747060A2623;
	Fri, 13 Nov 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUO5XjYr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944221F000C4;
	Fri, 13 Nov 2026 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590629;
	bh=Ks1jBfMffCCwE8jOOknEWVtslRKnDepj+RZKEzYLGi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUO5XjYrQH5FdAKRCxum9IgArt0ko715aX+8XVz3vR3yihUvFjALpex+u1mBF8Pb7
	 F80N+ivaaVI+oMGAQOJ3LM902EJocSoQLq1L1XXh3+4FVhPcRcMmZROzjMf03JdqXx
	 vez/l+NuqVcomNPLLvxwdUhA4QUVy6Q+wsAjmRPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 551/686] ovl: fail the mount if the casefold flag has changed
Date: Fri, 13 Nov 2026 10:51:24 -0500
Message-ID: <20261113153840.238171372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit c782fc8ada811569811c0fdea5c3412511be95d0 ]

An unprivileged user in a user namespace can repeatedly trigger a kernel
warning with their own overlay mounts. They do so by changing the
casefold flag of the topmost layer's empty root, the top directory of
that layer, after the layers are set and before the mount is created.

The casefold flag of a directory makes name lookups in that directory
case-insensitive. All layers of an overlay must agree on casefolding.

ovl_mount_dir_check() reads the casefold flag of a layer root when
fsconfig() sets that layer, and saves the result in ofs->casefold. The
mount is created later, by another fsconfig() call with
FSCONFIG_CMD_CREATE.

The casefold flag of an empty directory can be changed.

The casefold flag of the overlay root must match ofs->casefold.
ovl_get_root() copies the flag from the topmost layer root, as it is
when the mount is created. On a mismatch, ovl_get_root() only does a
WARN_ON(), and the mount continues. The check is not a WARN_ON_ONCE(),
so each such mount warns again.

An unprivileged user needs CONFIG_UNICODE, and a tmpfs mounted with the
casefold option in their namespace.

Reproduced by changing the casefold flag of the empty upper directory
after the layers were set and before FSCONFIG_CMD_CREATE, with tmpfs and
ext4 layers, and as uid 1000 in a user namespace.

Fix this by replacing the WARN_ON() with a check that fails the mount
with -EINVAL.

Fixes: f9377faaeae0 ("ovl: Add S_CASEFOLD as part of the inode flag to be copied")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Tested-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: In 6.18, ovl_fill_super() handles credential restoration and
filesystem cleanup. Drop the unpublished root dentry and go to out_err,
skipping out_free_oe because the root inode already owns oe.]
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 8d4ef5b2f1780..52d6f32a5a7c3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1370,7 +1370,6 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
-	WARN_ON(!!IS_CASEFOLDED(d_inode(root)) != ofs->casefold);
 	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);
 	/* root keeps a reference of upperdentry */
 	dget(upperdentry);
@@ -1576,6 +1575,17 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!root_dentry)
 		goto out_free_oe;
 
+	/*
+	 * The casefold flag of an empty layer root may have changed since the
+	 * mount options were parsed. The root inode owns oe by now.
+	 */
+	if (!!IS_CASEFOLDED(d_inode(root_dentry)) != ofs->casefold) {
+		pr_err("casefold flag of the root directory has changed\n");
+		dput(root_dentry);
+		err = -EINVAL;
+		goto out_err;
+	}
+
 	sb->s_root = root_dentry;
 
 	ovl_revert_creds(old_cred);
-- 
2.53.0



