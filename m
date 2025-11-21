Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49574314D2F;
	Fri, 21 Nov 2025 13:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732573; cv=none; b=iLRxm2QGsSkSMo9YP7wSB2D1GTH/NwnJjoihuJJkFuDBlQiw3F6unEc4PoYdtr/COE54nKTIwG25MmdgNksT06UQqLU43xmTQaVeapkaRRWhfJX8bwdHdJEbNVEUZ6Ajca109cGOE1Nq8qFN5NA2iQrPZj2SvImB4aJ9eM76yCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732573; c=relaxed/simple;
	bh=2Ru2fWAVOnQf+wO1o0CsraSof6O0ZHcB+XfYnhrjmSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ5K/HVzAp/Q/Lln0n4WdOz6t4nBoB7kZy5ECgQX6gamBnt7xVSi/HIAX6vsZB+FS3s5+KpIoR27uJBNdqjMI0AmZm9mlur1x1XtnK/nSstk3ivkkhwQDkMUOEH14VYMhsJMmNOwVw7QUHFHZjw63cDALVOJ/sn0vsByzqtpRiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLSOoBwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLSOoBwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D1EC4CEF1;
	Fri, 21 Nov 2025 13:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732573;
	bh=2Ru2fWAVOnQf+wO1o0CsraSof6O0ZHcB+XfYnhrjmSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLSOoBwDp53X/DB/e6nMLHv0hHaJR/y6s4LMF6uMQ9MJO4pH+BFfiW9+PDoFdgTyo
	 yMl1WrCApdL5qRQPdVTxPlpjfD/2u9NIz0vPWOlzjbbwND5em0cnXlurOABR3kzcYV
	 K9TvL3LCje6MrLJijbVsynFPFiIomDh7aN0dRlrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH 6.6 135/529] x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall
Date: Fri, 21 Nov 2025 14:07:14 +0100
Message-ID: <20251121130235.823157088@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit 8ba38a7a9a699905b84fa97578a8291010dec273 ]

emulate_vsyscall() expects to see X86_PF_INSTR in PFEC on a vsyscall
page fault, but the CPU does not report X86_PF_INSTR if neither
X86_FEATURE_NX nor X86_FEATURE_SMEP are enabled.

X86_FEATURE_NX should be enabled on nearly all 64-bit CPUs, except for
early P4 processors that did not support this feature.

Instead of explicitly checking for X86_PF_INSTR, compare the fault
address to RIP.

On machines with X86_FEATURE_NX enabled, issue a warning if RIP is equal
to fault address but X86_PF_INSTR is absent.

[ dhansen: flesh out code comments ]

Originally-by: Dave Hansen <dave.hansen@intel.com>
Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Link: https://lore.kernel.org/all/bd81a98b-f8d4-4304-ac55-d4151a1a77ab@intel.com
Link: https://lore.kernel.org/all/20250624145918.2720487-1-kirill.shutemov%40linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vsyscall/vsyscall_64.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index 2fb7d53cf3338..95e053b0a4bc0 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -124,7 +124,12 @@ bool emulate_vsyscall(unsigned long error_code,
 	if ((error_code & (X86_PF_WRITE | X86_PF_USER)) != X86_PF_USER)
 		return false;
 
-	if (!(error_code & X86_PF_INSTR)) {
+	/*
+	 * Assume that faults at regs->ip are because of an
+	 * instruction fetch. Return early and avoid
+	 * emulation for faults during data accesses:
+	 */
+	if (address != regs->ip) {
 		/* Failed vsyscall read */
 		if (vsyscall_mode == EMULATE)
 			return false;
@@ -136,13 +141,19 @@ bool emulate_vsyscall(unsigned long error_code,
 		return false;
 	}
 
+	/*
+	 * X86_PF_INSTR is only set when NX is supported.  When
+	 * available, use it to double-check that the emulation code
+	 * is only being used for instruction fetches:
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_NX))
+		WARN_ON_ONCE(!(error_code & X86_PF_INSTR));
+
 	/*
 	 * No point in checking CS -- the only way to get here is a user mode
 	 * trap to a high address, which means that we're in 64-bit user code.
 	 */
 
-	WARN_ON_ONCE(address != regs->ip);
-
 	if (vsyscall_mode == NONE) {
 		warn_bad_vsyscall(KERN_INFO, regs,
 				  "vsyscall attempted with vsyscall=none");
-- 
2.51.0



