Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F823769FD;
	Thu, 30 Jul 2026 15:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426965; cv=none; b=dJDx5bwnywpgaXGnfmsEo18kZWD4GukO+ACR+iKa5nYYECgrJ/kZRSDgr58bH2KFkPiOj8cViobqqWbfPt4brFrF329s47ibZvzK2JEveTgdEBUl7xUQENfHyJfhgM3GargeQm8M3TZmfEn/Q7n1uRU4NKJCv1cf5fgjqQQ3M3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426965; c=relaxed/simple;
	bh=eKryvKjrpgT29kIgpkcqMVm7QSx5bLSqQQCPkRUvOLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PqxK2tMgppmjAU7U0SPkH2vy6EC+BN3xWPoNBkKvVjZ4D0fTaU+4y+IqjjrYLqf2IjKcdWdXKVkUTvXWUAEfUPDJ1e3LP1X7RLD/RWJeKt8IjF1oyAuqLqvO3KGTcfmTwij0FA5y9UuGOexDhI1ZSUGuywu4W1ACSM5WHqnkJI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBE3RhE9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBE3RhE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A851F000E9;
	Thu, 30 Jul 2026 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426964;
	bh=F3FtRIeWm2C8sfMGPAhHmBF2lVSG+7vbIIrGgpEtGa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBE3RhE9sgYXiKoJedGV8xSTknnwaBDVhGvBFMipYI7m5l8VwNZd709869MQuSSMJ
	 rb+K2HLnAsZyiV4Lijh1j1uIb1L/g71V/FW9V6gMi1GGpNJDdwRoCdpANwCV8ceS11
	 wQziilgJLq3pPGwR1JWymqovhO+rQBmcwBgCHvE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Silveru <Chandrakanth.Silveru@amd.com>,
	Srikanth Aithal <Srikanth.Aithal@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 602/602] KVM: SVM: Bump asid_generation on CPU online to avoid ASID collision after hotplug
Date: Thu, 30 Jul 2026 16:16:34 +0200
Message-ID: <20260730141448.704529049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikunj A Dadhania <nikunj@amd.com>

commit 25f744ffa0c8e799e06250ce2e618367b166b0d4 upstream.

If a vCPU stays scheduled out (or blocked) while the last pCPU it ran
on goes through a hotplug cycle (online->offline->online), and the vCPU
then resumes execution on the same pCPU, then it is possible for it to
run with an ASID that has now been assigned to a different vCPU,
resulting in stale TLB translations being used.

svm_enable_virtualization_cpu() resets asid_generation to 1 and sets
next_asid to max_asid + 1 on every CPU online event, including hotplug
cycles.  Because next_asid starts beyond the pool boundary, the first
call to new_asid() after an online event always wraps the pool,
incrementing asid_generation to 2 and assigning ASIDs starting from
min_asid.

Consider two vCPUs from different VMs, vCPU-A pinned to CPU-X holding
asid_generation=2 and ASID=N from before the hotplug event:

  1. CPU-X goes offline and back online: asid_generation resets to 1,
     next_asid = max_asid + 1.

  2. One or more vCPUs migrate to CPU-X and call new_asid(), wrapping
     the pool and consuming ASIDs starting from min_asid.  Eventually
     vCPU-B from a different VM is assigned asid_generation=2, ASID=N
     — the same ASID that vCPU-A held before the hotplug.

  3. vCPU-A enters pre_svm_run() on CPU-X: current_vmcb->cpu is
     unchanged so the migration branch is skipped.  Its saved
     asid_generation=2 matches sd->asid_generation=2, so the generation
     check silently passes and vCPU-A continues running with ASID=N —
     the same ASID just freshly assigned to vCPU-B.

Both vCPUs from different VMs now run on CPU-X with the same ASID,
causing them to share NPT TLB entries and producing stale translations.

The collision manifests as a KVM internal error (Suberror: 1, emulation
failure).  The NPT page fault reports a faulting GPA far outside the
VM's physical memory range — a sign of stale TLB translations being
used.  KVM falls back to instruction emulation, which fails on
FPU/XSave instructions (XRSTOR, STMXCSR) that the emulator does not
implement.

Fix this by incrementing asid_generation instead of resetting it to 1
in svm_enable_virtualization_cpu().  On module load, asid_generation
starts at 0 (memset) and the increment produces 1, identical to the
old behaviour.  On subsequent hotplug cycles the generation advances
beyond any value a vCPU previously observed on this CPU, so the
generation check in pre_svm_run() reliably forces new_asid() on every
vCPU after every hotplug cycle.

Fixes: 774c47f1d78e ("[PATCH] KVM: cpu hotplug support")
Reported-by: Chandrakanth Silveru <Chandrakanth.Silveru@amd.com>
Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Message-ID: <20260715063506.672432-1-nikunj@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -626,7 +626,12 @@ static int svm_enable_virtualization_cpu
 		return -EBUSY;
 
 	sd = per_cpu_ptr(&svm_data, me);
-	sd->asid_generation = 1;
+	/*
+	 * Bump the current asid_generation value to ensure any vCPU that
+	 * previously ran on this CPU sees a stale generation and is forced
+	 * to acquire a new ASID, preventing a latent ASID collision.
+	 */
+	sd->asid_generation++;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	sd->next_asid = sd->max_asid + 1;
 	sd->min_asid = max_sev_asid + 1;


