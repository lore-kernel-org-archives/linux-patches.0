Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DE9305065;
	Sat, 25 Oct 2025 16:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408820; cv=none; b=vAAzDSUVrfmLVaCdjB432y9pI29ta6g9dYfv99V9cSt9GXSlIXh+IPgGs3tvm51xLnGwI691KUGqx1ISV4idTgCL8V87ho82kfAgt2cqCAiJ/SxciQvwBa58ngSu+SLlBDXTtKHbMu6+w/auMst90KTn1M41wHp/Eqt2dQ4VfKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408820; c=relaxed/simple;
	bh=VcQp5qeVD6Y+aKXeAFG/9MBShNmhebThUlkMsWij/1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bhHpEm8Wk1o2x4JxMBqd6r5jym7v+ZmLA2Y2UHEICPB5hL8XMp6EoEIXgHd82DMunaYJIe3UijSH1Yb9VR8eTSq6jMGsS2ytU1pEwq2FPCbNI1gZ8cSN7Hvi9lhvuMy6r81OdgrxVfMEvDvy8mZtnXuGIja5z6wTDKRNVVUtvV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0jibp8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0jibp8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF44C4CEF5;
	Sat, 25 Oct 2025 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408820;
	bh=VcQp5qeVD6Y+aKXeAFG/9MBShNmhebThUlkMsWij/1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0jibp8YN9sGf2h7dkYzzwdtb8A3p4PVwxHibX8C2q71ZUIRN6xIlvUc6gBVxI/Qx
	 1PzXG8eHbaY72bEUWdBhIddfr/e/7eCeRaAQ+Xee9pF2TLuZj1nfTy5vqkrZpUPzcU
	 0p7nteDqEdkZZ8UJG7BKR4IPQsb62J3R46eFzgeFYr7AaUGQ7dBKtD2Xp06kfWArPv
	 Mj1PV4OAOyNoOExKT7llh55eh6u39RWMQVHG92sBf5I3l6p+qfOpLfgneIcn11e8Hl
	 x5nnm73J4rVbxCxyoIO5/7sbfKH/U/7H0EdMAr45rPNs50ov32rxf13StaYjUkj6HG
	 wENyaplbYH4Ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kas@kernel.org,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-5.4] x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall
Date: Sat, 25 Oct 2025 11:55:14 -0400
Message-ID: <20251025160905.3857885-83-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

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

LLM Generated explanations, may be completely bogus:

YES

Why this is a bug
- Current emulation wrongly depends on `X86_PF_INSTR` to distinguish
  instruction fetches from data accesses. On CPUs without NX and SMEP,
  the CPU never sets `X86_PF_INSTR` for instruction faults, so genuine
  vsyscall execution faults are misclassified as data accesses and not
  emulated (breaking the legacy vsyscall ABI). Commit message explicitly
  notes this hardware behavior and the affected systems.

What changes in the patch
- Replaces the instruction-fault check from PFEC with an IP check:
  - Old: `if (!(error_code & X86_PF_INSTR)) { ... return false; }`
    `arch/x86/entry/vsyscall/vsyscall_64.c:127`
  - New: Treat the page fault as an instruction fetch iff `address ==
    regs->ip`, i.e., fault address equals RIP. This is the
    architecturally correct, feature-agnostic way to identify
    instruction fetch faults for vsyscall.
- Preserves existing behavior for vsyscall reads:
  - If `address != regs->ip`, still treat as a read-from-vsyscall-page
    and refuse emulation, keeping the same warning behavior for non-
    EMULATE modes.
- Adds a sanity check for NX-enabled systems:
  - If `X86_FEATURE_NX` is present but `X86_PF_INSTR` is missing despite
    `address == regs->ip`, emit a one-time warning to help catch
    anomalies without breaking functionality.
- Removes the passive assertion `WARN_ON_ONCE(address != regs->ip)`
  (previously only diagnostic at
  `arch/x86/entry/vsyscall/vsyscall_64.c:144`) and makes
  `address==regs->ip` the active gating condition, which fixes the
  actual misclassification on NX/SMEP-less CPUs.

Why it’s safe and appropriate for stable
- Fixes a real user-visible bug: vsyscall emulation fails on certain
  older x86-64 CPUs (notably some early P4 EM64T systems without NX),
  breaking legacy binaries that still use vsyscalls.
- Small, well-contained change: only touches
  `arch/x86/entry/vsyscall/vsyscall_64.c`; no ABI or architectural
  changes; no Kconfig or broad subsystem churn.
- Behavior-preserving where it matters:
  - On NX/SMEP-capable systems, functional behavior is unchanged; at
    most a WARN_ON_ONCE if PFEC is inconsistent. Emulation continues to
    occur only for instruction faults in the vsyscall page.
  - Data accesses to the vsyscall page remain denied exactly as before.
- Minimal regression risk:
  - Instruction fetches are reliably indicated by `CR2 == RIP` for the
    vsyscall fault path; the address gate plus `addr_to_vsyscall_nr()`
    ensures emulation only proceeds for valid vsyscall addresses.
  - The emulation code itself (syscall selection, seccomp handling,
    return emulation) is untouched.
- Conforms to stable rules: it’s a clear, targeted bugfix, not a
  feature; the scope is limited to x86 vsyscall emulation; risk is low;
  impact is correctness and compatibility on affected hardware.

Code references
- PFEC-based gate being replaced:
  `arch/x86/entry/vsyscall/vsyscall_64.c:127`
- Prior assertion about IP equality (now replaced by active gating):
  `arch/x86/entry/vsyscall/vsyscall_64.c:144`
- Emulation entry point and context: `arch/x86/mm/fault.c:1321` calls
  `emulate_vsyscall()` only for vsyscall addresses, ensuring the change
  is confined to the intended path.

Net effect
- Restores correct vsyscall emulation on CPUs where the CPU never sets
  `X86_PF_INSTR`, without impacting behavior where NX/SMEP is present.
  This is an important, low-risk bugfix suitable for backporting to
  stable trees.

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

