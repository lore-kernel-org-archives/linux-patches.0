Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829211;
	b=uqqNFi9h8ccaBM3ub8J+td8mPQYQqNGtom5a8+cvhTqOTRSGAOLTP/J8WSsikQvSQbdQ
	 TAjW4/egZZneh78OFe+vXuV1UGTpoAWHLfb8FCZKIeHyEa0DFHI/HjRk76/mGsaE+7Nc9
	 W9JsYDuOY9caIfIY7nhl0emrkLtMkuj+bGKlyzQe7G+zmjKBM+kiQZzGcHQFOTErFvjsq
	 uyQh4On2HlL/B85IoCUk2AAnWLA6ayNerEzOboqx7ngPk2iRfgZZL62WYFrrjM4wa+BtP
	 kcS4274UNFeryFZUJGC8OW/jIy8QudtolopGmI5I3xiTTWRt/cQS6XOZ09mFP657HTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KUK3wEFLlhKvnksjCjm+XRexUQFcMZ0HHsNjagr5B8U=;
	b=xbRKSDSJDN4+SKy9/FnqUvbTm6J7bZCqcWWlrjU0p0bGmhwcie5NrpKzD+PpWKAsRnGq
	 I2dJw8S5H34qLkIyEghcT78iy+gU7IjHUtylyFVMRIVI0JnTJJ1I5srPJz1xZggxcS9Fg
	 y3KsSwZhpqiWSf02FE2KIGNAGvm63BYZbTXNuOZwLodwiCbQPrHwXya0KFom/XtRREPk4
	 uFgKaQQpTMty4vt1uJe88mAVuvqDqvwNXz3Ab1+9SB63qdjc43FYkxv/m5BsVF84SWipH
	 Tkydf/lLy76GXQXldpr1q7R+9GoUJ/9HeXcsEd6Iq3Vuwo4YXF+KdtMULnNI7bV5ZhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ze+YYVzp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C0C60709A8;
	Wed,  4 Nov 2026 21:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ze+YYVzp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E5E1F00919;
	Wed,  4 Nov 2026 21:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829210;
	bh=KUK3wEFLlhKvnksjCjm+XRexUQFcMZ0HHsNjagr5B8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ze+YYVzpp1S11o7A7dASkLqGCXv4QbzSPyzrZvWel3rk2k2HWZf91xeqK06ekZAE3
	 JmRnRMZoAiQI42DCd1VamsVnBS/iKv3eJU7je7KCXmEYp4rY8NGn6If0MhfM9+kxCr
	 0OGZ8pvb3FSBT34OMwRkxwGqcoYnf+Ktp5Aqa/DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 478/547] KVM: guest_memfd: Split bind() into prepare()+commit() phases
Date: Wed,  4 Nov 2026 16:11:02 -0500
Message-ID: <20261104211051.950834626@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 83411f32b8ad96c6b05b1511d1a588daab44bd25 upstream.

Split binding a memslot to a guest_memfd instance into prepare() and
commit() phases so that KVM can separate preparing the memslot from binding
the memslot to the gmem instance, i.e. from committing the memslot.  This
will allow waiting to commit the memslot+gmem binding until the memslot is
fully prepared, which is necessary as the memslot becomes reachable when
the binding is created.

As a bonus, drop the unwind-on-failure from the commit phase (other than
nullifying the bindings), as the only reason bind() did the full unwind is
because it technically didn't own the memslot, i.e. "needed" to leave
memslot in the same state it started in.

No functional change intended (the unwinding down on bind() failure was
effectively dead code since KVM simply deletes the memslot on failure,
i.e. there was nothing that could actually observe the unwind).

Cc: stable@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://patch.msgid.link/20260922001332.1121266-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/guest_memfd.c |   68 ++++++++++++++++++++++++++++---------------------
 virt/kvm/guest_memfd.h |   19 ++++++++++---
 virt/kvm/kvm_main.c    |   18 ++++++++++++
 3 files changed, 70 insertions(+), 35 deletions(-)

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -603,15 +603,14 @@ int kvm_gmem_create(struct kvm *kvm, str
 	return __kvm_gmem_create(kvm, size, flags);
 }
 
