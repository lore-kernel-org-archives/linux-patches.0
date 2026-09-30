Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231564F7CBF;
	Wed, 30 Sep 2026 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787886; cv=none; b=uvWgdDlHq6WIfY8qehrvpNDJFhRD4pO7PS5ikoTejtNx749KrlrG/F/AAWnOHu2otrUu8TtqN0KdlBlnuADBIhH1hnPPNF+iRDmDO2dpAE1gcM+Zi+lQ8AbQo4igKZHR75MCvIPkB1M0+t3GqxVzvh6YjDj0NpcSGB/mRnGiACI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787886; c=relaxed/simple;
	bh=+LxHXaxYHEf86j/UYWbAYrpPMd7ERNWPIXMCzzwZqFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpfvqTjb8O7ggy4hPTjks4DzrVLJ1uuLsvalY0XHruPoxF2/zD+xyqFeSmuJ8MGLPSQjbLMscYNZZb570+k/jOrrWdISnyIy2nP6Ei41UIKbXEDsNRY1+iAIZtBKN2XZ55oLox1BjKgFvIx0i5oY2/5Di17ubiaDDAjS7GC70V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IE5LPE9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IE5LPE9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736D31F000FF;
	Wed, 30 Sep 2026 17:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787885;
	bh=o3x1i/p2UmzdWxjYmEJgjPN6KFSRCYEn1QYlaPmk2mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IE5LPE9WjD0okjhepy/HQZJ7MyqJxVsEI38n8v1AvTTqhczYHFr924+Zff+HPc70t
	 qH1mZUQk1mcusfjSvoP9IXzEYdtjdLdwdJ3miOVl6EgzcbEQ3xOLhvSUWapRo+Rfw0
	 p7wTgNUCr7kAbvLgc6yqK0YojPZ87A0iiZAZPbsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 386/457] KVM: SEV: Do cache maintenance on the source VM during intra-host migration
Date: Wed, 30 Sep 2026 17:28:11 +0200
Message-ID: <20260930152354.326709082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 93de2a6a4b91b72607136dd656edf03fb399d27f upstream.

Manually perform cache maintenance on the source VM during intra-host
migration to ensure no stale data is left in CPU caches after the VM is
destroyed.  Because the source VM is "converted" to a non-SEV VM, KVM's
memory reclaim flows won't trigger cache maintenance, e.g. when all guest
memory is reclaimed in response to detaching from the mmu_notifier.

Note, relying on the destination VM to do cache maintenance isn't an option
as KVM doesn't require identical guest memory configurations, i.e. the
source VM may have access to memory that the destination VM does not.
Enforcing equivalent memory configurations is infeasible, as it would
require a *deep* comparison of memslots, e.g. to verify that not only are
the memslot identical, but what the memslots point at is also identical.

Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260923163721.1584779-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2048,6 +2048,12 @@ static void sev_migrate_from(struct kvm
 	src->pages_locked = 0;
 	src->es_active = false;
 
+	/*
+	 * Do cache maintenance on the source VM as it is no longer an SEV VM,
+	 * i.e. memory reclaim flows won't trigger cache maintenance on the VM.
+	 */
+	sev_writeback_caches(src_kvm);
+
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 
 	mutex_lock(&sev_mirror_lock);
@@ -2187,6 +2193,10 @@ int sev_vm_move_enc_context_from(struct
 	 * the set of CPUs from the source.  If a CPU was used to run a vCPU in
 	 * the source VM but is never used for the destination VM, then the CPU
 	 * can only have cached memory that was accessible to the source VM.
+	 * Furthermore, KVM *must* perform cache maintenance on the source VM,
+	 * as the source VM may have access to memory that the destination VM
+	 * does not, i.e. KVM could skip flushes if memory is reclaimed from
+	 * the old VM but not the new VM.
 	 */
 	if (!zalloc_cpumask_var(&dst_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
 		ret = -ENOMEM;


