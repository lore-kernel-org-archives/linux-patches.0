Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9847BAFD;
	Mon,  8 Apr 2024 13:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583943; cv=none; b=WaTb9HJJQVQdYxNx1NDu6mAtOel7MBP46aRHNW3Sb3wGWwKBnz8C1m3GDkbjuzUpqXohEu5Aa0Yw631bITKUSiFfu/ybe5SFZguQR36VvxMXeOywlyj13jDjfYA1j+9tT/uhQh1uxDcjRNgQSczguM1DE1uBy4TqVoZseUcqNiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583943; c=relaxed/simple;
	bh=sKSzK1Tm9bpS6l/B7XY+KldpNJwPJflpym7ieBTHNCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gK5LIL45VvJ37cwywvEG88sQ8ectAFr2/AkYau5wYmXznG0xJmwDLB/MfuhuVrbRH5bvDJGw/9vWttjOUebTL0wXo7z3bIPuLsmHQeSLC1rapltKgcP1TKEok3o9i0rzE2gp2VG0unQu3uqBrQfm6G11IKDCBlZ9l5eADgHodbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBgeqQih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBgeqQih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39B6C43399;
	Mon,  8 Apr 2024 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583943;
	bh=sKSzK1Tm9bpS6l/B7XY+KldpNJwPJflpym7ieBTHNCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBgeqQihIrwkffLe/N0hBrgDmIwBrvyyESAMcj1ZcdDKlNNw25wo0USvh20tl0AFM
	 Yycu27nRWy+BBmtr9ljN0/gkIeyKe+en/acocqf1BjHK10blflhUuBwOA8OfBSwjfj
	 CVWuBK+RWKVduykZfWM7/zaGo0kTluU4AnuQpTkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Vineet Gupta <vgupta@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Andy Chiu <andy.chiu@sifive.com>,
	Vineet Gupta <vineetg@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.8 236/273] riscv: Fix vector state restore in rt_sigreturn()
Date: Mon,  8 Apr 2024 14:58:31 +0200
Message-ID: <20240408125316.759435540@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

commit c27fa53b858b4ee6552a719aa599c250cf98a586 upstream.

The RISC-V Vector specification states in "Appendix D: Calling
Convention for Vector State" [1] that "Executing a system call causes
all caller-saved vector registers (v0-v31, vl, vtype) and vstart to
become unspecified.". In the RISC-V kernel this is called "discarding
the vstate".

Returning from a signal handler via the rt_sigreturn() syscall, vector
discard is also performed. However, this is not an issue since the
vector state should be restored from the sigcontext, and therefore not
care about the vector discard.

The "live state" is the actual vector register in the running context,
and the "vstate" is the vector state of the task. A dirty live state,
means that the vstate and live state are not in synch.

When vectorized user_from_copy() was introduced, an bug sneaked in at
the restoration code, related to the discard of the live state.

An example when this go wrong:

  1. A userland application is executing vector code
  2. The application receives a signal, and the signal handler is
     entered.
  3. The application returns from the signal handler, using the
     rt_sigreturn() syscall.
  4. The live vector state is discarded upon entering the
     rt_sigreturn(), and the live state is marked as "dirty", indicating
     that the live state need to be synchronized with the current
     vstate.
  5. rt_sigreturn() restores the vstate, except the Vector registers,
     from the sigcontext
  6. rt_sigreturn() restores the Vector registers, from the sigcontext,
     and now the vectorized user_from_copy() is used. The dirty live
     state from the discard is saved to the vstate, making the vstate
     corrupt.
  7. rt_sigreturn() returns to the application, which crashes due to
     corrupted vstate.

Note that the vectorized user_from_copy() is invoked depending on the
value of CONFIG_RISCV_ISA_V_UCOPY_THRESHOLD. Default is 768, which
means that vlen has to be larger than 128b for this bug to trigger.

The fix is simply to mark the live state as non-dirty/clean prior
performing the vstate restore.

Link: https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-8abdb41-2024-03-26/unpriv-isa-asciidoc.pdf # [1]
Reported-by: Charlie Jenkins <charlie@rivosinc.com>
Reported-by: Vineet Gupta <vgupta@kernel.org>
Fixes: c2a658d41924 ("riscv: lib: vectorize copy_to_user/copy_from_user")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Andy Chiu <andy.chiu@sifive.com>
Tested-by: Vineet Gupta <vineetg@rivosinc.com>
Link: https://lore.kernel.org/r/20240403072638.567446-1-bjorn@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/signal.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -119,6 +119,13 @@ static long __restore_v_state(struct pt_
 	struct __sc_riscv_v_state __user *state = sc_vec;
 	void __user *datap;
 
+	/*
+	 * Mark the vstate as clean prior performing the actual copy,
+	 * to avoid getting the vstate incorrectly clobbered by the
+	 *  discarded vector state.
+	 */
+	riscv_v_vstate_set_restore(current, regs);
+
 	/* Copy everything of __sc_riscv_v_state except datap. */
 	err = __copy_from_user(&current->thread.vstate, &state->v_state,
 			       offsetof(struct __riscv_v_ext_state, datap));
@@ -133,13 +140,7 @@ static long __restore_v_state(struct pt_
 	 * Copy the whole vector content from user space datap. Use
 	 * copy_from_user to prevent information leak.
 	 */
-	err = copy_from_user(current->thread.vstate.datap, datap, riscv_v_vsize);
-	if (unlikely(err))
-		return err;
-
-	riscv_v_vstate_set_restore(current, regs);
-
-	return err;
+	return copy_from_user(current->thread.vstate.datap, datap, riscv_v_vsize);
 }
 #else
 #define save_v_state(task, regs) (0)


