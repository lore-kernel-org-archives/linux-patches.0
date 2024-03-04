Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D191C6AB;
	Mon,  4 Mar 2024 21:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589171; cv=none; b=ZcyV1gd4C82MabX9SlmgIfWn2O1Ie0Oz191cR1hxB/aDa+CJfEP4/RHZlivVVgwTguuG7RQ5lpND64AT7tPHDbxmX9/4Hew9WK1OOy1tXGMsZCNxH45aej3X5JH1/o/0B6trMrfvHsJSsu4TrklY6pzBuW1SBPljieRwo9CAToE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589171; c=relaxed/simple;
	bh=tbe5fRHkeZZLuqAwDJxxTOYOvw2kaljiKgCAlNg+FDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIKeE2LIr4Axel1AsNj4GrG9BNojSK5KsSUWD001qRnPj7w4hpl4x514d59C/z7PahJ184+m6/+QV0gFjbxR8aZHMl3s2qlaz8JNpeyLXxD2YNRpykxxf8JaLlwDdzw23yb1SGNCXoX7hNlfZaMazEICFDXZSjp03KhYozPL0CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmxhZKG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmxhZKG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9BCC433F1;
	Mon,  4 Mar 2024 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589171;
	bh=tbe5fRHkeZZLuqAwDJxxTOYOvw2kaljiKgCAlNg+FDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmxhZKG8zouyZEZpfTXZXvOv5bp7hHZnjbnGVNJNGgjOEAMfcQ6g26vIo3SoqPpqV
	 tKodo4x/eKGbQx7DDidq+uRSJnkxEaqthsI30hooQKsu7vzlAHJ4ll0YmUuNUTVIUO
	 ptIAzuNfEhoUdGcatKZSDvJ76ybrD0/kd5N8m3No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.1 208/215] x86/entry_32: Add VERW just before userspace transition
Date: Mon,  4 Mar 2024 21:24:31 +0000
Message-ID: <20240304211603.592927824@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit a0e2dab44d22b913b4c228c8b52b2a104434b0b3 upstream.

As done for entry_64, add support for executing VERW late in exit to
user path for 32-bit mode.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-3-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -912,6 +912,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.
@@ -981,6 +982,7 @@ restore_all_switch_stack:
 
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
+	CLEAR_CPU_BUFFERS
 .Lirq_return:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
@@ -1173,6 +1175,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:


