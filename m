Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C5F2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3543C433CA;
	Wed, 20 Sep 2023 11:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211079;
	bh=n9zMEk8uOA4N+BZrDZbMtN9ZFGSKpvYuuSrovOYzHI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJqAiYz+eAs3QQTFELzT13jB12AjEe/yP+blV3syPEDJR6FQ7Q6g5eU5i+EHF8Jcz
	 6xUChVctjOn20RjllAPH8gy+imt2hWf7QoyhrejjDCu0L84oA8sVFv2H/tG2IwvXVy
	 +q18Bu66Xi7gfMIo8QsXEGpwaVx5HGfMKf697s+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <David.Kaplan@amd.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/139] x86/ibt: Suppress spurious ENDBR
Date: Wed, 20 Sep 2023 13:30:34 +0200
Message-ID: <20230920112839.302512456@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 25e73b7e3f72a25aa30cbb2eecb49036e0acf066 ]

It was reported that under certain circumstances GCC emits ENDBR
instructions for _THIS_IP_ usage. Specifically, when it appears at the
start of a basic block -- but not elsewhere.

Since _THIS_IP_ is never used for control flow, these ENDBR
instructions are completely superfluous. Override the _THIS_IP_
definition for x86_64 to avoid this.

Less ENDBR instructions is better.

Fixes: 156ff4a544ae ("x86/ibt: Base IBT bits")
Reported-by: David Kaplan <David.Kaplan@amd.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230802110323.016197440@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/linkage.h      | 8 ++++++++
 include/linux/instruction_pointer.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index f484d656d34ee..3a0282a6a55df 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -8,6 +8,14 @@
 #undef notrace
 #define notrace __attribute__((no_instrument_function))
 
+#ifdef CONFIG_64BIT
+/*
+ * The generic version tends to create spurious ENDBR instructions under
+ * certain conditions.
+ */
+#define _THIS_IP_ ({ unsigned long __here; asm ("lea 0(%%rip), %0" : "=r" (__here)); __here; })
+#endif
+
 #ifdef CONFIG_X86_32
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
 #endif /* CONFIG_X86_32 */
diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
index cda1f706eaeb1..aa0b3ffea9353 100644
--- a/include/linux/instruction_pointer.h
+++ b/include/linux/instruction_pointer.h
@@ -2,7 +2,12 @@
 #ifndef _LINUX_INSTRUCTION_POINTER_H
 #define _LINUX_INSTRUCTION_POINTER_H
 
+#include <asm/linkage.h>
+
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
+
+#ifndef _THIS_IP_
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
+#endif
 
 #endif /* _LINUX_INSTRUCTION_POINTER_H */
-- 
2.40.1



