Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7302D23A8;
	Thu,  3 Jul 2025 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554860; cv=none; b=p/mXljf/FcARU5WNapmTyyE002gAMobvbLTJwks9l5Qz8Q2hX5BcX8BCbF7AE5kPKCM6LhLmWDse3s6jJjSDotWboRxV1dCWLyd+988I4PhcYmxlng+R6DHge8CE4ylc0UZNcIJPHEjVEkFwuq8omu6uObhH1sBwOtAvx8cHe6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554860; c=relaxed/simple;
	bh=Mrfw25bbfxheoUGUpkXc7vFElLWwwsD6SnCwhYENr/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbwcqA0u9aG9Sqq4W4mTcDCvmXWHb/EFvZma1nTNbpgnpnjCncyrzCF6nNXrZoPs0G5laXpxvEPvydl9bCBbmDS+y7MIsWK19TIooHEjjhJ8ufu6cB/Sg7eoUGvFFJp0WVR40r5z2Vvq52xvIaHbxiSKvqaTNXZgZGnsXG0qQHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fS2FYiTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fS2FYiTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E037CC4CEE3;
	Thu,  3 Jul 2025 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554860;
	bh=Mrfw25bbfxheoUGUpkXc7vFElLWwwsD6SnCwhYENr/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fS2FYiTbrqYLdJq52QQW5D8aAfRh8HSbuZHsyWk4sbx51m6Rg/aCtrNk8pX6oNeZB
	 zcUKAFlJ0PgEB0KJzb0Sr0qRxh5h2I6Qcw1+zoaeE3VXUNUi9CwK9fsQ+HkHhqedIK
	 Zziftku8eHm+Pm0WZknUNato/wxKw+XrERrxWVZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 102/263] LoongArch: KVM: Check validity of "num_cpu" from user space
Date: Thu,  3 Jul 2025 16:40:22 +0200
Message-ID: <20250703144008.395113000@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit cc8d5b209e09d3b52bca1ffe00045876842d96ae upstream.

The maximum supported cpu number is EIOINTC_ROUTE_MAX_VCPUS about
irqchip EIOINTC, here add validation about cpu number to avoid array
pointer overflow.

Cc: stable@vger.kernel.org
Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -784,7 +784,7 @@ static int kvm_eiointc_ctrl_access(struc
 	int ret = 0;
 	unsigned long flags;
 	unsigned long type = (unsigned long)attr->attr;
-	u32 i, start_irq;
+	u32 i, start_irq, val;
 	void __user *data;
 	struct loongarch_eiointc *s = dev->kvm->arch.eiointc;
 
@@ -792,8 +792,14 @@ static int kvm_eiointc_ctrl_access(struc
 	spin_lock_irqsave(&s->lock, flags);
 	switch (type) {
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
-		if (copy_from_user(&s->num_cpu, data, 4))
+		if (copy_from_user(&val, data, 4))
 			ret = -EFAULT;
+		else {
+			if (val >= EIOINTC_ROUTE_MAX_VCPUS)
+				ret = -EINVAL;
+			else
+				s->num_cpu = val;
+		}
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
 		if (copy_from_user(&s->features, data, 4))
@@ -821,7 +827,7 @@ static int kvm_eiointc_regs_access(struc
 					struct kvm_device_attr *attr,
 					bool is_write)
 {
-	int addr, cpuid, offset, ret = 0;
+	int addr, cpu, offset, ret = 0;
 	unsigned long flags;
 	void *p = NULL;
 	void __user *data;
@@ -829,7 +835,7 @@ static int kvm_eiointc_regs_access(struc
 
 	s = dev->kvm->arch.eiointc;
 	addr = attr->attr;
-	cpuid = addr >> 16;
+	cpu = addr >> 16;
 	addr &= 0xffff;
 	data = (void __user *)attr->addr;
 	switch (addr) {
@@ -854,8 +860,11 @@ static int kvm_eiointc_regs_access(struc
 		p = &s->isr.reg_u32[offset];
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		if (cpu >= s->num_cpu)
+			return -EINVAL;
+
 		offset = (addr - EIOINTC_COREISR_START) / 4;
-		p = &s->coreisr.reg_u32[cpuid][offset];
+		p = &s->coreisr.reg_u32[cpu][offset];
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
 		offset = (addr - EIOINTC_COREMAP_START) / 4;


