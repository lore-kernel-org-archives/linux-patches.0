Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F8B328963;
	Wed, 17 Sep 2025 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113811; cv=none; b=p1FkRsHeCeSqAoNPvWTcFQz6FhSBOw4PmF9l6YC4du2B0ri1UaQp5dfZmM+TSJtpuafWz5iBL/NR23jr1Tm4hSY761ESiuNjTa5XHDVuSagVoTAr7Q1JfdjH7Edymgxd1Cr8t3fDXNS4jGwLDfCAQygyAKk28kC6RqGgkIRzDcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113811; c=relaxed/simple;
	bh=HLOGYJhXY+6hrlKiiOUCoyTNWP/u+riLGQQZIiQpeuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0WSV1hDDyuhzUKAbCguiC/FvbqvLrpNG+KyqKVpitnKT53iFoMakCEVOROMHPgy7zlUGqH+gLyhMFsrHnITbqLWyszkUl1l1TvnSuGR5mpCZ5nPQEFh0YAfA3kjA0pSx23gwOzlTMdsdfJfGaPRRbeVib2ASlj5HeljezhWoU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyfZaSQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyfZaSQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF5BC4CEF0;
	Wed, 17 Sep 2025 12:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113811;
	bh=HLOGYJhXY+6hrlKiiOUCoyTNWP/u+riLGQQZIiQpeuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyfZaSQPBWpqMvZ4ztEEzAYpdtjDAv/GjWQBljI2HaK//ihjWF+kegSm+uHz0oXyW
	 55lu2VFwgJy1ITTAA0/XWSLQojZ0tTNtNzaqt+teGsubuAmXDXksaQGpJfR6HXt0rV
	 0WAGka1uZa2BZYXZzaX9p48gkI4OdP0pRjbzNCKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zhang Zhaotian <zhangzhaotian@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/101] kernfs: Fix UAF in polling when open file is released
Date: Wed, 17 Sep 2025 14:34:41 +0200
Message-ID: <20250917123338.245690660@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

commit 3c9ba2777d6c86025e1ba4186dc5cd930e40ec5f upstream.

A use-after-free (UAF) vulnerability was identified in the PSI (Pressure
Stall Information) monitoring mechanism:

BUG: KASAN: slab-use-after-free in psi_trigger_poll+0x3c/0x140
Read of size 8 at addr ffff3de3d50bd308 by task systemd/1

psi_trigger_poll+0x3c/0x140
cgroup_pressure_poll+0x70/0xa0
cgroup_file_poll+0x8c/0x100
kernfs_fop_poll+0x11c/0x1c0
ep_item_poll.isra.0+0x188/0x2c0

Allocated by task 1:
cgroup_file_open+0x88/0x388
kernfs_fop_open+0x73c/0xaf0
do_dentry_open+0x5fc/0x1200
vfs_open+0xa0/0x3f0
do_open+0x7e8/0xd08
path_openat+0x2fc/0x6b0
do_filp_open+0x174/0x368

Freed by task 8462:
cgroup_file_release+0x130/0x1f8
kernfs_drain_open_files+0x17c/0x440
kernfs_drain+0x2dc/0x360
kernfs_show+0x1b8/0x288
cgroup_file_show+0x150/0x268
cgroup_pressure_write+0x1dc/0x340
cgroup_file_write+0x274/0x548

Reproduction Steps:
1. Open test/cpu.pressure and establish epoll monitoring
2. Disable monitoring: echo 0 > test/cgroup.pressure
3. Re-enable monitoring: echo 1 > test/cgroup.pressure

The race condition occurs because:
1. When cgroup.pressure is disabled (echo 0 > cgroup.pressure), it:
   - Releases PSI triggers via cgroup_file_release()
   - Frees of->priv through kernfs_drain_open_files()
2. While epoll still holds reference to the file and continues polling
3. Re-enabling (echo 1 > cgroup.pressure) accesses freed of->priv

epolling			disable/enable cgroup.pressure
fd=open(cpu.pressure)
while(1)
...
epoll_wait
kernfs_fop_poll
kernfs_get_active = true	echo 0 > cgroup.pressure
...				cgroup_file_show
				kernfs_show
				// inactive kn
				kernfs_drain_open_files
				cft->release(of);
				kfree(ctx);
				...
kernfs_get_active = false
				echo 1 > cgroup.pressure
				kernfs_show
				kernfs_activate_one(kn);
kernfs_fop_poll
kernfs_get_active = true
cgroup_file_poll
psi_trigger_poll
// UAF
...
end: close(fd)

To address this issue, introduce kernfs_get_active_of() for kernfs open
files to obtain active references. This function will fail if the open file
has been released. Replace kernfs_get_active() with kernfs_get_active_of()
to prevent further operations on released file descriptors.

Fixes: 34f26a15611a ("sched/psi: Per-cgroup PSI accounting disable/re-enable interface")
Cc: stable <stable@kernel.org>
Reported-by: Zhang Zhaotian <zhangzhaotian@huawei.com>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250822070715.1565236-2-chenridong@huaweicloud.com
[ Drop llseek bits ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/file.c |   54 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 18 deletions(-)

--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -70,6 +70,24 @@ static struct kernfs_open_node *of_on(st
 					 !list_empty(&of->list));
 }
 
+/* Get active reference to kernfs node for an open file */
+static struct kernfs_open_file *kernfs_get_active_of(struct kernfs_open_file *of)
+{
+	/* Skip if file was already released */
+	if (unlikely(of->released))
+		return NULL;
+
+	if (!kernfs_get_active(of->kn))
+		return NULL;
+
+	return of;
+}
+
+static void kernfs_put_active_of(struct kernfs_open_file *of)
+{
+	return kernfs_put_active(of->kn);
+}
+
 /**
  * kernfs_deref_open_node_locked - Get kernfs_open_node corresponding to @kn
  *
@@ -139,7 +157,7 @@ static void kernfs_seq_stop_active(struc
 
 	if (ops->seq_stop)
 		ops->seq_stop(sf, v);
-	kernfs_put_active(of->kn);
+	kernfs_put_active_of(of);
 }
 
 static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
@@ -152,7 +170,7 @@ static void *kernfs_seq_start(struct seq
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!kernfs_get_active(of->kn))
+	if (!kernfs_get_active_of(of))
 		return ERR_PTR(-ENODEV);
 
 	ops = kernfs_ops(of->kn);
@@ -238,7 +256,7 @@ static ssize_t kernfs_file_read_iter(str
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!kernfs_get_active(of->kn)) {
+	if (!kernfs_get_active_of(of)) {
 		len = -ENODEV;
 		mutex_unlock(&of->mutex);
 		goto out_free;
@@ -252,7 +270,7 @@ static ssize_t kernfs_file_read_iter(str
 	else
 		len = -EINVAL;
 
-	kernfs_put_active(of->kn);
+	kernfs_put_active_of(of);
 	mutex_unlock(&of->mutex);
 
 	if (len < 0)
@@ -323,7 +341,7 @@ static ssize_t kernfs_fop_write_iter(str
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!kernfs_get_active(of->kn)) {
+	if (!kernfs_get_active_of(of)) {
 		mutex_unlock(&of->mutex);
 		len = -ENODEV;
 		goto out_free;
@@ -335,7 +353,7 @@ static ssize_t kernfs_fop_write_iter(str
 	else
 		len = -EINVAL;
 
-	kernfs_put_active(of->kn);
+	kernfs_put_active_of(of);
 	mutex_unlock(&of->mutex);
 
 	if (len > 0)
@@ -357,13 +375,13 @@ static void kernfs_vma_open(struct vm_ar
 	if (!of->vm_ops)
 		return;
 
-	if (!kernfs_get_active(of->kn))
+	if (!kernfs_get_active_of(of))
 		return;
 
 	if (of->vm_ops->open)
 		of->vm_ops->open(vma);
 
-	kernfs_put_active(of->kn);
+	kernfs_put_active_of(of);
 }
 
 static vm_fault_t kernfs_vma_fault(struct vm_fault *vmf)
@@ -375,14 +393,14 @@ static vm_fault_t kernfs_vma_fault(struc
 	if (!of->vm_ops)
 		return VM_FAULT_SIGBUS;
 
-	if (!kernfs_get_active(of->kn))
+	if (!kernfs_get_active_of(of))
 		return VM_FAULT_SIGBUS;
 
 	ret = VM_FAULT_SIGBUS;
 	if (of->vm_ops->fault)
 		ret = of->vm_ops->fault(vmf);
 
-	kernfs_put_active(of->kn);
+	kernfs_put_active_of(of);
 	return ret;
 }
 
@@ -395,7 +413,7 @@ static vm_fault_t kernfs_vma_page_mkwrit
 	if (!of->vm_ops)
 		return VM_FAULT_SIGBUS;
 
-	if (!kernfs_get_active(of->kn))
+	if (!kernfs_get_active_of(of))
 		return VM_FAULT_SIGBUS;
 
 	ret = 0;
@@ -404,7 +422,7 @@ static vm_fault_t kernfs_vma_page_mkwrit
 	else
 		file_update_time(file);
 
-	kernfs_put_active(of->kn);
+	kernfs_put_active_of(of);
 	return ret;
 }
 
@@ -418,14 +436,14 @@ static int kernfs_vma_access(struct vm_a
 	if (!of->vm_ops)
 		return -EINVAL;
 
-	if (!kernfs_get_active(of->kn))
+	if (!kernfs_get_active_of(of))
 		return -EINVAL;
 
 	ret = -EINVAL;
 	if (of->vm_ops->access)
 		ret = of->vm_ops->access(vma, addr, buf, len, write);
 
-	kernfs_put_active(of->kn);
+	kernfs_put_active_of(of);
 	return ret;
 }
 
@@ -504,7 +522,7 @@ static int kernfs_fop_mmap(struct file *
 	mutex_lock(&of->mutex);
 
 	rc = -ENODEV;
-	if (!kernfs_get_active(of->kn))
+	if (!kernfs_get_active_of(of))
 		goto out_unlock;
 
 	ops = kernfs_ops(of->kn);
@@ -539,7 +557,7 @@ static int kernfs_fop_mmap(struct file *
 	}
 	vma->vm_ops = &kernfs_vm_ops;
 out_put:
-	kernfs_put_active(of->kn);
+	kernfs_put_active_of(of);
 out_unlock:
 	mutex_unlock(&of->mutex);
 
@@ -894,7 +912,7 @@ static __poll_t kernfs_fop_poll(struct f
 	struct kernfs_node *kn = kernfs_dentry_node(filp->f_path.dentry);
 	__poll_t ret;
 
-	if (!kernfs_get_active(kn))
+	if (!kernfs_get_active_of(of))
 		return DEFAULT_POLLMASK|EPOLLERR|EPOLLPRI;
 
 	if (kn->attr.ops->poll)
@@ -902,7 +920,7 @@ static __poll_t kernfs_fop_poll(struct f
 	else
 		ret = kernfs_generic_poll(of, wait);
 
-	kernfs_put_active(kn);
+	kernfs_put_active_of(of);
 	return ret;
 }
 


