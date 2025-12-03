Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4BA312810;
	Wed,  3 Dec 2025 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776210; cv=none; b=trdtIpSQNxhdTk03lIQmVeOCUhRiL1nkrmMX8elL7l48DQQQZHW39YgDxKIJezOwj0qaA+UXHm+LkjIMhv4QwpKAStLv3mjGel7L3oyvai1Iqjf9FoJxr3MKQR5eAk5t12bdP6EQOzIZoKeSbfXtIx4VcLRDhBctgYsCjuTNKbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776210; c=relaxed/simple;
	bh=CGbuOZaVa/D2I78xTLje7HoM+gAlZWcnIlYREnfm2ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I73+/iB3YxFYJa6bG1SaxOqXXnHvsNrk53k5g8kKXtu2YVDcSU97GN2TobBrYimFLZBOstXLVURuNOTwSYgX4kR7sj9r94NutN+doxQDOE9sUPoBqqFou18I6/LYC4OCi9r+lSC83IpbP5D3fiHW4FrGKRr+0X5HDfn9xmfncVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJvNiHbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJvNiHbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DFCC4CEF5;
	Wed,  3 Dec 2025 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776209;
	bh=CGbuOZaVa/D2I78xTLje7HoM+gAlZWcnIlYREnfm2ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJvNiHbxro65XSuViRn0JUXeiSalDbKgxh7PUSHoUI5KqhhEi0Az3rRY+nhUeFSRz
	 d4wc9xTq/pFr0YYY+XTEt25HqeUaN6DyK8rf1Tak407v5oIkGl4cHUDwUdLmHupVWb
	 KtiYIRumIqkLlfYuNQOkuj2kcqCyCmDin+pYntWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Sean Christopherson <seanjc@google.com>,
	Wangyang Guo <wangyang.guo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/300] x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT
Date: Wed,  3 Dec 2025 16:25:18 +0100
Message-ID: <20251203152404.843911850@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 960550503965094b0babd7e8c83ec66c8a763b0b ]

The commit b2798ba0b876 ("KVM: X86: Choose qspinlock when dedicated
physical CPUs are available") states that when PV_DEDICATED=1
(vCPU has dedicated pCPU), qspinlock should be preferred regardless of
PV_UNHALT.  However, the current implementation doesn't reflect this: when
PV_UNHALT=0, we still use virt_spin_lock() even with dedicated pCPUs.

This is suboptimal because:
1. Native qspinlocks should outperform virt_spin_lock() for dedicated
   vCPUs irrespective of HALT exiting
2. virt_spin_lock() should only be preferred when vCPUs may be preempted
   (non-dedicated case)

So reorder the PV spinlock checks to:
1. First handle dedicated pCPU case (disable virt_spin_lock_key)
2. Second check single CPU, and nopvspin configuration
3. Only then check PV_UNHALT support

This ensures we always use native qspinlock for dedicated vCPUs, delivering
pretty performance gains at high contention levels.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Wangyang Guo <wangyang.guo@intel.com>
Link: https://lore.kernel.org/r/20250722110005.4988-1-lirongqing@baidu.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kvm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index fe9babe94861f..d7d2eb79120d6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -964,16 +964,6 @@ ASM_RET
  */
 void __init kvm_spinlock_init(void)
 {
-	/*
-	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
-	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
-	 * preferred over native qspinlock when vCPU is preempted.
-	 */
-	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
-		pr_info("PV spinlocks disabled, no host support\n");
-		return;
-	}
-
 	/*
 	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
 	 * are available.
@@ -993,6 +983,16 @@ void __init kvm_spinlock_init(void)
 		goto out;
 	}
 
+	/*
+	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
+	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
+	 * preferred over native qspinlock when vCPU is preempted.
+	 */
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
+		pr_info("PV spinlocks disabled, no host support\n");
+		return;
+	}
+
 	pr_info("PV spinlocks enabled\n");
 
 	__pv_init_lock_hash();
-- 
2.51.0