-int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, uoff_t offset)
+int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot,
+				   unsigned int fd, uoff_t offset)
 {
 	uoff_t size = slot->npages << PAGE_SHIFT;
-	unsigned long start, end;
 	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
-	int r = -EINVAL;
+
 
 	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
 	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
@@ -635,44 +634,55 @@ int kvm_gmem_bind(struct kvm *kvm, struc
 	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
 		goto err;
 
-	filemap_invalidate_lock(inode->i_mapping);
-
-	start = offset >> PAGE_SHIFT;
-	end = start + slot->npages;
-
-	if (!xa_empty(&f->bindings) &&
-	    xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
-		r = -EEXIST;
-		filemap_invalidate_unlock(inode->i_mapping);
-		goto err;
-	}
-
 	/*
 	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
 	 * kvm_gmem_bind() must occur on a new memslot.  Because the memslot
 	 * is not visible yet, kvm_gmem_get_pfn() is guaranteed to see the file.
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
-	slot->gmem.pgoff = start;
+	slot->gmem.pgoff = offset >> PAGE_SHIFT;
 	if (kvm_gmem_supports_mmap(inode))
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
-	r = xa_err(xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL));
-	if (r) {
-		xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
-		slot->gmem.file = NULL;
-		slot->gmem.pgoff = 0;
-		slot->flags &= ~KVM_MEMSLOT_GMEM_ONLY;
-	}
-	filemap_invalidate_unlock(inode->i_mapping);
-
 	/*
-	 * Drop the reference to the file, even on success.  The file pins KVM,
-	 * not the other way 'round.  Active bindings are invalidated if the
-	 * file is closed before memslots are destroyed.
+	 * Gift the caller a reference to the file.  The reference will be
+	 * dropped after bindings are established, or if installing the new
+	 * memslot ultimately fails.
 	 */
+	return 0;
+
 err:
 	fput(file);
+	return -EINVAL;
+}
+
+int kvm_gmem_commit_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct gmem_file *f = slot->gmem.file->private_data;
+	struct inode *inode = file_inode(slot->gmem.file);
+	unsigned long start, end;
+	int r;
+
+	if (WARN_ON_ONCE(slot->gmem.file->f_op != &kvm_gmem_fops))
+		return -EIO;
+
+	filemap_invalidate_lock(inode->i_mapping);
+
+	start = slot->gmem.pgoff;
+	end = start + slot->npages;
+
+	if (!xa_empty(&f->bindings) &&
+	    xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
+		filemap_invalidate_unlock(inode->i_mapping);
+		return -EEXIST;
+	}
+
+	r = xa_err(xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL));
+	if (r)
+		xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
+
+	filemap_invalidate_unlock(inode->i_mapping);
+
 	return r;
 }
 
--- a/virt/kvm/guest_memfd.h
+++ b/virt/kvm/guest_memfd.h
@@ -8,8 +8,9 @@
 int kvm_gmem_init(struct module *module);
 void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
-int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, uoff_t offset);
+int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot,
+				   unsigned int fd, uoff_t offset);
+int kvm_gmem_commit_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
 static inline int kvm_gmem_init(struct module *module)
@@ -17,9 +18,17 @@ static inline int kvm_gmem_init(struct m
 	return 0;
 }
 static inline void kvm_gmem_exit(void) {};
-static inline int kvm_gmem_bind(struct kvm *kvm,
-					 struct kvm_memory_slot *slot,
-					 unsigned int fd, uoff_t offset)
+
+static inline int kvm_gmem_prepare_memory_region(struct kvm *kvm,
+						 struct kvm_memory_slot *slot,
+						 unsigned int fd, uoff_t offset)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
+
+static inline int kvm_gmem_commit_memory_region(struct kvm *kvm,
+						struct kvm_memory_slot *slot)
 {
 	WARN_ON_ONCE(1);
 	return -EIO;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2123,7 +2123,23 @@ static int kvm_set_memory_region(struct
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
 	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD)) {
-		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
+		r = kvm_gmem_prepare_memory_region(kvm, new, mem->guest_memfd,
+						   mem->guest_memfd_offset);
+		if (r)
+			goto out;
+
+		r = kvm_gmem_commit_memory_region(kvm, new);
+
+		/*
+		 * Drop the reference to the file, even on success.  The file
+		 * pins KVM, not the other way 'round.  Active bindings are
+		 * invalidated if the file is closed before memslots are
+		 * destroyed.
+		 */
+#ifdef CONFIG_KVM_GUEST_MEMFD
+		 fput(new->gmem.file);
+#endif
+
 		if (r)
 			goto out;
 	}


