Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E4F39FF3;
	Fri, 24 Nov 2023 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDIGVZD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27F3C433C8;
	Fri, 24 Nov 2023 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849706;
	bh=IhEsyxzx9eLPGpAgrN2QYIpYvOCqsf1miENE9n/fXfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDIGVZD4LDtMYmUJtrdZTFJa9+5hv8C4Y2o20r1WPkEtLmpvyUuW9qRXC0DtTRnJs
	 DzFB57VNdR1TEY0IV0JNPn3wg18v5UvHVtqy7v/ZbXY9K3pZ6SV3aJISSwJF6+pN4g
	 UnAixVFdHXv6UFnneib8PluV3UKlAP2V9M8mQPP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 287/530] parisc: Add nop instructions after TLB inserts
Date: Fri, 24 Nov 2023 17:47:33 +0000
Message-ID: <20231124172036.774302160@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: John David Anglin <dave@parisc-linux.org>

commit ad4aa06e1d92b06ed56c7240252927bd60632efe upstream.

An excerpt from the PA8800 ERS states:

* The PA8800 violates the seven instruction pipeline rule when performing
  TLB inserts or PxTLBE instructions with the PSW C bit on. The instruction
  will take effect by the 12th instruction after the insert or purge.

I believe we have a problem with handling TLB misses. We don't fill
the pipeline following TLB inserts. As a result, we likely fault again
after returning from the interruption.

The above statement indicates that we need at least seven instructions
after the insert on pre PA8800 processors and we need 12 instructions
on PA8800/PA8900 processors.

Here we add macros and code to provide the required number instructions
after a TLB insert.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Suggested-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/entry.S |   81 ++++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 29 deletions(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -36,6 +36,24 @@
 	.level 2.0
 #endif
 
+/*
+ * We need seven instructions after a TLB insert for it to take effect.
+ * The PA8800/PA8900 processors are an exception and need 12 instructions.
+ * The RFI changes both IAOQ_Back and IAOQ_Front, so it counts as one.
+ */
+#ifdef CONFIG_64BIT
+#define NUM_PIPELINE_INSNS    12
+#else
+#define NUM_PIPELINE_INSNS    7
+#endif
+
+	/* Insert num nops */
+	.macro	insert_nops num
+	.rept \num
+	nop
+	.endr
+	.endm
+
 	/* Get aligned page_table_lock address for this mm from cr28/tr4 */
 	.macro  get_ptl reg
 	mfctl	%cr28,\reg
@@ -415,24 +433,20 @@
 3:
 	.endm
 
-	/* Release page_table_lock without reloading lock address.
-	   We use an ordered store to ensure all prior accesses are
-	   performed prior to releasing the lock. */
-	.macro		ptl_unlock0	spc,tmp,tmp2
+	/* Release page_table_lock if for user space. We use an ordered
+	   store to ensure all prior accesses are performed prior to
+	   releasing the lock. Note stw may not be executed, so we
+	   provide one extra nop when CONFIG_TLB_PTLOCK is defined. */
+	.macro		ptl_unlock	spc,tmp,tmp2
 #ifdef CONFIG_TLB_PTLOCK
-98:	ldi		__ARCH_SPIN_LOCK_UNLOCKED_VAL, \tmp2
+98:	get_ptl		\tmp
+	ldi		__ARCH_SPIN_LOCK_UNLOCKED_VAL, \tmp2
 	or,COND(=)	%r0,\spc,%r0
 	stw,ma		\tmp2,0(\tmp)
 99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
-#endif
-	.endm
-
-	/* Release page_table_lock. */
-	.macro		ptl_unlock1	spc,tmp,tmp2
-#ifdef CONFIG_TLB_PTLOCK
-98:	get_ptl		\tmp
-	ptl_unlock0	\spc,\tmp,\tmp2
-99:	ALTERNATIVE(98b, 99b, ALT_COND_NO_SMP, INSN_NOP)
+	insert_nops	NUM_PIPELINE_INSNS - 4
+#else
+	insert_nops	NUM_PIPELINE_INSNS - 1
 #endif
 	.endm
 
@@ -1124,7 +1138,7 @@ dtlb_miss_20w:
 	
 	idtlbt          pte,prot
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1133,6 +1147,7 @@ dtlb_check_alias_20w:
 
 	idtlbt          pte,prot
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1150,7 +1165,7 @@ nadtlb_miss_20w:
 
 	idtlbt          pte,prot
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1159,6 +1174,7 @@ nadtlb_check_alias_20w:
 
 	idtlbt          pte,prot
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1184,7 +1200,7 @@ dtlb_miss_11:
 
 	mtsp		t1, %sr1	/* Restore sr1 */
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1194,6 +1210,7 @@ dtlb_check_alias_11:
 	idtlba          pte,(va)
 	idtlbp          prot,(va)
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1217,7 +1234,7 @@ nadtlb_miss_11:
 
 	mtsp		t1, %sr1	/* Restore sr1 */
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1227,6 +1244,7 @@ nadtlb_check_alias_11:
 	idtlba          pte,(va)
 	idtlbp          prot,(va)
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1246,7 +1264,7 @@ dtlb_miss_20:
 
 	idtlbt          pte,prot
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1255,6 +1273,7 @@ dtlb_check_alias_20:
 	
 	idtlbt          pte,prot
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1274,7 +1293,7 @@ nadtlb_miss_20:
 	
 	idtlbt		pte,prot
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1283,6 +1302,7 @@ nadtlb_check_alias_20:
 
 	idtlbt          pte,prot
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1319,7 +1339,7 @@ itlb_miss_20w:
 	
 	iitlbt          pte,prot
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1343,7 +1363,7 @@ naitlb_miss_20w:
 
 	iitlbt          pte,prot
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1352,6 +1372,7 @@ naitlb_check_alias_20w:
 
 	iitlbt		pte,prot
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1377,7 +1398,7 @@ itlb_miss_11:
 
 	mtsp		t1, %sr1	/* Restore sr1 */
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1401,7 +1422,7 @@ naitlb_miss_11:
 
 	mtsp		t1, %sr1	/* Restore sr1 */
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1411,6 +1432,7 @@ naitlb_check_alias_11:
 	iitlba          pte,(%sr0, va)
 	iitlbp          prot,(%sr0, va)
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1431,7 +1453,7 @@ itlb_miss_20:
 
 	iitlbt          pte,prot
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1451,7 +1473,7 @@ naitlb_miss_20:
 
 	iitlbt          pte,prot
 
-	ptl_unlock1	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1460,6 +1482,7 @@ naitlb_check_alias_20:
 
 	iitlbt          pte,prot
 
+	insert_nops	NUM_PIPELINE_INSNS - 1
 	rfir
 	nop
 
@@ -1481,7 +1504,7 @@ dbit_trap_20w:
 		
 	idtlbt          pte,prot
 
-	ptl_unlock0	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 #else
@@ -1507,7 +1530,7 @@ dbit_trap_11:
 
 	mtsp            t1, %sr1     /* Restore sr1 */
 
-	ptl_unlock0	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 
@@ -1527,7 +1550,7 @@ dbit_trap_20:
 	
 	idtlbt		pte,prot
 
-	ptl_unlock0	spc,t0,t1
+	ptl_unlock	spc,t0,t1
 	rfir
 	nop
 #endif


