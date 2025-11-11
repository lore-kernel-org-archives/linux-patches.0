Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384BD306B39;
	Tue, 11 Nov 2025 01:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823878; cv=none; b=MYjSRJc/FPntjxo7FApO8Xg2ZMqhe/06U4KAjsrlmTzi98FwAmGCyRDzST/h0OzAeDMRyvXvSMF6sULkRsMeH8nEA5pXahK9PhegwIadCMQUv3K+XKm4SMq4HZHXrjBsUekFDsbOprCCbN3uWYspOcxKLgxuYrllx4Vx6S0Z4E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823878; c=relaxed/simple;
	bh=1rQtIYz3pjOD19fMnaTxsV0FGOfy/AyIVuy98WeD60U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dtz/l90VXbCFhalrTBxU+ZcMAYbi2FhTF5buttX8OmLW8OZQhq/7DOTjXFxHI+FYV2/hadZseYGMag1zThVm6qCR9etHRHrWrYcQ5ASjsAPQJuDu60sXHIPcNNiXah+NlFtcKz6lqwMdU2bne7aHqHhnJ/FXBLtEfjwBGmnZMQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyDgHldb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyDgHldb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4685C19421;
	Tue, 11 Nov 2025 01:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823878;
	bh=1rQtIYz3pjOD19fMnaTxsV0FGOfy/AyIVuy98WeD60U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyDgHldb5bsvjFXDEI10TP4A1nqMRUPcnF1oMDDkxS9YJLiNfC3hS9pSFOQkZHgzD
	 fOvVGJEbDCkVNySI81z35/M+4uMDEFMXzcwk9zzdDcXxeS+MeB6GlfQnGT49br0f/i
	 3XCxEFHQu8m5ldKjsyEUM7Gy9H0uVK/j6UKkvTqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Sean Christopherson <seanjc@google.com>,
	Wangyang Guo <wangyang.guo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/565] x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT
Date: Tue, 11 Nov 2025 09:43:18 +0900
Message-ID: <20251111004534.572633093@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd21c568bc2ad..46887d60348ef 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1089,16 +1089,6 @@ static void kvm_wait(u8 *ptr, u8 val)
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
@@ -1118,6 +1108,16 @@ void __init kvm_spinlock_init(void)
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



