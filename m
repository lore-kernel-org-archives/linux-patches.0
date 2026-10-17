Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E2B18787A;
	Sat, 17 Oct 2026 16:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253690; cv=none; b=se26gbE/1dJCwoMRjZl+3ocnpwILSNHhsrsPvmbL+OA7i8KRkdzRwS749kFw+AyGRU+zIMs0IqpEu3Cvja5W+GlSSHk2dtAAHAzXROgMGtgM//srF4OSDAvBar1b+hwBG7O9clZ0kQFPA/7uNuaoRHmfliCorxDTuVNXSMT+ni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253690; c=relaxed/simple;
	bh=tr8ckJxowG6oIYE2ceQ/uX72jL5ReA5i01e/LNRvUeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJa6oy5qFr2M32KT7V3nx1aCWPkvaChiOeh/1pcCQhl9F2+d9yO4J4Fo+KEuWko9Zqwi9g7pUWq0dL6/gusRvdCXNRdmlddonQ7bmwc+7sVVp26cTSllwfI1y3sCgxf4p9cZvE4zmOtybVvEE+xUohWi23SzcJaFleu8z3CZBpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0tW1n14; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0tW1n14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153B01F000C4;
	Sat, 17 Oct 2026 16:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253689;
	bh=uEYxA16XOAuQKd5m/6771ouiIp1Z2qEZyIf8ajwcheo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0tW1n14+JLyBdKt07Wj4/C8WuBK4/eKmylHnoUdtluxlyVFAEiWIJG5v1N8Z3dEd
	 oSB5hmVWoe6BR4jNoPE91b5dlv0PUc4z48XIx2c9KQeT8S9VCeKsBlewT7ZYh3FbC6
	 ciDvaBmm09aURwlZxMk4F2oi5MGOyAF97gi0eLoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ge Yang <yangge1116@126.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	David Hildenbrand <david@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/869] KVM: SEV: Use long-term pin when registering encrypted memory regions
Date: Sat, 17 Oct 2026 17:50:40 +0200
Message-ID: <20261017160042.160710674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ge Yang <yangge1116@126.com>

[ Upstream commit 7e066cb9b71a22c3e5ef233de63ff14525baf6f0 ]

When registering an encrypted memory region for SEV-MEM/SEV-ES guests,
pin the pages with FOLL_TERM so that the pages are migrated out of
MIGRATE_CMA/ZONE_MOVABLE.  Failure to do so violates the CMA/MOVABLE
mechanisms and can result in fragmentation due to unmovable pages, e.g.
can make CMA allocations fail.

Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/1739241423-14326-1-git-send-email-yangge1116@126.com
[sean: massage changelog, make @flags an unsigned int]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: b6408b6cec5d ("KVM: SEV: Protect *all* of sev_mem_enc_register_region() with kvm->lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index eb9c1f9e23bd6..775704fb704ca 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -624,7 +624,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 				    unsigned long ulen, unsigned long *n,
-				    int write)
+				    unsigned int flags)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	unsigned long npages, size;
@@ -668,7 +668,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 		return ERR_PTR(-ENOMEM);
 
 	/* Pin the user virtual address. */
-	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
+	npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		ret = -ENOMEM;
@@ -756,7 +756,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
-	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+	inpages = sev_pin_memory(kvm, vaddr, size, &npages, FOLL_WRITE);
 	if (IS_ERR(inpages))
 		return PTR_ERR(inpages);
 
@@ -1261,7 +1261,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		if (IS_ERR(src_p))
 			return PTR_ERR(src_p);
 
-		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
+		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, FOLL_WRITE);
 		if (IS_ERR(dst_p)) {
 			sev_unpin_memory(kvm, src_p, n);
 			return PTR_ERR(dst_p);
@@ -1328,7 +1328,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
+	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, FOLL_WRITE);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
@@ -1810,7 +1810,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 1);
+				    PAGE_SIZE, &n, FOLL_WRITE);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
@@ -2718,7 +2718,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 		return -ENOMEM;
 
 	mutex_lock(&kvm->lock);
-	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
+	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
+				       FOLL_WRITE | FOLL_LONGTERM);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
 		mutex_unlock(&kvm->lock);
-- 
2.53.0



