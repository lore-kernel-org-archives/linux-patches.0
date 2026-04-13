Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D7F3203B6;
	Mon, 13 Apr 2026 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099370; cv=none; b=u4xt2Pb0D1mF9CLTb76WZks4kUlDsVvU/9ec+OKhpVMwE3CFWn1XjsuKGicK27bt/rl2aybZdVpx1HdRbiJG+oWP+rjQshQTR5tvYO8jachsGI7e4T0fUZoRm2OiVIiQj+nvM7b+Dljt5/RLuMIohZVmi4NGXetj2ebR134xQ9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099370; c=relaxed/simple;
	bh=j0Y4V/iLMhYPSyBs3HrK8W02yt3GJoiN4Qnubz5OVi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2wAl1AMd3s2Fbc/e6dmBOA+RBRuru73kIQQhZP4yoxYRH6og6ZtWxGm50dQkMMb/yEXGyX5gipHBw5Sldo3iZxGc0ObrzWOfVXhQIVr6Rxs6bFRNG2ZLKZt/dWCQKzcw7pTIo/tSFa+xYu+VG9IsmDP9VH2GR2qeDvJWRKCL3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxoUtqCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxoUtqCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F742C2BCAF;
	Mon, 13 Apr 2026 16:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099370;
	bh=j0Y4V/iLMhYPSyBs3HrK8W02yt3GJoiN4Qnubz5OVi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxoUtqCk1zaWic/3o5AYBR51RE3lGRclzzTYsZ4CM6f1wxJfA3b0mQT0xQuqqszzR
	 vYSUV3/vwiz7fSNzoz4zpqFQMDZ26h1xqms0uDbg2YWDvOE+2ufyK5cmCNcAISy1WH
	 m600Ihx78tdKnK541mk080vrMuSXBgCuy3fmReVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/491] x86/fault: Improve kernel-executing-user-memory handling
Date: Mon, 13 Apr 2026 17:58:47 +0200
Message-ID: <20260413155829.603695727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit 03c81ea3331658f613bb2913d33764a4e0410cbd ]

Right now, the case of the kernel trying to execute from user memory
is treated more or less just like the kernel getting a page fault on a
user access. In the failure path, it checks for erratum #93, tries to
otherwise fix up the error, and then oopses.

If it manages to jump to the user address space, with or without SMEP,
it should not try to resolve the page fault. This is an error, pure and
simple. Rearrange the code so that this case is caught early, check for
erratum #93, and bail out.

 [ bp: Massage commit message. ]

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/ab8719c7afb8bd501c4eee0e36493150fbbe5f6a.1612924255.git.luto@kernel.org
Stable-dep-of: 217c0a5c177a ("x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/fault.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 07983b6208f52..e06182127e1c8 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -433,6 +433,9 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	    || boot_cpu_data.x86 != 0xf)
 		return 0;
 
+	if (user_mode(regs))
+		return 0;
+
 	if (address != regs->ip)
 		return 0;
 
@@ -697,9 +700,6 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	if (is_prefetch(regs, error_code, address))
 		return;
 
-	if (is_errata93(regs, address))
-		return;
-
 	/*
 	 * Buggy firmware could access regions which might page fault, try to
 	 * recover from such faults.
@@ -1162,6 +1162,21 @@ void do_user_addr_fault(struct pt_regs *regs,
 	tsk = current;
 	mm = tsk->mm;
 
+	if (unlikely((error_code & (X86_PF_USER | X86_PF_INSTR)) == X86_PF_INSTR)) {
+		/*
+		 * Whoops, this is kernel mode code trying to execute from
+		 * user memory.  Unless this is AMD erratum #93, which
+		 * corrupts RIP such that it looks like a user address,
+		 * this is unrecoverable.  Don't even try to look up the
+		 * VMA.
+		 */
+		if (is_errata93(regs, address))
+			return;
+
+		bad_area_nosemaphore(regs, error_code, address);
+		return;
+	}
+
 	/* kprobes don't want to hook the spurious faults: */
 	if (unlikely(kprobe_page_fault(regs, X86_TRAP_PF)))
 		return;
-- 
2.53.0



