Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023491;
	b=Gk4vrIUligq+1QkCD5A8/YJeAr/LF9kxssU5EedjGqwMircQTyd4f3OEnXQtNpJgxl6/
	 LaMY4GgkmFPMCrJcBdjcbwrvY5JnAeq3HYpl9U2exKLfkspDuKS9FLPsIxTC2Fmx1TbDH
	 LLAMZQ5gsf7mkMFy0j2IaeKbwSs+9GCWXm0zJIn3qrNkxouV7/9kczyNIWoBZPqZy8Zih
	 sbnSltBzC/tloowPeWpOWj9kBc1cfoStFkQ61600swlZ49PfT8973dT2jBczhNL9yWXMj
	 HlrCr4pNnpkSEa2qvlzNR3ihxrvh2zq0n0d4u9B2Ky7guMTNAUfXJeAUFPqYMevtE3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=35USMPlWvbrws+0ql5BT0pYjp4oVGQq0P8ztUNf/4gA=;
	b=SjAHZKfyXEev5uc231+nmDmXpaZfxOZ+n8fILRCTM3GSG6Af0uNgSUpmrjHYlnJcwC3Q
	 657/nd9OM6eXLwECy6As5u238ROmJlHhXMyuS3cZj+6GOVOuGfT/bi3ZMHqPhRi6JMCGF
	 6AEWUR+AeuK/+4LzjflGrEh3qusW+1Tb/V6mABofhT/p+gk0hKMQT9oYba/P/oBh6oMV6
	 4MQ/943bopQlj2Ql4e4O6NyM/MrvtC1KxRpBpZGvJUb74hUcpnEc5O0cP3sA8rv2hutnW
	 PL+joq8ZxubkdZK4zvPpJl7Pq9XvRB8ib15+GFss3I1abUW1CSt0jvrN22mPOJi41dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="umZvU/50";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0281606A31C;
	Wed, 18 Nov 2026 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umZvU/50
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FF41F000C4;
	Wed, 18 Nov 2026 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023490;
	bh=35USMPlWvbrws+0ql5BT0pYjp4oVGQq0P8ztUNf/4gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umZvU/507pp2HzkT+SZjKPCYGG6+fmfWSPCTk4zYhPJBHU0ueI3Y6DHe+xaxozzlW
	 dmhuEbC9zKHSOhj3ryE6SgUtPJUjUeg7+4yQXjYH6JWwiqpSq6OkR7NdyJ2jptUBE8
	 4DavlWaYW4H/JlrnQipJdGE0VgXDbwv+vLdaqrnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0347/2151] kernfs: fix up the unlocked attribute reads on the creation paths
Date: Wed, 18 Nov 2026 15:34:42 +0100
Message-ID: <20261118150134.745446997@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit 81bdc85b4c086502f4446a58eb5d25f29bb5e9f7 ]

Two creation paths read a live node's attributes without holding
kernfs_iattr_rwsem, which kernfs_iop_setattr() takes for writing.  They
need different fixes.

kernfs_create_link() copies the target's ia_uid and then its ia_gid into
the new link.  A chown of the target between the two reads leaves the
link with the old uid and the new gid, an owner the target never had.
Read both under the rwsem.

kernfs_new_node() reads the parent's mode and ia_gid for S_ISGID
inheritance.  Either value is fine there: the node does not exist yet,
so nothing orders a racing chmod or chown against the creation.  Taking
the rwsem would only pick between two answers that are both right.  Mark
the reads with READ_ONCE() instead.

The pointer that leads to them is already fine: __kernfs_iattrs()
publishes kernfs_node::iattr with try_cmpxchg(), and both sides read it
with READ_ONCE(), like the rest of fs/kernfs.

The Fixes tag is for the symlink half.  kernfs_create_link() has read
the pair unlocked since it started copying the target's owner; only the
name of the lock its writer takes has changed.  The READ_ONCE() markings
are not a fix.

Fixes: 488dee96bb62 ("kernfs: allow creating kernfs objects with arbitrary uid/gid")
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20260905191613.3143937-5-shakeel.butt@linux.dev
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c     | 12 +++++++++---
 fs/kernfs/symlink.c | 17 ++++++++++++++---
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 360cfbd8dd36e..8cdb44ac68db0 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -701,13 +701,19 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 {
 	struct kernfs_node *kn;
 
-	if (parent->mode & S_ISGID) {
+	/*
+	 * The mode and the gid below are read unlocked on purpose: they feed
+	 * a node that does not exist yet, so nothing orders a racing chmod or
+	 * chown against this creation.
+	 */
+	if (READ_ONCE(parent->mode) & S_ISGID) {
 		/* this code block imitates inode_init_owner() for
 		 * kernfs
 		 */
+		struct kernfs_iattrs *attrs = READ_ONCE(parent->iattr);
 
-		if (parent->iattr)
-			gid = parent->iattr->ia_gid;
+		if (attrs)
+			gid = READ_ONCE(attrs->ia_gid);
 
 		if (flags & KERNFS_DIR)
 			mode |= S_ISGID;
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 0bd8a2143723d..727d77ff742f0 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -31,9 +31,20 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 	kuid_t uid = GLOBAL_ROOT_UID;
 	kgid_t gid = GLOBAL_ROOT_GID;
 
-	if (target->iattr) {
-		uid = target->iattr->ia_uid;
-		gid = target->iattr->ia_gid;
+	/*
+	 * A symlink takes its owner from its target, so both fields have to
+	 * come from the same moment: read them under kernfs_iattr_rwsem, or
+	 * a chown of the target racing this could leave the link with the
+	 * old uid and the new gid.  The section ends before kernfs_add_one()
+	 * takes kernfs_rwsem.
+	 */
+	scoped_guard(rwsem_read, &kernfs_root(target)->kernfs_iattr_rwsem) {
+		struct kernfs_iattrs *attrs = READ_ONCE(target->iattr);
+
+		if (attrs) {
+			uid = attrs->ia_uid;
+			gid = attrs->ia_gid;
+		}
 	}
 
 	kn = kernfs_new_node(parent, name, S_IFLNK|0777, uid, gid, KERNFS_LINK);
-- 
2.53.0



