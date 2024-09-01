Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833941C68C;
	Sun,  1 Sep 2024 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208251; cv=none; b=mUcBuHyD4hl6tsJcjuUYS4LKB9P4ZG1zOghhNO+59eyY4nKaKPQ3BzNjU4Xc3I4hLtUsCVxEeg/4iEgAgXst1nTQDPZxJNcDIccKcONJBvrpTL1BTEPg1LR1D6sigM34C96Z/sEGC+yUnnhlS+tBcy6R/3RbQKqoTAeRlR3UGno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208251; c=relaxed/simple;
	bh=Vxh27VCyrVKrsdUP/JV0FjJjru9fUmfs8ZSL4Kw71lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRtqOQHJnA2cpTDeMDDvTkO+awhwqrFRViKQhLFvDiBnhZialsXeiSJF8MFrVEUU+OnxbBF1eR3fhuhuzDU1LkoG3e6bLPiCT8ks2UwHEjyuWUElm7K/vwDJvROR91DaGuCjb6ANKn+T2MvyZv40XD/yloi6OoVnDuxd5VVOsH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUhSmkvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUhSmkvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA31DC4CEC3;
	Sun,  1 Sep 2024 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208251;
	bh=Vxh27VCyrVKrsdUP/JV0FjJjru9fUmfs8ZSL4Kw71lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUhSmkvAH2c2fpDAa0er5z2Hnvc0VStJzeU8ru21/uHNpOdXmMIyjNcMbNhRDn9lY
	 rCOG3aPZjjzc48LzjzRLJVPRXvKmmQLYSs89Rr+3M5IIwe+I44uBBs6yP6Prw7Ky4W
	 /ZyVMVEAEUVOp2yZHcYY19oHt8mHzcSRjwmyErKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.10 007/149] LoongArch: Add ifdefs to fix LSX and LASX related warnings
Date: Sun,  1 Sep 2024 18:15:18 +0200
Message-ID: <20240901160817.741612008@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 80376323e2b6a4559f86b2b4d864848ac25cb054 upstream.

There exist some warnings when building kernel if CONFIG_CPU_HAS_LBT is
set but CONFIG_CPU_HAS_LSX and CONFIG_CPU_HAS_LASX are not set. In this
case, there are no definitions of _restore_lsx & _restore_lasx and there
are also no definitions of kvm_restore_lsx & kvm_restore_lasx in fpu.S
and switch.S respectively, just add some ifdefs to fix these warnings.

  AS      arch/loongarch/kernel/fpu.o
arch/loongarch/kernel/fpu.o: warning: objtool: unexpected relocation symbol type in .rela.discard.func_stack_frame_non_standard: 0
arch/loongarch/kernel/fpu.o: warning: objtool: unexpected relocation symbol type in .rela.discard.func_stack_frame_non_standard: 0

  AS [M]  arch/loongarch/kvm/switch.o
arch/loongarch/kvm/switch.o: warning: objtool: unexpected relocation symbol type in .rela.discard.func_stack_frame_non_standard: 0
arch/loongarch/kvm/switch.o: warning: objtool: unexpected relocation symbol type in .rela.discard.func_stack_frame_non_standard: 0

  MODPOST Module.symvers
ERROR: modpost: "kvm_restore_lsx" [arch/loongarch/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_restore_lasx" [arch/loongarch/kvm/kvm.ko] undefined!

Cc: stable@vger.kernel.org # 6.9+
Fixes: cb8a2ef0848c ("LoongArch: Add ORC stack unwinder support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408120955.qls5oNQY-lkp@intel.com/
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/fpu.S | 4 ++++
 arch/loongarch/kvm/switch.S | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/loongarch/kernel/fpu.S b/arch/loongarch/kernel/fpu.S
index 69a85f2479fb..6ab640101457 100644
--- a/arch/loongarch/kernel/fpu.S
+++ b/arch/loongarch/kernel/fpu.S
@@ -530,6 +530,10 @@ SYM_FUNC_END(_restore_lasx_context)
 
 #ifdef CONFIG_CPU_HAS_LBT
 STACK_FRAME_NON_STANDARD _restore_fp
+#ifdef CONFIG_CPU_HAS_LSX
 STACK_FRAME_NON_STANDARD _restore_lsx
+#endif
+#ifdef CONFIG_CPU_HAS_LASX
 STACK_FRAME_NON_STANDARD _restore_lasx
 #endif
+#endif
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 80e988985a6a..0c292f818492 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -277,6 +277,10 @@ SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
 
 #ifdef CONFIG_CPU_HAS_LBT
 STACK_FRAME_NON_STANDARD kvm_restore_fpu
+#ifdef CONFIG_CPU_HAS_LSX
 STACK_FRAME_NON_STANDARD kvm_restore_lsx
+#endif
+#ifdef CONFIG_CPU_HAS_LASX
 STACK_FRAME_NON_STANDARD kvm_restore_lasx
 #endif
+#endif
-- 
2.46.0



