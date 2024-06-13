Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABE5A59;
	Thu, 13 Jun 2024 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282946; cv=none; b=ZMgEv6Ov1/cln/z3R4Ivp3BsTlMXyLhztE0rAlQ8GtGcf7XGgPam+IhshH19c41LxfFu42np7FQq0VdtFfVfZ8j7LtZRAWbsIysXIlcDm1V4y3ju9xlSm17J4z7u+hzJt0gnOY05HsLDfiZP30H+N6lmxVpumoW/eQGIB9jPsSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282946; c=relaxed/simple;
	bh=fOFXYu2G1+AH77BwNUxaafM3I/Wo45xM8DHn0zxEteg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+Xl+Y5q5SdipkBp/DNkCHJwOyIfQpbofq6j2BsZKUPyIz3O6VtNsh9lpODg0z5BRIncKJST7XU+f88uq0ob4Rpc3IvSWD5nqInEtvrMRJ8zkKQYK6ThHh37ryxD+/B4vCeG1vG702acmoQB3G8X8MRRknnjd6dRv3YdOc5CuKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0sm1egb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0sm1egb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE2C2BBFC;
	Thu, 13 Jun 2024 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282946;
	bh=fOFXYu2G1+AH77BwNUxaafM3I/Wo45xM8DHn0zxEteg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0sm1egbjrQeJKWb81d1fZxHW7Ev9xK9FE35y2mKpDwk8u8EBsEBT0m0J7Mb2M4Ye
	 wWCa/D3gCfoq8hFsuDC1qeGhMLpBFrR1aWb9JTiSNOLKhKlvbtuXRcBjSwGMD6+H+N
	 4zQevWa+JydtBMuHqYSOGCbaZBUTslRgFxaLQJlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.1 46/85] 9p: add missing locking around taking dentry fid list
Date: Thu, 13 Jun 2024 13:35:44 +0200
Message-ID: <20240613113215.920179558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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
@@ -50,12 +50,17 @@ static int v9fs_cached_dentry_delete(con
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


