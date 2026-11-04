Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829082;
	b=ykrvDwKoce6boveDYdjaL63uC5V75SJhDIm3168Xsmb8HLlwVBc61Qo7ZKWRaaa7pMQr
	 fc7gtx3oMlajrqYdEiF4bNjEgamto04ifBcNLa1x5A7sZyyLIUf/GwXiFklyg4/6fBo80
	 kgrF1zVAQFY01YzqEaWMejFsM+d5Mwk0xrOFJt2MJ5hJZjGhdoJS7L8qc2jZwds6NY5hJ
	 XxS0Jg+o83+dM2ljjWiiwYi/BDRrGF1GPfLbahYBHKCs3jPo/wkRyB22T8Audo9692iKa
	 ySuYhZVjevjylQMYSLPy1S+bLhRn3hcycQ75GAU1SmTN7J+kL9KPHzaHHK6Yy1OS3jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/hL0ot0lHEBGpWYjqbjGsWgbSvzv65e/SZOorgbikyc=;
	b=DNX7dJWdmrWxOmItGpwyW4k8Ide8A0uzMlS/cZ04/v8zGq4EK4VFkbo29+wbrwH+N3wZ
	 myysLQM4NmB6W8kqnTkmyFUk/dXvEsWzXL4B/MXMgC9IKcMNrvzjBVE0WMVxZATICwqWR
	 yi/SRIKYRu6WTzyUEGHrkB0PS5c5p1YCZjCuzP/OLEv2YxMTvMyIs3Lb0BO14PvPcLD3q
	 iQ+tk1mueDUpjOfLuzB/8D9L/xgW1WnoDBgZVmWtBWkFNn5h6FGFHIGwoi75bUOmfVirt
	 wJeoJrCCFtB/FiKciAHWFckN9XJyzPzfD91dG6O4+N2CLu3CQCTq46EUIbdPG58s6Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Db3INMZp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3D1606EEB6;
	Wed,  4 Nov 2026 21:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Db3INMZp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C13B1F00A15;
	Wed,  4 Nov 2026 21:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829081;
	bh=/hL0ot0lHEBGpWYjqbjGsWgbSvzv65e/SZOorgbikyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Db3INMZpAdXJP2b7XOuhd1V6o8i93Mq8e5dYFkKsm99r4SJZyUvarCHUw1UyUmJkI
	 +uaJZhUdEP6msjjsF1ut/LguaEmPIVb/hOLivvJ2a6wYTopXZqIxrDdxdmOa0OLTGk
	 42HKpUbyTyyAfFJ9NEvF7A1EBf/s0QX5pnBUEQDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 393/547] kernfs: dont lose IN_DELETE_SELF when decoding a file handle
Date: Wed,  4 Nov 2026 16:09:37 -0500
Message-ID: <20261104211049.467362203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit dc1a0cc95737344b1a6aa42075e573e9625c6b9a upstream.

__kernfs_remove() clears i_nlink on a node's inodes and finds them with
ilookup().  A decode that has pinned the node but not yet hashed its
inode is invisible to that pass:

  CPU0                                    CPU1
  open_by_handle_at()
    kernfs_find_and_get_node_by_id()
      pins the node, still active
                                          rmdir()
                                            marks the subtree removing
                                            ilookup() finds no inode
    kernfs_get_inode()
      hashes an inode with i_nlink 1

Nothing fixes it later: kernfs_refresh_inode() never touches i_nlink for
a file and skips it for a directory being removed.  The inode keeps the
1 it was born with, and dentry_unlink_inode() sends IN_DELETE_SELF only
at 0, so a watcher never learns the node went away.

The other callers of kernfs_get_inode() are safe: those in fs/kernfs
hold kernfs_rwsem, and cgroup_may_write() is covered by cgroup_mutex,
which cgroup_destroy_locked() holds across kernfs_remove().
__kernfs_fh_to_dentry() has held nothing since exportfs support was
added.

Take kernfs_rwsem for reading, as ->get_parent already does, and cover
the lookup as well as kernfs_get_inode().  __kernfs_remove() deactivates
the whole subtree under the write lock, so under the read lock either
the lookup refuses the node, or the inode is hashed before the ilookup()
pass runs.  The same holds for ->fh_to_parent, since a node cannot be
active while an ancestor is being removed.

Reproduced with a 300ms delay between the lookup and kernfs_get_inode(),
decoding a handle for a file in a cgroup directory while another task
rmdir()s it: st_nlink is 1 without this patch and 0 with it.

->get_parent still has a window of its own.  It takes the same lock but
has no active check, so reconnect_path() can build an inode for an
ancestor that is already gone.  That needs the active test rather than a
lock, and changes what ->get_parent returns, so it is left to the series
that reworks these paths.

Fixes: eea5d2bb34ba ("kernfs: Send IN_DELETE_SELF and IN_IGNORED")
Cc: stable@vger.kernel.org
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20260905191613.3143937-4-shakeel.butt@linux.dev
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/mount.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -124,22 +124,32 @@ static struct dentry *__kernfs_fh_to_den
 		return NULL;
 	}
 
-	kn = kernfs_find_and_get_node_by_id(info->root, id);
-	if (!kn)
-		return ERR_PTR(-ESTALE);
+	/*
+	 * Hold kernfs_rwsem across the lookup as well as kernfs_get_inode().
+	 * __kernfs_remove() deactivates the subtree and clears i_nlink on its
+	 * inodes under the write lock, so under the read lock either
+	 * kernfs_find_and_get_node_by_id() refuses the node, or the inode is
+	 * in the inode hash before the ilookup() pass goes looking for it.
+	 */
+	scoped_guard(rwsem_read, &info->root->kernfs_rwsem) {
+		kn = kernfs_find_and_get_node_by_id(info->root, id);
+		if (!kn)
+			return ERR_PTR(-ESTALE);
+
+		if (get_parent) {
+			struct kernfs_node *parent;
 
-	if (get_parent) {
-		struct kernfs_node *parent;
+			parent = kernfs_get_parent(kn);
+			kernfs_put(kn);
+			kn = parent;
+			if (!kn)
+				return ERR_PTR(-ESTALE);
+		}
 
-		parent = kernfs_get_parent(kn);
+		inode = kernfs_get_inode(sb, kn);
 		kernfs_put(kn);
-		kn = parent;
-		if (!kn)
-			return ERR_PTR(-ESTALE);
 	}
 
-	inode = kernfs_get_inode(sb, kn);
-	kernfs_put(kn);
 	return d_obtain_alias(inode);
 }
 


