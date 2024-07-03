Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B901817B431;
	Wed,  3 Jul 2024 10:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003839; cv=none; b=PozMuf+5HYw3re8n9P3Uy1i5qEn2aqTD31w9qFTczLollHDGbysSLqtp8HkzojLq6VAoDiiCbYp8o+9GlsWQteGRcIQvBNFRX0inDVh2Wdf80vrw0J1hoF/HetY01zYOVWivmDPr3xACSbI4/PfQOswT0Jg6CdzmXnKkahKpecQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003839; c=relaxed/simple;
	bh=AGHnRZNdozBshdtFdFGoSquw37bjlHgx6ARvRE3mgSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8BCvhCJpLrJXxm2vob45J+zloNljc22qAIFOS0KAyU04NWxhb3AwmTsx7tx6wftswpkeXhWX2EiqbaG5dTkviBzInEVhpYJXGgw9dF5rI6+WxZSmRTp0I2ez9UF1jVy5yQ54LMm2yjDhkJOsw9qpwrbiyKaNKw7Bav2PwurnCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhKsfS1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhKsfS1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4114DC2BD10;
	Wed,  3 Jul 2024 10:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003839;
	bh=AGHnRZNdozBshdtFdFGoSquw37bjlHgx6ARvRE3mgSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhKsfS1sbmHGP3cl1UaF3zmAmEKZ+5T5WS2FJqFdLt8MA5uYemXDd/w19CvLESwTW
	 EG3mBs3MRXchdTVRcI55soBnr92s0fcsl4OwPf5WtB6T41j/kl83jrUTi4DLzMVukK
	 RI40TNttPkgH/xi4Xuo6yWu9Vq0KrSifC1x8Ywq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Steuer <patrick.steuer@de.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/189] s390/cpacf: get rid of register asm
Date: Wed,  3 Jul 2024 12:38:19 +0200
Message-ID: <20240703102842.949059708@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b84d0c417a5ac1eb820c8114c0c7cf1fcbf6f017 ]

Using register asm statements has been proven to be very error prone,
especially when using code instrumentation where gcc may add function
calls, which clobbers register contents in an unexpected way.

Therefore get rid of register asm statements in cpacf code, and make
sure this bug class cannot happen.

Reviewed-by: Patrick Steuer <patrick.steuer@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 830999bd7e72 ("s390/cpacf: Split and rework cpacf query functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/cpacf.h | 208 ++++++++++++++++++----------------
 1 file changed, 111 insertions(+), 97 deletions(-)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index c0f3bfeddcbeb..646b12981f208 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -173,17 +173,16 @@ typedef struct { unsigned char bytes[16]; } cpacf_mask_t;
  */
 static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
 {
-	register unsigned long r0 asm("0") = 0;	/* query function */
-	register unsigned long r1 asm("1") = (unsigned long) mask;
-
 	asm volatile(
-		"	spm 0\n" /* pckmo doesn't change the cc */
+		"	lghi	0,0\n" /* query function */
+		"	lgr	1,%[mask]\n"
+		"	spm	0\n" /* pckmo doesn't change the cc */
 		/* Parameter regs are ignored, but must be nonzero and unique */
 		"0:	.insn	rrf,%[opc] << 16,2,4,6,0\n"
 		"	brc	1,0b\n"	/* handle partial completion */
 		: "=m" (*mask)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (opcode)
-		: "cc");
+		: [mask] "d" ((unsigned long)mask), [opc] "i" (opcode)
+		: "cc", "0", "1");
 }
 
 static __always_inline int __cpacf_check_opcode(unsigned int opcode)
