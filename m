Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC754C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FA3C433D6;
	Mon, 14 Nov 2022 13:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431275;
	bh=uk2rUXfvKEHZmXIU1t1q/MTJBpxeGB/JKi5uA+D+Zoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz2snKCcouVWxb8jiJCnWNpJ6+Db/c3zp1ApIZvg5TkCMEMD0MG+jruFmpR+HehE3
	 gPQY/whwFlmIk7k/SXVWs5aWSAuL93V3Y+OaZQHvv/G5lzfh9ZWY1BEnNKtwmpsSTc
	 g9EYT4UKtG9FfLlbQGaNboh81wiZflREZVDESTzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 165/190] KVM: x86/mmu: Block all page faults during kvm_zap_gfn_range()
Date: Mon, 14 Nov 2022 13:46:29 +0100
Message-Id: <20221114124506.052191739@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit 6d3085e4d89ad7e6c7f1c6cf929d903393565861 upstream.

When zapping a GFN range, pass 0 => ALL_ONES for the to-be-invalidated
range to effectively block all page faults while the zap is in-progress.
The invalidation helpers take a host virtual address, whereas zapping a
GFN obviously provides a guest physical address and with the wrong unit
of measurement (frame vs. byte).

Alternatively, KVM could walk all memslots to get the associated HVAs,
but thanks to SMM, that would require multiple lookups.  And practically
speaking, kvm_zap_gfn_range() usage is quite rare and not a hot path,
e.g. MTRR and CR0.CD are almost guaranteed to be done only on vCPU0
during boot, and APICv inhibits are similarly infrequent operations.

Fixes: edb298c663fc ("KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range")
Reported-by: Chao Peng <chao.p.peng@linux.intel.com>
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221111001841.2412598-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6044,7 +6044,7 @@ void kvm_zap_gfn_range(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 
-	kvm_mmu_invalidate_begin(kvm, gfn_start, gfn_end);
+	kvm_mmu_invalidate_begin(kvm, 0, -1ul);
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
@@ -6058,7 +6058,7 @@ void kvm_zap_gfn_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
 						   gfn_end - gfn_start);
 
-	kvm_mmu_invalidate_end(kvm, gfn_start, gfn_end);
+	kvm_mmu_invalidate_end(kvm, 0, -1ul);
 
 	write_unlock(&kvm->mmu_lock);
 }


