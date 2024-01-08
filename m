Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579D34B5AB;
	Mon,  8 Jan 2024 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRMEvjGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664A2C433C8;
	Mon,  8 Jan 2024 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726584;
	bh=cgcPX4TSqWPiPyRsd47my3sKnI0wuKC2614VqjbsEZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRMEvjGgecUj45BzzsWuDiWUNCO5mop8LWluVIlP8J6sKL/TUpKXOIGGOXWm8jGFP
	 3gBWtE1Ha8J1zDmMs8ajbJNHafbcQlX4oaqgJq1ctnIE4KH7ekRGp3boZgnZUpj0DJ
	 jasE/axsdnF1iMPRaEWlix+TAcgQfBtRLYUzhzfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 014/124] KVM: x86/pmu: fix masking logic for MSR_CORE_PERF_GLOBAL_CTRL
Date: Mon,  8 Jan 2024 16:07:20 +0100
Message-ID: <20240108150603.633383461@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 971079464001c6856186ca137778e534d983174a upstream.

When commit c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE
MSR emulation for extended PEBS") switched the initialization of
cpuc->guest_switch_msrs to use compound literals, it screwed up
the boolean logic:

+	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
...
-	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
+               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),

Before the patch, the value of arr[0].guest would have been intel_ctrl &
~cpuc->intel_ctrl_host_mask & ~pebs_mask.  The intent is to always treat
PEBS events as host-only because, while the guest runs, there is no way
to tell the processor about the virtual address where to put PEBS records
intended for the host.

Unfortunately, the new expression can be expanded to

	(intel_ctrl & ~cpuc->intel_ctrl_host_mask) | (intel_ctrl & ~pebs_mask)

which makes no sense; it includes any bit that isn't *both* marked as
exclude_guest and using PEBS.  So, reinstate the old logic.  Another
way to write it could be "intel_ctrl & ~(cpuc->intel_ctrl_host_mask |
pebs_mask)", presumably the intention of the author of the faulty.
However, I personally find the repeated application of A AND NOT B to
be a bit more readable.

This shows up as guest failures when running concurrent long-running
perf workloads on the host, and was reported to happen with rcutorture.
All guests on a given host would die simultaneously with something like an
instruction fault or a segmentation violation.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Analyzed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4062,12 +4062,17 @@ static struct perf_guest_switch_msr *int
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
 	int global_ctrl, pebs_enable;
 
+	/*
+	 * In addition to obeying exclude_guest/exclude_host, remove bits being
+	 * used for PEBS when running a guest, because PEBS writes to virtual
+	 * addresses (not physical addresses).
+	 */
 	*nr = 0;
 	global_ctrl = (*nr)++;
 	arr[global_ctrl] = (struct perf_guest_switch_msr){
 		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
 		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
-		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
+		.guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask & ~pebs_mask,
 	};
 
 	if (!x86_pmu.pebs)


