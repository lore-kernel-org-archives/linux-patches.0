Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052921;
	b=KqY9sO4xjLOkA0owZ6c+aUSSVxIBjazpiK0h6yGddiNATxyx74Isrvkw+t3WcemdGyp4
	 l5JTzbZpBuVyzcEUJucIDUw5CJzjrlFa32Zy3CMY8BSqb5DSOKpJlnkvUra4vM9Fzc7L1
	 QicgXwnnyw2vPY7YbCpPAnFwyHjfMoK8sVhlvx8+mdXWE+Tt9Tul7V/Vmex+HDODJDXpA
	 hlfvfzMZODROaMtp738s0DSTYlveUoFWgN23hwFXIXK7ZtdhBwnC5hpX2lyxrAvXaXesJ
	 DJFlC0BfZdf52yHTZSh7OqINzJuzcWDOIpU+REwjULT43lfegL0B05zzjVUC6vBwU5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iuuzqlagqTiRek1R86FMJ1l1VXjArpPSXot6D7Gx8Lo=;
	b=R0G0jFwrMQjFa3gkIXlX79+OCOuzVEv6EdNGbA8N7aB5Osejld/2wqXRw38DXxSBw8Wi
	 q1sr1COIMeo+sUnL5ms6IDEVgDuiKQeGNGPQ2v3daTsxA5vn4MTfJ+wulN3lfQZq3+trD
	 +OBw9mrLQbtTr1DKfjNvPc2QxJJZjCKIPLsiHpUd0gIYPClwdWJ6vVamzq7o1ZzMFcz6Q
	 vk4nR6+mBFwulY0EXd07lbdB8CEhlkSOtr7LWmiddwtLlj7jPHjmLB6DhRvjDpIquVGH4
	 Aov7WgpYSWDf20+3hlIKayD4olzQnmLjZE9vt/nlAwUD7WUo480i1ybWMRoZS2bEBDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwgYqhNt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3568C606A320;
	Thu, 19 Nov 2026 01:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwgYqhNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5C01F000C4;
	Thu, 19 Nov 2026 01:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052921;
	bh=iuuzqlagqTiRek1R86FMJ1l1VXjArpPSXot6D7Gx8Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwgYqhNt4euXxrIHqd2rrrHQewIbpRpUkdzP95f0Nubd3meT9cASzD6SjS4uSenB8
	 zXwlGlk0Er0LmDKVBW6GZd0VKoZ1Bgbwg+4AuVOs7mKydnXeMfsDAcY2/CbUENE0WD
	 SNbkwP4tedueRCoD7ONgEWOgOW7lQukdDlhtr+Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0685/2214] alpha: determine tininess after rounding in the FP emulation
Date: Wed, 18 Nov 2026 15:39:21 +0100
Message-ID: <20261118150039.150721273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit b74843b38da8f1186fd7d447646c835b47096a15 ]

IEEE 754 lets an architecture determine tininess of a floating-point
result either before or after rounding, but requires the same choice for
every operation.  Alpha determines it after rounding, and stdlib's
tst-tininess confirms the hardware does so for the results it produces
itself.

The soft-fp emulation has no notion of the distinction and always
determines tininess before rounding, so a result that the hardware would
not consider tiny is reported as underflowing whenever the instruction
happens to trap for software completion.  The two paths then disagree on
the same machine.  A multiply of the largest subnormal double by
1 + 2^-52 rounds up to the smallest normal and raises no underflow when
the operands are normal, but raises it when an operand is subnormal and
the instruction traps:

  glibc math testsuite, test-float32x-float64-mul:
    Failure: mul_double (0x3.ffffffffffffcp-1024, 0x1.0000000000001p+0):
    Exception "Underflow" set

Add _FP_TININESS_AFTER_ROUNDING, as glibc's copy of soft-fp has, and set
it for alpha.  It determines tininess by rounding a copy of the result as
if the exponent range were unbounded, which is what the definition asks
for.  A plain check of whether the rounded result came out normal is not
equivalent: it differs for values that are still tiny once rounded with
an unbounded exponent range but reach the smallest normal on the coarser
subnormal grid.  That plain check is what the hardware itself does (it
decides tininess from the delivered result), and it is why a divide such
as -0x4p-128 / 0x1.000002p+0 in FE_DOWNWARD delivers -0x1p-126 and raises
nothing although the result is tiny after rounding.  Such cases do not
trap, so the emulation never sees them; where it does get control, it
follows the definition rather than reproducing that deviation, which is
what glibc's soft-fp does as well.

