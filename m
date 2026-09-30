Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5E75012B1;
	Wed, 30 Sep 2026 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784906; cv=none; b=m1r0uLeBXtCe0qeWvCPtBafIh1pjJRY+dlTVHRWm6d2qMmSS7HLZi7qZJCnGiXFhFMHH16VfPJMh7nyKSPeBVqI+uyDp2r5zh8IVQqyt57HhPdHp77KEfmEtRIWe/oNKtybF1L2gLIX3EvmTfzPgtBocaCi7wQmJGPOFN+Oycxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784906; c=relaxed/simple;
	bh=E+H9g1xwJp6DmWXm5F36uWgQDDLyXlUBzZvVyNz9VhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nqt12SEWGcAy+36JljuljsgFGqaZQoQ3b6O3hHwXAOqhQCXYEtXZgZKtdDLbPGIwFqghLRT3sRBSLj3UB66xJiWCC8jtdDi8DhU10z+dq5lnSjOfBnCS4cKbmf9wWKhrTjyTpbMNsEjEOy9WK2uPCHzy18exCD9coujEozcpWro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klj8Fkv1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klj8Fkv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FAD1F000FF;
	Wed, 30 Sep 2026 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784898;
	bh=BcycYaMghZxHuEyEtFYfsIXyQWSSQ1c3N5pbfbwTQ9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klj8Fkv1g1shZZ41vqPddbYji/0pOVykmHVBe2YVciGNNZoBDFWurLXlUmIgE+NjU
	 v+9BZjphnxsYDFfFidQOQwi4VeSHQBtJSfFmk7hOa15IgfhGFx9BJvUeK9jUw/yfBu
	 EWtjj2i+TSp2NgKVnMIXWPrNge6jivUPppBTrMiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yadi.hu" <yadi.hu@windriver.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 319/982] ARM: ensure interrupts are enabled in __do_user_fault()
Date: Wed, 30 Sep 2026 17:17:35 +0200
Message-ID: <20260930152423.673006691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 59e4f3b45b96a24fc9b7a89e5f8a2168b30f95af ]

__do_user_fault() may be called from fault handling paths where the
interrupts are enabled or disabled. E.g. do_page_fault() calls this
with interrupts enabled, whereas do_sect_fault()->do_bad_area()
will call this with interrupts disabled. Since this is a userspace
fault, we know that interrupts were enabled in the parent context,
so call local_irq_enable() here to give a consistent interrupt state.

This is necessary for force_sig_info() when PREEMPT_RT is enabled.

Reported-by: Yadi.hu <yadi.hu@windriver.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 1010e808e2308..3d15acacc6866 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -187,7 +187,8 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 
 /*
  * Something tried to access memory that isn't in our memory map..
- * User mode accesses just cause a SIGSEGV
+ * User mode accesses just cause a SIGSEGV. Ensure interrupts are enabled
+ * for preempt RT.
  */
 static void
 __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
@@ -195,6 +196,8 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 {
 	struct task_struct *tsk = current;
 
+	local_irq_enable();
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
@@ -251,6 +254,7 @@ do_kernel_address_page_fault(struct mm_struct *mm, unsigned long addr,
 		 * should not be faulting in kernel space, which includes the
 		 * vector/khelper page. Handle the branch predictor hardening
 		 * while interrupts are still disabled, then send a SIGSEGV.
+		 * Note that __do_user_fault() will enable interrupts.
 		 */
 		harden_branch_predictor();
 		__do_user_fault(addr, fsr, SIGSEGV, SEGV_MAPERR, regs);
-- 
2.53.0



