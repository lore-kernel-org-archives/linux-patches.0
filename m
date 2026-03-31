Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1125D3A1E8C;
	Tue, 31 Mar 2026 16:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976228; cv=none; b=h8oOJP8H1zc0GGdoyH4RJ7dBJEwAX6CoofV59HX5EvX4+lquG5M+l3FmVAwLz+cJQPB8D6BC4BXs9TkfPTaOA3B+fOT9rqDD66St5EkPNA1P5mrcpIbcR7AAAiSK4ZVZKg0sLpXyEkz+be+ibRfq7JICSb8O0sbdT/sbKTw0BsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976228; c=relaxed/simple;
	bh=ynbIkS+IFthJXROSfVlF8rCbUFHrysnAC7X158xnv/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYvv5Q6mgBJOmJncNTDfyLRlWHU7v2xsVsWJ8gFv7QLsnGP5IXreGe4VVIOjyS3JSAEUnkOjC1d/OQBKrrwc9c981VmTMo88ZNQxaf9F44QoYgLfylc0yQuALE1tgivolHU70QVxjo4svZg7TYbovl5nPPgyhdVNlpWzBoVsVks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5+B97Np; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5+B97Np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B77C19423;
	Tue, 31 Mar 2026 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976227;
	bh=ynbIkS+IFthJXROSfVlF8rCbUFHrysnAC7X158xnv/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5+B97NpqrNhD2Qd/tX+oYSaU0nvZTWvTfDwN86YGZgHlY2l6+BwqZW5GMwN9HpCz
	 sf3ZS5Y72SdB6LvpBO3TJ3DDhdfSbenUpCO59MKGY2ytu0ZeuYY1JCTjLtzPTj9j16
	 2LO0tHLw06yBk/744OB2UHG8YoHUlcC1Kwvv8+tA=
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
Subject: [PATCH 6.18 012/309] bpf: Release module BTF IDR before module unload
Date: Tue, 31 Mar 2026 18:18:35 +0200
Message-ID: <20260331161753.929594130@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0de8fc8a0e0b3..75a5df36f9170 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1676,7 +1676,16 @@ static void btf_free_id(struct btf *btf)
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
 
@@ -7995,7 +8004,7 @@ static void bpf_btf_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct btf *btf = filp->private_data;
 
-	seq_printf(m, "btf_id:\t%u\n", btf->id);
+	seq_printf(m, "btf_id:\t%u\n", READ_ONCE(btf->id));
 }
 #endif
 
@@ -8077,7 +8086,7 @@ int btf_get_info_by_fd(const struct btf *btf,
 	if (copy_from_user(&info, uinfo, info_copy))
 		return -EFAULT;
 
-	info.id = btf->id;
+	info.id = READ_ONCE(btf->id);
 	ubtf = u64_to_user_ptr(info.btf);
 	btf_copy = min_t(u32, btf->data_size, info.btf_size);
 	if (copy_to_user(ubtf, btf->data, btf_copy))
@@ -8140,7 +8149,7 @@ int btf_get_fd_by_id(u32 id)
 
 u32 btf_obj_id(const struct btf *btf)
 {
-	return btf->id;
+	return READ_ONCE(btf->id);
 }
 
 bool btf_is_kernel(const struct btf *btf)
@@ -8262,6 +8271,13 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
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



