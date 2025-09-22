Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF9A2F0C5C;
	Mon, 22 Sep 2025 19:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570280; cv=none; b=bMFnQuR++Wb4EnHbUudEM/fCJQnHbL3ringbSudW0iGSjYyXlxqD58R4pdirMXwTeLFsuFPk8GOgYZZljogdRHdYRd7Afu83eacZf+YFtxagw+f3PGF80FtEYomETz4qzu8K2PKn+0HuSZSp8Cio0CW8oKQYrJLO6zpRK+CQX4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570280; c=relaxed/simple;
	bh=jcys/min0QlXdWznCnPq6wvju/1LI6hWp0XqI8rsUwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3z2+PYXLmBh3h2F3P7K3aIk/wjj+UFBo7ddKjzrHipod+t/Gnw/xBVWam76TEVrR0sJ0c98IHn/fgmTv9b+UJAvbp8r6BCgqmCC9dxDmXQ9hvXMeYs9eAkediVY+0vjLn175mifAtiehl9Kx/V4nolobvRbmHxu52x2vmuMTg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJR4jfTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJR4jfTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68373C4CEF0;
	Mon, 22 Sep 2025 19:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570279;
	bh=jcys/min0QlXdWznCnPq6wvju/1LI6hWp0XqI8rsUwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJR4jfTok+687vKJSKZvw/J6Dka3SetSctJp24Hy8NWYK1hSIRRX0QwWjAODsVdhT
	 Lziq/GxoPhYJ/5ABJquNVl/fam5g61odtQnbK9WqiWurv+iO/WZgVYtSIjZzby9Y5e
	 A/qzuftcbDmmBSKM9OPZM8u9/WTYEmDlNEe7YHGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 075/149] LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_eiointc_sw_status_access()
Date: Mon, 22 Sep 2025 21:29:35 +0200
Message-ID: <20250922192414.774526466@linuxfoundation.org>
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

commit 01a8e68396a6d51f5ba92021ad1a4b8eaabdd0e7 upstream.

Function copy_from_user() and copy_to_user() may sleep because of page
fault, and they cannot be called in spin_lock hold context. Here move
funtcion calling of copy_from_user() and copy_to_user() out of function
kvm_eiointc_sw_status_access().

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
[<ffff800002311de0>] kvm_eiointc_sw_status_access.isra.0+0x88/0x380 [kvm]
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
 arch/loongarch/kvm/intc/eiointc.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -911,19 +911,17 @@ static int kvm_eiointc_regs_access(struc
 
 static int kvm_eiointc_sw_status_access(struct kvm_device *dev,
 					struct kvm_device_attr *attr,
-					bool is_write)
+					bool is_write, int *data)
 {
 	int addr, ret = 0;
 	unsigned long flags;
 	void *p = NULL;
-	void __user *data;
 	struct loongarch_eiointc *s;
 
 	s = dev->kvm->arch.eiointc;
 	addr = attr->attr;
 	addr &= 0xffff;
 
-	data = (void __user *)attr->addr;
 	switch (addr) {
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU:
 		if (is_write)
@@ -945,13 +943,10 @@ static int kvm_eiointc_sw_status_access(
 		return -EINVAL;
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
@@ -973,7 +968,14 @@ static int kvm_eiointc_get_attr(struct k
 
 		return ret;
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
-		return kvm_eiointc_sw_status_access(dev, attr, false);
+		ret = kvm_eiointc_sw_status_access(dev, attr, false, &data);
+		if (ret)
+			return ret;
+
+		if (copy_to_user((void __user *)attr->addr, &data, 4))
+			ret = -EFAULT;
+
+		return ret;
 	default:
 		return -EINVAL;
 	}
@@ -993,7 +995,10 @@ static int kvm_eiointc_set_attr(struct k
 
 		return kvm_eiointc_regs_access(dev, attr, true, &data);
 	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
-		return kvm_eiointc_sw_status_access(dev, attr, true);
+		if (copy_from_user(&data, (void __user *)attr->addr, 4))
+			return -EFAULT;
+
+		return kvm_eiointc_sw_status_access(dev, attr, true, &data);
 	default:
 		return -EINVAL;
 	}


