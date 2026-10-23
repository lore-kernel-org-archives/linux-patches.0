Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774668;
	b=2XyWsvNqK7fl3KTWpVP4dTD+p01mHHrYa9clVd99WGKXvJDi1fmCVXltUUQ27f4RJ3TU
	 wKsKugh+gJsew0AjrLfn7t1ralieknqaVIN+18zqKJL2iOXBa0cEKH3Ty5jgEpKKos47r
	 MVQF5HSCM+IExunGWqHbxAVmNML3gQu4LEa08ktqf1lSu6Rn3D1LL4zy2GLkZEINWBAAv
	 8lOsj5KNnsG6UPvvcgf1sUU4VLeo5b2vNSy69vfBeMCKSsqYBepfn27jH1LOlICawS2lm
	 GplmYMvsH5qUW1uSp/bwje07O52QmLOLSyQbbVFhNoNYo2zSR+nadP8gInMhF/O2hvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A0ZY5Lpqig3khWNP9Shz75LZ3KxWMjQmhlYJ1qHPLtk=;
	b=Yr2IauF2xRLWna2Q8X1wlh32xwY+xAm/Easlw+mD7ZWd+npkbZ2IpTnFAPbHIaW/75FQ
	 7R8WwgEul5srCa9KjUyrngURSmaq2IRfRWt/Tn28JyWjlxt42TyeHhVuqdsO8extazMCv
	 SkydLwfqumWxnRkjEIKNVKw6SeR+0mkWsHNtJe7SNEoCddMHY8dycscA8UkYpeq6EgudO
	 BDQk1w71vm9XNRO3aQmkVrCEeEGJW4eaxz2kvWExSWDgipmWXzXjzU0dQXZr45w6sp/kD
	 DzycJ6P/mF0m/8Zu2g7bkPLfqW43bwPwrqIMZWBzG6mbX00vQADErO2TzZ6RJx6Fh9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsPzol3b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072DF606A31A;
	Fri, 23 Oct 2026 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsPzol3b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B501F01825;
	Fri, 23 Oct 2026 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774667;
	bh=A0ZY5Lpqig3khWNP9Shz75LZ3KxWMjQmhlYJ1qHPLtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsPzol3bPj8OPb11CW6vrgq6c4JnyMIgLhZjmbri9JfzWs6hQxy5bz8z1aMBs/GO6
	 XV8C+WDayxyTsT/suMVIR3C4o/UpWEfPf7/9Cup8f3dDCS8RLodYybQqzOur1DIyAl
	 YzqFJMgu3NYTi6ZmwtqC7k8iNCKZyW2cXbGsuUKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 117/242] ntfs3: free the sbi after a grace period
Date: Fri, 23 Oct 2026 18:39:19 +0200
Message-ID: <20261023163716.546499305@linuxfoundation.org>
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

commit c01b091b06412d3b1b53d8c2925f6de586c8a2fc upstream.

If the "nocase" mount option ntfs3 uses custom hash and dentry compare
functions. Both access ntfs3 superblock private information in rcu
pathwalk. ntfs_put_super() and ntfs3_kill_sb() drop the info without any
rcu delay. A lookup that's still inside the filesystem when the last
reference to the mount is dropped causes a UAF. With a pathwalk held up
in ntfs_d_hash() while the last reference to the mount goes away:

  BUG: KASAN: slab-use-after-free in ntfs_nls_to_utf16+0x752/0x940
  Read of size 8 at addr ff1100010453c850 by task walker/99
  Call Trace:
   <TASK>
   ntfs_nls_to_utf16+0x752/0x940
   ntfs_d_hash+0x22b/0x500
   link_path_walk+0x11ad/0x1d30
   path_lookupat+0x63/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
  [...]
  Allocated by task 95:
   __kmalloc_cache_noprof+0x249/0x560
   ntfs_init_fs_context+0x2db/0x5a0
   alloc_fs_context+0x52e/0xc70
  [...]
  Freed by task 98:
   kfree+0x1db/0x5b0
   deactivate_locked_super+0x9c/0xf0
   cleanup_mnt+0x9f/0x130
   task_work_run+0x131/0x250

