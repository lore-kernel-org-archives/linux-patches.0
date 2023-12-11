Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CDCFC06;
	Mon, 11 Dec 2023 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljW3V8pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D975CC433C7;
	Mon, 11 Dec 2023 18:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320299;
	bh=BENXmjO2N8ichrAopCJ+VleRkRQF3LcfdvKFoGiDWmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljW3V8pdOp266R1iakcCyqU45BagYkQiQUcIvHMynIM6Nu86ZoFCzlZITk1CGvjXi
	 R+UcYbZuXht+EEqLf9mm7+QsPepJArIjRjR7SqAWW1eKB2fxCZOqlS85+A0+sqpBK0
	 CekVcQPSMk4YOEbs6flZz9t06Y9a5DmazMT79KVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 010/194] x86: Introduce ia32_enabled()
Date: Mon, 11 Dec 2023 19:20:00 +0100
Message-ID: <20231211182037.065164611@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: Nikolay Borisov <nik.borisov@suse.com>

[ upstream commit 1da5c9bc119d3a749b519596b93f9b2667e93c4a ]

IA32 support on 64bit kernels depends on whether CONFIG_IA32_EMULATION
is selected or not. As it is a compile time option it doesn't
provide the flexibility to have distributions set their own policy for
IA32 support and give the user the flexibility to override it.

As a first step introduce ia32_enabled() which abstracts whether IA32
compat is turned on or off. Upcoming patches will implement
the ability to set IA32 compat state at boot time.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230623111409.3047467-2-nik.borisov@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/common.c     |    4 ++++
 arch/x86/include/asm/ia32.h |   16 +++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -96,6 +96,10 @@ static __always_inline int syscall_32_en
 	return (int)regs->orig_ax;
 }
 
+#ifdef CONFIG_IA32_EMULATION
+bool __ia32_enabled __ro_after_init = true;
+#endif
+
 /*
  * Invoke a 32-bit syscall.  Called with IRQs on in CONTEXT_KERNEL.
  */
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -68,6 +68,20 @@ extern void ia32_pick_mmap_layout(struct
 
 #endif
 
-#endif /* CONFIG_IA32_EMULATION */
+extern bool __ia32_enabled;
+
+static inline bool ia32_enabled(void)
+{
+	return __ia32_enabled;
+}
+
+#else /* !CONFIG_IA32_EMULATION */
+
+static inline bool ia32_enabled(void)
+{
+	return IS_ENABLED(CONFIG_X86_32);
+}
+
+#endif
 
 #endif /* _ASM_X86_IA32_H */


