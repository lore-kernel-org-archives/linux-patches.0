Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCF3350843;
	Tue, 26 Aug 2025 14:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219354; cv=none; b=WMEHRHEB3Lo1V0rXC1uDMFtf6ajUH3P1MI64VWa4wYVY78baFuT/K5knA6FLt9B3HUfj2yVYbvcdnHxnO1wayndVQKy/J39BfG+Vvt3S4Y/2tkusTvbHW0sSiMWFq0DQ4oJrUpbCJDz0z/XsPzhgW5E6ePDix+gxVn/3zCgKSew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219354; c=relaxed/simple;
	bh=TeZ9N8J9PP/jK4Ps9NCPMXrPdNzXJJmRc9mQkxGIDXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poLhj7l5CnvKJ508MKOmWOfnZ6UFFBVhCabKmEm31S55Tij9JYrAgOo9spoKCugstmUIye65zlgRe/qas7rDFdNX6DhKEPnrSg5+r39MF/CXwMxvbYC/8wADBqNP+fkamn+V64BjAoImZaoDpqeCBdScnd2FG9v1MLd4liny768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeYhyZQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeYhyZQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0190EC4CEF1;
	Tue, 26 Aug 2025 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219354;
	bh=TeZ9N8J9PP/jK4Ps9NCPMXrPdNzXJJmRc9mQkxGIDXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeYhyZQHjfs8wQd40+boclPfNrPWbKvQC68xok/XvjFIyYOrzofV66ehhCFaweAD4
	 fnKprOWSYaGGzdt8EH2TYEwF9FLvxsrIbR4h7cg8pAP+Uru/8EYEf209WVtiZZY2QV
	 UwOY8CA8iE0XVzYNAOXo46FGlJMuAa5fN/3+A18I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 348/403] x86/fpu: Delay instruction pointer fixup until after warning
Date: Tue, 26 Aug 2025 13:11:14 +0200
Message-ID: <20250826110916.486731950@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit 1cec9ac2d071cfd2da562241aab0ef701355762a ]

Right now, if XRSTOR fails a console message like this is be printed:

	Bad FPU state detected at restore_fpregs_from_fpstate+0x9a/0x170, reinitializing FPU registers.

However, the text location (...+0x9a in this case) is the instruction
*AFTER* the XRSTOR. The highlighted instruction in the "Code:" dump
also points one instruction late.

The reason is that the "fixup" moves RIP up to pass the bad XRSTOR and
keep on running after returning from the #GP handler. But it does this
fixup before warning.

The resulting warning output is nonsensical because it looks like the
non-FPU-related instruction is #GP'ing.

Do not fix up RIP until after printing the warning. Do this by using
the more generic and standard ex_handler_default().

Fixes: d5c8028b4788 ("x86/fpu: Reinitialize FPU registers if restoring FPU state fails")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Acked-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250624210148.97126F9E%40davehans-spike.ostc.intel.com
[ adapted ex_handler_default() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/extable.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -59,13 +59,12 @@ __visible bool ex_handler_fprestore(cons
 				    unsigned long error_code,
 				    unsigned long fault_addr)
 {
-	regs->ip = ex_fixup_addr(fixup);
-
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
 	__copy_kernel_to_fpregs(&init_fpstate, -1);
-	return true;
+
+	return ex_handler_default(fixup, regs, trapnr, error_code, fault_addr);
 }
 EXPORT_SYMBOL_GPL(ex_handler_fprestore);
 


