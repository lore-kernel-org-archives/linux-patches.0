Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953B122301;
	Thu, 16 Jul 2026 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210162; cv=none; b=UUxpyu5mnmgzCVBJZR3b5AyrJTmuE/HlYzf6LSrLvXfHb0e0YoFH2UXGIU7RkrXDqw69C7Xhae6tsPXGkmCX+XwovDE3pJPhcQeEipSzXI6JyhmOUH+Qe4IJsDDlVna4jkLfZmvYzjM3FpEjNXxUQoCtrJqN4C55AjEIq8zeaLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210162; c=relaxed/simple;
	bh=MzsJi+HGsphugM9za82FJlOoVXmbEMs+ZmzbBY3hN3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgn1308+PlKa7slNucc+zpEN36OwlDXG6NS3ccyAhNuGsIPTsHBJPqrTCu4BvjvO0Nn+7nGq7nShmJq/SPtaX/tEveaEq7HdKw5A0WyvjkkbmN1tKm3hsTUdnyGvxs44yThBvZRG4o6ZG29q3JGq5jtZuKX3RQDmxng4JB/l2gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd3SE9Eb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd3SE9Eb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FE71F00A3A;
	Thu, 16 Jul 2026 13:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210161;
	bh=RkMcxhaMjEEad3bt0bgfvAz4yMVH73uUqQdHxDFK4Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bd3SE9Ebxqa8jX0qDILi6YGcQgjLYw6ZeYbH/XJ+hEVJ1QTcLQsHkr5ochKrLpK4O
	 ilx7bEqBuFhxLI1aY6Fuodm3MEtjjAJRAQUSwbi2oE4KO5G1aMuyf+lnwGz9tXcOZX
	 I3UWuTUaFZC7qB5b1FE2y/+HOEfDhjxS2eYx5rvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ackerley Tng <ackerleytng@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 462/518] KVM: guest_memfd: Treat memslot binding offset+size as unsigned values
Date: Thu, 16 Jul 2026 15:32:10 +0200
Message-ID: <20260716133057.953014449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit eba85fee7fc6cf28fec38a5bf3c378bef9a79ca6 upstream.

When binding a memslot to a guest_memfd file, treat the offset and size as
unsigned values to fix a bug where the sum of the two can result in a false
negative when checking for overflow against the size of the file.  Passing
unsigned values also avoids relying on somewhat obscure checks in other
flows for safety, and tracks the offset and size as they are intended to be
tracked, as unsigned values.

On 64-bit kernels, the number of pages a memslot contains and thus the size
(and offset) of its guest_memfd binding are unsigned 64-bit values.  Taking
the offset+size as an loff_t instead of a uoff_t inadvertently converts
the unsigned value to a signed value if the offset and/or size is massive.

Locally storing the offset and size as signed values is benign in and of
itself (though even that is *extremely* difficult to discern), but
operating on their sum is not.

For the offset, KVM explicitly checks against a negative value, which might
seem like a bug as KVM could incorrectly reject a legitimate binding, but
that's not actually the case as KVM_CREATE_GUEST_MEMFD takes a signed value
for its size, i.e. a would-be-negative offset is also greater than the
maximum possible size of any guest_memfd file.

Regarding the size, while KVM lacks an explicit check for a negative value,
i.e. seemingly has a flawed overflow check, KVM restricts the number of
pages in a single memslot to the largest positive signed 32-bit value:

        if (id < KVM_USER_MEM_SLOTS &&
            (mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
                return -EINVAL;

and so that maximum "size" will ever be is 0x7fffffff000.

The sum of the two is, however, problematic.  While the size is restricted
by KVM's memslot logic, the offset is not, i.e. the offset is completely
unchecked until the "offset + size > i_size_read(inode)" check.  If the
offset is the (nearly) largest possible _positive_ value, then adding size
to the offset can result in a signed, negative 64-bit value.  When compared
against the size of the file (guaranteed to be positive), the negative sum
is always smaller, and KVM incorrectly allows the absurd offset.

Opportunistically add missing includes in kvm_mm.h (instead of relying on
its parents).

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Cc: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Link: https://patch.msgid.link/20260602170921.1304394-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/guest_memfd.c |    8 ++++----
 virt/kvm/kvm_mm.h      |    7 +++++--
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -640,15 +640,16 @@ int kvm_gmem_create(struct kvm *kvm, str
 }
 
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, loff_t offset)
+		  unsigned int fd, uoff_t offset)
 {
-	loff_t size = slot->npages << PAGE_SHIFT;
+	uoff_t size = slot->npages << PAGE_SHIFT;
 	unsigned long start, end;
 	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
 	int r = -EINVAL;
 
+	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
 	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
 
 	file = fget(fd);
@@ -664,8 +665,7 @@ int kvm_gmem_bind(struct kvm *kvm, struc
 
 	inode = file_inode(file);
 
-	if (offset < 0 || !PAGE_ALIGNED(offset) ||
-	    offset + size > i_size_read(inode))
+	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
 		goto err;
 
 	filemap_invalidate_lock(inode->i_mapping);
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -3,6 +3,9 @@
 #ifndef __KVM_MM_H__
 #define __KVM_MM_H__ 1
 
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
+
 /*
  * Architectures can choose whether to use an rwlock or spinlock
  * for the mmu_lock.  These macros, for use in common code
@@ -72,7 +75,7 @@ int kvm_gmem_init(struct module *module)
 void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, loff_t offset);
+		  unsigned int fd, uoff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
 static inline int kvm_gmem_init(struct module *module)
@@ -82,7 +85,7 @@ static inline int kvm_gmem_init(struct m
 static inline void kvm_gmem_exit(void) {};
 static inline int kvm_gmem_bind(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
-					 unsigned int fd, loff_t offset)
+					 unsigned int fd, uoff_t offset)
 {
 	WARN_ON_ONCE(1);
 	return -EIO;


