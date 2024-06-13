Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786276AFAE;
	Thu, 13 Jun 2024 11:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279378; cv=none; b=Bl0/F46OS51ZohRXXV6JMUdwkI6btPGTjzXwKbx1o8Zpzt4YBFoIJlZ3yMm5Zs4Ze20SAatOQM/6LVX0J3ea1TzLvCwwKbTSKjmTX5M+Hp4qGxyP0KCdf8Twi6leCjxRURtLncsC+CelsUBy5RxmPIyu9y2zallmfVJNaIoQ8J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279378; c=relaxed/simple;
	bh=mSiazMd0rU950ApFYr2Cw+jeVeIAXMXvRkO/U34s7LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHFKYbaXbaG17vytJ0gUbJme2PwfT8QLn5qOjNbOOJARN2R1KPGUYxXBJggWZp2D1gx2dJ8GfubPbv2uGee+QsrWbzkIolbh/KtXSuMkln+F5zyRVZUXVTI84tM2mDX2I0ks4Bs/90UjvAYySUjMjRmhkdDJCkHcVyVIRTLOfXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkD+fNYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkD+fNYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001F7C2BBFC;
	Thu, 13 Jun 2024 11:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279378;
	bh=mSiazMd0rU950ApFYr2Cw+jeVeIAXMXvRkO/U34s7LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkD+fNYLpnFGXHYnvTXNQaNtrZyWVHFEM6YeZgJpS7Yg6lyMOEwEiKHtCwduQ4ek6
	 TZGSPLAgBOb8sEa0txJwdqHL8WW8CDyE+jf6g+Cp46BCm5KswmJwAqF3pVnYAD+sko
	 4mJsvbZGVFhoikB5DEVrZj4zG6PQPLjpzk6XgulI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.9 054/157] 9p: add missing locking around taking dentry fid list
Date: Thu, 13 Jun 2024 13:32:59 +0200
Message-ID: <20240613113229.515996913@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

commit c898afdc15645efb555acb6d85b484eb40a45409 upstream.

Fix a use-after-free on dentry's d_fsdata fid list when a thread
looks up a fid through dentry while another thread unlinks it:

UAF thread:
refcount_t: addition on 0; use-after-free.
 p9_fid_get linux/./include/net/9p/client.h:262
 v9fs_fid_find+0x236/0x280 linux/fs/9p/fid.c:129
 v9fs_fid_lookup_with_uid linux/fs/9p/fid.c:181
 v9fs_fid_lookup+0xbf/0xc20 linux/fs/9p/fid.c:314
 v9fs_vfs_getattr_dotl+0xf9/0x360 linux/fs/9p/vfs_inode_dotl.c:400
 vfs_statx+0xdd/0x4d0 linux/fs/stat.c:248

Freed by:
 p9_fid_destroy (inlined)
 p9_client_clunk+0xb0/0xe0 linux/net/9p/client.c:1456
 p9_fid_put linux/./include/net/9p/client.h:278
 v9fs_dentry_release+0xb5/0x140 linux/fs/9p/vfs_dentry.c:55
 v9fs_remove+0x38f/0x620 linux/fs/9p/vfs_inode.c:518
 vfs_unlink+0x29a/0x810 linux/fs/namei.c:4335

The problem is that d_fsdata was not accessed under d_lock, because
d_release() normally is only called once the dentry is otherwise no
longer accessible but since we also call it explicitly in v9fs_remove
that lock is required:
move the hlist out of the dentry under lock then unref its fids once
they are no longer accessible.

Fixes: 154372e67d40 ("fs/9p: fix create-unlink-getattr idiom")
Cc: stable@vger.kernel.org
Reported-by: Meysam Firouzi
Reported-by: Amirmohammad Eftekhar
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <20240521122947.1080227-1-asmadeus@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_dentry.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -48,12 +48,17 @@ static int v9fs_cached_dentry_delete(con
 static void v9fs_dentry_release(struct dentry *dentry)
 {
 	struct hlist_node *p, *n;
+	struct hlist_head head;
 
 	p9_debug(P9_DEBUG_VFS, " dentry: %pd (%p)\n",
 		 dentry, dentry);
-	hlist_for_each_safe(p, n, (struct hlist_head *)&dentry->d_fsdata)
+
+	spin_lock(&dentry->d_lock);
+	hlist_move_list((struct hlist_head *)&dentry->d_fsdata, &head);
+	spin_unlock(&dentry->d_lock);
+
+	hlist_for_each_safe(p, n, &head)
 		p9_fid_put(hlist_entry(p, struct p9_fid, dlist));
-	dentry->d_fsdata = NULL;
 }
 
 static int v9fs_lookup_revalidate(struct dentry *dentry, unsigned int flags)