@@ -249,20 +248,22 @@ static __always_inline int cpacf_query_func(unsigned int opcode, unsigned int fu
 static inline int cpacf_km(unsigned long func, void *param,
 			   u8 *dest, const u8 *src, long src_len)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-	register unsigned long r2 asm("2") = (unsigned long) src;
-	register unsigned long r3 asm("3") = (unsigned long) src_len;
-	register unsigned long r4 asm("4") = (unsigned long) dest;
+	union register_pair d, s;
 
+	d.even = (unsigned long)dest;
+	s.even = (unsigned long)src;
+	s.odd  = (unsigned long)src_len;
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rre,%[opc] << 16,%[dst],%[src]\n"
 		"	brc	1,0b\n" /* handle partial completion */
-		: [src] "+a" (r2), [len] "+d" (r3), [dst] "+a" (r4)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_KM)
-		: "cc", "memory");
+		: [src] "+&d" (s.pair), [dst] "+&d" (d.pair)
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [opc] "i" (CPACF_KM)
+		: "cc", "memory", "0", "1");
 
-	return src_len - r3;
+	return src_len - s.odd;
 }
 
 /**
@@ -279,20 +280,22 @@ static inline int cpacf_km(unsigned long func, void *param,
 static inline int cpacf_kmc(unsigned long func, void *param,
 			    u8 *dest, const u8 *src, long src_len)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-	register unsigned long r2 asm("2") = (unsigned long) src;
-	register unsigned long r3 asm("3") = (unsigned long) src_len;
-	register unsigned long r4 asm("4") = (unsigned long) dest;
+	union register_pair d, s;
 
+	d.even = (unsigned long)dest;
+	s.even = (unsigned long)src;
+	s.odd  = (unsigned long)src_len;
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rre,%[opc] << 16,%[dst],%[src]\n"
 		"	brc	1,0b\n" /* handle partial completion */
-		: [src] "+a" (r2), [len] "+d" (r3), [dst] "+a" (r4)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_KMC)
-		: "cc", "memory");
+		: [src] "+&d" (s.pair), [dst] "+&d" (d.pair)
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [opc] "i" (CPACF_KMC)
+		: "cc", "memory", "0", "1");
 
-	return src_len - r3;
+	return src_len - s.odd;
 }
 
 /**
@@ -306,17 +309,19 @@ static inline int cpacf_kmc(unsigned long func, void *param,
 static inline void cpacf_kimd(unsigned long func, void *param,
 			      const u8 *src, long src_len)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-	register unsigned long r2 asm("2") = (unsigned long) src;
-	register unsigned long r3 asm("3") = (unsigned long) src_len;
+	union register_pair s;
 
+	s.even = (unsigned long)src;
+	s.odd  = (unsigned long)src_len;
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rre,%[opc] << 16,0,%[src]\n"
 		"	brc	1,0b\n" /* handle partial completion */
-		: [src] "+a" (r2), [len] "+d" (r3)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_KIMD)
-		: "cc", "memory");
+		: [src] "+&d" (s.pair)
+		: [fc] "d" (func), [pba] "d" ((unsigned long)(param)),
+		  [opc] "i" (CPACF_KIMD)
+		: "cc", "memory", "0", "1");
 }
 
 /**
@@ -329,17 +334,19 @@ static inline void cpacf_kimd(unsigned long func, void *param,
 static inline void cpacf_klmd(unsigned long func, void *param,
 			      const u8 *src, long src_len)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-	register unsigned long r2 asm("2") = (unsigned long) src;
-	register unsigned long r3 asm("3") = (unsigned long) src_len;
+	union register_pair s;
 
+	s.even = (unsigned long)src;
+	s.odd  = (unsigned long)src_len;
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rre,%[opc] << 16,0,%[src]\n"
 		"	brc	1,0b\n" /* handle partial completion */
-		: [src] "+a" (r2), [len] "+d" (r3)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_KLMD)
-		: "cc", "memory");
+		: [src] "+&d" (s.pair)
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [opc] "i" (CPACF_KLMD)
+		: "cc", "memory", "0", "1");
 }
 
 /**
@@ -355,19 +362,21 @@ static inline void cpacf_klmd(unsigned long func, void *param,
 static inline int cpacf_kmac(unsigned long func, void *param,
 			     const u8 *src, long src_len)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-	register unsigned long r2 asm("2") = (unsigned long) src;
-	register unsigned long r3 asm("3") = (unsigned long) src_len;
+	union register_pair s;
 
+	s.even = (unsigned long)src;
+	s.odd  = (unsigned long)src_len;
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rre,%[opc] << 16,0,%[src]\n"
 		"	brc	1,0b\n" /* handle partial completion */
