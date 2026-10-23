Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774220;
	b=1qTCqvQS0OZNopaHtboYUrlhheeYN5kvQr88oGkMnlxvTTHbfOxEyZCoAyqwJD5Hh9r4
	 qqGACjkZhIELuN+7czjnzvRqCjl3Up7hNNALKY5TTZJtYiC1Mq87xf7OXp6WiVNMnJeGr
	 Vj9SBum/oiSlIowsjQc8ZNZbZ5wIOGEzNStLHyaEOfwWZ567/Dr0WZWEYayS3rA4Y1tgt
	 D2fc1gUH7IYL7TCufHCR5iGvP8X/0FTVY34jUfnCGxwxvWFiNa6NyvXygjydMQiJNBLkp
	 WBKyWxRVSXqhCGsS2p0q0EdrvtFubO4goWBifX5LR8ye7bwl2h+YXyRxWM9ewpYkvNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jevmdvOI4iK2tqeLu28KcC14+1/IPsWIpmwoJbwexz8=;
	b=ruEgtq5ob5M844YujjWmZrPGNQ10ET9DkY0IsbGy1U65oE1FL/Fetbh39FzHPtUIEpXN
	 3Q9KncGvI31yhXyLUN2inBzWVemyNAgRUEHrcz+ibUq/fGs/SzbNUFdojIxBHblDVC7a4
	 8HIt2FJG8sAVvRLHvdu9jstI+YETH8gcY5z6yXm/ik5MZFeZpmkJdeOfHB8uoZOgHVd6B
	 UKJ3aSLdHlltTnVzUQa2ylRwKEnUuypAJKtDyYYGWX49AoLzt91K/olwXlB8FZSMvwyGy
	 FUFlyewrGRjJdhonUzeGeRSfjMoM/I7oBU+0ANCiTvEUfe7vDqNSNsedBMdcr4xX41Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSoGMu90;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54716606A31D;
	Fri, 23 Oct 2026 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSoGMu90
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7511F01825;
	Fri, 23 Oct 2026 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774220;
	bh=jevmdvOI4iK2tqeLu28KcC14+1/IPsWIpmwoJbwexz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSoGMu90vQzULPo1cGrpakn9MpZW602npFgI/dKL1PNxWcm6GX+B8FceWUYnaIykA
	 uvHB3fhbS6oLF8pU6MUD0Pvclr96aAWQFFX7I/3NpFM6Zd+0DnoW6SPmxjXSrF0sQ4
	 ySXGrW3jD1pDDIAJ6SaIKUyexfQBL6baUbsuoqF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d77c546c60db651a389c@syzkaller.appspotmail.com,
	YangWen <anmuxixixi@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/193] ntfs3: fix use-after-free of sbi->options in cmp_fnames
Date: Fri, 23 Oct 2026 18:37:18 +0200
Message-ID: <20261023163718.017926627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: YangWen <anmuxixixi@gmail.com>

[ Upstream commit 02f312754c873efe076888a2fdca982e56617929 ]

The root cause is that sbi->options points directly to fc->fs_private.
If fc->fs_private is freed while sbi still exists, sbi->options becomes
a dangling pointer.

This patch ensures that sbi->options is a separate copy of fc->fs_private
and duplicates nls_name if present. On superblock release or error,
sbi->options->nls_name and sbi->options are freed and sbi->options
is set to NULL to avoid any dangling pointer.

Reported-by: syzbot+d77c546c60db651a389c@syzkaller.appspotmail.com
Signed-off-by: YangWen <anmuxixixi@gmail.com>
[almaz.alexandrovich@paragon-software.com: remove syzbot logs from description]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: c01b091b0641 ("ntfs3: free the sbi after a grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |   47 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 8 deletions(-)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -703,6 +703,14 @@ static void ntfs_put_super(struct super_
 
 	/* Mark rw ntfs as clear, if possible. */
 	ntfs_set_state(sbi, NTFS_DIRTY_CLEAR);
+
+	if (sbi->options) {
+		unload_nls(sbi->options->nls);
+		kfree(sbi->options->nls);
+		kfree(sbi->options);
+		sbi->options = NULL;
+	}
+
 	ntfs3_put_sbi(sbi);
 }
 
@@ -1221,7 +1229,8 @@ static int ntfs_fill_super(struct super_
 	int err;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	struct block_device *bdev = sb->s_bdev;
-	struct ntfs_mount_options *options;
+	struct ntfs_mount_options *fc_opts;
+	struct ntfs_mount_options *options = NULL;
 	struct inode *inode;
 	struct ntfs_inode *ni;
 	size_t i, tt, bad_len, bad_frags;
@@ -1238,20 +1247,35 @@ static int ntfs_fill_super(struct super_
 	ref.high = 0;
 
 	sbi->sb = sb;
-	sbi->options = options = fc->fs_private;
-	fc->fs_private = NULL;
+	fc_opts = fc->fs_private;
+	if (!fc_opts) {
+		errorf(fc, "missing mount options");
+		return -EINVAL;
+	}
+	options = kmemdup(fc_opts, sizeof(*fc_opts), GFP_KERNEL);
+	if (!options)
+		return -ENOMEM;
+
+	if (fc_opts->nls_name) {
+		options->nls_name = kstrdup(fc_opts->nls_name, GFP_KERNEL);
+		if (!options->nls_name) {
+			kfree(options);
+			return -ENOMEM;
+		}
+	}
+	sbi->options = options;
 	sb->s_flags |= SB_NODIRATIME;
 	sb->s_magic = 0x7366746e; // "ntfs"
 	sb->s_op = &ntfs_sops;
 	sb->s_export_op = &ntfs_export_ops;
 	sb->s_time_gran = NTFS_TIME_GRAN; // 100 nsec
 	sb->s_xattr = ntfs_xattr_handlers;
-	set_default_d_op(sb, options->nocase ? &ntfs_dentry_ops : NULL);
+	set_default_d_op(sb, sbi->options->nocase ? &ntfs_dentry_ops : NULL);
 
-	options->nls = ntfs_load_nls(options->nls_name);
-	if (IS_ERR(options->nls)) {
-		options->nls = NULL;
-		errorf(fc, "Cannot load nls %s", options->nls_name);
+	sbi->options->nls = ntfs_load_nls(sbi->options->nls_name);
+	if (IS_ERR(sbi->options->nls)) {
+		sbi->options->nls = NULL;
+		errorf(fc, "Cannot load nls %s", fc_opts->nls_name);
 		err = -EINVAL;
 		goto out;
 	}
@@ -1668,6 +1692,13 @@ load_root:
 put_inode_out:
 	iput(inode);
 out:
+	if (sbi && sbi->options) {
+		unload_nls(sbi->options->nls);
+		kfree(sbi->options->nls);
+		kfree(sbi->options);
+		sbi->options = NULL;
+	}
+
 	ntfs3_put_sbi(sbi);
 	kfree(boot2);
 	return err;


