Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B29E2DA775;
	Wed,  9 Sep 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962560; cv=none; b=IkXpLVG3ZQN6pHKUuu1K26uHE0T86Evo8i38D8RsWAL1z9w/f2aYhDe8d6uAOFOzqCvLOTY70/bCIZnhbP7Qd9DGIdrQ7iWFkH7uX6EtcLLRAb0gsK13Z1c2vnaZSrElgeZUgpxZynqbo5nB7x2ypaT7J93cSJGhrcpRyqE0loU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962560; c=relaxed/simple;
	bh=EZ6K0r5ENFXy4zcaUZEf9VXSxgWmBG5ZvQ6lOMTOiWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxZMeLcS1wveqn02YJEji+5gAeczTodb+jYscv93fufmxGzNVVxwET0wsjRpe3zYw9ZXJ15LaE84EhPgSZRZVJtoe7+OXf0QhEBSXYRZ7HnIh0gVS/MOAH3GmHrvFnbZo8JCsT6RC7LKv4akCqYIyb99ZRde15p7/BEN/JyQXck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17koNS1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17koNS1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610C91F00A3A;
	Wed,  9 Sep 2026 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962558;
	bh=zAcQOaQmm/zzQcVLwCDxOomdsc6M+KjFPqAIsoc4ecY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17koNS1BtkidtB0hYqrnvETlDEj/z1GHf1K5txUo7/tBBAvct79maiN1JzeB0idfu
	 liJnvYH7ertIOlxShbLEHhihk/9AB0j7/SCLo69EJFeU5JIIa5t/0lnHtCgYRbKraL
	 X+JJG8prul06/597YHBRE7iM9iDUlyocUJNhFmMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 331/556] LoongArch: KVM: Fix TOCTOU race on pv_features
Date: Wed,  9 Sep 2026 15:40:11 +0200
Message-ID: <20260909134242.299877956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Tao Cui <cuitao@kylinos.cn>

commit 9296375902579f9b0e456bbb76e5cf179e5a4e0b upstream.

In kvm_loongarch_cpucfg_set_attr() the check-then-set on
kvm->arch.pv_features is lockless, so two vCPUs can race past the
validation and set different values. Add a spinlock to protect it.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/kvm_host.h |    1 +
 arch/loongarch/kvm/vcpu.c             |    6 +++++-
 arch/loongarch/kvm/vm.c               |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -125,6 +125,7 @@ struct kvm_arch {
 	unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
 	unsigned int  root_level;
 	spinlock_t    phyid_map_lock;
+	spinlock_t    pv_setting_lock;
 	struct kvm_phyid_map  *phyid_map;
 	/* Enabled PV features */
 	unsigned long pv_features;
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1165,10 +1165,14 @@ static int kvm_loongarch_cpucfg_set_attr
 			return -EINVAL;
 
 		/* All vCPUs need set the same PV features */
+		spin_lock(&kvm->arch.pv_setting_lock);
 		if ((kvm->arch.pv_features & LOONGARCH_PV_FEAT_UPDATED)
-				&& ((kvm->arch.pv_features & valid) != val))
+				&& ((kvm->arch.pv_features & valid) != val)) {
+			spin_unlock(&kvm->arch.pv_setting_lock);
 			return -EINVAL;
+		}
 		kvm->arch.pv_features = val | LOONGARCH_PV_FEAT_UPDATED;
+		spin_unlock(&kvm->arch.pv_setting_lock);
 		return 0;
 	default:
 		return -ENXIO;
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -76,6 +76,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 		return -ENOMEM;
 	}
 	spin_lock_init(&kvm->arch.phyid_map_lock);
+	spin_lock_init(&kvm->arch.pv_setting_lock);
 
 	kvm_init_vmcs(kvm);
 	kvm_vm_init_features(kvm);


