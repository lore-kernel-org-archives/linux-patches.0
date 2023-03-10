Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995068820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D07CC433EF;
	Fri, 10 Mar 2023 14:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459732;
	bh=50LQ9mYtk0q7UsY4qXBtH5nZDJCN2z5c0YX57QPbOjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2Y1E3ceT1fCesirOlgXMSaVkwXNiQwcr3sMyfw9asJ5lnzK0t7SOhSDSjPoWRaTp
	 sw6ZVLYRfYhSHwHlYZtJEwfXL2hU+rObcXd5MF3iKbMH69uzFVB/wNuGXb71NAOb0B
	 oLEyKTG/pf3LpzKaV97HVhVbB36JwSug2p+bQla4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/529] x86: Mark stop_this_cpu() __noreturn
Date: Fri, 10 Mar 2023 14:34:04 +0100
Message-Id: <20230310133809.649095210@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit f9cdf7ca57cada055f61ef6d0eb4db21c3f200db ]

vmlinux.o: warning: objtool: smp_stop_nmi_callback()+0x2b: unreachable instruction

0000 0000000000047cf0 <smp_stop_nmi_callback>:
...
0026    47d16:  e8 00 00 00 00          call   47d1b <smp_stop_nmi_callback+0x2b>       47d17: R_X86_64_PLT32   stop_this_cpu-0x4
002b    47d1b:  b8 01 00 00 00          mov    $0x1,%eax

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154319.290905453@infradead.org
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h | 2 +-
 arch/x86/kernel/process.c        | 2 +-
 tools/objtool/check.c            | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 388541ec77aad..01bcbf8a25b29 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -839,7 +839,7 @@ bool xen_set_default_idle(void);
 #define xen_set_default_idle 0
 #endif
 
-void stop_this_cpu(void *dummy);
+void __noreturn stop_this_cpu(void *dummy);
 void microcode_check(void);
 
 enum l1tf_mitigations {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 5e17c3939dd1c..1cba09a9f1c13 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -720,7 +720,7 @@ bool xen_set_default_idle(void)
 }
 #endif
 
-void stop_this_cpu(void *dummy)
+void __noreturn stop_this_cpu(void *dummy)
 {
 	local_irq_disable();
 	/*
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 985bcc5cea8a4..ff47aed7ef6fe 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -180,6 +180,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"kunit_try_catch_throw",
 		"xen_start_kernel",
 		"cpu_bringup_and_idle",
+		"stop_this_cpu",
 	};
 
 	if (!func)
-- 
2.39.2



