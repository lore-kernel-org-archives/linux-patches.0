Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C149F2E2F0C;
	Tue, 15 Jul 2025 13:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587944; cv=none; b=Y0FEUM2Lk641GJi+JDwKhUIypodgtcyO/kryMIcwQ9Bs+GXDZDJZ3qJs17PzEsyk9oENxg3zF5NRelKWDRG6IaNYP+DeUffgaUlqyl2Oto1ob0jMUwphpsofD7ZUhKLccGdCo1Z7TvQpOv8Alo/Qb9qPMxMUJDfyZzugUEfFYIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587944; c=relaxed/simple;
	bh=OupeyO+rbGW+0f9uvmt0Rj2sMEVlBzKbcAP/81OLpkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LiqA65xRFH/C62RZLnyLNSA1Ecb7oUJqDS0gYvn/va7/Wbqf0YvuggyDDK3DtD0Swvi1o58C0fM6K6NjXygcwX5NTh6+62RPB9IXvhbKFMmi2PHzo/oaxHEWRdxv1HPFE1DvoatRWfG2eoAgRjSzxuQ0ezy6tjNxNuLcBbvwgbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrPJx5Jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrPJx5Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533E4C4CEE3;
	Tue, 15 Jul 2025 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587944;
	bh=OupeyO+rbGW+0f9uvmt0Rj2sMEVlBzKbcAP/81OLpkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrPJx5JkgG2F0RQZQp0e7XXDaZpxKfzArf8SOorRgJEhyNY9c95Pa0Il72EshN1DB
	 t8+u0UMauue8IcOG2xaWscssQF004r6QDLDxXANblFI2U77XINpUMSivhjO7JJmvqL
	 XK9PLeLvjyVW9dHFvg10dS7kZ34nrINTsZ/Rk1k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.10 170/208] x86/its: FineIBT-paranoid vs ITS
Date: Tue, 15 Jul 2025 15:14:39 +0200
Message-ID: <20250715130817.789480077@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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

[ pawan: move the its_static_thunk() definition to alternative.c. This is
	 done to avoid a build failure due to circular dependency between
	 kernel.h(asm-generic/bug.h) and asm/alternative.h which is
	 needed for WARN_ONCE(). ]

[ Just a portion of the original commit, in order to fix a build issue
  in stable kernels due to backports ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Link: https://lore.kernel.org/r/20250514113952.GB16434@noisy.programming.kicks-ass.net
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h |    2 ++
 arch/x86/kernel/alternative.c      |   19 ++++++++++++++++++-
 arch/x86/net/bpf_jit_comp.c        |    2 +-
 3 files changed, 21 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -80,6 +80,8 @@ extern void apply_returns(s32 *start, s3
 
 struct module;
 
+extern u8 *its_static_thunk(int reg);
+
 #ifdef CONFIG_MITIGATION_ITS
 extern void its_init_mod(struct module *mod);
 extern void its_fini_mod(struct module *mod);
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -752,7 +752,24 @@ static bool cpu_wants_indirect_its_thunk
 	/* Lower-half of the cacheline? */
 	return !(addr & 0x20);
 }
-#endif
+
+u8 *its_static_thunk(int reg)
+{
+	u8 *thunk = __x86_indirect_its_thunk_array[reg];
+
+	return thunk;
+}
+
+#else /* CONFIG_MITIGATION_ITS */
+
+u8 *its_static_thunk(int reg)
+{
+	WARN_ONCE(1, "ITS not compiled in");
+
+	return NULL;
+}
+
+#endif /* CONFIG_MITIGATION_ITS */
 
 /*
  * Rewrite the compiler generated retpoline thunk calls.
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -390,7 +390,7 @@ static void emit_indirect_jump(u8 **ppro
 	if (IS_ENABLED(CONFIG_MITIGATION_ITS) &&
 	    cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS)) {
 		OPTIMIZER_HIDE_VAR(reg);
-		emit_jump(&prog, &__x86_indirect_its_thunk_array[reg], ip);
+		emit_jump(&prog, its_static_thunk(reg), ip);
 	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		EMIT_LFENCE();
 		EMIT2(0xFF, 0xE0 + reg);


