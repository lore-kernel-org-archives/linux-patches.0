Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873A8421EFB;
	Sat, 12 Sep 2026 11:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213690; cv=none; b=oWEtkOLf72rQF/+EGSQv18WwADMscwfPBrfIBKMzSfCB6f9EU6iHvQMLlLVuV/I1DFW4DdmX1Heh+qQ/Y5PvyAunI5E3vwQttsIjnTOYmR9N+gIcNB+U6e6tkQ+hbjcbKkH0W2okgl9h0OWL1iBr2WyL3eRgMGCRkpnnWIby9Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213690; c=relaxed/simple;
	bh=0zhSbExp55jPYZHYl8AoTRTtfssWsicA/zcLvY7KIcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaeuFAIsTR/KqJhumUP5A03jFh7nk29+A8WoZJe9Gb1aW8oniW3XbNVQsEEX/bRtsRoF6jheaDlPzHj65QT+Cw3Hc3JYBYOhhey5ACtWHCFGIo5sCJK3aFvJ/br2MvM7yHenPEDt7wJBT/gBIn5nqLS0fs3+gXxJD5KpvEFuz8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfYdUbg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfYdUbg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9BD1F000FF;
	Sat, 12 Sep 2026 11:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213687;
	bh=Nt5IjQ2gRO4P9jpxMFqgejBvx48JiXV2+EHSd3lbrwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfYdUbg8KnBnpjuFcy4G1c6nV8BbkxG7JgPkKujNgXDA5ro3enEVDdkawvSe0tLGP
	 AU7hDq1lKmdpoMuaCc+BQVyMxOOQrnyTgmDOJhBS9hNFjTY6jCZhhaFiWIdb6I3DSv
	 +ResQ4jiZ5qmcaDblTZbmvUo9IYg9zEme4iI2XJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0172/1376] LoongArch: KVM: Fix TOCTOU race on pv_features
Date: Sat, 12 Sep 2026 08:43:18 +0200
Message-ID: <20260912065611.384690307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -110,6 +110,7 @@ struct kvm_arch {
 	unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
 	unsigned int  root_level;
 	spinlock_t    phyid_map_lock;
+	spinlock_t    pv_setting_lock;
 	struct kvm_phyid_map  *phyid_map;
 	/* Enabled PV features */
 	unsigned long pv_features;
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1088,10 +1088,14 @@ static int kvm_loongarch_cpucfg_set_attr
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
@@ -38,6 +38,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 		return -ENOMEM;
 	}
 	spin_lock_init(&kvm->arch.phyid_map_lock);
+	spin_lock_init(&kvm->arch.pv_setting_lock);
 
 	kvm_init_vmcs(kvm);
 


