Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB8C22C325;
	Tue, 20 May 2025 13:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749325; cv=none; b=lBRnKjFmEVF2cjITcrtWPcf40zv6Ia7a0CqJDtm+H5pGqW6aK0Mw8e1zliz72wLu51cvonPjLDbhwrvA1R6idL+Lt9uG91b+dBJaq3uXqZqwTTs/bdNHl7AGEcVyC+wZ3hzwOEq3mnQZcse8ifQ7G0e30DmMimRV6DYIDriYpaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749325; c=relaxed/simple;
	bh=x291YV/c/VQHEBW3zFJGi123AyRu+tvs0thH6n4gXqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgQ10KehpjWwyQJI2W7nDski+/lkrdjDLN15IxBdMgEKHMd1AGTyXPvciyXca+7yF4bxZQQ3FDR9DVBbT9b5UuUNk2idVK8ol3LGvDXkExubcoY1B/k2QARsbJ8H57u5Ot2QJe7XDD2hdoU2A2MjLlOqKPfniK8J4MVvjSlO7n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5wMEwIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5wMEwIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A49C4CEE9;
	Tue, 20 May 2025 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749325;
	bh=x291YV/c/VQHEBW3zFJGi123AyRu+tvs0thH6n4gXqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5wMEwICrKpPK+9QyMYNbm3BSuJ09KuPAyNqWhmPW/wBdghbdCbkexQyWgZqecY/f
	 QLfkMcEEhjofvE+gk70HIJAxGkbXujrEd/Q3PvTqm4pPOVNY4GKqcA5wXSW+es0BOD
	 PGcokwO68BSyNOzk4/z4h1u8u59UEZq5tfeb8qOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Subject: [PATCH 5.15 29/59] x86/its: FineIBT-paranoid vs ITS
Date: Tue, 20 May 2025 15:50:20 +0200
Message-ID: <20250520125755.018498241@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit e52c1dc7455d32c8a55f9949d300e5e87d011fa6 upstream.

FineIBT-paranoid was using the retpoline bytes for the paranoid check,
disabling retpolines, because all parts that have IBT also have eIBRS
and thus don't need no stinking retpolines.

Except... ITS needs the retpolines for indirect calls must not be in
the first half of a cacheline :-/

So what was the paranoid call sequence:

  <fineibt_paranoid_start>:
   0:   41 ba 78 56 34 12       mov    $0x12345678, %r10d
   6:   45 3b 53 f7             cmp    -0x9(%r11), %r10d
   a:   4d 8d 5b <f0>           lea    -0x10(%r11), %r11
   e:   75 fd                   jne    d <fineibt_paranoid_start+0xd>
  10:   41 ff d3                call   *%r11
  13:   90                      nop

Now becomes:

  <fineibt_paranoid_start>:
   0:   41 ba 78 56 34 12       mov    $0x12345678, %r10d
   6:   45 3b 53 f7             cmp    -0x9(%r11), %r10d
   a:   4d 8d 5b f0             lea    -0x10(%r11), %r11
   e:   2e e8 XX XX XX XX	cs call __x86_indirect_paranoid_thunk_r11

  Where the paranoid_thunk looks like:

   1d:  <ea>                    (bad)
   __x86_indirect_paranoid_thunk_r11:
   1e:  75 fd                   jne 1d
   __x86_indirect_its_thunk_r11:
   20:  41 ff eb                jmp *%r11
   23:  cc                      int3

[ dhansen: remove initialization to false ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
[ Just a portion of the original commit, in order to fix a build issue
  in stable kernels due to backports ]
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Link: https://lore.kernel.org/r/20250514113952.GB16434@noisy.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h |    8 ++++++++
 arch/x86/kernel/alternative.c      |    8 ++++++++
 arch/x86/net/bpf_jit_comp.c        |    2 +-
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/stringify.h>
 #include <asm/asm.h>
+#include <asm/bug.h>
 
 #define ALTINSTR_FLAG_INV	(1 << 15)
 #define ALT_NOT(feat)		((feat) | ALTINSTR_FLAG_INV)
@@ -84,10 +85,17 @@ struct module;
 extern void its_init_mod(struct module *mod);
 extern void its_fini_mod(struct module *mod);
 extern void its_free_mod(struct module *mod);
+extern u8 *its_static_thunk(int reg);
 #else /* CONFIG_MITIGATION_ITS */
 static inline void its_init_mod(struct module *mod) { }
 static inline void its_fini_mod(struct module *mod) { }
 static inline void its_free_mod(struct module *mod) { }
+static inline u8 *its_static_thunk(int reg)
+{
+	WARN_ONCE(1, "ITS not compiled in");
+
+	return NULL;
+}
 #endif
 
 #ifdef CONFIG_RETHUNK
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -597,6 +597,14 @@ static bool cpu_wants_indirect_its_thunk
 	/* Lower-half of the cacheline? */
 	return !(addr & 0x20);
 }
+
+u8 *its_static_thunk(int reg)
+{
+	u8 *thunk = __x86_indirect_its_thunk_array[reg];
+
+	return thunk;
+}
+
 #endif
 
 /*
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -449,7 +449,7 @@ static void emit_indirect_jump(u8 **ppro
 	if (IS_ENABLED(CONFIG_MITIGATION_ITS) &&
 	    cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS)) {
 		OPTIMIZER_HIDE_VAR(reg);
-		emit_jump(&prog, &__x86_indirect_its_thunk_array[reg], ip);
+		emit_jump(&prog, its_static_thunk(reg), ip);
 	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		EMIT_LFENCE();
 		EMIT2(0xFF, 0xE0 + reg);


