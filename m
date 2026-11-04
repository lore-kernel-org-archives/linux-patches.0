Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829212;
	b=Zv6AIM7PL1n7z7ISHxM18Mmwor7tEKYIG5Xa83x4yVHhpPd1l2HmPkla1cxI8W32e0mq
	 XaOvl3LcuWntRMeEets3WOnju5BzbDMAeY6Ovza4Hhzr9ByawMtiQXbDg7DtF5kmOU7WV
	 2wbOboahH5lfrUBLg+GfMXE9ViXb9Xi2IikRugMWZfG2PDkNiqYcF/or5mq2oBJiiZ5gY
	 /DIxPkKyQwo97IH70gRTj8nds0ZjDdffPoihbru1Lprla653VLUH6z0SO4Lu9a1SQm/Yb
	 RjFBAUsprKxlTHpU/5jgE17dFGbt7gY6syKHKqXjLzpN+CiTcHF+hq2K2zpj3F/NUBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IduHgt5wzvGWC1wS1wU4GiW3RCQ+U1eejJR6bVbEi4s=;
	b=Dbz3XrcsglmXp+UVy9wbl9W3eTrSSveEaftNq6j+EwUjDcWEU2ZD060aPL0Q8rOzCQ97
	 ZftPy1/y8A7FjuLpmm1fXxe34XHFZMurTlFWMRgFSZEEy7/QoJJYu2njeA727y9d5O8FD
	 nkmDbqf61Sn3ZbLvUUcpiL9S6hTVrfPOQBDOr+VCMm5Cq2YiLBlWKyf9QAO8uQmTKBg6d
	 9ZkbI8Lsb+g6rAjKSV8xr9cvUYqzj202rPTxrWAhzordDGbtDUwocu9r0rjAMoZ3E7A9G
	 DMcW0OVhsvZSuaaUsozXdqdnxQtnZrrFKzSBNvnVlrd2A6LypfGXPUd3OBNPayPv/SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUhDjgga;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B0B6070323;
	Wed,  4 Nov 2026 21:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUhDjgga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE951F000C1;
	Wed,  4 Nov 2026 21:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829212;
	bh=IduHgt5wzvGWC1wS1wU4GiW3RCQ+U1eejJR6bVbEi4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUhDjgga4s5ZCvQ6nJM65UZiibFBX04LfGUgz2SzxmgAJGWEujidxk69IADZ/EmZU
	 +Su65mwrkUk1s9vIiIFL0tF1QJQ+9TnaRG0jhhowkcj2vaezpaz6KXeSpHuaZCAbV8
	 yspr4hEzRt5YU8tYvoxQSFyXeFFDGwDl6zTvGOj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 7.3 479/547] KVM: guest_memfd: take the invalidate lock when unbinding a dying file
Date: Wed,  4 Nov 2026 16:11:03 -0500
Message-ID: <20261104211051.981381895@linuxfoundation.org>
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

From: Shivank Garg <shivankg@amd.com>

commit 0ee2c883b62deb74d8c43007e8049dc006d3a2fb upstream.

kvm_gmem_unbind() takes mapping->invalidate_lock only if the
get_file_active() succeeds. When the guest_memfd file is dying, its
reference count is already zero so get_file_active fails and the binding
is removed without holding the invalidate lock.

kvm_gmem_invalidate_{start,end}() checks f->bindings independently to
decide whether to begin or end KVM MMU invalidation. So, the bindings
must therefore remain stable between the two calls. Otherwise, unbind
can remove a binding after start increments mmu_invalidate_in_progress,
but before end finds the binding and decrements it.
Example, unbind race with memory failure:

  CPU 0: memory failure               CPU 1: memslot delete
  ----------------------------------  ---------------------------
                                      (guest_memfd file is dying)
  kvm_gmem_error_folio()
    kvm_gmem_invalidate_start()
      finds binding
      mmu_invalidate_in_progress++
                                      kvm_gmem_unbind()
                                        get_file_active() fails
                                        removes binding
    kvm_gmem_invalidate_end()
      no binding found
      counter stays elevated

mmu_invalidate_retry() then returns 1 forever, so guest page faults
retry without ever installing a mapping and the guest hangs.

Remove the distinction between live and dying files in the unbind path.
Always use slot->gmem.file and take the invalidate lock when it's non-NULL.
Normal unbind callers hold slots_lock, which prevents release from clearing
the pointer or freeing the file state until unbind completes. Final VM
teardown can only see a NULL pointer because guest_memfd pins the KVM until
release has cleared all bindings.

Fixes: ae431059e75d ("KVM: guest_memfd: Remove bindings on memslot deletion when gmem is dying")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260728092027.225CF1F000E9@smtp.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://patch.msgid.link/20260901-gmem-unbind-fix-v2-1-12febe1d2216@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/guest_memfd.c |   44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -686,48 +686,40 @@ int kvm_gmem_commit_memory_region(struct
 	return r;
 }
 
-static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct gmem_file *f)
+void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
+	struct file *file = slot->gmem.file;
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
-
-	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
+	struct gmem_file *f;
 
 	/*
-	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
-	 * cannot see this memslot.
-	 */
-	WRITE_ONCE(slot->gmem.file, NULL);
-}
-
-void kvm_gmem_unbind(struct kvm_memory_slot *slot)
-{
-	/*
 	 * Nothing to do if the underlying file was _already_ closed, as
 	 * kvm_gmem_release() invalidates and nullifies all bindings.
 	 */
-	if (!slot->gmem.file)
+	if (!file)
 		return;
 
-	CLASS(gmem_get_file, file)(slot);
-
 	/*
 	 * However, if the file is _being_ closed, then the bindings need to be
 	 * removed as kvm_gmem_release() might not run until after the memslot
-	 * is freed.  Note, modifying the bindings is safe even though the file
-	 * is dying as kvm_gmem_release() nullifies slot->gmem.file under
-	 * slots_lock, and only puts its reference to KVM after destroying all
-	 * bindings.  I.e. reaching this point means kvm_gmem_release() hasn't
-	 * yet destroyed the bindings or freed the gmem_file, and can't do so
-	 * until the caller drops slots_lock.
+	 * is freed.  Modifying the bindings is safe even if the file is dying
+	 * as kvm_gmem_release() nullifies slot->gmem.file under slots_lock,
+	 * and only puts its reference to KVM after destroying all bindings.
+	 * I.e. reaching this point means kvm_gmem_release() hasn't destroyed
+	 * the bindings or freed the gmem_file and can't do so until the caller
+	 * drops slots_lock, so there's no need to verify the file is live.
 	 */
-	if (!file) {
-		__kvm_gmem_unbind(slot, slot->gmem.file->private_data);
-		return;
-	}
+	f = file->private_data;
 
 	filemap_invalidate_lock(file->f_mapping);
-	__kvm_gmem_unbind(slot, file->private_data);
+	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
+
+	/*
+	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
+	 * cannot see this memslot.
+	 */
+	WRITE_ONCE(slot->gmem.file, NULL);
 	filemap_invalidate_unlock(file->f_mapping);
 }
 


