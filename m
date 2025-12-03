Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA50E330306;
	Wed,  3 Dec 2025 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779072; cv=none; b=oVIZRQI0A/xPqVmLD4UGVlrIWgEQRBsBspsc52GKnnTqsHW7dhVYOsZbtuuYWkK25QShYpeK5A73uFRZJfthcO/rs9FJkMpoAMHvfrWR2I5Y/Iuevw6IegTkqZiaV2z5NDF04rJmEzFyYhFzlumUKEWEoOxrUIiv+1EHG57tIzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779072; c=relaxed/simple;
	bh=ESPLBqYILFSB6sOxNCl9jtobpglS0qONy4R84NtoP3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSku9+8/m4RzXKL3rhTlHylptFSLy2iKnNTQXBkPMdUfG7dMfTJxCw3UxrxyavtL2lZdhY1dMtPGsL5tDwzL7TOLHJEXnvW20c/51/MAXl9lJawMGgB1DpRM9VcHaP29tdPKJNccG3Qf5PeS2DPxewaZcXqjVFUpT5D+KOmU/F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzKhJeJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzKhJeJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A978BC4CEF5;
	Wed,  3 Dec 2025 16:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779072;
	bh=ESPLBqYILFSB6sOxNCl9jtobpglS0qONy4R84NtoP3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzKhJeJllVusyAZ8r8gb2+S1nH6QMPSyYc0p0Uxa77ETZ5Vtd42uN372eePZsbXFh
	 ub3S8XNia2eETva6NYG9sJXRMO6IwD1xOJJDXR5clvy0sM+i0etYajYuHnZxNQJW1C
	 huFAzYtLXv/e3e1z6C/b5LjRqzo90fO2Z0R3D++k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH 6.1 147/568] x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall
Date: Wed,  3 Dec 2025 16:22:29 +0100
Message-ID: <20251203152446.113507096@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 5d4ca8b942939..9404f9f416660 100644
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



