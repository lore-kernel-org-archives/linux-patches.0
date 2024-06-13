Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA61213D512;
	Thu, 13 Jun 2024 12:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280682; cv=none; b=DC+K+OTQ8lFxwxrFbWu6HsZlFpH7/oKC6Yie6vKZMeru3UHw04B9GvS5BD1hGbVXtHhGDCGO19VMopwceSyej0YZ9ff2gdqlWq11p2fqvS3VLPdSvJpdR05ax/vvghm+yt9xwJS1QRjsxMiXpbUrcgT+6YW+TBqBtFjb0lhBbjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280682; c=relaxed/simple;
	bh=nGaUL/p2Xhn0vfmdSnXHafdl8euVxPC7gATEfQYoICc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6HTPvqPx9fIEPXYedQIF85sd0sWvm4f/WhOQdveFx5endia0Obk/TwuM1KKoiu+nxspMowD5e1rt5fCTuGGSM9igdyNPN0K6mI8koKAa7Ibf/eV6rdbw4Wl8m3mSCbxMsB+ZvUX/SpAfGp6Z+6TUTyyUSgrWWs/3RWMV0XFx1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrPan1vM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrPan1vM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A7BC2BBFC;
	Thu, 13 Jun 2024 12:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280682;
	bh=nGaUL/p2Xhn0vfmdSnXHafdl8euVxPC7gATEfQYoICc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrPan1vMb/nKgYLOwI9Yu/R7B/Lfuerp+EayQ+AdmWnrQYL6mUKxTtr6ysH1KSZP3
	 NdCAawNuIvD9WugOgVZt4hi+pzJ8tVJ5Zh5yhKYubi5tc0TOKnWnplRk//Ho2RuoxV
	 I5xt37bMwGnKoLv+se/oda/4d+9HUMeOaklC4EMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 135/137] powerpc/bpf: enforce full ordering for ATOMIC operations with BPF_FETCH
Date: Thu, 13 Jun 2024 13:35:15 +0200
Message-ID: <20240613113228.541631267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

commit b1e7cee96127468c2483cf10c2899c9b5cf79bf8 upstream.

The Linux Kernel Memory Model [1][2] requires RMW operations that have a
return value to be fully ordered.

BPF atomic operations with BPF_FETCH (including BPF_XCHG and
BPF_CMPXCHG) return a value back so they need to be JITed to fully
ordered operations. POWERPC currently emits relaxed operations for
these.

We can show this by running the following litmus-test:

  PPC SB+atomic_add+fetch

  {
      0:r0=x;  (* dst reg assuming offset is 0 *)
      0:r1=2;  (* src reg *)
      0:r2=1;
      0:r4=y;  (* P0 writes to this, P1 reads this *)
      0:r5=z;  (* P1 writes to this, P0 reads this *)
      0:r6=0;

      1:r2=1;
      1:r4=y;
      1:r5=z;
  }

  P0                      | P1            ;
  stw         r2, 0(r4)   | stw  r2,0(r5) ;
                          |               ;
  loop:lwarx  r3, r6, r0  |               ;
  mr          r8, r3      |               ;
  add         r3, r3, r1  | sync          ;
  stwcx.      r3, r6, r0  |               ;
  bne         loop        |               ;
  mr          r1, r8      |               ;
                          |               ;
  lwa         r7, 0(r5)   | lwa  r7,0(r4) ;

  ~exists(0:r7=0 /\ 1:r7=0)

  Witnesses
  Positive: 9 Negative: 3
  Condition ~exists (0:r7=0 /\ 1:r7=0)
  Observation SB+atomic_add+fetch Sometimes 3 9

This test shows that the older store in P0 is reordered with a newer
load to a different address. Although there is a RMW operation with
fetch between them. Adding a sync before and after RMW fixes the issue:

  Witnesses
  Positive: 9 Negative: 0
  Condition ~exists (0:r7=0 /\ 1:r7=0)
  Observation SB+atomic_add+fetch Never 0 9

[1] https://www.kernel.org/doc/Documentation/memory-barriers.txt
[2] https://www.kernel.org/doc/Documentation/atomic_t.txt

Fixes: aea7ef8a82c0 ("powerpc/bpf/32: add support for BPF_ATOMIC bitwise operations")
Fixes: 2d9206b22743 ("powerpc/bpf/32: Add instructions for atomic_[cmp]xchg")
Fixes: dbe6e2456fb0 ("powerpc/bpf/64: add support for atomic fetch operations")
Fixes: 1e82dfaa7819 ("powerpc/bpf/64: Add instructions for atomic_[cmp]xchg")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Naveen N Rao <naveen@kernel.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240513100248.110535-1-puranjay@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp32.c |   12 ++++++++++++
 arch/powerpc/net/bpf_jit_comp64.c |   12 ++++++++++++
 2 files changed, 24 insertions(+)

--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -851,6 +851,15 @@ int bpf_jit_build_body(struct bpf_prog *
 
 			/* Get offset into TMP_REG */
 			EMIT(PPC_RAW_LI(tmp_reg, off));
+			/*
+			 * Enforce full ordering for operations with BPF_FETCH by emitting a 'sync'
+			 * before and after the operation.
+			 *
+			 * This is a requirement in the Linux Kernel Memory Model.
+			 * See __cmpxchg_u32() in asm/cmpxchg.h as an example.
+			 */
+			if ((imm & BPF_FETCH) && IS_ENABLED(CONFIG_SMP))
+				EMIT(PPC_RAW_SYNC());
 			tmp_idx = ctx->idx * 4;
 			/* load value from memory into r0 */
 			EMIT(PPC_RAW_LWARX(_R0, tmp_reg, dst_reg, 0));
@@ -904,6 +913,9 @@ int bpf_jit_build_body(struct bpf_prog *
 
 			/* For the BPF_FETCH variant, get old data into src_reg */
 			if (imm & BPF_FETCH) {
+				/* Emit 'sync' to enforce full ordering */
+				if (IS_ENABLED(CONFIG_SMP))
+					EMIT(PPC_RAW_SYNC());
 				EMIT(PPC_RAW_MR(ret_reg, ax_reg));
 				if (!fp->aux->verifier_zext)
 					EMIT(PPC_RAW_LI(ret_reg - 1, 0)); /* higher 32-bit */
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -805,6 +805,15 @@ emit_clear:
 
 			/* Get offset into TMP_REG_1 */
 			EMIT(PPC_RAW_LI(tmp1_reg, off));
+			/*
+			 * Enforce full ordering for operations with BPF_FETCH by emitting a 'sync'
+			 * before and after the operation.
+			 *
+			 * This is a requirement in the Linux Kernel Memory Model.
+			 * See __cmpxchg_u64() in asm/cmpxchg.h as an example.
+			 */
+			if ((imm & BPF_FETCH) && IS_ENABLED(CONFIG_SMP))
+				EMIT(PPC_RAW_SYNC());
 			tmp_idx = ctx->idx * 4;
 			/* load value from memory into TMP_REG_2 */
 			if (size == BPF_DW)
@@ -867,6 +876,9 @@ emit_clear:
 			PPC_BCC_SHORT(COND_NE, tmp_idx);
 
 			if (imm & BPF_FETCH) {
+				/* Emit 'sync' to enforce full ordering */
+				if (IS_ENABLED(CONFIG_SMP))
+					EMIT(PPC_RAW_SYNC());
 				EMIT(PPC_RAW_MR(ret_reg, _R0));
 				/*
 				 * Skip unnecessary zero-extension for 32-bit cmpxchg.


