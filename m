Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4858501281;
	Tue, 13 Oct 2026 12:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893629; cv=none; b=frDnSjkm2lcUj5yRpXoqWvaWXuCAGW110t/+3ptajm4GPp9U6f0CgXT2tw5y2ZJmpIo8hnNNbIcsU8UjShwOM/9/TI1mTLVTi/4vyKFM1rxPrYX8FJGdPap891XAr+IMZ5Ch2lPzTG3IbdlBiCEzMEoqFpBUT2lpGB2R95Xgh40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893629; c=relaxed/simple;
	bh=bJSXocnADc0KBoax5NjutoqN2oIM3AMPhcwG52wehhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7Ukf22Pa7WsmJ8obVZTZCEV01d/urerhwWuQFg4oldiGSafkpxCYAA3kRxJuZOwLUu+SzKlIqNXLpOtvAj1cTaai2Ej3KA+fwKpnIdx487tE+1mAMqKEAiFZZLoksgwXgzoasqgNGvAgi2zrBWNpkS/cxos8CZ01sP8/3r8cEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtLtT5DZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtLtT5DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0061F000FF;
	Tue, 13 Oct 2026 12:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893627;
	bh=MtsjzTjRqx6x9ih1WtWWeev1cRVfcBF9YcHT1Qh6EVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtLtT5DZGtzdqH0wEEkWIWnB4or9aXqfuxFdEJY8PFAft94LC3vEhem+3/xFGWpyK
	 P7H/Zx4XxaQXSrTQPm+KX/UyAJy18tUkIdREelMtH/Adyz6nflimbQOxn78Dr8Npo3
	 OYpJ1CLLCegDJ8DzWVCdbtJ++2xonCwhGtEOMzoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ackerley Tng <ackerleytng@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/621] KVM: guest_memfd: Treat memslot binding offset+size as unsigned values
Date: Tue, 13 Oct 2026 13:34:07 +0200
Message-ID: <20261013112926.841751182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit eba85fee7fc6cf28fec38a5bf3c378bef9a79ca6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/guest_memfd.c | 8 ++++----
 virt/kvm/kvm_mm.h      | 7 +++++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ffadc5ee8e045..f87c3cbb9fe17 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -560,15 +560,16 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 }
 
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, loff_t offset)
+		  unsigned int fd, u64 offset)
 {
-	loff_t size = slot->npages << PAGE_SHIFT;
+	u64 size = slot->npages << PAGE_SHIFT;
 	unsigned long start, end;
 	struct kvm_gmem *gmem;
 	struct inode *inode;
 	struct file *file;
 	int r = -EINVAL;
 
+	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
 	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
 
 	file = fget(fd);
@@ -584,8 +585,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	inode = file_inode(file);
 
-	if (offset < 0 || !PAGE_ALIGNED(offset) ||
-	    offset + size > i_size_read(inode))
+	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
 		goto err;
 
 	filemap_invalidate_lock(inode->i_mapping);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 31defb08ccbab..0e68675a8a630 100644
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
@@ -71,7 +74,7 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 void kvm_gmem_init(struct module *module);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, loff_t offset);
+		  unsigned int fd, u64 offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
 static inline void kvm_gmem_init(struct module *module)
@@ -81,7 +84,7 @@ static inline void kvm_gmem_init(struct module *module)
 
 static inline int kvm_gmem_bind(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
-					 unsigned int fd, loff_t offset)
+					 unsigned int fd, u64 offset)
 {
 	WARN_ON_ONCE(1);
 	return -EIO;
-- 
2.53.0



