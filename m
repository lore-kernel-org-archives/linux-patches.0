Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019912;
	b=t2IdbGuqMc9w042SrBdq5B6bg7Q9Sj/zlePwHwjhz3LaCqpZzcCG3yGVCJAuuGGkV7HS
	 W3WFYBSJqT5fv42OQjSHwjEv+sOqwhnlAiTBd7k7Th1c0yYd9b3uQjw5DIqJfh9rbNZ/m
	 PtIOQahIuhhIg9PSOrxtvuYJCkN+045H9cV9MoC38RdwyHLP3pGYTQA4Tk7YWprG5JET8
	 mUVruMs8PM61diaDyryns+LlExmvABBzDjI0e33LprQTb7d2XqP0lK8RPyoiGnnHunRAe
	 BP/CiCzSfnjKEYNgK67myv67nS+7e3t2DGl++MD/JQKASAFRTnLk+ZITegtCG4REEfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d9TyLJAqLt+Mk5WTyMF0XvjrtqVSframr6UiEE4EBpI=;
	b=Ppa80mmBfPTnBEiW4c5D11C6vFB3Sv+eEKXbtTtbNajd8GtExCjz/lpAg+A6URv/dyz0
	 bZwhN1b6arK3tawOWDq+d17AMzgDesqfz64wJe3aSW3uisqYQXJcTldhA+31ECyETpCv/
	 NREjcQ1I9xXR6Niy1XJqZX3jHmKXbq8+wjMuGv0znfg9U0UiNvVPBlgvLe5f3doX3MThS
	 ZkWdZl2ZZJPgzG+kQm//UVv3xJJph+pl0S2eXJ+RdIPqaIVPkcb3GHG4xgFoL1ODT5Abe
	 I0UnVqQsFGxLwDfgeFk95LfKVLGySecuIE8TdyiV5F0CjfdaSwXg4TXH7jpY7ZbA/4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erDP2X91;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35533606A320;
	Wed, 18 Nov 2026 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erDP2X91
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA5E1F000C5;
	Wed, 18 Nov 2026 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019912;
	bh=d9TyLJAqLt+Mk5WTyMF0XvjrtqVSframr6UiEE4EBpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erDP2X918xP/XwKZPqoKMuELgRcdAouSezAlVnEqOKKe4VjBgojKkJvp9DYTSqWLo
	 O0BsNiH/pAkvjodKUUP7hGVnk5NDuLK4RU0lOre2fBOCIWX+pQSp4XK+VrdmCBVEcP
	 MeYDAe49LMh4v1mshgTePwfk4zSt9dNPld0yavzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1764/2651] s390/percpu: Use percpu code section for this_cpu_xchg()
Date: Wed, 18 Nov 2026 15:50:04 +0100
Message-ID: <20261118150350.949310675@linuxfoundation.org>
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

[ Upstream commit d83b5cf355ca762ef19aa3a424af44e3e275ff52 ]

Convert this_cpu_xchg() to make use of percpu code section
functionality in order to get rid of preempt_disable() and
preempt_enable() calls.

Consider only four and eight byte usages, since there are no compare and
swap instructions for one and two bytes available. For one and two byte
use the previous simple implementation.

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 37e7ca08c4afe..5ac2ec0b93e34 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -331,7 +331,7 @@ do {									\
 	old__;								\
 })
 
-#define arch_this_cpu_xchg(pcp, nval)					\
+#define arch_this_cpu_xchg_simple(pcp, nval)				\
 ({									\
 	typeof(pcp) *ptr__;						\
 	typeof(pcp) ret__;						\
@@ -342,10 +342,34 @@ do {									\
 	ret__;								\
 })
 
-#define this_cpu_xchg_1(pcp, nval) arch_this_cpu_xchg(pcp, nval)
-#define this_cpu_xchg_2(pcp, nval) arch_this_cpu_xchg(pcp, nval)
-#define this_cpu_xchg_4(pcp, nval) arch_this_cpu_xchg(pcp, nval)
-#define this_cpu_xchg_8(pcp, nval) arch_this_cpu_xchg(pcp, nval)
+#define arch_this_cpu_xchg(pcp, nval, ldop, csop)			\
+({									\
+	typedef typeof(pcp) pcp_op_T__;					\
+	pcp_op_T__ old__, new__ = (nval);				\
+	pcp_op_T__ *ptr__;						\
+									\
+	ptr__ = PERCPU_PTR(&(pcp));					\
+	asm_inline volatile(						\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
+		"	" ldop "	%[old__],0(%[ptr__])\n"		\
+		"0:	" csop "	%[old__],%[new__],0(%[ptr__])\n"\
+		"	jnz	0b\n"					\
+		__PCPU_END("%[lcreg]")					\
+		: [old__] "=&d" (old__),				\
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
+#define this_cpu_xchg_1(pcp, nval) arch_this_cpu_xchg_simple(pcp, nval)
+#define this_cpu_xchg_2(pcp, nval) arch_this_cpu_xchg_simple(pcp, nval)
+#define this_cpu_xchg_4(pcp, nval) arch_this_cpu_xchg(pcp, nval, "l",  "cs")
+#define this_cpu_xchg_8(pcp, nval) arch_this_cpu_xchg(pcp, nval, "lg", "csg")
 
 #include <asm-generic/percpu.h>
 
-- 
2.53.0



