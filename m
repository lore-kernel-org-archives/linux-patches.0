Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD5376413;
	Mon,  8 Apr 2024 13:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582404; cv=none; b=XZEY8F6xU80RGBlH6GkQV4k+f2ZY3ossCbLhv9J/6XaePXvbp1ROC1nmJRbFtEPnDqa8d1db1wVomfr9NbNThA+xWHHf7prZycefxnGQjQ4ob/nxsf0cRJNBopjN9RTUXfXWbffc72PceJZPawjBRIBb+GccoUnO9+HwGDIPLCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582404; c=relaxed/simple;
	bh=EsMjF/jGRJV7B+mHSlJdtJ4xvH75osOu6hj7QRLMEHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWjxaROHrw1EKsh1kBD92LdHdUdJ72zPxfPsxTf8jyd+XCwB+ntLJL9cItbe3Zf39yXCFQLYA+96wX5GGnvOcmOA7Aczv9ll5+UOgiXlD3ws3R0tXBHwauhsPDXfjIfU8HX7epq4PPheZUXY9apf1JmtxHA0hvy2TM8tu7QVB+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pgo8Mc8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pgo8Mc8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D0FC433C7;
	Mon,  8 Apr 2024 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582404;
	bh=EsMjF/jGRJV7B+mHSlJdtJ4xvH75osOu6hj7QRLMEHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pgo8Mc8hQialghxV2spSiVoBcMRVkwZLI81h1wJuE1LdIOJM3B4xv3Bs+pTTRrjO3
	 h6uZzOIz5qcz0wL1U89JaSqsbSauwKjILTFo2L+cS5kvuG6RQ1/va9db8wnNvjWuwn
	 FMlVQ+u9zCHeDAIR274M8q67WBcey+bBZ12vSYzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 090/252] x86/srso: Improve i-cache locality for alias mitigation
Date: Mon,  8 Apr 2024 14:56:29 +0200
Message-ID: <20240408125309.446964844@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

Commit aa730cff0c26244e88066b5b461a9f5fbac13823 upstream.

Move srso_alias_return_thunk() to the same section as
srso_alias_safe_ret() so they can share a cache line.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/eadaf5530b46a7ae8b936522da45ae555d2b3393.1693889988.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -177,15 +177,14 @@ SYM_START(srso_alias_safe_ret, SYM_L_GLO
 	int3
 SYM_FUNC_END(srso_alias_safe_ret)
 
-	.section .text..__x86.return_thunk
-
-SYM_CODE_START(srso_alias_return_thunk)
+SYM_CODE_START_NOALIGN(srso_alias_return_thunk)
 	UNWIND_HINT_FUNC
 	ANNOTATE_NOENDBR
 	call srso_alias_safe_ret
 	ud2
 SYM_CODE_END(srso_alias_return_thunk)
 
+	.section .text..__x86.return_thunk
 /*
  * Some generic notes on the untraining sequences:
  *


