Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590063;
	b=xQHSoZ88msJFSo3IcS1ixxMjqKYdXuaqIeViuDueFdCQ4w5AoGyWojzKzwBmgHwNzD+X
	 +QcHdMnoJYiJ5kZBeyS3yhES+w7bg9Z2P8y2ljF3nC6aWjCPjUtwRh5MGmnxXwdhu+xYH
	 fVBf8enqY2F+lmljQ5EuSM+hPmmK0KYdlKEzYCHJAPXInRwBklF5nC8/KUx7qwWTgsAPI
	 XgyUD5z3AdTT+PHZW9HaCQYczEuPJCNn+dzndMw73SLP6s37CSouwqdlA8RsQlMj+VgWj
	 YBdKTEsjHat+ftA5/VNlvPHglLHLAM3qzOcJ2bhcndBvs7ezT5JmMz2ohReLbUpT/Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b0jDDU3KCNjNLT2qoLaXPKoYi1KCQ6sLAKppjwZz6QM=;
	b=Hf/wUZIz8YndmczMD4uIlEOraCSKMtOjnGyx4RkrR0kxWb9SrWyffMvPW0ti2LKpCYr+
	 03MxWoaBVQli2pYqTTYdYbsRUh5NYA9DvIiKEi5xfeZKhiJoP6wFAXVSx6gYWr96p1h2l
	 AQlQI7hyakXndtJOnEDJw/i1ofhY0+Nr1Vg706Ja5bChSNHasYPW0vnMtNxRNncg2oleW
	 3LdK6vgqD3YprVJgcGjssdLJ84WYLeweKuv/F3ZMuQ7MsCI1SNV4zyUE12ckTB6kddW9Q
	 dI8/Mi2SMLTBMBtmfTVCwbCsvchBtFNqY7WH19kzYC6vb1eNgygpviaQ3X5Qatx47pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiEJfLdp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4812A606A335;
	Fri, 13 Nov 2026 17:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiEJfLdp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B231F000C5;
	Fri, 13 Nov 2026 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590063;
	bh=b0jDDU3KCNjNLT2qoLaXPKoYi1KCQ6sLAKppjwZz6QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiEJfLdpqeB+CXF8rroR35UlP9QnchXhaWRP1m47ehvOQlGcUx4sP3Dw92xC1AcUC
	 nqfvicTCBZONdznOHvOz5jpALzZvOLrGjjvaIxtMRjggNWlBhnUK1x3cuk/qr82DC5
	 cuUWY3OQ9y8QuZ3w4Ph6ENU3dXlb2H+N93RoOrss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/686] KVM: guest_memfd: take the invalidate lock when unbinding a dying file
Date: Fri, 13 Nov 2026 10:43:06 -0500
Message-ID: <20261113153822.759550199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivank Garg <shivankg@amd.com>

[ Upstream commit 0ee2c883b62deb74d8c43007e8049dc006d3a2fb ]

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
[ sashal: Adapted unbind to struct kvm_gmem with explicit kvm_gmem_get_file()/fput() removal replacing upstream's automatic cleanup removal. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/guest_memfd.c | 48 ++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2ab7bb46a371e..5f9a25fa0a09b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -635,53 +635,41 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 
-static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct kvm_gmem *gmem)
+void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
+	struct file *file = slot->gmem.file;
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
-
-	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
-
-	/*
-	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
-	 * cannot see this memslot.
-	 */
-	WRITE_ONCE(slot->gmem.file, NULL);
-}
-
-void kvm_gmem_unbind(struct kvm_memory_slot *slot)
-{
-	struct file *file;
+	struct kvm_gmem *gmem;
 
 	/*
 	 * Nothing to do if the underlying file was _already_ closed, as
 	 * kvm_gmem_release() invalidates and nullifies all bindings.
 	 */
-	if (!slot->gmem.file)
+	if (!file)
 		return;
 
-	file = kvm_gmem_get_file(slot);
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
+	gmem = file->private_data;
 
 	filemap_invalidate_lock(file->f_mapping);
-	__kvm_gmem_unbind(slot, file->private_data);
-	filemap_invalidate_unlock(file->f_mapping);
+	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
 
-	fput(file);
+	/*
+	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
+	 * cannot see this memslot.
+	 */
+	WRITE_ONCE(slot->gmem.file, NULL);
+	filemap_invalidate_unlock(file->f_mapping);
 }
 
 /* Returns a locked folio on success.  */
-- 
2.53.0



