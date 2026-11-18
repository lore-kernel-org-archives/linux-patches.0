Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019915;
	b=GsfdC5Rny0IAlBLfirTGzNGdtCvN+Ize2AZcHzleYUdZhlBV3L7qYscn9lIg0vd3Tn+7
	 Rlm91C2sSoAYUHf+pemN23qozqXV4lZCzuOrSKc8emSV/e9Ps5ItgE9XQMFD8AJmyWu6n
	 7P1iFR0OurOIhgYDlZrkpP0LUFR3mMkCkdo1rKtN45yeG/XZ+EH2lS4BbbTz7tchje56z
	 z27Ln3tj7WnbrkX0dzvw+r6vF61w96Vv0Ho0KkDJAKAsWWe/LiTvN0CHVU08ahKO+MxmW
	 3cmxZZZd/MWSUgcyzk23aVyW0jFSNvu7VVq/dbu5Dxe5xBPH5BccvA7bo6yB+WqikBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=leJalkUtoEe150TRjv4y9n1rdrmZ4I3nyepNLMKPNCE=;
	b=aAHSo5DBIXjDrDVZo0LwX9WCdLD07RHX+SxQiqm5rxw8Kv5Pm/UPyTccW1dKcN3KFT+l
	 VIKtnD8xA/pqrTMXD7fhfejn/wOzPbr4GnSnGGwDyqqRQ59gpuPzUHn4q/C9cUMOcmh8C
	 MV/YHuz3DvMQTgOkylxEWOWoklgJ3VwIoYrPUHbodgrSVXGlI/rWjOuj7AwHk/5nBB55Y
	 Di9h8kd59PoGZE4FNJWCOTtiYFVA5FEIde7P+z3Z5GA0gsuI84MhmIxyYTXitttCvexVN
	 ADiLqPmE3wcxoWwBFHvvaNboNAbVPKnS1pw9H/0VrP3GmdxPbp3V9EHYcW0/4+Io7rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tvjBeQ+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1588606A31C;
	Wed, 18 Nov 2026 16:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tvjBeQ+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466571F000C5;
	Wed, 18 Nov 2026 16:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019914;
	bh=leJalkUtoEe150TRjv4y9n1rdrmZ4I3nyepNLMKPNCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvjBeQ+WRfGNti2AfKf+VB6zWTvpGSQi+EcFf+4CiXvy03VIif2c+f1xS+W93N4nE
	 If3yAPaUOUoU1ZZlW2uZL4i5oOzRKeuklfz/m9R3zGyfWO0q3zull7nY5QJP7/iTiu
	 X+UPeekvTEpaol/3QDcE5ONhtA6TuI3+hj7euLyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1765/2651] s390/percpu: Use percpu code section for this_cpu_cmpxchg()
Date: Wed, 18 Nov 2026 15:50:05 +0100
Message-ID: <20261118150350.980235963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 45b0097302d87a42189abe0b33d69fe18f6c7cb0 ]

Convert this_cpu_cmpxchg() to make use of percpu code section
functionality in order to get rid of preempt_disable() and
preempt_enable() calls.

Consider only four and eight byte usages, since there are no compare
and swap instructions for one and two bytes available. For one and
two bytes use the previous simple implementation.

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 5ac2ec0b93e34..cd0d7c138d661 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -290,7 +290,7 @@ do {									\
 #define this_cpu_write_4(pcp, val) arch_this_cpu_write(pcp, val, "st")
 #define this_cpu_write_8(pcp, val) arch_this_cpu_write(pcp, val, "stg")
 
-#define arch_this_cpu_cmpxchg(pcp, oval, nval)				\
+#define arch_this_cpu_cmpxchg_simple(pcp, oval, nval)			\
 ({									\
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ ret__;						\
@@ -302,10 +302,32 @@ do {									\
 	ret__;								\
 })
 
-#define this_cpu_cmpxchg_1(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval)
-#define this_cpu_cmpxchg_2(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval)
-#define this_cpu_cmpxchg_4(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval)
-#define this_cpu_cmpxchg_8(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval)
+#define arch_this_cpu_cmpxchg(pcp, oval, nval, op)			\
+({									\
+	typedef typeof(pcp) pcp_op_T__;					\
+	pcp_op_T__ old__ = (oval), new__ = (nval);			\
+	pcp_op_T__ *ptr__;						\
+									\
+	ptr__ = PERCPU_PTR(&(pcp));					\
+	asm_inline volatile(						\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
+		op "	%[old__],%[new__],0(%[ptr__])\n"		\
+		__PCPU_END("%[lcreg]")					\
+		: [old__] "+&d" (old__),				\
+		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
+		  "=m" (((struct lowcore *)0)->percpu_register)		\
+		: [new__] "d" (new__),					\
+		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
+		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
+		  "m" (((struct lowcore *)0)->percpu_offset)		\
+		: "memory", "cc");					\
+	old__;								\
+})
+
+#define this_cpu_cmpxchg_1(pcp, oval, nval) arch_this_cpu_cmpxchg_simple(pcp, oval, nval)
+#define this_cpu_cmpxchg_2(pcp, oval, nval) arch_this_cpu_cmpxchg_simple(pcp, oval, nval)
+#define this_cpu_cmpxchg_4(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval, "cs")
+#define this_cpu_cmpxchg_8(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval, "csg")
 
 #define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
 
-- 
2.53.0



