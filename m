Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619869;
	b=uMRQLVQnMart0gmuneH7Am6Cw3WkGZ9qdinj1VXft0XI8HwUpFLk2zSewUx25Ls4wZPI
	 nzRLrU+URMqM0GRJz6OvUtjZ5FwKZAFv13cD/F7Y+21CYBUXRVnC/mUyNtO02Ne88SFQ/
	 6+/5rTWxXmDUzLwMy/tzvQVqNGArcL4TSJvfLWn4Y2BhSzuuICFDv2z17yL/tzjy9APbi
	 A63yDcXqVN+RoUvP/y5FvG9t+TYC9m3+8Cj1DsaE7OxBk3JwWdQgQaVn4mJDAMDPrlSdP
	 na4yU6tmIxphbDDS+hA2uzKIaLVut78H3sHrW3nsOERSw3hwfv3GUqsQ2u1NopcWFUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6uGornIN+RJs4EOhWoaWx7wjpVFajibmTH7idb2IU9w=;
	b=BVaIOcnzmnIMYaI5IZUAL6w4A5NL38l3VGr8pY7joo1kiq4Ha6Enx3Xa8EVYCMd2gKsB
	 /92GPKaY6LA1UNRJu2CK7jLYguJFZuvWQR4clGuwyTJPL4f8Qb8OnRJvjesWXc68qXMdm
	 pzek81pTS/2v9korM+0cajyEueTuIwr3n2DyMQ5jv9QCsV2OGNiiraM4ZwOCSOOz/E4C5
	 KdvgCcPww+FyV5FeF10LPAYi69rxf72ZLgKbBxaNRZwxygk6vd1ctFj+simdJpeazwsnz
	 AXvaYXcUI0RFBl2dM/PmHZgDQ84cv1Xh6Q4cXHY/0rC+r07CyCfHgxtUy8vsFDNG8Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozV8obit;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B08C606A323;
	Wed, 25 Nov 2026 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozV8obit
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0339B1F000CA;
	Wed, 25 Nov 2026 15:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619868;
	bh=6uGornIN+RJs4EOhWoaWx7wjpVFajibmTH7idb2IU9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozV8obitEQ6zIs6X104W1lrxiSNRfX/taOUaMtHcaU45iL1v8KxZHlGpUXVcUTNn9
	 IdLinqWF1AQ15+0wgy3OQRwkNS82H8IN+dkJyadAgaI0esaLv9a29PnarbNPCI76Bz
	 QJgBjDpHCmInt1g/R3FuuYxR6cGZIUQwDrp/LQCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0696/1005] dcache: let umount find a disconnected ex-mountpoint
Date: Wed, 25 Nov 2026 15:33:54 +0100
Message-ID: <20261125143838.058390747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 32e564e222b7ca3811b2acee404b73fcaf43f312 upstream.

When a mount goes away the reference to its mountpoint is dropped with
dput_to_list() and namespace_unlock() evicts the dentry after dropping
namespace_sem. Nothing pins the filesystem at that point so it can be
unmounted at the same time. That's fine as long as
shrink_dcache_for_umount() finds the dentry. It then either evicts it
itself or waits for the eviction to finish.

But it can't find a disconnected root as those are neither in the tree
nor on ->s_roots. And they can be mounted on:

  fd = open_by_handle_at(mnt_fd, handle of a file with no dentry, O_PATH);
  tree = open_tree(AT_FDCWD, "/tmp/x", OPEN_TREE_CLONE);
  move_mount(tree, "", fd, "", MOVE_MOUNT_F_EMPTY_PATH |
			       MOVE_MOUNT_T_EMPTY_PATH);
  close(fd);

  thread A                              thread B
  umount2("/proc/self/fd/<tree>", MNT_DETACH)
    namespace_unlock()
      up_write(&namespace_sem)
                                        umount of the filesystem
                                          shrink_dcache_for_umount()
                                          evict_inodes()
                                          "Busy inodes after unmount"
      shrink_dentry_list()
        dentry_kill()
          iput() of an inode of a superblock that is gone

So put such a dentry on ->s_roots when it's put on the shrink list. From
then on it's a secondary root like any other.

This needs the previous patch. Otherwise do_one_tree() takes the dentry
off ->s_roots and umount doesn't wait for an eviction in progress.

The stable tag is narrower than the Fixes tag on purpose. Before commit
e9895609cb7f ("wind ->s_roots via ->d_sib instead of ->d_hash") umount
doesn't wait for a secondary root that is being evicted either.

Fixes: 4edbe133f851 ("make struct mountpoint bear the dentry reference to mountpoint, not struct mount")
Cc: stable@vger.kernel.org # v7.2+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261030-work-dcache-ai-v1-3-cd6b86e0ccc7@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c                    |   16 ++++++++++++++--
 include/linux/fs/super_types.h |    2 +-
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -45,7 +45,8 @@
  * dcache_hash_bucket lock protects:
  *   - the dcache hash table
  * s_roots_lock protects:
- *   - the s_roots list (see __d_move()/dentry_unlist()/d_obtain_root())
+ *   - the s_roots list (see __d_move()/dentry_unlist()/d_obtain_root()/
+ *     dput_to_list())
  * dentry->d_sb->s_dentry_lru_lock protects:
  *   - the dcache lru lists and counters
  * d_lock protects:
@@ -1101,7 +1102,18 @@ void dput_to_list(struct dentry *dentry,
 {
 	if (likely(fast_dput(dentry)))
 		return;
-	__move_to_shrink_list(dentry, list);
+	/*
+	 * The list owner need not pin the superblock, so make a disconnected
+	 * root a secondary one for shrink_dcache_for_umount() to find.
+	 */
+	if (__move_to_shrink_list(dentry, list) &&
+	    unlikely(IS_ROOT(dentry) && hlist_unhashed(&dentry->d_sib))) {
+		struct super_block *sb = dentry->d_sb;
+
+		spin_lock(&sb->s_roots_lock);
+		hlist_add_head(&dentry->d_sib, &sb->s_roots);
+		spin_unlock(&sb->s_roots_lock);
+	}
 	spin_unlock(&dentry->d_lock);
 }
 
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -173,7 +173,7 @@ struct super_block {
 	struct unicode_map			*s_encoding;
 	__u16					s_encoding_flags;
 #endif
-	struct hlist_head			s_roots;	/* alternate root dentries for NFS */
+	struct hlist_head			s_roots;	/* alternate root dentries for NFS and ex-mountpoints */
 	spinlock_t				s_roots_lock;
 	struct mount				*s_mounts;	/* list of mounts; _not_ for fs use */
 	struct block_device			*s_bdev;	/* can go away once we use an accessor for @s_bdev_file */


