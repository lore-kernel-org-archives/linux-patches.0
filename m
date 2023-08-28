Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C43611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79494C433C8;
	Mon, 28 Aug 2023 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219470;
	bh=3b4Q/kkIdK6d5Y7FFSTuJcMifcoIb076xmA3XYGfBII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OFYoFFHbFkPW2F0z6Cic2FnqyqrYWoNZqTzDuiyFH5KRSVQ2YP1MJtleawz5gZyt
	 t1AkL9QJJ0mzBOwVFgJdwTt/9TYmcWxzCEN9eSTTjB1YxZ7IqpUub0aOMyL2EagLD7
	 iL5foaMEFyxQ1eUBkYcY7y79qpdNR4PaeJRunMm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 46/89] Revert "KVM: x86: enable TDP MMU by default"
Date: Mon, 28 Aug 2023 12:13:47 +0200
Message-ID: <20230828101151.724186987@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

This reverts commit 71ba3f3189c78f756a659568fb473600fd78f207.

Disable the TDP MMU by default in v5.15 kernels to "fix" several severe
performance bugs that have since been found and fixed in the TDP MMU, but
are unsuitable for backporting to v5.15.

The problematic bugs are fixed by upstream commit edbdb43fc96b ("KVM:
x86: Preserve TDP MMU roots until they are explicitly invalidated") and
commit 01b31714bd90 ("KVM: x86: Do not unload MMU roots when only toggling
CR0.WP with TDP enabled").  Both commits fix scenarios where KVM will
rebuild all TDP MMU page tables in paths that are frequently hit by
certain guest workloads.  While not exactly common, the guest workloads
are far from rare.  The fallout of rebuilding TDP MMU page tables can be
so severe in some cases that it induces soft lockups in the guest.

Commit edbdb43fc96b would require _significant_ effort and churn to
backport due it depending on a major rework that was done in v5.18.

Commit 01b31714bd90 has far fewer direct conflicts, but has several subtle
_known_ dependencies, and it's unclear whether or not there are more
unknown dependencies that have been missed.

Lastly, disabling the TDP MMU in v5.15 kernels also fixes a lurking train
wreck started by upstream commit a955cad84cda ("KVM: x86/mmu: Retry page
fault if root is invalidated by memslot update").  That commit was tagged
for stable to fix a memory leak, but didn't cherry-pick cleanly and was
never backported to v5.15.  Which is extremely fortunate, as it introduced
not one but two bugs, one of which was fixed by upstream commit
18c841e1f411 ("KVM: x86: Retry page fault if MMU reload is pending and
root has no sp"), while the other was unknowingly fixed by upstream
commit ba6e3fe25543 ("KVM: x86/mmu: Grab mmu_invalidate_seq in
kvm_faultin_pfn()") in v6.3 (a one-off fix will be made for v6.1 kernels,
which did receive a backport for a955cad84cda).  Disabling the TDP MMU
by default reduces the probability of breaking v5.15 kernels by
backporting only a subset of the fixes.

As far as what is lost by disabling the TDP MMU, the main selling point of
the TDP MMU is its ability to service page fault VM-Exits in parallel,
i.e. the main benefactors of the TDP MMU are deployments of large VMs
(hundreds of vCPUs), and in particular delployments that live-migrate such
VMs and thus need to fault-in huge amounts of memory on many vCPUs after
restarting the VM after migration.

Smaller VMs can see performance improvements, but nowhere enough to make
up for the TDP MMU (in v5.15) absolutely cratering performance for some
workloads.  And practically speaking, anyone that is deploying and
migrating VMs with hundreds of vCPUs is likely rolling their own kernel,
not using a stock v5.15 series kernel.

Link: https://lore.kernel.org/all/ZDmEGM+CgYpvDLh6@google.com
Link: https://lore.kernel.org/all/f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com
Acked-by: Mathias Krause <minipli@grsecurity.net>
Acked-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -10,7 +10,7 @@
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
-static bool __read_mostly tdp_mmu_enabled = true;
+static bool __read_mostly tdp_mmu_enabled = false;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
 
 /* Initializes the TDP MMU for the VM, if enabled. */


