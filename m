Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102A47350E;
	Mon,  8 Apr 2024 13:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582432; cv=none; b=kuNoBCyNvmLx6ohUKSWoPYdI+8uvuqWXrSR4xGMJ5a8Uwzl/xPIdo/VBbAe84LiLwqQ+hDT80hc6DbhL+Wkjxq5olGjKoacQ2Nn3wPJEOUnvK7m3xqnxPsX5XYIdrkrCyFspEyyDHhbDaPWk95C68A+dJ6z880QCpSEmocOurNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582432; c=relaxed/simple;
	bh=KrODIwKBDV/2lY7Uii/Z/Rbxarc8fRHsWhYgnP24gQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSMf6/4sitDaq7nlO5PmNwvIrseaqqiAdV0gKcwZUOS1qPO93F7z0Yyn2YHiFE0sCnt2Lu3ljLdfq6rdeO4MpXMPpEaLOXMMa+AZ/GcrvqvPMG5W0GRa04nhDSqJPQ+SghcskHLm/SiWIeLcJAhd1Cxma5X3zAHWijQz+ULiskA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPW6fJgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPW6fJgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B4FC433C7;
	Mon,  8 Apr 2024 13:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582430;
	bh=KrODIwKBDV/2lY7Uii/Z/Rbxarc8fRHsWhYgnP24gQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPW6fJgHUexsASsVPGDWNtCF3+8YD3zhfrtZvh7Vp/7RAMSyGRw1HaZQ/irCmvhXC
	 Ua92dAA3SfPUTuESXTREktD84QpHTShZDgbLH6c6tjLr36fDpxxdNsOCjUAy22vhNj
	 EF39ON+dE4y6THfYrGrmxQRk7R5FI3MFjiLHrsnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 092/252] x86/nospec: Refactor UNTRAIN_RET[_*]
Date: Mon,  8 Apr 2024 14:56:31 +0200
Message-ID: <20240408125309.509983848@linuxfoundation.org>
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

Commit e8efc0800b8b5045ba8c0d1256bfbb47e92e192a upstream.

Factor out the UNTRAIN_RET[_*] common bits into a helper macro.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/f06d45489778bd49623297af2a983eea09067a74.1693889988.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -288,35 +288,24 @@
  * As such, this must be placed after every *SWITCH_TO_KERNEL_CR3 at a point
  * where we have a stack but before any RET instruction.
  */
-.macro UNTRAIN_RET
+.macro __UNTRAIN_RET ibpb_feature, call_depth_insns
 #if defined(CONFIG_RETHUNK) || defined(CONFIG_CPU_IBPB_ENTRY)
 	VALIDATE_UNRET_END
 	ALTERNATIVE_3 "",						\
 		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
-		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB,	\
-		     __stringify(RESET_CALL_DEPTH), X86_FEATURE_CALL_DEPTH
+		      "call entry_ibpb", \ibpb_feature,			\
+		     __stringify(\call_depth_insns), X86_FEATURE_CALL_DEPTH
 #endif
 .endm
 
-.macro UNTRAIN_RET_VM
-#if defined(CONFIG_RETHUNK) || defined(CONFIG_CPU_IBPB_ENTRY)
-	VALIDATE_UNRET_END
-	ALTERNATIVE_3 "",						\
-		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
-		      "call entry_ibpb", X86_FEATURE_IBPB_ON_VMEXIT,	\
-		      __stringify(RESET_CALL_DEPTH), X86_FEATURE_CALL_DEPTH
-#endif
-.endm
+#define UNTRAIN_RET \
+	__UNTRAIN_RET X86_FEATURE_ENTRY_IBPB, __stringify(RESET_CALL_DEPTH)
 
-.macro UNTRAIN_RET_FROM_CALL
-#if defined(CONFIG_RETHUNK) || defined(CONFIG_CPU_IBPB_ENTRY)
-	VALIDATE_UNRET_END
-	ALTERNATIVE_3 "",						\
-		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
-		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB,	\
-		      __stringify(RESET_CALL_DEPTH_FROM_CALL), X86_FEATURE_CALL_DEPTH
-#endif
-.endm
+#define UNTRAIN_RET_VM \
+	__UNTRAIN_RET X86_FEATURE_IBPB_ON_VMEXIT, __stringify(RESET_CALL_DEPTH)
+
+#define UNTRAIN_RET_FROM_CALL \
+	__UNTRAIN_RET X86_FEATURE_ENTRY_IBPB, __stringify(RESET_CALL_DEPTH_FROM_CALL)
 
 
 .macro CALL_DEPTH_ACCOUNT


