Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C7F1DF72E;
	Mon, 12 May 2025 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072624; cv=none; b=PzcNPe9CmbHXmWffm8BpC3VwjhOSsOtgi5iBBwNuxxxn9duZ6n7zQRgs8MZAXqxU4N8+wfUR/quEafS9djaXw9a5zQhuk2N0nQgqIwdJ50lYeNENuNsLiX097XyYn8fxtd/uzemMEQ/N33YbOj3QLI/g+WzoV+SsOrtVPm4ll0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072624; c=relaxed/simple;
	bh=FRMrahg/en/iZMC/bCw123bHBnArI6uoURifufpLlK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T01iJJ3hiZ88nidgjsz3GrLHwGspmSiTNWzOqJGUYX3cei596A5F2mf7Wrbf7Rb057CnJ0BcPcY8QKQbzhUJhk3cShpT4MCSzmF9ErK8meHOzpC0ga6AqH9aqblth+nktAj2o4ehOWJthGd3pe2+tHi3wAYnVP8+LQQwFaiH+tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xis13Vjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xis13Vjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E167C4CEE7;
	Mon, 12 May 2025 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072623;
	bh=FRMrahg/en/iZMC/bCw123bHBnArI6uoURifufpLlK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xis13Vjwjpat2ukv8qyxGCHdUd4u2esGFnhatP2KeYjNjqzRg8FmASrRzcmPsJEsU
	 9XQR4GykM8Br2fKmw5NjLiuxUhhSOX9mYsT2pbYoG09ZD8XXtJxlKhdQMNTeYEMqdS
	 9E1WQ786kizqE17xFAQgRWrfrai4mSzgbLB/EP3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.1 91/92] x86/ibt: Keep IBT disabled during alternative patching
Date: Mon, 12 May 2025 19:46:06 +0200
Message-ID: <20250512172026.831224986@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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

  [ pawan: Since apply_paravirt() happens before __apply_fineibt()
	   relocates the ENDBR, pv_ops in the example above is not relevant.
	   It is still safer to keep this commit because missing an ENDBR
	   means an oops. ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -30,6 +30,7 @@
 #include <asm/fixmap.h>
 #include <asm/paravirt.h>
 #include <asm/asm-prototypes.h>
+#include <asm/cfi.h>
 
 int __read_mostly alternatives_patched;
 
@@ -1006,6 +1007,8 @@ static noinline void __init int3_selftes
 
 void __init alternative_instructions(void)
 {
+	u64 ibt;
+
 	int3_selftest();
 
 	/*
@@ -1043,6 +1046,9 @@ void __init alternative_instructions(voi
 	 */
 	paravirt_set_cap();
 
+	/* Keep CET-IBT disabled until caller/callee are patched */
+	ibt = ibt_save();
+
 	/*
 	 * First patch paravirt functions, such that we overwrite the indirect
 	 * call with the direct call.
@@ -1064,6 +1070,8 @@ void __init alternative_instructions(voi
 
 	apply_ibt_endbr(__ibt_endbr_seal, __ibt_endbr_seal_end);
 
+	ibt_restore(ibt);
+
 #ifdef CONFIG_SMP
 	/* Patch to UP if other cpus not imminent. */
 	if (!noreplace_smp && (num_present_cpus() == 1 || setup_max_cpus <= 1)) {


