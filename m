Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE5F11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3158BC433C7;
	Mon, 21 Aug 2023 19:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647889;
	bh=u/pao4YBnKqtDvOQjiCAh/ojzQMYfgEkexng0fR5Avg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugaKI5KMGRkZA0wpxIli0bjSNs89s9r9wNqeXoJJX/O3MrY6Tkum1yjoTt+Z7SPgR
	 x6gLkGZSd/bzQQRjWMomo79aKGvxdtSCPHLTdgjH9atNwP0k7PZcuPw4q/apELhTgJ
	 YbGfjcCVs+YdVQuoXucZxr31FTt2ED4XyUZocRgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 175/194] x86/alternative: Make custom return thunk unconditional
Date: Mon, 21 Aug 2023 21:42:34 +0200
Message-ID: <20230821194130.411698652@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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

commit 095b8303f3835c68ac4a8b6d754ca1c3b6230711 upstream.

There is infrastructure to rewrite return thunks to point to any
random thunk one desires, unwrap that from CALL_THUNKS, which up to
now was the sole user of that.

  [ bp: Make the thunks visible on 32-bit and add ifdeffery for the
    32-bit builds. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230814121148.775293785@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    5 +++++
 arch/x86/kernel/cpu/bugs.c           |    2 ++
 2 files changed, 7 insertions(+)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -210,7 +210,12 @@
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
 extern retpoline_thunk_t __x86_indirect_thunk_array[];
 
+#ifdef CONFIG_RETHUNK
 extern void __x86_return_thunk(void);
+#else
+static inline void __x86_return_thunk(void) {}
+#endif
+
 extern void zen_untrain_ret(void);
 extern void srso_untrain_ret(void);
 extern void srso_untrain_ret_alias(void);
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -62,6 +62,8 @@ EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
+
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
 static void update_spec_ctrl(u64 val)
 {


