Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D7317B4E8;
	Wed,  3 Jul 2024 10:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003842; cv=none; b=s6TjzK9iVuYaW1c2bIOEddv4FxuKotoK6H4JP7trOaKNThUPIt0qGIq6OeXFnX91oJt4St0iQeYXraMiwoOQGv+NTj2WiXBSfrGUx2eePpTr+tByyNLu5pvnRbi0zZDsHAByYuDVKEt4G0xVykxnoiqHMJmw3fjbVvhUtfX1NGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003842; c=relaxed/simple;
	bh=AqJ5fq1YhrOimkhWvbLs823pa0Gq8zzQP1dO0MFeG7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjQAVSExU79QfzK8GOkzAhQMkT9huLJPkdEzinFKYG5vOuXkqsjWiL4AKp0NVvANw2q4hbwGgTAlKhNBwHIKANts05zpp6iD55og74KTiClNA9c8YDdF/lg3PkzV0+z9dQn4YEv+nNhV8C3g2dv5J4h3erRO38cD6JvW44AVE5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFcPnHrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFcPnHrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DD0C4AF0C;
	Wed,  3 Jul 2024 10:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003842;
	bh=AqJ5fq1YhrOimkhWvbLs823pa0Gq8zzQP1dO0MFeG7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFcPnHrY0ikgZtoBUkvEoDwrqStuKFYB/RTdtgqjCBEJFVOFFkJuoodnvAL/SfibL
	 dG6d6MVew7U8t04dcTHtBcw3MtOYQJI4uzcgZUU8ENQzgQzRkq6efxnf+vJyy+bg9d
	 H2xwVeqKlPbijWavMWCPruhhmoDhbsvD3GGT71Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Juergen Christ <jchrist@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/189] s390/cpacf: Split and rework cpacf query functions
Date: Wed,  3 Jul 2024 12:38:20 +0200
Message-ID: <20240703102842.986519842@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 830999bd7e72f4128b9dfa37090d9fa8120ce323 ]

Rework the cpacf query functions to use the correct RRE
or RRF instruction formats and set register fields within
instructions correctly.

Fixes: 1afd43e0fbba ("s390/crypto: allow to query all known cpacf functions")
Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Suggested-by: Juergen Christ <jchrist@linux.ibm.com>
Suggested-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/cpacf.h | 101 +++++++++++++++++++++++++++-------
 1 file changed, 81 insertions(+), 20 deletions(-)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index 646b12981f208..fa31f71cf5746 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -161,28 +161,79 @@
 
 typedef struct { unsigned char bytes[16]; } cpacf_mask_t;
 
-/**
- * cpacf_query() - check if a specific CPACF function is available
- * @opcode: the opcode of the crypto instruction
- * @func: the function code to test for
- *
- * Executes the query function for the given crypto instruction @opcode
- * and checks if @func is available
- *
- * Returns 1 if @func is available for @opcode, 0 otherwise
- */
-static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
+static __always_inline void __cpacf_query_rre(u32 opc, u8 r1, u8 r2,
+					      cpacf_mask_t *mask)
 {
 	asm volatile(
-		"	lghi	0,0\n" /* query function */
-		"	lgr	1,%[mask]\n"
-		"	spm	0\n" /* pckmo doesn't change the cc */
-		/* Parameter regs are ignored, but must be nonzero and unique */
-		"0:	.insn	rrf,%[opc] << 16,2,4,6,0\n"
-		"	brc	1,0b\n"	/* handle partial completion */
-		: "=m" (*mask)
-		: [mask] "d" ((unsigned long)mask), [opc] "i" (opcode)
-		: "cc", "0", "1");
+		"	la	%%r1,%[mask]\n"
+		"	xgr	%%r0,%%r0\n"
+		"	.insn	rre,%[opc] << 16,%[r1],%[r2]\n"
+		: [mask] "=R" (*mask)
+		: [opc] "i" (opc),
+		  [r1] "i" (r1), [r2] "i" (r2)
+		: "cc", "r0", "r1");
+}
+
+static __always_inline void __cpacf_query_rrf(u32 opc,
+					      u8 r1, u8 r2, u8 r3, u8 m4,
+					      cpacf_mask_t *mask)
+{
+	asm volatile(
+		"	la	%%r1,%[mask]\n"
+		"	xgr	%%r0,%%r0\n"
+		"	.insn	rrf,%[opc] << 16,%[r1],%[r2],%[r3],%[m4]\n"
+		: [mask] "=R" (*mask)
+		: [opc] "i" (opc), [r1] "i" (r1), [r2] "i" (r2),
+		  [r3] "i" (r3), [m4] "i" (m4)
+		: "cc", "r0", "r1");
+}
+
+static __always_inline void __cpacf_query(unsigned int opcode,
+					  cpacf_mask_t *mask)
+{
+	switch (opcode) {
+	case CPACF_KDSA:
+		__cpacf_query_rre(CPACF_KDSA, 0, 2, mask);
+		break;
+	case CPACF_KIMD:
+		__cpacf_query_rre(CPACF_KIMD, 0, 2, mask);
+		break;
+	case CPACF_KLMD:
+		__cpacf_query_rre(CPACF_KLMD, 0, 2, mask);
+		break;
+	case CPACF_KM:
+		__cpacf_query_rre(CPACF_KM, 2, 4, mask);
+		break;
+	case CPACF_KMA:
+		__cpacf_query_rrf(CPACF_KMA, 2, 4, 6, 0, mask);
+		break;
+	case CPACF_KMAC:
+		__cpacf_query_rre(CPACF_KMAC, 0, 2, mask);
+		break;
+	case CPACF_KMC:
+		__cpacf_query_rre(CPACF_KMC, 2, 4, mask);
+		break;
+	case CPACF_KMCTR:
+		__cpacf_query_rrf(CPACF_KMCTR, 2, 4, 6, 0, mask);
+		break;
+	case CPACF_KMF:
+		__cpacf_query_rre(CPACF_KMF, 2, 4, mask);
+		break;
+	case CPACF_KMO:
+		__cpacf_query_rre(CPACF_KMO, 2, 4, mask);
+		break;
+	case CPACF_PCC:
+		__cpacf_query_rre(CPACF_PCC, 0, 0, mask);
+		break;
+	case CPACF_PCKMO:
+		__cpacf_query_rre(CPACF_PCKMO, 0, 0, mask);
+		break;
+	case CPACF_PRNO:
+		__cpacf_query_rre(CPACF_PRNO, 2, 4, mask);
+		break;
+	default:
+		BUG();
+	}
 }
 
 static __always_inline int __cpacf_check_opcode(unsigned int opcode)
@@ -210,6 +261,16 @@ static __always_inline int __cpacf_check_opcode(unsigned int opcode)
 	}
 }
 
+/**
+ * cpacf_query() - check if a specific CPACF function is available
+ * @opcode: the opcode of the crypto instruction
+ * @func: the function code to test for
+ *
+ * Executes the query function for the given crypto instruction @opcode
+ * and checks if @func is available
+ *
+ * Returns 1 if @func is available for @opcode, 0 otherwise
+ */
 static __always_inline int cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
 {
 	if (__cpacf_check_opcode(opcode)) {
-- 
2.43.0



