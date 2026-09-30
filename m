Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012E351599B;
	Wed, 30 Sep 2026 16:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787589; cv=none; b=HV8AAzhpxbqNztkUvR+3BdiiNlsqfWsffJZu5G3mi82WptIjJ6AHuMoaA1VjoYmx2DOs2JdUC+dgpxKdhdg2V+UKEN57xehZPovX32yO5jv0QSJmPZPpJ5jbxNUUKYFii1l4rhGNgZCRcyi5nEzdU7dXXrO8mTC5SjtgQhB6GY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787589; c=relaxed/simple;
	bh=BAePkFoz/VCKxmI42+Mh7o4n9gs78E6z5VG3kj5OI7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHshLeH/ZDOkC+uZmRkI01O/CvnmTdGzQtz2LjM13AFf22kiR8S3KS4mpHNrJlf6ZYFqjerbOQULlF5X0fkv7yVn/juJO4CE2MeTtq/grOpinFY9soIOw52ACQLN5CL61zOMEy731/cCxdDBqcywT3vg3qZQGHh+2xUKfdelqfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTFlnfBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTFlnfBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365661F00898;
	Wed, 30 Sep 2026 16:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787587;
	bh=sKhzBtDLo5h0mUk3Xwp8jxCPdMeI+vmD8nqXOz6scRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTFlnfBPYojoKQ8NrMMQlfixZj3EfJNoFsW5gLKXBQN07O2Y0b+ortgLk1PJhpio5
	 8qWg4dzmFCO1sUdpGgEl+qxg6Rjbof2cRNrTAwWDqPWZFlA0/JjSBQ3ugjML1aKd/l
	 /+Oqid+jijO2yBvAShu+ps0ORfNYmUAoDklDqHLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 282/457] drm/amdkfd: fix use-after-free and multi-container gap in kfd_dev_mapping
Date: Wed, 30 Sep 2026 17:26:27 +0200
Message-ID: <20260930152352.122050612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

commit c3a31087b1c8df679b653c1a09d9abe5ff7ec8ef upstream.

kfd_dev_mapping caches the address_space of the first /dev/kfd opener
so that the GPU reset path can call unmap_mapping_range() to zap all
userspace mappings of doorbell and MMIO ranges.  This design has two
bugs that both manifest under SRIOV with multiple containers:

1. Use-after-free / rwsem deadlock.  The cached pointer refers to an
   inode owned by the first opener's container.  When that container
   exits and its inode is released, kfd_dev_mapping becomes a dangling
   pointer.  A subsequent GPU reset dereferences it inside
   unmap_mapping_range(), which takes i_mmap_rwsem on the freed inode,
   causing a hard hang observable as an uninterruptible rwsem wait.

2. Multi-container gap.  Only the first opener's address_space is cached;
   VMAs created by later openers live in a different address_space and
   are never reached by unmap_mapping_range().  After a GPU reset those
   stale mappings keep doorbell and MMIO pages accessible to guest
   userspace with no GPU behind them, risking PCIe transaction timeouts
   and NMI panics.

Fix both bugs with the same approach used by DRM core (drm_drv.c):
create a private pseudo-filesystem at module init time and allocate one
anonymous inode from it.  In kfd_open() redirect every opener's
file->f_mapping to that inode's address_space.  The inode is
module-owned, lives exactly as long as the amdgpu module, and collects
VMAs from all openers in one address_space.  A single
unmap_mapping_range() call in the reset path then correctly reaches
every container's mappings with no dangling pointer risk.

The hang manifests as an NMI backtrace on the GPU reset workqueue stuck
spinning in rwsem_down_read_slowpath() with a corrupted i_mmap_rwsem:

  Workqueue: amdgpu-reset-dev xgpu_ai_mailbox_flr_work [amdgpu]
  Call Trace:
   <TASK>
   kvm_wait+0x1f/0x40
   __pv_queued_spin_lock_slowpath+0x31d/0x3a0
   _raw_spin_lock_irq+0x51/0x80
   rwsem_down_read_slowpath+0xb3/0x550
   down_read+0x48/0xd0
   unmap_mapping_range+0x71/0x140
   kfd_dev_unmap_mapping_range+0x5b/0x140 [amdgpu]
   amdgpu_amdkfd_clear_kfd_mapping+0xd8/0x190 [amdgpu]
   amdgpu_device_gpu_recover+0x232/0x450 [amdgpu]
   xgpu_ai_mailbox_flr_work+0xb5/0xc0 [amdgpu]
   process_one_work+0x18e/0x3e0
   worker_thread+0x2e3/0x420
   kthread+0x10a/0x230

