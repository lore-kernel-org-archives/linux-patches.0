Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B013128CC;
	Thu, 16 Jul 2026 14:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211536; cv=none; b=YtdxuzxBWTYEYPtoaVydLkc5sIzfw84oI2AtDXQJberE701Ot/LZ+mh/nblRJD4vBfzuq8nDbctRddqljQLGMr77SQLYnjUASXvNzh7n9yxhNVYMgdGufX6g0R9DTklWbOIBCFyTeK3FnhgVocW4ztC6EXzAZxlVMdHrAFMjo4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211536; c=relaxed/simple;
	bh=ValBm4v0aPX0NlVjPq2awW3ymkmGIcpSeJ4N6EAMceU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSnepQW/YFsWesbgtfxHNUVD5KcMEq+vwP7NPSZ4KS4+fCELz2WTrHoGViSdmu+89l018cGDQVjg0LjRwwhBXqkHchVrxq1yx6KBQk1kuz5zrjmksI1jbg/Aly7GMdFN0N2UQdNGE2xT183oGfQl3Q3odlbcyUyJLWOuCkRjbJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuyeSDVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuyeSDVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D021F000E9;
	Thu, 16 Jul 2026 14:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211535;
	bh=fG9qLTvuVz9s4Gm8HPuSy4wUaLupcr0Xvtdx3Ye8pJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuyeSDVCyC9FKao66TilskWjZLxghuso+pivXtXjyaEz21tdmgmmDWHBudGKNQ7MZ
	 Yu33CcuAYaFNvS1r9fUoYDyO9HzNzhfG14EFGvdb0+3fI3jIoMqnD36mrTIBGkMFCU
	 68FzexiT7teXGIwVM1nBdzBT7TYRzTBPdOL9M2hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Zeng Chi <zengchi@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 421/480] LoongArch: KVM: Add missing slots_lock for device register/unregister
Date: Thu, 16 Jul 2026 15:32:48 +0200
Message-ID: <20260716133053.922200852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Zeng Chi <zengchi@kylinos.cn>

commit aeded601d6aceb57cdda4b2701d2ee00c43a8b69 upstream.

kvm_io_bus_register_dev() and kvm_io_bus_unregister_dev() should be
called under kvm->slots_lock. The unregister calls in ipi.c, eiointc.c
and pch_pic.c were also missing this protection. Add it to match the
register side.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c |    6 ++++++
 arch/loongarch/kvm/intc/ipi.c     |    2 ++
 arch/loongarch/kvm/intc/pch_pic.c |    2 ++
 3 files changed, 10 insertions(+)

--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -654,10 +654,14 @@ static int kvm_eiointc_create(struct kvm
 
 	device = &s->device_vext;
 	kvm_iodevice_init(device, &kvm_eiointc_virt_ops);
+	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
 			EIOINTC_VIRT_BASE, EIOINTC_VIRT_SIZE, device);
+	mutex_unlock(&kvm->slots_lock);
 	if (ret < 0) {
+		mutex_lock(&kvm->slots_lock);
 		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device);
+		mutex_unlock(&kvm->slots_lock);
 		kfree(s);
 		return ret;
 	}
@@ -676,8 +680,10 @@ static void kvm_eiointc_destroy(struct k
 
 	kvm = dev->kvm;
 	eiointc = kvm->arch.eiointc;
+	mutex_lock(&kvm->slots_lock);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device_vext);
+	mutex_unlock(&kvm->slots_lock);
 	kfree(eiointc);
 	kfree(dev);
 }
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -457,7 +457,9 @@ static void kvm_ipi_destroy(struct kvm_d
 
 	kvm = dev->kvm;
 	ipi = kvm->arch.ipi;
+	mutex_lock(&kvm->slots_lock);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &ipi->device);
+	mutex_unlock(&kvm->slots_lock);
 	kfree(ipi);
 	kfree(dev);
 }
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -473,7 +473,9 @@ static void kvm_pch_pic_destroy(struct k
 	kvm = dev->kvm;
 	s = kvm->arch.pch_pic;
 	/* unregister pch pic device and free it's memory */
+	mutex_lock(&kvm->slots_lock);
 	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &s->device);
+	mutex_unlock(&kvm->slots_lock);
 	kfree(s);
 	kfree(dev);
 }


