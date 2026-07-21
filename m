Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2690646AA9C;
	Tue, 21 Jul 2026 15:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649280; cv=none; b=CpXA3GtJ0SUD/nTN23IYhvsZTbG+vuGGP0yw4lHrEM9VcwmuZb8N62oN/Kvkb2FtcBwEGVfoJ/ui0vbra8TzBU6B6fw60J8MLx58OC4O9KqWUqEQyOjHbeLr2Pey3DamIu9BF46NHkQLw049oCTsKWJXXYfgs1Dx9SrMztnjJzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649280; c=relaxed/simple;
	bh=S+39oNYnPh6Uydpci+Wa+OiEEkSgZJDySKLpf/f/Hbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dG3netPqn60g+tHKHVMoDOz8bZh87Z32g199pFnbqv/x0k9aMVvASJu8JQJXPIvt+Lx/TTaEZTqMzluAcXDnQqa56Zy5n2tRIZ50wUX8EoaHrdzH34i+nrkwznaRsljbILhiR65yqdsI04FXSN2t3Wwp+Z0W3AyrQ2Hhl2pvwzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZkF6n+J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZkF6n+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C63E1F00A3A;
	Tue, 21 Jul 2026 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649279;
	bh=3fIjT+Mu2KCB3sJQbZUDSlbPyslNb2TK2GojFEyfiuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZkF6n+JJlwpIc4+3aJhB6Ca8aUcPqp6xEHqhNntU7zTttgIV8iAp5NH5AKPhc4ew
	 YkUe0P3euLnbLn2MrSpPOxWgEPB58mcfLm0t/lbRyzSmfOAnWOrhiyH6Mj4JS7CiPx
	 tCWUWe71401i6k1liehxHH8PuWW+KXHxuQpNovjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calum Mackay <calum.mackay@oracle.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0519/2077] kernfs: link kn to its parent before the LSM init hook
Date: Tue, 21 Jul 2026 17:03:12 +0200
Message-ID: <20260721152605.053872178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6cccc49b027c7551ffc1d2532f2ef1922661f3da ]

After commit 12e9e3cd03b5 ("simpe_xattr: use per-sb cache"),
kernfs_xattr_set() and kernfs_xattr_get() compute the cache via
kernfs_root(kn) before any other check.  kernfs_root(kn) walks
kn->__parent first and falls back to kn->dir.root, both of which are
NULL on a freshly kmem_cache_zalloc()'d kn. kn->__parent was being set
in kernfs_new_node() after __kernfs_new_node() returned, and kn->dir.root
is set even later by kernfs_create_dir_ns() / kernfs_create_empty_dir().

The LSM kernfs_init_security hook is invoked from inside
__kernfs_new_node(), before either field has been initialized.
selinux_kernfs_init_security() ends with kernfs_xattr_set(kn,
XATTR_NAME_SELINUX, ...).  kernfs_root(kn) then returns NULL, and
&((struct kernfs_root *)NULL)->xa_cache evaluates to
offsetof(struct kernfs_root, xa_cache) which faults:

  BUG: kernel NULL pointer dereference, address: 00000000000000e0
  RIP: 0010:simple_xattr_set+0x27/0x8b0
  Call Trace:
   kernfs_xattr_set+0x63/0xb0
   selinux_kernfs_init_security+0x13b/0x270
   security_kernfs_init_security+0x36/0xc0
   __kernfs_new_node+0x182/0x290
   kernfs_new_node+0x80/0xc0
   kernfs_create_dir_ns+0x2b/0xa0
   cgroup_create+0x116/0x380
   cgroup_mkdir+0x7c/0x1a0

Reproduces deterministically at PID 1 (systemd) on an SELinux-enabled
distro. The first cgroup mkdir under /sys/fs/cgroup with a labelled
parent panics the kernel.

The LSM hook's contract is that the kn_dir argument is the parent of
the new kn, so kn->__parent should already point at kn_dir when the
hook runs.  Move kernfs_get(parent) and rcu_assign_pointer of
kn->__parent from kernfs_new_node() into __kernfs_new_node() right
before the security hook, and unwind the parent reference on the
err_out4 path.  kernfs_root(kn) then takes its parent branch during
the hook and returns parent->dir.root, which is the correct root.

This also closes the same-shape latent bug in kernfs_xattr_get() (which
today is hidden only by kernfs_iattrs_noalloc() returning NULL on a
fresh kn).

Fixes: 12e9e3cd03b5 ("simpe_xattr: use per-sb cache")
Reported-by: Calum Mackay <calum.mackay@oracle.com>
Closes: https://lore.kernel.org/all/5386153f-9112-4971-98fc-de90d7aae2c6@oracle.com/
Link: https://patch.msgid.link/20260526-ablief-demut-wehen-aef8446ef5c9@brauner
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 78812cf1256b95..97d9d227b66d9d 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -701,6 +701,9 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	}
 
 	if (parent) {
+		kernfs_get(parent);
+		rcu_assign_pointer(kn->__parent, parent);
+
 		ret = security_kernfs_init_security(parent, kn);
 		if (ret)
 			goto err_out4;
@@ -709,6 +712,8 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	return kn;
 
  err_out4:
+	RCU_INIT_POINTER(kn->__parent, NULL);
+	kernfs_put(parent);
 	if (kn->iattr) {
 		simple_xattrs_free(&root->xa_cache, &kn->iattr->xattrs, NULL);
 		kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
@@ -745,10 +750,6 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 
 	kn = __kernfs_new_node(kernfs_root(parent), parent,
 			       name, mode, uid, gid, flags);
-	if (kn) {
-		kernfs_get(parent);
-		rcu_assign_pointer(kn->__parent, parent);
-	}
 	return kn;
 }
 
-- 
2.53.0