Fixes: 70cadefcc616 ("drm/amdgpu: unmap all user mappings of framebuffer and doorbell before mode1 reset")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1128b4a52de1572e87431de837fd9850cb99542c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 71 +++++++++++++++++++-----
 1 file changed, 57 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 504a286368eb..344da6c0e96a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -35,6 +35,7 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/pseudo_fs.h>
 #include <linux/ptrace.h>
 #include <linux/dma-buf.h>
 #include <linux/processor.h>
@@ -70,18 +71,54 @@ static const struct class kfd_class = {
 };
 
 /*
- * Cache the address space of the chardev on first open so that the reset
- * path can drop all userspace mappings of doorbell and MMIO ranges via
- * unmap_mapping_range().
+ * Private pseudo-filesystem for KFD, Provides a stable, module-owned
+ * inode whose address_space is the unmap target for all /dev/kfd
+ * openers during GPU reset.
  */
-static struct address_space *kfd_dev_mapping;
+static struct vfsmount *kfd_fs_mnt;
+static int kfd_fs_cnt;
+
+static int kfd_fs_init_fs_context(struct fs_context *fc)
+{
+	return init_pseudo(fc, 0x4b464400 /* "KFD" */) ? 0 : -ENOMEM;
+}
+
+static struct file_system_type kfd_fs_type = {
+	.name		= "kfd",
+	.init_fs_context = kfd_fs_init_fs_context,
+	.kill_sb	= kill_anon_super,
+};
+
+static struct inode *kfd_fs_inode_new(void)
+{
+	struct inode *inode;
+	int r;
+
+	r = simple_pin_fs(&kfd_fs_type, &kfd_fs_mnt, &kfd_fs_cnt);
+	if (r < 0)
+		return ERR_PTR(r);
+
+	inode = alloc_anon_inode(kfd_fs_mnt->mnt_sb);
+	if (IS_ERR(inode))
+		simple_release_fs(&kfd_fs_mnt, &kfd_fs_cnt);
+
+	return inode;
+}
+
+static void kfd_fs_inode_free(struct inode *inode)
+{
+	if (inode) {
+		iput(inode);
+		simple_release_fs(&kfd_fs_mnt, &kfd_fs_cnt);
+	}
+}
+
+static struct inode *kfd_anon_inode;
 
 void kfd_dev_unmap_mapping_range(loff_t const holebegin, loff_t const holelen)
 {
-	struct address_space *mapping = READ_ONCE(kfd_dev_mapping);
-
-	if (mapping)
-		unmap_mapping_range(mapping, holebegin, holelen, 1);
+	if (kfd_anon_inode)
+		unmap_mapping_range(kfd_anon_inode->i_mapping, holebegin, holelen, 1);
 }
 
 static inline struct kfd_process_device *kfd_lock_pdd_by_id(struct kfd_process *p, __u32 gpu_id)
@@ -107,6 +144,13 @@ int kfd_chardev_init(void)
 {
 	int err = 0;
 
+	kfd_anon_inode = kfd_fs_inode_new();
+	if (IS_ERR(kfd_anon_inode)) {
+		err = PTR_ERR(kfd_anon_inode);
+		kfd_anon_inode = NULL;
+		return err;
+	}
+
 	kfd_char_dev_major = register_chrdev(0, kfd_dev_name, &kfd_fops);
 	err = kfd_char_dev_major;
 	if (err < 0)
@@ -130,6 +174,8 @@ int kfd_chardev_init(void)
 err_class_create:
 	unregister_chrdev(kfd_char_dev_major, kfd_dev_name);
 err_register_chrdev:
+	kfd_fs_inode_free(kfd_anon_inode);
+	kfd_anon_inode = NULL;
 	return err;
 }
 
@@ -138,6 +184,8 @@ void kfd_chardev_exit(void)
 	device_destroy(&kfd_class, MKDEV(kfd_char_dev_major, 0));
 	class_unregister(&kfd_class);
 	unregister_chrdev(kfd_char_dev_major, kfd_dev_name);
+	kfd_fs_inode_free(kfd_anon_inode);
+	kfd_anon_inode = NULL;
 	kfd_device = NULL;
 }
 
@@ -150,12 +198,7 @@ static int kfd_open(struct inode *inode, struct file *filep)
 	if (iminor(inode) != 0)
 		return -ENODEV;
 
-	/*
-	 * /dev/kfd is a single chardev so all opens share one inode. Cache
-	 * its address_space on the first open for use by the reset path.
-	 */
-	if (!READ_ONCE(kfd_dev_mapping))
-		cmpxchg(&kfd_dev_mapping, NULL, inode->i_mapping);
+	filep->f_mapping = kfd_anon_inode->i_mapping;
 
 	is_32bit_user_mode = in_compat_syscall();
 
-- 
2.55.0



