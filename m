Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D1642A83;
	Wed,  7 May 2025 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643881; cv=none; b=BBxhOa0NpiTL1V0xzx/qe8uSwxg7rY2uv+z3Lo1x8iH2dxcbvn87vJMGh94Q8N1BuhtlsYuKP6F6abHhkPofbuJH/xJ0BNJf4qmzsp5ebAXsnivtmaiY1lkFZZpV1xKuuqxbcyyv24q0pySUZO67ZK6GVa9dVrKghSaIC0cS04w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643881; c=relaxed/simple;
	bh=MRHTCi2/fdkzsvqka8hhNGnnqfavd5JHJI8XYse0Jjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHJJqjpexKv42CAbiyIyuME8K0xO2w0XiBLIlatUXVOZAxzbfiOpQI65Fu75nlOccTjhbecVPJhvbEdrCn+7LUG92UgR/miCq+gM/XdWTXRENH5Y2E32UPbhDhcI4iGr+y8TgEkL9BcALJQGMyGnNcrX9x6FMHjJyl7DHzwEpGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cfw5odDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cfw5odDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5EAC4CEE2;
	Wed,  7 May 2025 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643881;
	bh=MRHTCi2/fdkzsvqka8hhNGnnqfavd5JHJI8XYse0Jjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cfw5odDqrr6l3t1HBWASlo+qKtnqU8Y1XXRuQyPuCBeUi4P9vYb0BBqmuZIXk/t93
	 8O8ifUdfwPFdZeXPtgmi3xIs5/a0ckAPP/paqa+coFgvLyMLfO3yS9WsKRt3FmB4uN
	 O8g1WZyvNideFDJbFgVWMthzp/BTIloLuKna6oYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seth Forshee <sforshee@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 6.14 018/183] perf/x86/intel: KVM: Mask PEBS_ENABLE loaded for guest with vCPUs value.
Date: Wed,  7 May 2025 20:37:43 +0200
Message-ID: <20250507183825.431234008@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 58f6217e5d0132a9f14e401e62796916aa055c1b upstream.

When generating the MSR_IA32_PEBS_ENABLE value that will be loaded on
VM-Entry to a KVM guest, mask the value with the vCPU's desired PEBS_ENABLE
value.  Consulting only the host kernel's host vs. guest masks results in
running the guest with PEBS enabled even when the guest doesn't want to use
PEBS.  Because KVM uses perf events to proxy the guest virtual PMU, simply
looking at exclude_host can't differentiate between events created by host
userspace, and events created by KVM on behalf of the guest.

Running the guest with PEBS unexpectedly enabled typically manifests as
crashes due to a near-infinite stream of #PFs.  E.g. if the guest hasn't
written MSR_IA32_DS_AREA, the CPU will hit page faults on address '0' when
trying to record PEBS events.

The issue is most easily reproduced by running `perf kvm top` from before
commit 7b100989b4f6 ("perf evlist: Remove __evlist__add_default") (after
which, `perf kvm top` effectively stopped using PEBS).	The userspace side
of perf creates a guest-only PEBS event, which intel_guest_get_msrs()
misconstrues a guest-*owned* PEBS event.

Arguably, this is a userspace bug, as enabling PEBS on guest-only events
simply cannot work, and userspace can kill VMs in many other ways (there
is no danger to the host).  However, even if this is considered to be bad
userspace behavior, there's zero downside to perf/KVM restricting PEBS to
guest-owned events.

Note, commit 854250329c02 ("KVM: x86/pmu: Disable guest PEBS temporarily
in two rare situations") fixed the case where host userspace is profiling
KVM *and* userspace, but missed the case where userspace is profiling only
KVM.

Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Closes: https://lore.kernel.org/all/Z_VUswFkWiTYI0eD@do-x1carbon
Reported-by: Seth Forshee <sforshee@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250426001355.1026530-1-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4341,7 +4341,7 @@ static struct perf_guest_switch_msr *int
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
 		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
-		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
+		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask & kvm_pmu->pebs_enable,
 	};
 
 	if (arr[pebs_enable].host) {


