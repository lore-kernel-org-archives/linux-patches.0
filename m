Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3195481E;
	Mon, 10 Mar 2025 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627824; cv=none; b=flmVO1yJQbOZ5kTjil5PW8eQOStAy86FJ69rnr0UoULpEnpTFW7HkK/hM2MSOlwlY2o0n1wiv988n84WHxhT3VgR6dnvMmhXkbGqbZc/IW9ek2K13KYMSgHH6LQpVq4kaS2kEZpqZb0bL9EXLlzNOWvRzuozevgmY/QD9/n6pNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627824; c=relaxed/simple;
	bh=RDbBa8zBYxXe8hbHimvZVhAzXB7WgMfqHYjsjM1dmcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYLSMrnpMfr3j3rt1PFWaPBpG1DKuITgxYjXIK3cua0/70IOOthJ7LmlxD5RMvWniGlfujdEqqHkbIXdlfAY1RkcSeqPJs6sDJsTcPmbHXjZhwJ5pqAoWZo6FSuSPaq7BUJD2ZMp3g9uqIleiZaG6DK/g5lNe6J4/K/QgyKDTN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEDBOXwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEDBOXwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC5DC4CEE5;
	Mon, 10 Mar 2025 17:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627824;
	bh=RDbBa8zBYxXe8hbHimvZVhAzXB7WgMfqHYjsjM1dmcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEDBOXwd7hcqXlmUHjWPhdXSfo/ZmtJzXpl7fbigPM797WZTFv8nhwfCIame/jH8j
	 m/XBgCzo1HWHh+OhPxYVJV4QUfaUg4efAzeYQiNKRqtEJdaVtw0YwMLZNlx/C413ed
	 Osa3PBxNlKsGLxqTD3tebJDkSF/K6nrNTZACqlDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 263/269] Revert "KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults"
Date: Mon, 10 Mar 2025 18:06:56 +0100
Message-ID: <20250310170508.271128973@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 833f69be62ac366b5c23b4a6434389e470dd5c7f which is
commit 419cfb983ca93e75e905794521afefcfa07988bb upstream.

It should not have been applied.

Link: https://lore.kernel.org/r/CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/e500_mmu_host.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -322,7 +322,6 @@ static inline int kvmppc_e500_shadow_map
 {
 	struct kvm_memory_slot *slot;
 	unsigned long pfn = 0; /* silence GCC warning */
-	struct page *page = NULL;
 	unsigned long hva;
 	int pfnmap = 0;
 	int tsize = BOOK3E_PAGESZ_4K;
@@ -444,7 +443,7 @@ static inline int kvmppc_e500_shadow_map
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
+		pfn = gfn_to_pfn_memslot(slot, gfn);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
@@ -489,6 +488,8 @@ static inline int kvmppc_e500_shadow_map
 		}
 	}
 	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	if (writable)
+		kvm_set_pfn_dirty(pfn);
 
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
@@ -497,7 +498,8 @@ static inline int kvmppc_e500_shadow_map
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	/* Drop refcount on page, so that mmu notifiers can clear it */
+	kvm_release_pfn_clean(pfn);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }


