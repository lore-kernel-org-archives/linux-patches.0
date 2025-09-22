Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19FE2F0C64;
	Mon, 22 Sep 2025 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570251; cv=none; b=Dq+swHS2GoA4jNlDJWXB3lsjKJhegJofJwdhdIzGmsMaHRnirek8FOyCuMh5a3Md63BAhGer7yn+HACN2NYGCsceTIq8mWSorq5VAZh55LbqfBrYlq+9IBy4d3pICGsadTMuMcpf1b+XINPkP0kHdMRCTBL57GzpP1cyZ43oBLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570251; c=relaxed/simple;
	bh=Ca/4zOsLRleHgaCwcvc+DIP7aTxfbw12DxhIRCaMAIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLyPgE8o/nf09MK7ZbRE/T2l2E4j6V/lyLW2fLIiWAd9yxDmvLbgI5Bv+Isi6817wJULC9lUAIzBLJizQYeQLEDeFLv2OTEDCv5rAgp7oQHQMYMandgY5y04qPS1/DwN8SAxjzdVYiGIXLxhhqfF/JbFU6eyog2BF0eE0RMmggQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1RxO8W3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1RxO8W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62850C4CEF5;
	Mon, 22 Sep 2025 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570251;
	bh=Ca/4zOsLRleHgaCwcvc+DIP7aTxfbw12DxhIRCaMAIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1RxO8W3XurT/lf8RhwACKVyqph0GHuqO0CFsfrfRpmDzMbSaHdiwYkpMm2OEHh1C
	 blfpN9i7Ak/UfaWn+nDHYKFmDytI5KUydaJyLE7y2J4hoPkFzGlH+MkctYeXGuGAf/
	 hp/ojUjrck581gukCQ47MXCMU2vYiMgrfje6jkmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 076/149] LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_pch_pic_regs_access()
Date: Mon, 22 Sep 2025 21:29:36 +0200
Message-ID: <20250922192414.798518931@linuxfoundation.org>
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

commit 8dc5245673cf7f33743e5c0d2a4207c0b8df3067 upstream.

Function copy_from_user() and copy_to_user() may sleep because of page
fault, and they cannot be called in spin_lock hold context. Here move
function calling of copy_from_user() and copy_to_user() out of spinlock
context in function kvm_pch_pic_regs_access().

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
[<ffff800002311de0>] kvm_pch_pic_regs_access.isra.0+0x88/0x380 [kvm]
[<ffff8000022f8514>] kvm_device_ioctl+0x194/0x290 [kvm]
[<900000000506b0d8>] sys_ioctl+0x388/0x1010
[<90000000063ed210>] do_syscall+0xb0/0x2d8
[<9000000004c25ef8>] handle_syscall+0xb8/0x158

Cc: stable@vger.kernel.org
Fixes: d206d95148732 ("LoongArch: KVM: Add PCHPIC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/pch_pic.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -348,6 +348,7 @@ static int kvm_pch_pic_regs_access(struc
 				struct kvm_device_attr *attr,
 				bool is_write)
 {
+	char buf[8];
 	int addr, offset, len = 8, ret = 0;
 	void __user *data;
 	void *p = NULL;
@@ -397,17 +398,23 @@ static int kvm_pch_pic_regs_access(struc
 		return -EINVAL;
 	}
 
-	spin_lock(&s->lock);
-	/* write or read value according to is_write */
 	if (is_write) {
-		if (copy_from_user(p, data, len))
-			ret = -EFAULT;
-	} else {
-		if (copy_to_user(data, p, len))
-			ret = -EFAULT;
+		if (copy_from_user(buf, data, len))
+			return -EFAULT;
 	}
+
+	spin_lock(&s->lock);
+	if (is_write)
+		memcpy(p, buf, len);
+	else
+		memcpy(buf, p, len);
 	spin_unlock(&s->lock);
 
+	if (!is_write) {
+		if (copy_to_user(data, buf, len))
+			return -EFAULT;
+	}
+
 	return ret;
 }
 


