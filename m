Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A254613DDDD;
	Thu, 11 Apr 2024 09:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829551; cv=none; b=JlqQZiG8I0BlsiY+l7v/g09SkRdstN6XtCJWzrSImeSdlj21iEqh/+k41kEKOOiRILKn9iCOGa5cBRZjx+JR0CP05ylatWp3pWKLruVLiacIdsX208aHXLYlahxEMKnArCMhhArKIJSKOX19m7DBklBHENU2wPIgwwIZ/epE0s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829551; c=relaxed/simple;
	bh=YkJMmA5QuRwI5EkZGKTm5ujOFGPG3UajTb0Y+8zrTuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvQoB287z8PaVce2IkOrN5icAvEQYw4bUGTNIhsBZnBtDUFAL9OoomdTdur8EOR7SzStyf0FluLNdPgdaJeJgr4kwfELJP17GYPPVUprEAO6s+ywcV8W+t/ZgpI2cDjdQNax/3NQ8psp4knHrJ/RoDHyzx9c/2QaRBojeIOuJUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWJD6cFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWJD6cFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FBDC433C7;
	Thu, 11 Apr 2024 09:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829551;
	bh=YkJMmA5QuRwI5EkZGKTm5ujOFGPG3UajTb0Y+8zrTuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWJD6cFuqOTwG9aQzCyTwIBQoQlzTdlkzlDyWgu3g1TD8iR0tS0pk6D3YjlEleceY
	 qgrPmZT9Oj484wsxFR2QR+GnShKEoLyMvZTgwAOGkLGgcQDyCt+L+AvoiurH+S32kU
	 fliRWoGBuCZDuv7vAaNgXzZYvCLT+XGtrGvmcBHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/175] parisc: Do not hardcode registers in checksum functions
Date: Thu, 11 Apr 2024 11:54:08 +0200
Message-ID: <20240411095420.313171474@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 52b2d91752a82d9350981eb3b3ffc4b325c84ba9 ]

Do not hardcode processor registers r19 to r22 as scratch registers.
Instead let the compiler decide, which may give better optimization
results when the functions get inlined.

Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: a2abae8f0b63 ("parisc: Fix ip_fast_csum")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/checksum.h | 101 +++++++++++++++--------------
 1 file changed, 52 insertions(+), 49 deletions(-)

diff --git a/arch/parisc/include/asm/checksum.h b/arch/parisc/include/asm/checksum.h
index 3cbf1f1c1188e..c1c22819a04d1 100644
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -42,31 +42,32 @@ extern __wsum csum_partial_copy_from_user(const void __user *src,
 static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 {
 	unsigned int sum;
+	unsigned long t0, t1, t2;
 
 	__asm__ __volatile__ (
 "	ldws,ma		4(%1), %0\n"
 "	addib,<=	-4, %2, 2f\n"
 "\n"
-"	ldws		4(%1), %%r20\n"
-"	ldws		8(%1), %%r21\n"
-"	add		%0, %%r20, %0\n"
-"	ldws,ma		12(%1), %%r19\n"
-"	addc		%0, %%r21, %0\n"
-"	addc		%0, %%r19, %0\n"
-"1:	ldws,ma		4(%1), %%r19\n"
+"	ldws		4(%1), %4\n"
+"	ldws		8(%1), %5\n"
+"	add		%0, %4, %0\n"
+"	ldws,ma		12(%1), %3\n"
+"	addc		%0, %5, %0\n"
+"	addc		%0, %3, %0\n"
+"1:	ldws,ma		4(%1), %3\n"
 "	addib,<		0, %2, 1b\n"
-"	addc		%0, %%r19, %0\n"
+"	addc		%0, %3, %0\n"
 "\n"
-"	extru		%0, 31, 16, %%r20\n"
-"	extru		%0, 15, 16, %%r21\n"
-"	addc		%%r20, %%r21, %0\n"
-"	extru		%0, 15, 16, %%r21\n"
-"	add		%0, %%r21, %0\n"
+"	extru		%0, 31, 16, %4\n"
+"	extru		%0, 15, 16, %5\n"
+"	addc		%4, %5, %0\n"
+"	extru		%0, 15, 16, %5\n"
+"	add		%0, %5, %0\n"
 "	subi		-1, %0, %0\n"
 "2:\n"
-	: "=r" (sum), "=r" (iph), "=r" (ihl)
+	: "=r" (sum), "=r" (iph), "=r" (ihl), "=r" (t0), "=r" (t1), "=r" (t2)
 	: "1" (iph), "2" (ihl)
-	: "r19", "r20", "r21", "memory");
+	: "memory");
 
 	return (__force __sum16)sum;
 }
