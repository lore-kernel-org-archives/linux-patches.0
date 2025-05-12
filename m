Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ACA254879;
	Mon, 12 May 2025 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072323; cv=none; b=LpF5b6w8bmXYGcPsKT5oosteBvffnbtemOPnBfdWhel41/35BTavOfcrl3ZBfKgyaUQcW1/NDd8zusi899K7W5AhKOLzqpthnIe+OffurKMPHqEHqzwNglDarYx2Ge7LS42vmiCikXiQHcxkB7VlrOb3v+LjLUx5rOI0KuxrHYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072323; c=relaxed/simple;
	bh=H64WLA7skabmyREhakpp4Pau36Z3CplJweh4i/1yxQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQELFfQM9bT8Oj+hrhD3ICUT0la83EMzKpn8bQk0YjfkaMxCmXW6q8zcjhCCsTO4I7F9B2sNVvO/1njCZdCDgvfP7lW1c9TXC9Jewv44YNjGrtjLxpClkw9Zpt7X2l8UWTxEtyeU3dujZAflNHRBpK3wVFu9mZR/3eMzWd0Ze24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1uG5+nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1uG5+nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253C0C4CEE7;
	Mon, 12 May 2025 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072323;
	bh=H64WLA7skabmyREhakpp4Pau36Z3CplJweh4i/1yxQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1uG5+ndo7FnnA8/Yuoy4fJ/L2/Nj/94zNIxJHs5RoCoYKUeIQYW2RQIHZB0TdxG3
	 89XW0jkmLLDcHDjlbWJ4ANjPIwzdT+DyEJCK4WpEt5gst/gfaA/7CQvan3LWgD87KG
	 A1Y8mLD5pLnkPUiGmb/zTvNfik0NStKwFMrjB/YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.14 195/197] x86/ibt: Keep IBT disabled during alternative patching
Date: Mon, 12 May 2025 19:40:45 +0200
Message-ID: <20250512172052.356743250@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit ebebe30794d38c51f71fe4951ba6af4159d9837d upstream.

cfi_rewrite_callers() updates the fineIBT hash matching at the caller side,
but except for paranoid-mode it relies on apply_retpoline() and friends for
any ENDBR relocation. This could temporarily cause an indirect branch to
land on a poisoned ENDBR.

For instance, with para-virtualization enabled, a simple wrmsrl() could
have an indirect branch pointing to native_write_msr() who's ENDBR has been
relocated due to fineIBT:

<wrmsrl>:
       push   %rbp
       mov    %rsp,%rbp
       mov    %esi,%eax
       mov    %rsi,%rdx
       shr    $0x20,%rdx
       mov    %edi,%edi
       mov    %rax,%rsi
       call   *0x21e65d0(%rip)        # <pv_ops+0xb8>
       ^^^^^^^^^^^^^^^^^^^^^^^

Such an indirect call during the alternative patching could #CP if the
caller is not *yet* adjusted for the new target ENDBR. To prevent a false
 #CP, keep CET-IBT disabled until all callers are patched.

Patching during the module load does not need to be guarded by IBT-disable
because the module code is not executed until the patching is complete.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -31,6 +31,7 @@
 #include <asm/paravirt.h>
 #include <asm/asm-prototypes.h>
 #include <asm/cfi.h>
+#include <asm/ibt.h>
 
 int __read_mostly alternatives_patched;
 
@@ -1748,6 +1749,8 @@ static noinline void __init alt_reloc_se
 
 void __init alternative_instructions(void)
 {
+	u64 ibt;
+
 	int3_selftest();
 
 	/*
@@ -1774,6 +1777,9 @@ void __init alternative_instructions(voi
 	 */
 	paravirt_set_cap();
 
+	/* Keep CET-IBT disabled until caller/callee are patched */
+	ibt = ibt_save(/*disable*/ true);
+
 	__apply_fineibt(__retpoline_sites, __retpoline_sites_end,
 			__cfi_sites, __cfi_sites_end, NULL);
 
@@ -1797,6 +1803,8 @@ void __init alternative_instructions(voi
 	 */
 	apply_seal_endbr(__ibt_endbr_seal, __ibt_endbr_seal_end, NULL);
 
+	ibt_restore(ibt);
+
 #ifdef CONFIG_SMP
 	/* Patch to UP if other cpus not imminent. */
 	if (!noreplace_smp && (num_present_cpus() == 1 || setup_max_cpus <= 1)) {