The bug is currently masked by the grace period in namespace_unlock()
for umount(2). Keep the necessary information until the filesystem
private info is freed and free it with an rcu delay.

ntfs3_free_sbi() now runs from an rcu callback and drops the upcase
table via ntfs_put_shared(). So switch s_shared_lock over to
spin_lock_bh(). Otherwise the callback can deadlock against a task
holding the lock on the same cpu.

Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-7-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/ntfs_fs.h |    1 +
 fs/ntfs3/super.c   |   33 +++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)

--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -210,6 +210,7 @@ struct ntfs_index {
 /* Ntfs file system in-core superblock data. */
 struct ntfs_sb_info {
 	struct super_block *sb;
+	struct rcu_head rcu;
 
 	u32 discard_granularity;
 	u64 discard_granularity_mask_inv; // ~(discard_granularity_mask_inv-1)
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -195,7 +195,7 @@ void *ntfs_set_shared(void *ptr, u32 byt
 	void *ret = NULL;
 	int i, j = -1;
 
-	spin_lock(&s_shared_lock);
+	spin_lock_bh(&s_shared_lock);
 	for (i = 0; i < ARRAY_SIZE(s_shared); i++) {
 		if (!s_shared[i].cnt) {
 			j = i;
@@ -213,7 +213,7 @@ void *ntfs_set_shared(void *ptr, u32 byt
 		s_shared[j].cnt = 1;
 		ret = ptr;
 	}
-	spin_unlock(&s_shared_lock);
+	spin_unlock_bh(&s_shared_lock);
 
 	return ret;
 }
@@ -230,7 +230,7 @@ void *ntfs_put_shared(void *ptr)
 	void *ret = ptr;
 	int i;
 
-	spin_lock(&s_shared_lock);
+	spin_lock_bh(&s_shared_lock);
 	for (i = 0; i < ARRAY_SIZE(s_shared); i++) {
 		if (s_shared[i].cnt && s_shared[i].ptr == ptr) {
 			if (--s_shared[i].cnt)
@@ -238,7 +238,7 @@ void *ntfs_put_shared(void *ptr)
 			break;
 		}
 	}
-	spin_unlock(&s_shared_lock);
+	spin_unlock_bh(&s_shared_lock);
 
 	return ret;
 }
@@ -697,6 +697,8 @@ static noinline void ntfs3_put_sbi(struc
 
 static void ntfs3_free_sbi(struct ntfs_sb_info *sbi)
 {
+	if (sbi->options)
+		put_mount_options(sbi->options);
 	kfree(sbi->new_rec);
 	kvfree(ntfs_put_shared(sbi->upcase));
 	kvfree(sbi->def_table);
@@ -708,6 +710,11 @@ static void ntfs3_free_sbi(struct ntfs_s
 	kfree(sbi);
 }
 
+static void ntfs3_free_sbi_rcu(struct rcu_head *head)
+{
+	ntfs3_free_sbi(container_of(head, struct ntfs_sb_info, rcu));
+}
+
 static void ntfs_put_super(struct super_block *sb)
 {
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
@@ -717,11 +724,11 @@ static void ntfs_put_super(struct super_
 	/* Mark rw ntfs as clear, if possible. */
 	ntfs_set_state(sbi, NTFS_DIRTY_CLEAR);
 
-	if (sbi->options) {
-		put_mount_options(sbi->options);
-		sbi->options = NULL;
-	}
-
+	/*
+	 * The mount options stay until the sbi is freed: ->d_hash() and
+	 * ->d_compare() of a pathwalk in rcu mode read the nls table through
+	 * them.
+	 */
 	ntfs3_put_sbi(sbi);
 }
 
@@ -1923,9 +1930,11 @@ static void ntfs3_kill_sb(struct super_b
 
 	kill_block_super(sb);
 
-	if (sbi->options)
-		put_mount_options(sbi->options);
-	ntfs3_free_sbi(sbi);
+	/*
+	 * A pathwalk in rcu mode may still be in ->d_hash() or ->d_compare()
+	 * and read the upcase table and the nls table through the sbi.
+	 */
+	call_rcu(&sbi->rcu, ntfs3_free_sbi_rcu);
 }
 
 // clang-format off