-		: [src] "+a" (r2), [len] "+d" (r3)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_KMAC)
-		: "cc", "memory");
+		: [src] "+&d" (s.pair)
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [opc] "i" (CPACF_KMAC)
+		: "cc", "memory", "0", "1");
 
-	return src_len - r3;
+	return src_len - s.odd;
 }
 
 /**
@@ -385,22 +394,24 @@ static inline int cpacf_kmac(unsigned long func, void *param,
 static inline int cpacf_kmctr(unsigned long func, void *param, u8 *dest,
 			      const u8 *src, long src_len, u8 *counter)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-	register unsigned long r2 asm("2") = (unsigned long) src;
-	register unsigned long r3 asm("3") = (unsigned long) src_len;
-	register unsigned long r4 asm("4") = (unsigned long) dest;
-	register unsigned long r6 asm("6") = (unsigned long) counter;
+	union register_pair d, s, c;
 
+	d.even = (unsigned long)dest;
+	s.even = (unsigned long)src;
+	s.odd  = (unsigned long)src_len;
+	c.even = (unsigned long)counter;
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rrf,%[opc] << 16,%[dst],%[src],%[ctr],0\n"
 		"	brc	1,0b\n" /* handle partial completion */
-		: [src] "+a" (r2), [len] "+d" (r3),
-		  [dst] "+a" (r4), [ctr] "+a" (r6)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_KMCTR)
-		: "cc", "memory");
+		: [src] "+&d" (s.pair), [dst] "+&d" (d.pair),
+		  [ctr] "+&d" (c.pair)
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [opc] "i" (CPACF_KMCTR)
+		: "cc", "memory", "0", "1");
 
-	return src_len - r3;
+	return src_len - s.odd;
 }
 
 /**
@@ -417,20 +428,21 @@ static inline void cpacf_prno(unsigned long func, void *param,
 			      u8 *dest, unsigned long dest_len,
 			      const u8 *seed, unsigned long seed_len)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-	register unsigned long r2 asm("2") = (unsigned long) dest;
-	register unsigned long r3 asm("3") = (unsigned long) dest_len;
-	register unsigned long r4 asm("4") = (unsigned long) seed;
-	register unsigned long r5 asm("5") = (unsigned long) seed_len;
+	union register_pair d, s;
 
+	d.even = (unsigned long)dest;
+	d.odd  = (unsigned long)dest_len;
+	s.even = (unsigned long)seed;
+	s.odd  = (unsigned long)seed_len;
 	asm volatile (
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rre,%[opc] << 16,%[dst],%[seed]\n"
 		"	brc	1,0b\n"	  /* handle partial completion */
-		: [dst] "+a" (r2), [dlen] "+d" (r3)
-		: [fc] "d" (r0), [pba] "a" (r1),
-		  [seed] "a" (r4), [slen] "d" (r5), [opc] "i" (CPACF_PRNO)
-		: "cc", "memory");
+		: [dst] "+&d" (d.pair)
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [seed] "d" (s.pair), [opc] "i" (CPACF_PRNO)
+		: "cc", "memory", "0", "1");
 }
 
 /**
@@ -443,19 +455,19 @@ static inline void cpacf_prno(unsigned long func, void *param,
 static inline void cpacf_trng(u8 *ucbuf, unsigned long ucbuf_len,
 			      u8 *cbuf, unsigned long cbuf_len)
 {
-	register unsigned long r0 asm("0") = (unsigned long) CPACF_PRNO_TRNG;
-	register unsigned long r2 asm("2") = (unsigned long) ucbuf;
-	register unsigned long r3 asm("3") = (unsigned long) ucbuf_len;
-	register unsigned long r4 asm("4") = (unsigned long) cbuf;
-	register unsigned long r5 asm("5") = (unsigned long) cbuf_len;
+	union register_pair u, c;
 
+	u.even = (unsigned long)ucbuf;
+	u.odd  = (unsigned long)ucbuf_len;
+	c.even = (unsigned long)cbuf;
+	c.odd  = (unsigned long)cbuf_len;
 	asm volatile (
+		"	lghi	0,%[fc]\n"
 		"0:	.insn	rre,%[opc] << 16,%[ucbuf],%[cbuf]\n"
 		"	brc	1,0b\n"	  /* handle partial completion */