@@ -126,6 +127,10 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 					  __u32 len, __u8 proto,
 					  __wsum sum)
 {
+	unsigned long t0, t1, t2, t3;
+
+	len += proto;	/* add 16-bit proto + len */
+
 	__asm__ __volatile__ (
 
 #if BITS_PER_LONG > 32
@@ -136,20 +141,19 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	** Try to keep 4 registers with "live" values ahead of the ALU.
 	*/
 
-"	ldd,ma		8(%1), %%r19\n"	/* get 1st saddr word */
-"	ldd,ma		8(%2), %%r20\n"	/* get 1st daddr word */
-"	add		%8, %3, %3\n"/* add 16-bit proto + len */
-"	add		%%r19, %0, %0\n"
-"	ldd,ma		8(%1), %%r21\n"	/* 2cd saddr */
-"	ldd,ma		8(%2), %%r22\n"	/* 2cd daddr */
-"	add,dc		%%r20, %0, %0\n"
-"	add,dc		%%r21, %0, %0\n"
-"	add,dc		%%r22, %0, %0\n"
+"	ldd,ma		8(%1), %4\n"	/* get 1st saddr word */
+"	ldd,ma		8(%2), %5\n"	/* get 1st daddr word */
+"	add		%4, %0, %0\n"
+"	ldd,ma		8(%1), %6\n"	/* 2nd saddr */
+"	ldd,ma		8(%2), %7\n"	/* 2nd daddr */
+"	add,dc		%5, %0, %0\n"
+"	add,dc		%6, %0, %0\n"
+"	add,dc		%7, %0, %0\n"
 "	add,dc		%3, %0, %0\n"  /* fold in proto+len | carry bit */
-"	extrd,u		%0, 31, 32, %%r19\n"	/* copy upper half down */
-"	depdi		0, 31, 32, %0\n"	/* clear upper half */
-"	add		%%r19, %0, %0\n"	/* fold into 32-bits */
-"	addc		0, %0, %0\n"		/* add carry */
+"	extrd,u		%0, 31, 32, %4\n"/* copy upper half down */
+"	depdi		0, 31, 32, %0\n"/* clear upper half */
+"	add		%4, %0, %0\n"	/* fold into 32-bits */
+"	addc		0, %0, %0\n"	/* add carry */
 
 #else
 
@@ -158,30 +162,29 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	** Insn stream is serialized on the carry bit here too.
 	** result from the previous operation (eg r0 + x)
 	*/
-
-"	ldw,ma		4(%1), %%r19\n"	/* get 1st saddr word */
-"	ldw,ma		4(%2), %%r20\n"	/* get 1st daddr word */
-"	add		%8, %3, %3\n"	/* add 16-bit proto + len */
-"	add		%%r19, %0, %0\n"
-"	ldw,ma		4(%1), %%r21\n"	/* 2cd saddr */
-"	addc		%%r20, %0, %0\n"
-"	ldw,ma		4(%2), %%r22\n"	/* 2cd daddr */
-"	addc		%%r21, %0, %0\n"
-"	ldw,ma		4(%1), %%r19\n"	/* 3rd saddr */
-"	addc		%%r22, %0, %0\n"
-"	ldw,ma		4(%2), %%r20\n"	/* 3rd daddr */
-"	addc		%%r19, %0, %0\n"
-"	ldw,ma		4(%1), %%r21\n"	/* 4th saddr */
-"	addc		%%r20, %0, %0\n"
-"	ldw,ma		4(%2), %%r22\n"	/* 4th daddr */
-"	addc		%%r21, %0, %0\n"
-"	addc		%%r22, %0, %0\n"
+"	ldw,ma		4(%1), %4\n"	/* get 1st saddr word */
+"	ldw,ma		4(%2), %5\n"	/* get 1st daddr word */
+"	add		%4, %0, %0\n"
+"	ldw,ma		4(%1), %6\n"	/* 2nd saddr */
+"	addc		%5, %0, %0\n"
+"	ldw,ma		4(%2), %7\n"	/* 2nd daddr */
+"	addc		%6, %0, %0\n"
+"	ldw,ma		4(%1), %4\n"	/* 3rd saddr */
+"	addc		%7, %0, %0\n"
+"	ldw,ma		4(%2), %5\n"	/* 3rd daddr */
+"	addc		%4, %0, %0\n"
+"	ldw,ma		4(%1), %6\n"	/* 4th saddr */
+"	addc		%5, %0, %0\n"
+"	ldw,ma		4(%2), %7\n"	/* 4th daddr */
+"	addc		%6, %0, %0\n"
+"	addc		%7, %0, %0\n"
 "	addc		%3, %0, %0\n"	/* fold in proto+len, catch carry */
 
 #endif
-	: "=r" (sum), "=r" (saddr), "=r" (daddr), "=r" (len)
-	: "0" (sum), "1" (saddr), "2" (daddr), "3" (len), "r" (proto)
-	: "r19", "r20", "r21", "r22", "memory");
+	: "=r" (sum), "=r" (saddr), "=r" (daddr), "=r" (len),
+	  "=r" (t0), "=r" (t1), "=r" (t2), "=r" (t3)
+	: "0" (sum), "1" (saddr), "2" (daddr), "3" (len)
+	: "memory");
 	return csum_fold(sum);
 }
 
-- 
2.43.0



