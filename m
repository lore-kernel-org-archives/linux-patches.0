Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57077277804;
	Wed, 30 Jul 2025 09:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868963; cv=none; b=fMh8l3hAQy2z6A3bvBizRnmIilJiVgc/oOdE7XVcybHYWNv7S8YdfBMcHelRGY8fI3mBBLcf4EHZnejJkBr7Ue3bWuuWq09oPn+iLPw6SKAaPRK4goEl/4wXC5CP5W7bcBvjf7xsUi7jhb+k6D4j2Mkta+yQakZWrrpgnSlQ9Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868963; c=relaxed/simple;
	bh=BpKrVsk/uDWPn158FLk+cNNfujGBXiBPATUCQUcVExU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJ8tntiTNw4Ufe0Tp1EBwVnT+zrDpK0gLVggv/9+LkcUuzqvZvEQfqzuB5RxMm9iaOEF3GU6nUq0sHoQH9hCkX2e61Kx5INQ+ujJRibgCao8OuJFJHp3ByStopjKxn25HiUzHbHzU/1MEZmLdy7ZgkJrOxw3L/AckNj0BTXfm60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G85chA1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G85chA1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FF8C4CEF9;
	Wed, 30 Jul 2025 09:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868963;
	bh=BpKrVsk/uDWPn158FLk+cNNfujGBXiBPATUCQUcVExU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G85chA1OCHkMa6g6LeU6AxS/yKPExUZu0yHO64KoKPTYq/kmGj2a7U+sG9a8eMWrY
	 43bS7H7v3fY5IBdQ8s+LGQVYcYWqITkr8XAwboat9GtLjG6z415QvHIrm/OkiEdJRP
	 +kmF+8ZDBZYwrxM4BKHEfqL7kt0T+nIGhQaRIudQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Andreas <manuel.andreas@tum.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/117] KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush
Date: Wed, 30 Jul 2025 11:36:09 +0200
Message-ID: <20250730093237.690145102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Manuel Andreas <manuel.andreas@tum.de>

[ Upstream commit fa787ac07b3ceb56dd88a62d1866038498e96230 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1980,6 +1980,9 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcp
 		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
 			goto out_flush_all;
 
+		if (is_noncanonical_invlpg_address(entries[i], vcpu))
+			continue;
+
 		/*
 		 * Lower 12 bits of 'address' encode the number of additional
 		 * pages to flush.


