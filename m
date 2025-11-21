Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07A334F492;
	Fri, 21 Nov 2025 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732716; cv=none; b=sulhY90Mz2p+qN6bpsS2KxxxJIf/U4FxIM1zUiCkN5jGeiy4FHE8iohcxb0hxuOYilN3kOfd93m1ExLmhcwNMWKKSmpvbpkNwZiuwpfiz7zt7GDGlQsbf9hRxnnf3WclP2UR+TG9Q1gr7FU6uvRsd7sjBjhJYwttuzSC+48JfIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732716; c=relaxed/simple;
	bh=dX7FnduGo68058y5iRE1JuX2gdurFtyDCiOI4pVuRH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRKO18BGmJ3vAS/wWkQx1VSidVZVPmMQiso9x5ts6ttJ7SwYAKta19WKMzjBep4vI9OXjtjuFn3U2esLQpCUBuhemg3dZElC0I63w+kvCRbKajVsmmjEu0nQAICqqR6V5Cs/QS1m2glMSVp7NvEy1hS2r6d9Bsi8fz768CjLLw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QILa8Vv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QILa8Vv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD264C4CEF1;
	Fri, 21 Nov 2025 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732716;
	bh=dX7FnduGo68058y5iRE1JuX2gdurFtyDCiOI4pVuRH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QILa8Vv87STasGgLvT2SLvozJmK1FKu6uzCJc1P/mLdI874em8m97Yg8VxvPMigBJ
	 u0SxO1hBKSnpa6uFQVkUuf12n77ChC1bbsjml7zw0yrH+FeJkPp7aTEV0+Y5zZfTSN
	 mzSH5XVPLTPXa4k/S1uwlTHf5+uqbqxz1RCdMgBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Sean Christopherson <seanjc@google.com>,
	Wangyang Guo <wangyang.guo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/529] x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT
Date: Fri, 21 Nov 2025 14:08:38 +0100
Message-ID: <20251121130238.806629478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b8ab9ee5896c1..b5ef2c2899f2a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1066,16 +1066,6 @@ static void kvm_wait(u8 *ptr, u8 val)
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
@@ -1095,6 +1085,16 @@ void __init kvm_spinlock_init(void)
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



