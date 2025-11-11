Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5D726056C;
	Tue, 11 Nov 2025 01:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823395; cv=none; b=Z1JE933PZxEug5riPocNNhHmv2rUnr2hCb9sgBnPCjBurMCDIlYX6uQGmbX18vO2YyJMb82ZpyKXhhFFsG1PCCejGouEmlLzrcWJE4yMcAsJAEGRuBOFMk7xBGeX8hge/aTGh1Q2xqJdzzSN5549zLgLQDmDln4UWOqLEpS0vSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823395; c=relaxed/simple;
	bh=BODOqef5+JbkAcBzobPJCEfRMFW6Dop69jnw/5utqWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9mNIPcjREXevD3e3V0/g5ddiIToql8O7PIMRM+i01VWJt6+IFVGZqchixliEOzMqOWRuSrEbET2JOH20iHWYuiQSBtfRoRoZ0CT1atKZENvUwANpuhQcuCQ0ns1akPbDZg5AzGOcR0S4ZhLN28ktyQRSDYRkwh9Aeqz6hYMcS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vk3km2cJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vk3km2cJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DDEC19421;
	Tue, 11 Nov 2025 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823395;
	bh=BODOqef5+JbkAcBzobPJCEfRMFW6Dop69jnw/5utqWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vk3km2cJmlN6ni8c5Ri70OCC/j/pEV+IES9ZPxwx8XOjs9HWJQOfeffuwA52o9DQR
	 n4m5Xh3lLb2GKAai7fiiG8gzQXrb+RvNwEMSYNi7Q4JAC9Ujilxo20sy2Mia+HCKoz
	 OkeL0uVwq82BNju/sB+X0sThQ8PNfPdhXhalcq5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH 6.17 292/849] x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall
Date: Tue, 11 Nov 2025 09:37:42 +0900
Message-ID: <20251111004543.467441879@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index c9103a6fa06e8..6e6c0a7408371 100644
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



