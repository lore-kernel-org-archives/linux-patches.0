Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EEB1E5736;
	Mon, 21 Oct 2024 10:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507697; cv=none; b=MQiV+rQj4XJ6f6fVgte60EK/K5t13yJE/jj+qWU3tpgOGta50hA+eOGoGQitQeB+ulzS64W/mN59fYVz+wBEygXqslvNJPbNRYc6J5aTSdgeWnSFRziS54EazUZY8Hsw+JZouh+Tpy2o0b2AtyxpwAd5GsXTl9SE6I+qmiSyAAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507697; c=relaxed/simple;
	bh=9LNFU2Ljz2nFmivDi1KMAXlRgef6GfqCR840g/Eq5J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh8fBteb0z6XXRSs9eFloeym4IjmCNF9geMPqspvbr3dfBwp/zJYa5Mdv632B1xp6sl/sVTLFW3VNF6ziYskDPLJDukvzvG59VSZ3OXkDpTIJ1pAHdnatsrFA+OFUJDYvPawCud60LJ7z9lwzjdL/a1bfIG3dCP0ei7GpL4Qce0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLnpIsnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLnpIsnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4ABC4CEC3;
	Mon, 21 Oct 2024 10:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507696;
	bh=9LNFU2Ljz2nFmivDi1KMAXlRgef6GfqCR840g/Eq5J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLnpIsnNZE0bB4zj3JC3P2mb6s7QtqA4EJz3pRY8g84gxc2rabYjPVGmtz+ZQaXJX
	 hHcVe37BXA9RFJwnFsjEiBh79lhOX0YlD7v0YgaksjE6uyrxJVIs7mQimXQAEIDz3x
	 bIz4JmHkqBXQ0Rmvuf6wQpGDPtipg3GGBKMWENDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.15 71/82] x86/entry_32: Clear CPU buffers after register restore in NMI return
Date: Mon, 21 Oct 2024 12:25:52 +0200
Message-ID: <20241021102250.023857459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 48a2440d0f20c826b884e04377ccc1e4696c84e9 upstream.

CPU buffers are currently cleared after call to exc_nmi, but before
register state is restored. This may be okay for MDS mitigation but not for
RDFS. Because RDFS mitigation requires CPU buffers to be cleared when
registers don't have any sensitive data.

Move CLEAR_CPU_BUFFERS after RESTORE_ALL_NMI.

Fixes: a0e2dab44d22 ("x86/entry_32: Add VERW just before userspace transition")
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240925-fix-dosemu-vm86-v7-2-1de0daca2d42%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1176,7 +1176,6 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
-	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:
@@ -1197,6 +1196,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	CHECK_AND_APPLY_ESPFIX
 	RESTORE_ALL_NMI cr3_reg=%edi pop=4
+	CLEAR_CPU_BUFFERS
 	jmp	.Lirq_return
 
 #ifdef CONFIG_X86_ESPFIX32
@@ -1238,6 +1238,7 @@ SYM_CODE_START(asm_exc_nmi)
 	 *  1 - orig_ax
 	 */
 	lss	(1+5+6)*4(%esp), %esp			# back to espfix stack
+	CLEAR_CPU_BUFFERS
 	jmp	.Lirq_return
 #endif
 SYM_CODE_END(asm_exc_nmi)


