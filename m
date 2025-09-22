Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9030E2F0C5C;
	Mon, 22 Sep 2025 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570277; cv=none; b=snU1Wlva7NqFmGoTpySV4bYTc4+jusKfbtIlECCAb5ObOkik/Br19R/QAIKz0obRYtm9asazcNJqmoaonR2Gch6ilWQFseeCNIxWktpgri3r3lUDaNFm7dH2TgAYCK/YPZsaZOJObI6VNGmz7uX8d54nT+K+eXCl+iaiNFNRJyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570277; c=relaxed/simple;
	bh=u4bLze1FT4QReiMyO4gn5TpcArWUt4tZTwMP1GFhCcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8ysYViJ9p4HUUlkxwZIPWFFBuu05eAXrCWjTWuDUjcfSOrxptIJTJgevaWH4ak7e1BU+WqWOSfLhZVXGZrshXp7xUQMCytFsugmWFwlz413fiAp5yXRQaVFptT4eeCFmYAR3WSRJ8Nld+EXE+rRIQVpZLEhuQ3BSdigKnWSj58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdnbHmMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdnbHmMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE30EC4CEF0;
	Mon, 22 Sep 2025 19:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570277;
	bh=u4bLze1FT4QReiMyO4gn5TpcArWUt4tZTwMP1GFhCcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdnbHmMlpm07O3VnDmXzSlPN76duJTXgYQQ+5SsvTEaFSfXKF/7QhSXuih4QOWZES
	 7jOoRc6HmbBnWjuiq9ai26c3IWLpgjRyPxDWM4fKw/FoazOlgrIZKZmPFINHr3wAMr
	 t2DMqK3xnsB1+UjxSwUixwFPJWpI+B4wAy1C+TsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 074/149] LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_eiointc_regs_access()
Date: Mon, 22 Sep 2025 21:29:34 +0200
Message-ID: <20250922192414.749261179@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 62f11796a0dfa1a2ef5f50a2d1bc81c81628fb8e upstream.

Function copy_from_user() and copy_to_user() may sleep because of page
fault, and they cannot be called in spin_lock hold context. Here move
function calling of copy_from_user() and copy_to_user() before spinlock
context in function kvm_eiointc_ctrl_access().

Otherwise there will be possible warning such as:

BUG: sleeping function called from invalid context at include/linux/uaccess.h:192
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6292, name: qemu-system-loo
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<9000000004c4a554>] copy_process+0x90c/0x1d40
softirqs last  enabled at (0): [<9000000004c4a554>] copy_process+0x90c/0x1d40
softirqs last disabled at (0): [<0000000000000000>] 0x0
CPU: 41 UID: 0 PID: 6292 Comm: qemu-system-loo Tainted: G W 6.17.0-rc3+ #31 PREEMPT(full)
Tainted: [W]=WARN
Stack : 0000000000000076 0000000000000000 9000000004c28264 9000100092ff4000
        9000100092ff7b80 9000100092ff7b88 0000000000000000 9000100092ff7cc8
        9000100092ff7cc0 9000100092ff7cc0 9000100092ff7a00 0000000000000001
        0000000000000001 9000100092ff7b88 947d2f9216a5e8b9 900010008773d880
        00000000ffff8b9f fffffffffffffffe 0000000000000ba1 fffffffffffffffe
        000000000000003e 900000000825a15b 000010007ad38000 9000100092ff7ec0
        0000000000000000 0000000000000000 9000000006f3ac60 9000000007252000
        0000000000000000 00007ff746ff2230 0000000000000053 9000200088a021b0
        0000555556c9d190 0000000000000000 9000000004c2827c 000055556cfb5f40
        00000000000000b0 0000000000000007 0000000000000007 0000000000071c1d
Call Trace:
[<9000000004c2827c>] show_stack+0x5c/0x180
[<9000000004c20fac>] dump_stack_lvl+0x94/0xe4
[<9000000004c99c7c>] __might_resched+0x26c/0x290
[<9000000004f68968>] __might_fault+0x20/0x88
[<ffff800002311de0>] kvm_eiointc_regs_access.isra.0+0x88/0x380 [kvm]
[<ffff8000022f8514>] kvm_device_ioctl+0x194/0x290 [kvm]
[<900000000506b0d8>] sys_ioctl+0x388/0x1010
[<90000000063ed210>] do_syscall+0xb0/0x2d8
[<9000000004c25ef8>] handle_syscall+0xb8/0x158

Cc: stable@vger.kernel.org
Fixes: 1ad7efa552fd5 ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -851,19 +851,17 @@ static int kvm_eiointc_ctrl_access(struc
 
 static int kvm_eiointc_regs_access(struct kvm_device *dev,
 					struct kvm_device_attr *attr,
-					bool is_write)
+					bool is_write, int *data)
 {
 	int addr, cpu, offset, ret = 0;
 	unsigned long flags;
 	void *p = NULL;
-	void __user *data;
 	struct loongarch_eiointc *s;
 
 	s = dev->kvm->arch.eiointc;
 	addr = attr->attr;
 	cpu = addr >> 16;
 	addr &= 0xffff;
-	data = (void __user *)attr->addr;
 	switch (addr) {
 	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
 		offset = (addr - EIOINTC_NODETYPE_START) / 4;
@@ -902,13 +900,10 @@ static int kvm_eiointc_regs_access(struc
 	}
 
 	spin_lock_irqsave(&s->lock, flags);
-	if (is_write) {
-		if (copy_from_user(p, data, 4))
-			ret = -EFAULT;
-	} else {
-		if (copy_to_user(data, p, 4))
-			ret = -EFAULT;
-	}
+	if (is_write)
+		memcpy(p, data, 4);
+	else
+		memcpy(data, p, 4);
 	spin_unlock_irqrestore(&s->lock, flags);
 
 	return ret;
@@ -965,9 +960,18 @@ static int kvm_eiointc_sw_status_access(
 static int kvm_eiointc_get_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
+	int ret, data;
+
 	switch (attr->group) {
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
-		return kvm_eiointc_regs_access(dev, attr, false);
+		ret = kvm_eiointc_regs_access(dev, attr, false, &data);
+		if (ret)
+			return ret;
+
+		if (copy_to_user((void __user *)attr->addr, &data, 4))
+			ret = -EFAULT;
+
+		return ret;
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
 		return kvm_eiointc_sw_status_access(dev, attr, false);
 	default:
@@ -978,11 +982,16 @@ static int kvm_eiointc_get_attr(struct k
 static int kvm_eiointc_set_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
+	int data;
+
 	switch (attr->group) {
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL:
 		return kvm_eiointc_ctrl_access(dev, attr);
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
-		return kvm_eiointc_regs_access(dev, attr, true);
+		if (copy_from_user(&data, (void __user *)attr->addr, 4))
+			return -EFAULT;
+
+		return kvm_eiointc_regs_access(dev, attr, true, &data);
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
 		return kvm_eiointc_sw_status_access(dev, attr, true);
 	default:


