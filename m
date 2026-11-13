Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591368;
	b=GPPG8HpnZ2uzVoC7sXyYvOYvEgJ74D8DwInXXWkvr5YSvRpLE37HpZ85oP0Gmqfl1RTh
	 ub+QrRGecGZpEzad5/orxYBEpeBEah5qa6QKSa8GK/5HP2mMv+snvWJ/HrL8885Rrebk3
	 LsYccbwZEJXTwsiEMPMxL4BoNS6fzmWTKzJYPl0qyv9JPT+NnJAcCBPhfmYItG8SUSaPI
	 tVLer3qQG0wDUA8AsrQ+8ceZwNoegpkauhhA5ib8Y8vEl1AM2KSJ2J4fW/rvCji7XmoYx
	 cqNrkKJFoXd9TN4E1aDcQ7bwbvEGBZxUhev21MsR9ky38+BL+p2Ksy0Bmj+AG6Qazqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uIlVVwkD8TgPrYfUe5rO+lRRzVLuPhx94zi2DmAIOv0=;
	b=fbBFGIVRidMNvPKgAS0lPGJapfxXBsWo5C1jRqOvYPrY6FlJoCj6MBMmw3RWSMe+ICKs
	 UHIQ1cz3GZzZLll1kwoHl7yUMxNANlxPVagulXn3cdqDn9pBYWZ6AAq3uFBKMnOn7usc8
	 UOYb22x1LvsfbGDgBBVqPfs9vDSG8rCp3nsB8mfpMzWdMjZugpsn68YQJEhHncViGJgdX
	 89gFV5HHdPjPyQ6f6DVUq+JxmHGUi1eCYaViX19T5WneA0dwdy2utToHXo3CVUFLIat4l
	 iY//W9dFNzYxMN+dAfgVYnFR6T45xpojXCw0O4S2XR0/1p9488HMOgZAk3zM5sAFvCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhOE7KnE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DE0606EDA6;
	Fri, 13 Nov 2026 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhOE7KnE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8495A1F000C4;
	Fri, 13 Nov 2026 17:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591368;
	bh=uIlVVwkD8TgPrYfUe5rO+lRRzVLuPhx94zi2DmAIOv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EhOE7KnETow8CcO2PnUjcdzmzBZ1Xwo7zMKHHwxg/4cFKMWvRQGiZlQFBEVDZh8Xe
	 hD56wx/9WvG7391eSa25LLFciCdatPis1EjIj4MfW4p5qBKzGafEHuP8sJ/oN9Kbdz
	 pFDAQJ31KEZ4yr66yBsxpRvAbZsjwpOrXeB6zJV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 429/670] KVM: guest_memfd: Split bind() into prepare()+commit() phases
Date: Fri, 13 Nov 2026 10:49:53 -0500
Message-ID: <20261113153826.278322652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 83411f32b8ad96c6b05b1511d1a588daab44bd25 ]

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
[ sashal: changed the fput() guard from CONFIG_KVM_GUEST_MEMFD to CONFIG_KVM_PRIVATE_MEM ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/guest_memfd.c | 61 +++++++++++++++++++++++++-----------------
 virt/kvm/kvm_main.c    | 18 ++++++++++++-
 virt/kvm/kvm_mm.h      | 18 +++++++++----
 3 files changed, 66 insertions(+), 31 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 88b7279f4634d..4f69260cafbb2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -472,15 +472,13 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	return __kvm_gmem_create(kvm, size, flags);
 }
 
-int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, u64 offset)
+int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot,
+				   unsigned int fd, u64 offset)
 {
 	u64 size = slot->npages << PAGE_SHIFT;
-	unsigned long start, end;
 	struct kvm_gmem *gmem;
 	struct inode *inode;
 	struct file *file;
-	int r = -EINVAL;
 
 	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
 	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
@@ -501,40 +499,53 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
 		goto err;
 
+	/*
+	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
+	 * kvm_gmem_bind() must occur on a new memslot.  Because the memslot
+	 * is not visible yet, kvm_gmem_get_pfn() is guaranteed to see the file.
+	 */
+	WRITE_ONCE(slot->gmem.file, file);
+	slot->gmem.pgoff = offset >> PAGE_SHIFT;
+
+	/*
+	 * Gift the caller a reference to the file.  The reference will be
+	 * dropped after bindings are established, or if installing the new
+	 * memslot ultimately fails.
+	 */
+	return 0;
+
+err:
+	fput(file);
+	return -EINVAL;
+}
+
+int kvm_gmem_commit_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_gmem *gmem = slot->gmem.file->private_data;
+	struct inode *inode = file_inode(slot->gmem.file);
+	unsigned long start, end;
+	int r;
+
+	if (WARN_ON_ONCE(slot->gmem.file->f_op != &kvm_gmem_fops))
+		return -EIO;
+
 	filemap_invalidate_lock(inode->i_mapping);
 
-	start = offset >> PAGE_SHIFT;
+	start = slot->gmem.pgoff;
 	end = start + slot->npages;
 
 	if (!xa_empty(&gmem->bindings) &&
 	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
 		filemap_invalidate_unlock(inode->i_mapping);
-		goto err;
+		return -EEXIST;
 	}
 
-	/*
-	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
-	 * kvm_gmem_bind() must occur on a new memslot.  Because the memslot
-	 * is not visible yet, kvm_gmem_get_pfn() is guaranteed to see the file.
-	 */
-	WRITE_ONCE(slot->gmem.file, file);
-	slot->gmem.pgoff = start;
-
 	r = xa_err(xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL));
-	if (r) {
+	if (r)
 		xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
-		slot->gmem.file = NULL;
-		slot->gmem.pgoff = 0;
-	}
+
 	filemap_invalidate_unlock(inode->i_mapping);
 
-	/*
-	 * Drop the reference to the file, even on success.  The file pins KVM,
-	 * not the other way 'round.  Active bindings are invalidated if the
-	 * file is closed before memslots are destroyed.
-	 */
-err:
-	fput(file);
 	return r;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c574cd2f4f722..699198ae1594c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2103,7 +2103,23 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
+#ifdef CONFIG_KVM_PRIVATE_MEM
+		fput(new->gmem.file);
+#endif
+
 		if (r)
 			goto out;
 	}
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 15b2c728f7dd5..92ec2bde65324 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -41,8 +41,9 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 #ifdef CONFIG_KVM_PRIVATE_MEM
 void kvm_gmem_init(struct module *module);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
-int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, u64 offset);
+int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot,
+				   unsigned int fd, u64 offset);
+int kvm_gmem_commit_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
 static inline void kvm_gmem_init(struct module *module)
@@ -50,9 +51,16 @@ static inline void kvm_gmem_init(struct module *module)
 
 }
 
-static inline int kvm_gmem_bind(struct kvm *kvm,
-					 struct kvm_memory_slot *slot,
-					 unsigned int fd, u64 offset)
+static inline int kvm_gmem_prepare_memory_region(struct kvm *kvm,
+						 struct kvm_memory_slot *slot,
+						 unsigned int fd, u64 offset)
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
-- 
2.53.0



