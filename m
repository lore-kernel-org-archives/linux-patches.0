Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170F933263A;
	Tue, 16 Jun 2026 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623676; cv=none; b=iYgkYUYiY+/E2Xxj4c3RZdX/yc/cV89UUphdC0cnPb1XEQPHHVrBXo8ziiCSxXzcuGNUqDXaGTb+yudjgxCmVe7yaAUWsgDv09G2gpbx3W1WB7wF0mdgYXxH4HmOmbbTHdsL6tP83n3hcmQHA9Mi4LIrHEOM27b88HMXJbw9UIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623676; c=relaxed/simple;
	bh=BstF6N8C3bLlTfFLSEW6P5+eRcOv6cKfuykueuD447g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akRALFcjNc6LK2VwJerrl5PknXIF3pVa52tUPwLeqGiwmmzs7zgb9arcviWSp0Nh+ptSFRG7nVTm07kdFM5dbFDU3o4fJB6am7MKTsVUq1rSxICqR7vFY8QWaCJ5eBhlDHz5/hrEPPJyiQjH2/tXg6RqazXlNAJaC6rDzjPBr/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJhI5ncu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJhI5ncu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C4E1F00A3A;
	Tue, 16 Jun 2026 15:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623675;
	bh=5JsiIoMoVv+BYRk3H5is0VK+seJVgDOT0rN0HegnjVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJhI5ncu0w0BouJ3oPwjRaZIfRlr4z6gunWj+aeAZUAC1NP/khjBNcPeck2ozkUrJ
	 r1+k1eDB5kk+ViGyrGJKzcJi/577yp+AM1QiB7b+egcx+YWoP3/Uf3sKSaes0eYhcg
	 VH11PZ+5FbNglgogZlmCNU7bBfx9i3RfX5FoZja4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.0 195/378] KVM: Dont WARN if memory is dirtied without a vCPU when the VM is dying
Date: Tue, 16 Jun 2026 20:27:06 +0530
Message-ID: <20260616145120.646925781@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 8618004d3e897c0f1b71d9a9ab860461289bb89a upstream.

When marking a page dirty, complain about not having a running/loaded vCPU
if and only if the VM is still alive, i.e. its refcount is non-zero.  This
will allow fixing a memory leak for x86 SEV-ES guests without hitting what
is effectively a false positive on the WARN.

For some SEV-ES VM-Exits, KVM keeps a writable mapping of a guest page
across an exit to userspace, and typically unmaps the page on the next
KVM_RUN.  But if userspace never calls KVM_RUN after such an exit, then KVM
needs to unmap the page when the vCPU is destroyed, which in turn triggers
the WARN about not having a running vCPU.

Alternatively, SEV-ES could temporarily load the vCPU to suppress the WARN,
as is done in nested_vmx_free_vcpu() (but for completely unrelated reasons;
suppressing WARN from nested_put_vmcs12_pages() is pure happenstance).  But
loading a vCPU during destruction is gross (ideally nVMX code would be
cleaned up), risks complicating the SEV-ES code (KVM would need to ensure
the temporarily load()+put() only runs when the vCPU isn't already loaded),
and is ultimately pointless.

The motivation for the WARN is to guard against KVM dirtying guest memory
without pushing the corresponding GFN to the active vCPU's dirty ring, e.g.
to ensure userspace doesn't miss a dirty page.  But for the VM's refcount
to reach zero, there can't be _any_ userspace mappings to the dirty ring,
as mapping the dirty ring requires doing mmap() on the vCPU FD.  I.e. if
userspace had a valid mapping for the dirty ring, then the vCPU file and
thus the owning VM would still be alive.  And so since userspace can't
possibly reach the dirty ring, whether or not KVM technically "misses" a
push to the dirty ring is irrelevant.

Reported-by: Michael Roth <michael.roth@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-15-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20260529183549.1104619-15-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3527,7 +3527,8 @@ void mark_page_dirty_in_slot(struct kvm
 	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
 		return;
 
-	WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
+	WARN_ON_ONCE(!vcpu && refcount_read(&kvm->users_count) &&
+		     !kvm_arch_allow_write_without_running_vcpu(kvm));
 #endif
 
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {


