Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732DE19AD72;
	Tue, 16 Jul 2024 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145487; cv=none; b=o8vVh+uGTgN64qDvb9k8WmxiRJvi5hL4QPMUzLrz0bmb4xR1IroglSrlXKQNL/IsEdl8c0XEzpXX4iyr1sfs0PXAIHjeuB+acKXqX0F+Lzl0KvHI+r/hi6ByL1+UUXUI3oypKmyUdKUY8L5jrsMlv1x/ghoXd2oWEW0E5/iSwh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145487; c=relaxed/simple;
	bh=Hey1E9yOSORqCdxL5nQqK0UrjeftDvZfYQ3p4C3zb94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCbNeGiRmZdn6hLlRnxVh9l5ppwQDkavsvcoLgiGVwcYI2KcpBeiu8WNVTiFnWsR+NXUfvJejk1nXD4jUYn7B2j/yUE7KES4caKuliSXyPZX5fullv435mLrjY0M2Gs40JsuvUSllRuTb3/ch/LvfOnbdbYuWCkptR2kIzh8Fe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrINY+3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrINY+3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED575C116B1;
	Tue, 16 Jul 2024 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145487;
	bh=Hey1E9yOSORqCdxL5nQqK0UrjeftDvZfYQ3p4C3zb94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrINY+3LKAqw5A4w9ZWDKT2iZyp4aebhC+BtCrVdij6yuROxlX3Q56pvrHHdSJGgD
	 eCy81TX1vpWVK1zTgTzyb43wVhKhdS7sppg82VhdDK+9DqQsGTGsbgGw8rLQfnzXYW
	 UAbXkASkIfKAuURsUBvH1Q5JQwK+JLHy85bbG5aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Andrew Paniakin <apanyaki@amazon.com>
Subject: [PATCH 6.1 82/96] cifs: avoid dup prefix path in dfs_get_automount_devname()
Date: Tue, 16 Jul 2024 17:32:33 +0200
Message-ID: <20240716152749.667492414@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit d5a863a153e90996ab2aef6b9e08d509f4d5662b upstream.

@server->origin_fullpath already contains the tree name + optional
prefix, so avoid calling __build_path_from_dentry_optional_prefix() as
it might end up duplicating prefix path from @cifs_sb->prepath into
final full path.

Instead, generate DFS full path by simply merging
@server->origin_fullpath with dentry's path.

This fixes the following case

	mount.cifs //root/dfs/dir /mnt/ -o ...
	ls /mnt/link

where cifs_dfs_do_automount() will call smb3_parse_devname() with
@devname set to "//root/dfs/dir/link" instead of
"//root/dfs/dir/dir/link".

Fixes: 7ad54b98fc1f ("cifs: use origin fullpath for automounts")
Cc: <stable@vger.kernel.org> # 6.2+
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_dfs_ref.c |    2 --
 fs/smb/client/cifsproto.h    |   18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifs_dfs_ref.c
+++ b/fs/smb/client/cifs_dfs_ref.c
@@ -325,8 +325,6 @@ static struct vfsmount *cifs_dfs_do_auto
 		mnt = ERR_CAST(full_path);
 		goto out;
 	}
-
-	convert_delimiter(full_path, '/');
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
 	tmp = *cur_ctx;
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -62,11 +62,14 @@ char *__build_path_from_dentry_optional_
 					       bool prefix);
 extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
 						    void *page, bool prefix);
+/* Return DFS full path out of a dentry set for automount */
 static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct TCP_Server_Info *server = tcon->ses->server;
+	size_t len;
+	char *s;
 
 	if (unlikely(!server->origin_fullpath))
 		return ERR_PTR(-EREMOTE);
@@ -75,6 +78,21 @@ static inline char *dfs_get_automount_de
 							server->origin_fullpath,
 							strlen(server->origin_fullpath),
 							true);
+	s = dentry_path_raw(dentry, page, PATH_MAX);
+	if (IS_ERR(s))
+		return s;
+	/* for root, we want "" */
+	if (!s[1])
+		s++;
+
+	len = strlen(server->origin_fullpath);
+	if (s < (char *)page + len)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	s -= len;
+	memcpy(s, server->origin_fullpath, len);
+	convert_delimiter(s, '/');
+	return s;
 }
 
 static inline void *alloc_dentry_path(void)


