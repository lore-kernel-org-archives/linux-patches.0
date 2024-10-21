Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D7416F27E;
	Mon, 21 Oct 2024 10:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506776; cv=none; b=qyYviE+XcJyJxy+y7moKDnb50nP1Xm1VAfpOv7ke6iyZBqbyQGktxeNrBzWmoB0KCPdUX730qEJrgRm25pB7eQD76/6BtJwO/DI9ovqMfFrKc9sZDJ/b1UyRe4vpfgJpCv+CZV4K2OZYTXztx33X5MLVCJYd6XMsiU1z/rTSKTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506776; c=relaxed/simple;
	bh=f1sGoijTpFN6xU5k6OC4r/LO0pAjO3AUH/TU6zER6QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlC+AQ9wHx4dVEt83/6f3s497ggAAyl11RFuY0wFw6RKRQXH41wJDGmlZkwl3zeetBjRMDPU/F9H0ZOCakgGOlFnCbHASUC/55BCy7qWJ2fojBrT04sXBi8507n5zVTu2Z2jNK/tX0tYotWavQ/X/0LX6qsjRXkb3fcg9PryBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPHh7mlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPHh7mlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F96C4CEC3;
	Mon, 21 Oct 2024 10:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506775;
	bh=f1sGoijTpFN6xU5k6OC4r/LO0pAjO3AUH/TU6zER6QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPHh7mlqzfv4Jz0MS0LfBSlE1TmTjZVBXZQJn8vEvbrzWsFvpi3pjgSQy5gG5uGu9
	 I9pyswHR6G3fmNksZtej2Z+LxHtVdj8fsLVmCZwdgIkz4T5nuUD5ScUGttelvWF8X/
	 ls8u8nv2Ezkke+G1wYz/XCAR/pcW1j8Y9mcdLNeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.11 118/135] x86/entry_32: Clear CPU buffers after register restore in NMI return
Date: Mon, 21 Oct 2024 12:24:34 +0200
Message-ID: <20241021102303.945289737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1145,7 +1145,6 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
-	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:
@@ -1166,6 +1165,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	CHECK_AND_APPLY_ESPFIX
 	RESTORE_ALL_NMI cr3_reg=%edi pop=4
+	CLEAR_CPU_BUFFERS
 	jmp	.Lirq_return
 
 #ifdef CONFIG_X86_ESPFIX32
@@ -1207,6 +1207,7 @@ SYM_CODE_START(asm_exc_nmi)
 	 *  1 - orig_ax
 	 */
 	lss	(1+5+6)*4(%esp), %esp			# back to espfix stack
+	CLEAR_CPU_BUFFERS
 	jmp	.Lirq_return
 #endif
 SYM_CODE_END(asm_exc_nmi)


