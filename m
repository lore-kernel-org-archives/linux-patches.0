Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774506;
	b=2z8LYnS0xwwXDlClEuVof1aa36kNR4Gc/DrCp7hIA9Obea0rE0PqFldsalCztl4LA/4j
	 peahE5XHjvZ+4DHC2jlJmRIWKcV645XLE7kcXoUsKMXcoMGvmUe2B6vtBUafhPYVckDVn
	 fBSuGYnPhW/wX4n+dbN0u95JqGJVNdRlm7IZNvoDpsR+JV94DMRMyJqi7KcRvpSgep8Ep
	 Rpgu2oZ028YRg0kuefDOSqMCsG84W6O8hljM9qCezXlNrTiHNome+BO35cms7hh4zeR7j
	 Vzq5hZ5kkzansq8h8iYI80y/t+OAQpUOucJwC/9867t5lGknnx1F0wkOIJVdBkctKtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GTL8kt5hY/typkJ39SaVBGhySVNFok24PQIPwG4XUv4=;
	b=0OE4LjlMRA45jMswTHnmm1fpMBZdk20f6AfI8Td+nOTwLluSnX2e/CtVcO6TuL0h0DYb
	 KyIOBxvt+N3yRQq9WixSIH6cOvddRc3wkcznWNU03eixkYNEUuZ4sz3Z5VOkT2NxNInjn
	 eaQq/KD8IGO0MGNSMKd7VmcBjr/kla7n8i9uSRXWPtihmw2p+zJKCH9QTPxw8UpEVKkiF
	 e6WRBGpbC/iFObA3Ep+g2DnjPheyZj35vAh/WruRHGPNTlLrVVec7eCzV3CZjVVC5cvGx
	 cZc3yKDOhSBRRG8K4ED9MQgM85RQ3/LrohyeaAdS/bFdQTGfKeTs4tjrn14+iuIP+yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BWNltQI1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28D606A31A;
	Fri, 23 Oct 2026 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BWNltQI1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C161F01825;
	Fri, 23 Oct 2026 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774505;
	bh=GTL8kt5hY/typkJ39SaVBGhySVNFok24PQIPwG4XUv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWNltQI1v7lxYdUA/xKPe/toZthIJybCRP8392H5E0KopvjuGRqJuDVe994ljP0/5
	 /xINlFVvSOQ27/Qhu8GYVyIGY36r5Vv5f4WFzE8dah02cXpnQ+Rb/C2OEcl1xTxtMm
	 Y0ch8CkcTjKir4QytjXB8v6c0Zr5KoBV+TwJVscI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 064/242] fs: make userspace_init_fs a dynamically-initialized pointer
Date: Fri, 23 Oct 2026 18:38:26 +0200
Message-ID: <20261023163715.298417612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 9a8e296958884b807a02759975170b6559901242 ]

Change userspace_init_fs from a declared-but-unused extern struct to
a dynamically initialized pointer. Add init_userspace_fs() which is
called early in kernel_init() (PID 1) to record PID 1's fs_struct
as the canonical userspace filesystem state.

Wire up __override_init_fs() and __revert_init_fs() to actually swap
current->fs to/from userspace_init_fs. Previously these were no-ops
that stored current->fs back to itself.

Fix nullfs_userspace_init() to compare against userspace_init_fs
instead of &init_fs. When PID 1 unshares its filesystem state, revert
userspace_init_fs to init_fs's root (nullfs) so that stale filesystem
state is not silently inherited by kworkers and usermodehelpers.

At this stage PID 1's fs still points to rootfs (set by
init_mount_tree), so userspace_init_fs points to rootfs and
scoped_with_init_fs() is functionally equivalent to its previous no-op
behavior.

Link: https://patch.msgid.link/20260601-work-kthread-nullfs-v4-5-77ee053060e0@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: d2bdb9b61b42 ("fs: let idle threads share init_fs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_struct.c            | 48 ++++++++++++++++++++++++++++++++++++++-
 include/linux/fs_struct.h | 15 ++++++------
 include/linux/init_task.h |  1 +
 init/main.c               |  3 +++
 4 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index c03a574ed65aa..f44e43ce6d934 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -8,6 +8,7 @@
 #include <linux/fs_struct.h>
 #include <linux/init_task.h>
 #include "internal.h"