The macro defaults to zero, so powerpc, sh and sparc keep determining
tininess before rounding as they do now.

Cc: stable@vger.kernel.org # 5.15+
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260803-alpha-fp-exceptions-v1-3-c99d75608e60@gmail.com
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/sfp-machine.h |  4 ++++
 include/math-emu/op-common.h         | 23 +++++++++++++++++++++--
 include/math-emu/soft-fp.h           |  8 ++++++++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/sfp-machine.h b/arch/alpha/include/asm/sfp-machine.h
index 5fe63afbd474f..bff1ad963c689 100644
--- a/arch/alpha/include/asm/sfp-machine.h
+++ b/arch/alpha/include/asm/sfp-machine.h
@@ -59,6 +59,10 @@
     R##_c = FP_CLS_NAN;						\
   } while (0)
 
+/* Alpha determines tininess after rounding, so the emulation must do the
+   same as the hardware does for the results it produces itself.  */
+#define _FP_TININESS_AFTER_ROUNDING	1
+
 /* Obtain the current rounding mode. */
 #define FP_ROUNDMODE	mode
 #define FP_RND_NEAREST	(FPCR_DYN_NORMAL >> FPCR_DYN_SHIFT)
diff --git a/include/math-emu/op-common.h b/include/math-emu/op-common.h
index 4b57bbba588af..a30746d7a91fd 100644
--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -135,6 +135,24 @@ do {								\
     else							\
       {								\
 	/* we've got a denormalized number */			\
+	int _FP_PACK_CANONICAL_is_tiny = 1;			\
+	if (_FP_TININESS_AFTER_ROUNDING && X##_e == 0)		\
+	  {							\
+	    /* Architectures that detect tininess after rounding	\
+	       only signal underflow if the result is still		\
+	       subnormal once rounded as if the exponent range	\
+	       were unbounded.  Round a copy to find out.  */	\
+	    FP_DECL_##fs(_FP_PACK_CANONICAL_T);			\
+	    /* The class field is not used by the rounding below,	\
+	       and is unused entirely where this block is dead.  */	\
+	    (void)_FP_PACK_CANONICAL_T##_c;			\
+	    _FP_FRAC_COPY_##wc(_FP_PACK_CANONICAL_T, X);	\
+	    _FP_PACK_CANONICAL_T##_s = X##_s;			\
+	    _FP_PACK_CANONICAL_T##_e = X##_e;			\
+	    _FP_ROUND(wc, _FP_PACK_CANONICAL_T);		\
+	    if (_FP_FRAC_OVERP_##wc(fs, _FP_PACK_CANONICAL_T))	\
+	      _FP_PACK_CANONICAL_is_tiny = 0;			\
+	  }							\
 	X##_e = -X##_e + 1;					\
 	if (X##_e <= _FP_WFRACBITS_##fs)			\
 	  {							\
@@ -161,8 +179,9 @@ do {								\
 		    _FP_FRAC_SRL_##wc(X, _FP_WORKBITS);		\
 		  }						\
 	      }							\
-	    if ((FP_CUR_EXCEPTIONS & FP_EX_INEXACT) ||		\
-		(FP_TRAPPING_EXCEPTIONS & FP_EX_UNDERFLOW))	\
+	    if (_FP_PACK_CANONICAL_is_tiny			\
+		&& ((FP_CUR_EXCEPTIONS & FP_EX_INEXACT) ||	\
+		    (FP_TRAPPING_EXCEPTIONS & FP_EX_UNDERFLOW)))	\
 		FP_SET_EXCEPTION(FP_EX_UNDERFLOW);		\
 	  }							\
 	else							\
diff --git a/include/math-emu/soft-fp.h b/include/math-emu/soft-fp.h
index 5650c16283830..02ada0a9fca16 100644
--- a/include/math-emu/soft-fp.h
+++ b/include/math-emu/soft-fp.h
@@ -31,6 +31,14 @@
 #include <endian.h>
 #endif
 
+/* Whether the architecture determines tininess of a floating-point
+   result after rounding rather than before it.  IEEE 754 permits either
+   but requires the same choice for every operation, so this has to agree
+   with what the hardware does for the results it produces itself.  */
+#ifndef _FP_TININESS_AFTER_ROUNDING
+#define _FP_TININESS_AFTER_ROUNDING	0
+#endif
+
 #define _FP_WORKBITS		3
 #define _FP_WORK_LSB		((_FP_W_TYPE)1 << 3)
 #define _FP_WORK_ROUND		((_FP_W_TYPE)1 << 2)
-- 
2.53.0



