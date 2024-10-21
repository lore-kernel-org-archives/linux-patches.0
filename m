Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F3E195FEC;
	Mon, 21 Oct 2024 10:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507636; cv=none; b=VXZAuPSIyKplhY3Fd6CzXReUMJXV4TCOG69OmCRXtmQ4fbA7OmrTLlShnnIHwbjdb0q0Bi9UPRuxQSLpOumVNLF2KauRFSMNuw2dEdhxExEeM4hQZGfkSCUoiuEnsBlHe7HgYkDuUXlbOoZ8Fob2oFygxZOyMiSoCXVOjvw/gaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507636; c=relaxed/simple;
	bh=SZa9WfUpvdOy0r8eViOBNxTgaOIQgxwmVjUDV2YEYU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYKb731S2E1kKemGfInLoT1kfisd5FfDsy8j/7U/SRbMg5bf1fYxSCd2G4MAVWOWYjTO7lme31tbBH/jqNObXJ4oAHuAMUN/npCk+60yTpByCj5MHNlQ5Hvp9BY5Kxu1fHjQY6maBLjqHS1xGNkzLqAr6gqj1YwG/E6KocqpY4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6TK9jGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6TK9jGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D3FC4CEF1;
	Mon, 21 Oct 2024 10:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507636;
	bh=SZa9WfUpvdOy0r8eViOBNxTgaOIQgxwmVjUDV2YEYU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6TK9jGMH00LaWHzxgt709M94EMgEaktQBOXgT35+Q30v1fQx0UKVL24CxPkLS+nV
	 4+h/K/xbH9jCtOp0J0DbHU1Juk4hM08zt92nQwwXRHdDhvmZLhsHqhAMBIg0asTVOH
	 UJtCIK5ICsmbD/A/kErBTCxx8b/3wahjqWdrMmRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Wikner <kwikner@ethz.ch>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.15 44/82] x86/entry: Have entry_ibpb() invalidate return predictions
Date: Mon, 21 Oct 2024 12:25:25 +0200
Message-ID: <20241021102248.983401036@linuxfoundation.org>
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

From: Johannes Wikner <kwikner@ethz.ch>

commit 50e4b3b94090babe8d4bb85c95f0d3e6b07ea86e upstream.

entry_ibpb() should invalidate all indirect predictions, including return
target predictions. Not all IBPB implementations do this, in which case the
fallback is RSB filling.

Prevent SRSO-style hijacks of return predictions following IBPB, as the return
target predictor can be corrupted before the IBPB completes.

  [ bp: Massage. ]

Signed-off-by: Johannes Wikner <kwikner@ethz.ch>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry.S |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -9,6 +9,8 @@
 #include <asm/unwind_hints.h>
 #include <asm/segment.h>
 #include <asm/cache.h>
+#include <asm/cpufeatures.h>
+#include <asm/nospec-branch.h>
 
 .pushsection .noinstr.text, "ax"
 
@@ -17,6 +19,9 @@ SYM_FUNC_START(entry_ibpb)
 	movl	$PRED_CMD_IBPB, %eax
 	xorl	%edx, %edx
 	wrmsr
+
+	/* Make sure IBPB clears return stack preductions too. */
+	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET
 	RET
 SYM_FUNC_END(entry_ibpb)
 /* For KVM */


