Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43013E3C5C;
	Tue, 31 Mar 2026 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974323; cv=none; b=lf+sfkanu2xnahqb6XSQwh6CkAGaHcryUsaeflv2idTbZqK10wayUv85F1uAsviM262B5xDtTN+05EDhJJ72yn31fAGV+tHpgXqOJ8L3YolbSyTjoY5vI1ZKGD4w5jAVmf1HGFdEZrwm4wF1HP8KM+iZkaBCwgjUl7f3uc9T2NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974323; c=relaxed/simple;
	bh=kGCUZHf4I3tGaQoYvXysJ6sr+TpH1a46vn1Ye4dNTnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMmjVr9UBbmuQdhoy8SfcWWRB4+EzEyzTfT0tDqnDB/RMdYZEvwJca72LfwSfTOF7QP4zbe4BsapGWM96C4bSQYZYj/U/W/XOIm+9T03eC5dz3WTf8IX0Z7ulXsOZ0CwzOb35TgNjf6s4R+iFsKMtwCJavHAFSfzNE3Q2ZXrv50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3vOQNXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3vOQNXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3650DC19423;
	Tue, 31 Mar 2026 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974322;
	bh=kGCUZHf4I3tGaQoYvXysJ6sr+TpH1a46vn1Ye4dNTnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3vOQNXDbIIwL4clFqcW+pGqUa0n4nDAGenbmj6XY+2n5Hw+3O9bQoXtDvW/7E3ra
	 EJ3XrurqxQ/fduAvLnMWYMD1gj8UV7uB6uCaB6jgouVfh+/EoE8vhvDyRWeGbNgUqq
	 TE3HtbBtBZuhC9FHNS3bPSnJtdyG2rF8u4Nz67aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Gregory Bell <grbell@redhat.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/175] bpf: Release module BTF IDR before module unload
Date: Tue, 31 Mar 2026 18:19:52 +0200
Message-ID: <20260331161730.089623166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 146bd2a87a65aa407bb17fac70d8d583d19aba06 ]

Gregory reported in [0] that the global_map_resize test when run in
repeatedly ends up failing during program load. This stems from the fact
that BTF reference has not dropped to zero after the previous run's
module is unloaded, and the older module's BTF is still discoverable and
visible. Later, in libbpf, load_module_btfs() will find the ID for this
stale BTF, open its fd, and then it will be used during program load
where later steps taking module reference using btf_try_get_module()
fail since the underlying module for the BTF is gone.

Logically, once a module is unloaded, it's associated BTF artifacts
should become hidden. The BTF object inside the kernel may still remain
alive as long its reference counts are alive, but it should no longer be
discoverable.

To fix this, let us call btf_free_id() from the MODULE_STATE_GOING case
for the module unload to free the BTF associated IDR entry, and disable
its discovery once module unload returns to user space. If a race
happens during unload, the outcome is non-deterministic anyway. However,
user space should be able to rely on the guarantee that once it has
synchronously established a successful module unload, no more stale
artifacts associated with this module can be obtained subsequently.

Note that we must be careful to not invoke btf_free_id() in btf_put()
when btf_is_module() is true now. There could be a window where the
module unload drops a non-terminal reference, frees the IDR, but the
same ID gets reused and the second unconditional btf_free_id() ends up
releasing an unrelated entry.

To avoid a special case for btf_is_module() case, set btf->id to zero to
make btf_free_id() idempotent, such that we can unconditionally invoke it
from btf_put(), and also from the MODULE_STATE_GOING case. Since zero is
an invalid IDR, the idr_remove() should be a noop.

Note that we can be sure that by the time we reach final btf_put() for
btf_is_module() case, the btf_free_id() is already done, since the
module itself holds the BTF reference, and it will call this function
for the BTF before dropping its own reference.

  [0]: https://lore.kernel.org/bpf/cover.1773170190.git.grbell@redhat.com

Fixes: 36e68442d1af ("bpf: Load and verify kernel module BTFs")
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Suggested-by: Martin KaFai Lau <martin.lau@kernel.org>
Reported-by: Gregory Bell <grbell@redhat.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260312205307.1346991-1-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 14361b3b9edd0..1ace7faa59cfd 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1636,7 +1636,16 @@ static void btf_free_id(struct btf *btf)
 	 * of the _bh() version.
 	 */
 	spin_lock_irqsave(&btf_idr_lock, flags);
-	idr_remove(&btf_idr, btf->id);
+	if (btf->id) {
+		idr_remove(&btf_idr, btf->id);
+		/*
+		 * Clear the id here to make this function idempotent, since it will get
+		 * called a couple of times for module BTFs: on module unload, and then
+		 * the final btf_put(). btf_alloc_id() starts IDs with 1, so we can use
+		 * 0 as sentinel value.
+		 */
+		WRITE_ONCE(btf->id, 0);
+	}
 	spin_unlock_irqrestore(&btf_idr_lock, flags);
 }
 
@@ -7158,7 +7167,7 @@ static void bpf_btf_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct btf *btf = filp->private_data;
 
-	seq_printf(m, "btf_id:\t%u\n", btf->id);
+	seq_printf(m, "btf_id:\t%u\n", READ_ONCE(btf->id));
 }
 #endif
 
@@ -7250,7 +7259,7 @@ int btf_get_info_by_fd(const struct btf *btf,
 	if (copy_from_user(&info, uinfo, info_copy))
 		return -EFAULT;
 
-	info.id = btf->id;
+	info.id = READ_ONCE(btf->id);
 	ubtf = u64_to_user_ptr(info.btf);
 	btf_copy = min_t(u32, btf->data_size, info.btf_size);
 	if (copy_to_user(ubtf, btf->data, btf_copy))
@@ -7313,7 +7322,7 @@ int btf_get_fd_by_id(u32 id)
 
 u32 btf_obj_id(const struct btf *btf)
 {
-	return btf->id;
+	return READ_ONCE(btf->id);
 }
 
 bool btf_is_kernel(const struct btf *btf)
@@ -7445,6 +7454,13 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 			if (btf_mod->module != module)
 				continue;
 
+			/*
+			 * For modules, we do the freeing of BTF IDR as soon as
+			 * module goes away to disable BTF discovery, since the
+			 * btf_try_get_module() on such BTFs will fail. This may
+			 * be called again on btf_put(), but it's ok to do so.
+			 */
+			btf_free_id(btf_mod->btf);
 			list_del(&btf_mod->list);
 			if (btf_mod->sysfs_attr)
 				sysfs_remove_bin_file(btf_kobj, btf_mod->sysfs_attr);
-- 
2.51.0



