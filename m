Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77F73939A4;
	Sat, 17 Oct 2026 17:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258431; cv=none; b=A6RDWfvq3tjURmUCqXYF5OgIvLkpeSdBRahCS3etRnpBo7DiNjzknAyTWpECFG9aIbI86QmOfAgfu0nmyoDLWtn5cQGiacBuykTQVHP9ru3mZqPHwM73gFQETfqNM55WWJbr34LYd01WLFE08uruOT+QfhtyAflcPzFN+57LDdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258431; c=relaxed/simple;
	bh=IwgUfOO3kuKAnN5iKMopJ6Nw1j8n40thTkkMd7SGqWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq0H1u7A60T4PalWaKh/W5/GJM2hyaGJ8RFEKDC9vN+hAP1EoP3+CbDsx9pnCYl/8LdTfg7TowNoebC59yZHD7WJPs9zzCqvmjrVHb2l7HkM3RPrYagyliNp8q5QFLZjS0xcpvLp9+uv3CFLlUTM+E/WipkAUCOeMFk1FkqIJ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUjI0o7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUjI0o7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F328E1F000C4;
	Sat, 17 Oct 2026 17:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258430;
	bh=mK7ngR52C/IblSPYbZofWaNIMvulf60zP4L1bMe4PV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUjI0o7ausJURic/Yr1qZtx5lbcYqAS7NfxIP0wzPWfUQI7LQkXL6hMNWnk5u55AS
	 Qg0Ix0rQJ7h17YCCFEVsNjW6UY0B9Y5BIOqjY2a0ruZTRlTT42/FzmJqVlFLe0zMRR
	 a4uqPo4Cax7DFg880y3B7QQiRnTK27V06vesq8EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ge Yang <yangge1116@126.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	David Hildenbrand <david@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0880/1674] KVM: SEV: Use long-term pin when registering encrypted memory regions
Date: Sat, 17 Oct 2026 17:52:32 +0200
Message-ID: <20261017160453.705720339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 0ba286bd50c27..7ed6f71f49de6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -401,7 +401,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 				    unsigned long ulen, unsigned long *n,
-				    int write)
+				    unsigned int flags)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	unsigned long npages, size;
@@ -445,7 +445,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 		return ERR_PTR(-ENOMEM);
 
 	/* Pin the user virtual address. */
-	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
+	npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		ret = -ENOMEM;
@@ -533,7 +533,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
-	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+	inpages = sev_pin_memory(kvm, vaddr, size, &npages, FOLL_WRITE);
 	if (IS_ERR(inpages))
 		return PTR_ERR(inpages);
 
@@ -985,7 +985,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		if (IS_ERR(src_p))
 			return PTR_ERR(src_p);
 
-		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
+		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, FOLL_WRITE);
 		if (IS_ERR(dst_p)) {
 			sev_unpin_memory(kvm, src_p, n);
 			return PTR_ERR(dst_p);
@@ -1052,7 +1052,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
 		return -EFAULT;
 
-	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
+	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, FOLL_WRITE);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
@@ -1534,7 +1534,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 1);
+				    PAGE_SIZE, &n, FOLL_WRITE);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
@@ -1999,7 +1999,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
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



