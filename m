Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAC158F097;
	Wed,  9 Sep 2026 14:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963980; cv=none; b=WOYMbeFonCj4uPMpSGgolDIHhNtzxojy3PwUwRVl0VVkOMvD99xQtz3ezTQyAryySFa3L+OQxguKfZyVMsEtXKABRTcuolhXz1SBJota3flhOMHUwN9BLhdE6IlinyUke3BjewpM/V2+Ho48xK15/miu8UgPE6LMCOq615JST00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963980; c=relaxed/simple;
	bh=gRiPWBpyB8w4Fq9xSw9cYOl2TMc8CI05XNL2uejhfsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jw4RgtTR+d/D8asw2hSr6pgbXbZxp3cRvQ6TFmSxs+WEQHyMZJebEYOzTFWOrMrB3eXyf65RJP4bvhSBGRfLAhoQWZZiyycYs5E0wmAyz699IVpqU6JHsgXZynz/A6Fg0GnEqd7M4736keN1VXTXpr8lzztEuE3Vs3c9g0Ynzlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXVBUtxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXVBUtxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B1B1F00A3A;
	Wed,  9 Sep 2026 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963978;
	bh=2AHpq0IQZpxQowthKOY2Q5WM4OB7S67NodV4qh6JzRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXVBUtxYTiTVFiUg2x19xxkVt4UU46Pf3ZxrFmLqB3y4r/Mx2sBoPNGuGqMGaZh9Y
	 NznkmzjkinDM20V92+D/aXX652/f+45SoOaligN/1a7rV63JpwjPaXaj3ITM39I9rY
	 tyOKnhGDAO29rc/UmwF0ODJvC+kLur1/S6ECHwfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 263/583] LoongArch: KVM: Fix TOCTOU race on pv_features
Date: Wed,  9 Sep 2026 15:39:08 +0200
Message-ID: <20260909134247.209676270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -122,6 +122,7 @@ struct kvm_arch {
 	unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
 	unsigned int  root_level;
 	spinlock_t    phyid_map_lock;
+	spinlock_t    pv_setting_lock;
 	struct kvm_phyid_map  *phyid_map;
 	/* Enabled PV features */
 	unsigned long pv_features;
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1120,10 +1120,14 @@ static int kvm_loongarch_cpucfg_set_attr
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
@@ -40,6 +40,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 		return -ENOMEM;
 	}
 	spin_lock_init(&kvm->arch.phyid_map_lock);
+	spin_lock_init(&kvm->arch.pv_setting_lock);
 
 	kvm_init_vmcs(kvm);
 