-		: [ucbuf] "+a" (r2), [ucbuflen] "+d" (r3),
-		  [cbuf] "+a" (r4), [cbuflen] "+d" (r5)
-		: [fc] "d" (r0), [opc] "i" (CPACF_PRNO)
-		: "cc", "memory");
+		: [ucbuf] "+&d" (u.pair), [cbuf] "+&d" (c.pair)
+		: [fc] "K" (CPACF_PRNO_TRNG), [opc] "i" (CPACF_PRNO)
+		: "cc", "memory", "0");
 }
 
 /**
@@ -466,15 +478,15 @@ static inline void cpacf_trng(u8 *ucbuf, unsigned long ucbuf_len,
  */
 static inline void cpacf_pcc(unsigned long func, void *param)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rre,%[opc] << 16,0,0\n" /* PCC opcode */
 		"	brc	1,0b\n" /* handle partial completion */
 		:
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_PCC)
-		: "cc", "memory");
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [opc] "i" (CPACF_PCC)
+		: "cc", "memory", "0", "1");
 }
 
 /**
@@ -487,14 +499,14 @@ static inline void cpacf_pcc(unsigned long func, void *param)
  */
 static inline void cpacf_pckmo(long func, void *param)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"       .insn   rre,%[opc] << 16,0,0\n" /* PCKMO opcode */
 		:
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_PCKMO)
-		: "cc", "memory");
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [opc] "i" (CPACF_PCKMO)
+		: "cc", "memory", "0", "1");
 }
 
 /**
@@ -512,21 +524,23 @@ static inline void cpacf_kma(unsigned long func, void *param, u8 *dest,
 			     const u8 *src, unsigned long src_len,
 			     const u8 *aad, unsigned long aad_len)
 {
-	register unsigned long r0 asm("0") = (unsigned long) func;
-	register unsigned long r1 asm("1") = (unsigned long) param;
-	register unsigned long r2 asm("2") = (unsigned long) src;
-	register unsigned long r3 asm("3") = (unsigned long) src_len;
-	register unsigned long r4 asm("4") = (unsigned long) aad;
-	register unsigned long r5 asm("5") = (unsigned long) aad_len;
-	register unsigned long r6 asm("6") = (unsigned long) dest;
+	union register_pair d, s, a;
 
+	d.even = (unsigned long)dest;
+	s.even = (unsigned long)src;
+	s.odd  = (unsigned long)src_len;
+	a.even = (unsigned long)aad;
+	a.odd  = (unsigned long)aad_len;
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[pba]\n"
 		"0:	.insn	rrf,%[opc] << 16,%[dst],%[src],%[aad],0\n"
 		"	brc	1,0b\n"	/* handle partial completion */
-		: [dst] "+a" (r6), [src] "+a" (r2), [slen] "+d" (r3),
-		  [aad] "+a" (r4), [alen] "+d" (r5)
-		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (CPACF_KMA)
-		: "cc", "memory");
+		: [dst] "+&d" (d.pair), [src] "+&d" (s.pair),
+		  [aad] "+&d" (a.pair)
+		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		  [opc] "i" (CPACF_KMA)
+		: "cc", "memory", "0", "1");
 }
 
 #endif	/* _ASM_S390_CPACF_H */
-- 
2.43.0