+#include "mount.h"
 
 /*
  * Replace the fs->{rootmnt,root} with {mnt,dentry}. Put the old values.
@@ -163,15 +164,34 @@ EXPORT_SYMBOL_GPL(unshare_fs_struct);
  * fs_struct state. Breaking that contract sucks for both sides.
  * So just don't bother with extra work for this. No sane init
  * system should ever do this.
+ *
+ * On older kernels if PID 1 unshared its filesystem state with us the
+ * kernel simply used the stale fs_struct state implicitly pinning
+ * anything that PID 1 had last used. Even if PID 1 might've moved on to
+ * some completely different fs_struct state and might've even unmounted
+ * the old root.
+ *
+ * This has hilarious consequences: Think continuing to dump coredump
+ * state into an implicitly pinned directory somewhere. Calling random
+ * binaries in the old rootfs via usermodehelpers.
+ *
+ * Be aggressive about this: We simply reject operating on stale
+ * fs_struct state by reverting to nullfs. Every kworker that does
+ * lookups after this point will fail. Every usermodehelper call will
+ * fail. Tough luck but let's be kind and emit a warning to userspace.
  */
 static inline void validate_fs_switch(struct fs_struct *old_fs)
 {
+	might_sleep();
+
 	if (likely(current->pid != 1))
 		return;
 	/* @old_fs may be dangling but for comparison it's fine */
-	if (old_fs != &init_fs)
+	if (old_fs != userspace_init_fs)
 		return;
 	pr_warn("VFS: Pid 1 stopped sharing filesystem state\n");
+	set_fs_root(userspace_init_fs, &init_fs.root);
+	set_fs_pwd(userspace_init_fs, &init_fs.root);
 }
 
 struct fs_struct *switch_fs_struct(struct fs_struct *new_fs)
@@ -201,3 +221,29 @@ struct fs_struct init_fs = {
 	.seq		= __SEQLOCK_UNLOCKED(init_fs.seq),
 	.umask		= 0022,
 };
+
+struct fs_struct *userspace_init_fs __ro_after_init;
+EXPORT_SYMBOL_GPL(userspace_init_fs);
+
+void __init init_userspace_fs(void)
+{
+	struct mount *m;
+	struct path root;
+
+	/* Move PID 1 from nullfs into the initramfs. */
+	m = topmost_overmount(current->nsproxy->mnt_ns->root);
+	root.mnt = &m->mnt;
+	root.dentry = root.mnt->mnt_root;
+
+	VFS_WARN_ON_ONCE(current->pid != 1);
+
+	set_fs_root(current->fs, &root);
+	set_fs_pwd(current->fs, &root);
+
+	/* Hold a reference for the global pointer. */
+	read_seqlock_excl(&current->fs->seq);
+	current->fs->users++;
+	read_sequnlock_excl(&current->fs->seq);
+
+	userspace_init_fs = current->fs;
+}
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index e11d0e57168fd..97eef8d3863dd 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -17,6 +17,7 @@ struct fs_struct {
 } __randomize_layout;
 
 extern struct kmem_cache *fs_cachep;
+extern struct fs_struct *userspace_init_fs;
 
 extern void exit_fs(struct task_struct *);
 extern void set_fs_root(struct fs_struct *, const struct path *);
@@ -57,17 +58,17 @@ static inline int current_umask(void)
  */
 static inline struct fs_struct *__override_init_fs(void)
 {
-	struct fs_struct *fs;
+	struct fs_struct *old_fs;
 
-	fs = current->fs;
-	WRITE_ONCE(current->fs, fs);
-	return fs;
+	old_fs = current->fs;
+	WRITE_ONCE(current->fs, userspace_init_fs);
+	return old_fs;
 }
 
-static inline void __revert_init_fs(struct fs_struct *revert_fs)
+static inline void __revert_init_fs(struct fs_struct *old_fs)
 {
-	VFS_WARN_ON_ONCE(current->fs != revert_fs);
-	WRITE_ONCE(current->fs, revert_fs);
+	VFS_WARN_ON_ONCE(current->fs != userspace_init_fs);
+	WRITE_ONCE(current->fs, old_fs);
 }
 
 DEFINE_CLASS(__override_init_fs,
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index a6cb241ea00c3..61536be773f59 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -24,6 +24,7 @@
 
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
+extern struct fs_struct *userspace_init_fs;
 extern struct nsproxy init_nsproxy;
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
diff --git a/init/main.c b/init/main.c
index dd7b2a6599fca..367faf4bfc65f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -103,6 +103,7 @@
 #include <linux/stackdepot.h>
 #include <linux/randomize_kstack.h>
 #include <linux/pidfs.h>
+#include <linux/fs_struct.h>
 #include <linux/ptdump.h>
 #include <linux/time_namespace.h>
 #include <linux/unaligned.h>
@@ -1545,6 +1546,8 @@ static int __ref kernel_init(void *unused)
 {
 	int ret;
 
+	init_userspace_fs();
+
 	/*
 	 * Wait until kthreadd is all set-up.
 	 */
-- 
2.53.0



