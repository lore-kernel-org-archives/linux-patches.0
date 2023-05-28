Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F2D611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149B0C433D2;
	Sun, 28 May 2023 19:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303106;
	bh=oGaB5Wyq4WoUQYfQvkD33Pe08pN29vUIzygTCh8EMEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uhp+22jGGe1LrMUvZB9ry5WRCdKQSXdI3qNZAmvmGpK3hy6InyKLeIJ36Oucqe5OF
	 tzQ/096UIiaJ27yc+RB647aZrdi/dJxAk5+RghrY77tTzR69KaDW++KIbIqBxi8aY+
	 nTv3aAbW6Lju2eAH6xcKV5mEdM0htPuoe+LBSNj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Block <bblock@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/211] s390/qdio: get rid of register asm
Date: Sun, 28 May 2023 20:11:18 +0100
Message-Id: <20230528190847.408104857@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit d3e2ff5436d6ee38b572ba5c01dc7994769bec54 ]

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 2862a2fdfae8 ("s390/qdio: fix do_sqbs() inline assembly constraint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/qdio.h      | 25 ++++++++-------
 drivers/s390/cio/qdio_main.c | 62 +++++++++++++++++++-----------------
 2 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index cd2df4ff8e0ef..854a21e1d3b7b 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -88,15 +88,15 @@ enum qdio_irq_states {
 static inline int do_sqbs(u64 token, unsigned char state, int queue,
 			  int *start, int *count)
 {
-	register unsigned long _ccq asm ("0") = *count;
-	register unsigned long _token asm ("1") = token;
 	unsigned long _queuestart = ((unsigned long)queue << 32) | *start;
+	unsigned long _ccq = *count;
 
 	asm volatile(
-		"	.insn	rsy,0xeb000000008A,%1,0,0(%2)"
-		: "+d" (_ccq), "+d" (_queuestart)
-		: "d" ((unsigned long)state), "d" (_token)
-		: "memory", "cc");
+		"	lgr	1,%[token]\n"
+		"	.insn	rsy,0xeb000000008a,%[qs],%[ccq],0(%[state])"
+		: [ccq] "+&d" (_ccq), [qs] "+&d" (_queuestart)
+		: [state] "d" ((unsigned long)state), [token] "d" (token)
+		: "memory", "cc", "1");
 	*count = _ccq & 0xff;
 	*start = _queuestart & 0xff;
 
@@ -106,16 +106,17 @@ static inline int do_sqbs(u64 token, unsigned char state, int queue,
 static inline int do_eqbs(u64 token, unsigned char *state, int queue,
 			  int *start, int *count, int ack)
 {
-	register unsigned long _ccq asm ("0") = *count;
-	register unsigned long _token asm ("1") = token;
 	unsigned long _queuestart = ((unsigned long)queue << 32) | *start;
 	unsigned long _state = (unsigned long)ack << 63;
+	unsigned long _ccq = *count;
 
 	asm volatile(
-		"	.insn	rrf,0xB99c0000,%1,%2,0,0"
-		: "+d" (_ccq), "+d" (_queuestart), "+d" (_state)
-		: "d" (_token)
-		: "memory", "cc");
+		"	lgr	1,%[token]\n"
+		"	.insn	rrf,0xb99c0000,%[qs],%[state],%[ccq],0"
+		: [ccq] "+&d" (_ccq), [qs] "+&d" (_queuestart),
+		  [state] "+&d" (_state)
+		: [token] "d" (token)
+		: "memory", "cc", "1");
 	*count = _ccq & 0xff;
 	*start = _queuestart & 0xff;
 	*state = _state & 0xff;
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 3e29c26f01856..e3c55fc2363ac 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -31,38 +31,41 @@ MODULE_DESCRIPTION("QDIO base support");
 MODULE_LICENSE("GPL");
 
 static inline int do_siga_sync(unsigned long schid,
-			       unsigned int out_mask, unsigned int in_mask,
+			       unsigned long out_mask, unsigned long in_mask,
 			       unsigned int fc)
 {
-	register unsigned long __fc asm ("0") = fc;
-	register unsigned long __schid asm ("1") = schid;
-	register unsigned long out asm ("2") = out_mask;
-	register unsigned long in asm ("3") = in_mask;
 	int cc;
 
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[schid]\n"
+		"	lgr	2,%[out]\n"
+		"	lgr	3,%[in]\n"
 		"	siga	0\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (cc)
-		: "d" (__fc), "d" (__schid), "d" (out), "d" (in) : "cc");
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=&d" (cc)
+		: [fc] "d" (fc), [schid] "d" (schid),
+		  [out] "d" (out_mask), [in] "d" (in_mask)
+		: "cc", "0", "1", "2", "3");
 	return cc;
 }
 
-static inline int do_siga_input(unsigned long schid, unsigned int mask,
-				unsigned int fc)
+static inline int do_siga_input(unsigned long schid, unsigned long mask,
+				unsigned long fc)
 {
-	register unsigned long __fc asm ("0") = fc;
-	register unsigned long __schid asm ("1") = schid;
-	register unsigned long __mask asm ("2") = mask;
 	int cc;
 
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[schid]\n"
+		"	lgr	2,%[mask]\n"
 		"	siga	0\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (cc)
-		: "d" (__fc), "d" (__schid), "d" (__mask) : "cc");
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=&d" (cc)
+		: [fc] "d" (fc), [schid] "d" (schid), [mask] "d" (mask)
+		: "cc", "0", "1", "2");
 	return cc;
 }
 
@@ -78,23 +81,24 @@ static inline int do_siga_input(unsigned long schid, unsigned int mask,
  * Note: For IQDC unicast queues only the highest priority queue is processed.
  */
 static inline int do_siga_output(unsigned long schid, unsigned long mask,
-				 unsigned int *bb, unsigned int fc,
+				 unsigned int *bb, unsigned long fc,
 				 unsigned long aob)
 {
-	register unsigned long __fc asm("0") = fc;
-	register unsigned long __schid asm("1") = schid;
-	register unsigned long __mask asm("2") = mask;
-	register unsigned long __aob asm("3") = aob;
 	int cc;
 
 	asm volatile(
+		"	lgr	0,%[fc]\n"
+		"	lgr	1,%[schid]\n"
+		"	lgr	2,%[mask]\n"
+		"	lgr	3,%[aob]\n"
 		"	siga	0\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (cc), "+d" (__fc), "+d" (__aob)
-		: "d" (__schid), "d" (__mask)
-		: "cc");
-	*bb = __fc >> 31;
+		"	lgr	%[fc],0\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=&d" (cc), [fc] "+&d" (fc)
+		: [schid] "d" (schid), [mask] "d" (mask), [aob] "d" (aob)
+		: "cc", "0", "1", "2", "3");
+	*bb = fc >> 31;
 	return cc;
 }
 
-- 
2.39.2



