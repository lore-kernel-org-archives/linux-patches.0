Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D682459C9;
	Tue, 20 May 2025 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749160; cv=none; b=YwzMRqA7C10f0eXvZlSRNK97YFvKepkyremuES8nI3Bikrr+WRUggUhWNBSf7ftBfnZP0z43szrwT4Eirg1zJSPZBEo+ezayyw5OygOBEYecA0wDQVQ0z1BZep8XEwyqIEWf4SNVAtLusCavn5bp7uhfZNl7/R/6YWNMAh0Bqao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749160; c=relaxed/simple;
	bh=+kujDUrDI0UQGawFYxm0yWwvcwHtRdkSOuf3ApHBpZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHVPdvNQr6/GOlAbOwZF0NSUbt5AicDnL9zaF+697/cY0z5GuQ5xDyFbJP4irpOtraDGec9QqK711Rrg5s3Qj5w4RvAZacxrdTC6NO4pqHLeQ6HCFaeKSbOBYyghmCwDQMc9/9Gl/Ga/8QreDwlRQgeYv9bLXiBb/7LfuBWWyS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA9z5NNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA9z5NNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83432C4CEE9;
	Tue, 20 May 2025 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749159;
	bh=+kujDUrDI0UQGawFYxm0yWwvcwHtRdkSOuf3ApHBpZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA9z5NNpqdag9WSRGdeXwv3GOirwaSY/OFLB/gFyOpBOPJWwNJv8C+aNpQJjdTxML
	 c3Oc4MY3O3VngvVLqGIoELgY9T1bLLg1bCTO3AsNbMZw89tFw9CgSkgnaSBvJzfbNi
	 52uSSgIV52TA+XkPixG6ZOLOehvi1S5bLtjq4Y5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.15 16/59] x86/speculation: Add a conditional CS prefix to CALL_NOSPEC
Date: Tue, 20 May 2025 15:50:07 +0200
Message-ID: <20250520125754.479883612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 052040e34c08428a5a388b85787e8531970c0c67 upstream.

Retpoline mitigation for spectre-v2 uses thunks for indirect branches. To
support this mitigation compilers add a CS prefix with
-mindirect-branch-cs-prefix. For an indirect branch in asm, this needs to
be added manually.

CS prefix is already being added to indirect branches in asm files, but not
in inline asm. Add CS prefix to CALL_NOSPEC for inline asm as well. There
is no JMP_NOSPEC for inline asm.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250228-call-nospec-v3-2-96599fed0f33@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -119,9 +119,8 @@
 .endm
 
 /*
- * Equivalent to -mindirect-branch-cs-prefix; emit the 5 byte jmp/call
- * to the retpoline thunk with a CS prefix when the register requires
- * a RAX prefix byte to encode. Also see apply_retpolines().
+ * Emits a conditional CS prefix that is compatible with
+ * -mindirect-branch-cs-prefix.
  */
 .macro __CS_PREFIX reg:req
 	.irp rs,r8,r9,r10,r11,r12,r13,r14,r15
@@ -282,11 +281,23 @@ extern retpoline_thunk_t __x86_indirect_
 #ifdef CONFIG_X86_64
 
 /*
+ * Emits a conditional CS prefix that is compatible with
+ * -mindirect-branch-cs-prefix.
+ */
+#define __CS_PREFIX(reg)				\
+	".irp rs,r8,r9,r10,r11,r12,r13,r14,r15\n"	\
+	".ifc \\rs," reg "\n"				\
+	".byte 0x2e\n"					\
+	".endif\n"					\
+	".endr\n"
+
+/*
  * Inline asm uses the %V modifier which is only in newer GCC
  * which is ensured when CONFIG_RETPOLINE is defined.
  */
 #ifdef CONFIG_RETPOLINE
-#define CALL_NOSPEC	"call __x86_indirect_thunk_%V[thunk_target]\n"
+#define CALL_NOSPEC	__CS_PREFIX("%V[thunk_target]")	\
+			"call __x86_indirect_thunk_%V[thunk_target]\n"
 #else
 #define CALL_NOSPEC	"call *%[thunk_target]\n"
 #endif


