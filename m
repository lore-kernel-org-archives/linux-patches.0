Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2708462;
	Tue, 15 Jul 2025 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586883; cv=none; b=dJEAAWBjIk3NA19zkM+WDTMlXl9tIiAFAelYxLfQXHNq0ZFbUtXttYtEBf1wCc4+h5i18q3PVrdJhya8UcQwZox6rbb0UgItOtIO3/9c5c6bcjDkRnmJ39HguUxz4pG+VQsQbUmb9/x3c/RYYn3y3YjGRe3qyhoH/oPit9DfxO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586883; c=relaxed/simple;
	bh=9s3m8t/Wayix23M8FY05Zj6J8H6EQ9z9e/d20AoI4OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfJTGeG27Vp20GgpyWw/syciDkOw437AEyllPdvK3gB//yKw0JWAbKd3A+V9m96a8RRI4KZXyR8kFkOyDQLTqjXkICIS5cmVLVXJ8dyzloD2nHY3teFykutRzjLrPUvSdXBMYIv3BT1lAaYzIMnjadz3tjZhglPSueSBRKbBPbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtMmQzZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtMmQzZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B11FC4CEE3;
	Tue, 15 Jul 2025 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586883;
	bh=9s3m8t/Wayix23M8FY05Zj6J8H6EQ9z9e/d20AoI4OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtMmQzZydFo+aUVJv2znlCvRX2bAFvhQpAzAaoQRQUdrz3mT45yD0ZXVF+hFkU7/6
	 lbm5omtsGLt+Ja7bParZeIlB3gIi1KF+Kl3tHsz0D6P6W4YIpNPcuvZugVaJpFb1rQ
	 NUmdkEku3KkV1bv2IL12pIJ5EfleV/WFocyjFhI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Andreas <manuel.andreas@tum.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.15 057/192] KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush
Date: Tue, 15 Jul 2025 15:12:32 +0200
Message-ID: <20250715130817.126618818@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Andreas <manuel.andreas@tum.de>

commit fa787ac07b3ceb56dd88a62d1866038498e96230 upstream.

In KVM guests with Hyper-V hypercalls enabled, the hypercalls
HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX
allow a guest to request invalidation of portions of a virtual TLB.
For this, the hypercall parameter includes a list of GVAs that are supposed
to be invalidated.

However, when non-canonical GVAs are passed, there is currently no
filtering in place and they are eventually passed to checked invocations of
INVVPID on Intel / INVLPGA on AMD.  While AMD's INVLPGA silently ignores
non-canonical addresses (effectively a no-op), Intel's INVVPID explicitly
signals VM-Fail and ultimately triggers the WARN_ONCE in invvpid_error():

  invvpid failed: ext=0x0 vpid=1 gva=0xaaaaaaaaaaaaa000
  WARNING: CPU: 6 PID: 326 at arch/x86/kvm/vmx/vmx.c:482
  invvpid_error+0x91/0xa0 [kvm_intel]
  Modules linked in: kvm_intel kvm 9pnet_virtio irqbypass fuse
  CPU: 6 UID: 0 PID: 326 Comm: kvm-vm Not tainted 6.15.0 #14 PREEMPT(voluntary)
  RIP: 0010:invvpid_error+0x91/0xa0 [kvm_intel]
  Call Trace:
    vmx_flush_tlb_gva+0x320/0x490 [kvm_intel]
    kvm_hv_vcpu_flush_tlb+0x24f/0x4f0 [kvm]
    kvm_arch_vcpu_ioctl_run+0x3013/0x5810 [kvm]

Hyper-V documents that invalid GVAs (those that are beyond a partition's
GVA space) are to be ignored.  While not completely clear whether this
ruling also applies to non-canonical GVAs, it is likely fine to make that
assumption, and manual testing on Azure confirms "real" Hyper-V interprets
the specification in the same way.

Skip non-canonical GVAs when processing the list of address to avoid
tripping the INVVPID failure.  Alternatively, KVM could filter out "bad"
GVAs before inserting into the FIFO, but practically speaking the only
downside of pushing validation to the final processing is that doing so
is suboptimal for the guest, and no well-behaved guest will request TLB
flushes for non-canonical addresses.

Fixes: 260970862c88 ("KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently")
Cc: stable@vger.kernel.org
Signed-off-by: Manuel Andreas <manuel.andreas@tum.de>
Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/c090efb3-ef82-499f-a5e0-360fc8420fb7@tum.de
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1979,6 +1979,9 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcp
 		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
 			goto out_flush_all;
 
+		if (is_noncanonical_invlpg_address(entries[i], vcpu))
+			continue;
+
 		/*
 		 * Lower 12 bits of 'address' encode the number of additional
 		 * pages to flush.


