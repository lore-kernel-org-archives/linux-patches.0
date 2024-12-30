Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAA415E8B;
	Mon, 30 Dec 2024 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574387; cv=none; b=h5zfL3dMmClrE+k7JF469z+NSQjtVazw6MeVrbYKnKciGMrceBq9mLvbBHJ5wpQma6sCFDxTQFxZiR9t6oPlp391lwhvw0BMDxcfanQuuBzQHOPiwD/T77UumWXqay+tYjgcIALZkRB3MAYQ7EL/alzjcfXeD3aj2sUcByn4PWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574387; c=relaxed/simple;
	bh=wFdYgDNkZw95J20D4vqQoi0ZLBeP1BO3mCo1S14t3dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpDbriKW9GrVrOR0I1VSJoJAUPjY/HNwqgOvNJlebiDA6UTcKwij05/r78nugKQiXfHmxAKmNfsFPOxUt6cKNVtxsdNUcj3zXxu589PlmNJ7XSIS7p6TLSGIiLchTbsN+DccrPHlvUZYad6a2QVtoJamw/P5ILm+cVNtZOA5TjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PL8dAwES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PL8dAwES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FDAC4CED0;
	Mon, 30 Dec 2024 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574387;
	bh=wFdYgDNkZw95J20D4vqQoi0ZLBeP1BO3mCo1S14t3dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL8dAwES31fmNqo66he7wbAHNzeio0DbU5Z1vtaBZuFyC/YiH/ZeEmp2mz6KDVN6p
	 hpDyfxfjZ9MPckSwOAF2pVAN56s/+Bdj3gI5gaFcoF6Ccc9rEx7M/y7RatkKAMmHKY
	 bMWP0myVUdWcAVCQQP9tB4bFNsczoc4+tWZQSUzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xin Li (Intel)" <xin@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.12 090/114] x86/fred: Clear WFE in missing-ENDBRANCH #CPs
Date: Mon, 30 Dec 2024 16:43:27 +0100
Message-ID: <20241230154221.558109379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Li (Intel) <xin@zytor.com>

commit dc81e556f2a017d681251ace21bf06c126d5a192 upstream.

An indirect branch instruction sets the CPU indirect branch tracker
(IBT) into WAIT_FOR_ENDBRANCH (WFE) state and WFE stays asserted
across the instruction boundary.  When the decoder finds an
inappropriate instruction while WFE is set ENDBR, the CPU raises a #CP
fault.

For the "kernel IBT no ENDBR" selftest where #CPs are deliberately
triggered, the WFE state of the interrupted context needs to be
cleared to let execution continue.  Otherwise when the CPU resumes
from the instruction that just caused the previous #CP, another
missing-ENDBRANCH #CP is raised and the CPU enters a dead loop.

This is not a problem with IDT because it doesn't preserve WFE and
IRET doesn't set WFE.  But FRED provides space on the entry stack
(in an expanded CS area) to save and restore the WFE state, thus the
WFE state is no longer clobbered, so software must clear it.

Clear WFE to avoid dead looping in ibt_clear_fred_wfe() and the
!ibt_fatal code path when execution is allowed to continue.

Clobbering WFE in any other circumstance is a security-relevant bug.

[ dhansen: changelog rewording ]

Fixes: a5f6c2ace997 ("x86/shstk: Add user control-protection fault handler")
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241113175934.3897541-1-xin%40zytor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cet.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -81,6 +81,34 @@ static void do_user_cp_fault(struct pt_r
 
 static __ro_after_init bool ibt_fatal = true;
 
+/*
+ * By definition, all missing-ENDBRANCH #CPs are a result of WFE && !ENDBR.
+ *
+ * For the kernel IBT no ENDBR selftest where #CPs are deliberately triggered,
+ * the WFE state of the interrupted context needs to be cleared to let execution
+ * continue.  Otherwise when the CPU resumes from the instruction that just
+ * caused the previous #CP, another missing-ENDBRANCH #CP is raised and the CPU
+ * enters a dead loop.
+ *
+ * This is not a problem with IDT because it doesn't preserve WFE and IRET doesn't
+ * set WFE.  But FRED provides space on the entry stack (in an expanded CS area)
+ * to save and restore the WFE state, thus the WFE state is no longer clobbered,
+ * so software must clear it.
+ */
+static void ibt_clear_fred_wfe(struct pt_regs *regs)
+{
+	/*
+	 * No need to do any FRED checks.
+	 *
+	 * For IDT event delivery, the high-order 48 bits of CS are pushed
+	 * as 0s into the stack, and later IRET ignores these bits.
+	 *
+	 * For FRED, a test to check if fred_cs.wfe is set would be dropped
+	 * by compilers.
+	 */
+	regs->fred_cs.wfe = 0;
+}
+
 static void do_kernel_cp_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	if ((error_code & CP_EC) != CP_ENDBR) {
@@ -90,6 +118,7 @@ static void do_kernel_cp_fault(struct pt
 
 	if (unlikely(regs->ip == (unsigned long)&ibt_selftest_noendbr)) {
 		regs->ax = 0;
+		ibt_clear_fred_wfe(regs);
 		return;
 	}
 
@@ -97,6 +126,7 @@ static void do_kernel_cp_fault(struct pt
 	if (!ibt_fatal) {
 		printk(KERN_DEFAULT CUT_HERE);
 		__warn(__FILE__, __LINE__, (void *)regs->ip, TAINT_WARN, regs, NULL);
+		ibt_clear_fred_wfe(regs);
 		return;
 	}
 	BUG();


