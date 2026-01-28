Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86DF2D6400;
	Wed, 28 Jan 2026 15:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614652; cv=none; b=rbPbtKe/Jw2EV9I2O0I2ZHVFgY7KoLmOF4KrCbQ5HPxwNwRHYLQ81xx1j2DAq08HRUROBhpd0EeiJ3SES+bXNE31BXczIl1JP1p/NvaHNK/xpBldm0+zuOd+I0Kr947e4snJXDpKyWChhwUqM0uWnYgSH4zRRow3lWBjycjhNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614652; c=relaxed/simple;
	bh=cHxIjlquuWqZt+STES+620zVyt6I2LENoTbgCOlxynw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaaN9oWsCxf4cRUcpuu2bfKQaOv5WRTbtYYCzS7KMBdKetZnXHXMfVr65jnh6XewHI75l3frqO39dC8nNW5VZ5QFOHVI39XA0KnkvmLHUyBKiAJDL1c7HW6RwcKLf1vN+44uXf85Nyt92xZa6JueGgM50mTDp3Rfd6f6hssK7yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqV8soqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqV8soqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E7DC4CEF1;
	Wed, 28 Jan 2026 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614652;
	bh=cHxIjlquuWqZt+STES+620zVyt6I2LENoTbgCOlxynw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqV8soqW1SKnvgyRMdI8ImkbmsIofg3qkSzZvfW1VEtwr6AnYdMj7oMWiQCUa1BBK
	 0V7+gqE0qzrspsF5M7m8B9n3HmH6CDJMEzq2rbeRv79vmEzLK3Y6cLelBumWayzbbe
	 Ts7BnGIsONO6hXBY1v+Ko9ERzuooc0bHHA5sT/P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeson Gao <jeson.gao@unisoc.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 201/254] arm64: Set __nocfi on swsusp_arch_resume()
Date: Wed, 28 Jan 2026 16:22:57 +0100
Message-ID: <20260128145352.027890713@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

commit e2f8216ca2d8e61a23cb6ec355616339667e0ba6 upstream.

A DABT is reported[1] on an android based system when resume from hiberate.
This happens because swsusp_arch_suspend_exit() is marked with SYM_CODE_*()
and does not have a CFI hash, but swsusp_arch_resume() will attempt to
verify the CFI hash when calling a copy of swsusp_arch_suspend_exit().

Given that there's an existing requirement that the entrypoint to
swsusp_arch_suspend_exit() is the first byte of the .hibernate_exit.text
section, we cannot fix this by marking swsusp_arch_suspend_exit() with
SYM_FUNC_*(). The simplest fix for now is to disable the CFI check in
swsusp_arch_resume().

Mark swsusp_arch_resume() as __nocfi to disable the CFI check.

[1]
[   22.991934][    T1] Unable to handle kernel paging request at virtual address 0000000109170ffc
[   22.991934][    T1] Mem abort info:
[   22.991934][    T1]   ESR = 0x0000000096000007
[   22.991934][    T1]   EC = 0x25: DABT (current EL), IL = 32 bits
[   22.991934][    T1]   SET = 0, FnV = 0
[   22.991934][    T1]   EA = 0, S1PTW = 0
[   22.991934][    T1]   FSC = 0x07: level 3 translation fault
[   22.991934][    T1] Data abort info:
[   22.991934][    T1]   ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
[   22.991934][    T1]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[   22.991934][    T1]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   22.991934][    T1] [0000000109170ffc] user address but active_mm is swapper
[   22.991934][    T1] Internal error: Oops: 0000000096000007 [#1] PREEMPT SMP
[   22.991934][    T1] Dumping ftrace buffer:
[   22.991934][    T1]    (ftrace buffer empty)
[   22.991934][    T1] Modules linked in:
[   22.991934][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.6.98-android15-8-g0b1d2aee7fc3-dirty-4k #1 688c7060a825a3ac418fe53881730b355915a419
[   22.991934][    T1] Hardware name: Unisoc UMS9360-base Board (DT)
[   22.991934][    T1] pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   22.991934][    T1] pc : swsusp_arch_resume+0x2ac/0x344
[   22.991934][    T1] lr : swsusp_arch_resume+0x294/0x344
[   22.991934][    T1] sp : ffffffc08006b960
[   22.991934][    T1] x29: ffffffc08006b9c0 x28: 0000000000000000 x27: 0000000000000000
[   22.991934][    T1] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000820
[   22.991934][    T1] x23: ffffffd0817e3000 x22: ffffffd0817e3000 x21: 0000000000000000
[   22.991934][    T1] x20: ffffff8089171000 x19: ffffffd08252c8c8 x18: ffffffc080061058
[   22.991934][    T1] x17: 00000000529c6ef0 x16: 00000000529c6ef0 x15: 0000000000000004
[   22.991934][    T1] x14: ffffff8178c88000 x13: 0000000000000006 x12: 0000000000000000
[   22.991934][    T1] x11: 0000000000000015 x10: 0000000000000001 x9 : ffffffd082533000
[   22.991934][    T1] x8 : 0000000109171000 x7 : 205b5d3433393139 x6 : 392e32322020205b
[   22.991934][    T1] x5 : 000000010916f000 x4 : 000000008164b000 x3 : ffffff808a4e0530
[   22.991934][    T1] x2 : ffffffd08058e784 x1 : 0000000082326000 x0 : 000000010a283000
[   22.991934][    T1] Call trace:
[   22.991934][    T1]  swsusp_arch_resume+0x2ac/0x344
[   22.991934][    T1]  hibernation_restore+0x158/0x18c
[   22.991934][    T1]  load_image_and_restore+0xb0/0xec
[   22.991934][    T1]  software_resume+0xf4/0x19c
[   22.991934][    T1]  software_resume_initcall+0x34/0x78
[   22.991934][    T1]  do_one_initcall+0xe8/0x370
[   22.991934][    T1]  do_initcall_level+0xc8/0x19c
[   22.991934][    T1]  do_initcalls+0x70/0xc0
[   22.991934][    T1]  do_basic_setup+0x1c/0x28
[   22.991934][    T1]  kernel_init_freeable+0xe0/0x148
[   22.991934][    T1]  kernel_init+0x20/0x1a8
[   22.991934][    T1]  ret_from_fork+0x10/0x20
[   22.991934][    T1] Code: a9400a61 f94013e0 f9438923 f9400a64 (b85fc110)

Co-developed-by: Jeson Gao <jeson.gao@unisoc.com>
Signed-off-by: Jeson Gao <jeson.gao@unisoc.com>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: <stable@vger.kernel.org>
[catalin.marinas@arm.com: commit log updated by Mark Rutland]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/hibernate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -396,7 +396,7 @@ int swsusp_arch_suspend(void)
  * Memory allocated by get_safe_page() will be dealt with by the hibernate code,
  * we don't need to free it here.
  */
-int swsusp_arch_resume(void)
+int __nocfi swsusp_arch_resume(void)
 {
 	int rc;
 	void *zero_page;


