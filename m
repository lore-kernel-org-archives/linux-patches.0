Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500F72144B3;
	Tue, 12 Nov 2024 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408445; cv=none; b=b1XYyOH/rXn1RcsQD/yzdiBb4VNET1M7XKgOH8YFNXhykduy9QwgvQ+5quHH0S5Et6H6Hg7UN9ZkdW42zrG0wh+UuCmK4zitjUNGp2hVMBmiPSeyS5diQUzjb5nQRDDO2xgn0aHa63WxbDaLGnhgs5Y8vViMIqb+MZo2btyr3DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408445; c=relaxed/simple;
	bh=OX9d+QvrjL1DiAsBBgmO8cf94O5M7BioQmXeYDllHTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Age3do1Bw1lXLCshsp1kufOVeJzPBcLqmwnFbK/ATd9mQI4a9Ht7BNSCHTAFsj0L8JWaJjg5jSxjkBLKAPdGkFfDDpqLTrLN09zVySXK+IW9XsQUFQfnELe2V4CIU8M2CV0aqtnZQ6efb9ILVwKWPZgSYsmfIY4JJ8aH+UPeHdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQAIDq0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQAIDq0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B07C4CECD;
	Tue, 12 Nov 2024 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408445;
	bh=OX9d+QvrjL1DiAsBBgmO8cf94O5M7BioQmXeYDllHTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQAIDq0YXWtFbaSxgNAjfeKnv7O3n2nlvOchqtNLT1owMWbT73wsX4wKq59Od0Q/5
	 69lHmT2nk2u/ZjXIZ9Ry6AvTpA0KvU8rVnvZTL0GWGMB11Q8QVWYg1XqfM7Nphh01W
	 YfoMdRc6Gx1RaPAF+OpLu9/Z9sU9boGSJdYw5Srw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.11 133/184] KVM: PPC: Book3S HV: Mask off LPCR_MER for a vCPU before running it to avoid spurious interrupts
Date: Tue, 12 Nov 2024 11:21:31 +0100
Message-ID: <20241112101905.972164045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautam Menghani <gautam@linux.ibm.com>

commit a373830f96db288a3eb43a8692b6bcd0bd88dfe1 upstream.

Running a L2 vCPU (see [1] for terminology) with LPCR_MER bit set and no
pending interrupts results in that L2 vCPU getting an infinite flood of
spurious interrupts. The 'if check' in kvmhv_run_single_vcpu() sets the
LPCR_MER bit if there are pending interrupts.

The spurious flood problem can be observed in 2 cases:
1. Crashing the guest while interrupt heavy workload is running
  a. Start a L2 guest and run an interrupt heavy workload (eg: ipistorm)
  b. While the workload is running, crash the guest (make sure kdump
     is configured)
  c. Any one of the vCPUs of the guest will start getting an infinite
     flood of spurious interrupts.

2. Running LTP stress tests in multiple guests at the same time
   a. Start 4 L2 guests.
   b. Start running LTP stress tests on all 4 guests at same time.
   c. In some time, any one/more of the vCPUs of any of the guests will
      start getting an infinite flood of spurious interrupts.

The root cause of both the above issues is the same:
1. A NMI is sent to a running vCPU that has LPCR_MER bit set.
2. In the NMI path, all registers are refreshed, i.e, H_GUEST_GET_STATE
   is called for all the registers.
3. When H_GUEST_GET_STATE is called for LPCR, the vcpu->arch.vcore->lpcr
   of that vCPU at L1 level gets updated with LPCR_MER set to 1, and this
   new value is always used whenever that vCPU runs, regardless of whether
   there was a pending interrupt.
4. Since LPCR_MER is set, the vCPU in L2 always jumps to the external
   interrupt handler, and this cycle never ends.

Fix the spurious flood by masking off the LPCR_MER bit before running a
L2 vCPU to ensure that it is not set if there are no pending interrupts.

[1] Terminology:
1. L0 : PAPR hypervisor running in HV mode
2. L1 : Linux guest (logical partition) running on top of L0
3. L2 : KVM guest running on top of L1

Fixes: ec0f6639fa88 ("KVM: PPC: Book3S HV nestedv2: Ensure LPCR_MER bit is passed to the L0")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4892,6 +4892,18 @@ int kvmhv_run_single_vcpu(struct kvm_vcp
 							   BOOK3S_INTERRUPT_EXTERNAL, 0);
 			else
 				lpcr |= LPCR_MER;
+		} else {
+			/*
+			 * L1's copy of L2's LPCR (vcpu->arch.vcore->lpcr) can get its MER bit
+			 * unexpectedly set - for e.g. during NMI handling when all register
+			 * states are synchronized from L0 to L1. L1 needs to inform L0 about
+			 * MER=1 only when there are pending external interrupts.
+			 * In the above if check, MER bit is set if there are pending
+			 * external interrupts. Hence, explicity mask off MER bit
+			 * here as otherwise it may generate spurious interrupts in L2 KVM
+			 * causing an endless loop, which results in L2 guest getting hung.
+			 */
+			lpcr &= ~LPCR_MER;
 		}
 	} else if (vcpu->arch.pending_exceptions ||
 		   vcpu->arch.doorbell_request ||


