Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D3A1292FF;
	Thu, 13 Jun 2024 12:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281457; cv=none; b=ir5rzg5C/5yCGuxcDUOGT3f1rJ/0J21/2WrIOTtCmHrDBsmkFY6M/DvuEou3vPGwwru5ImW3pz8Ie4dvj88CVpckuuT9dxbwjUMh8bflo0miih6lahM3gXfHPT8R1RDcVtEwN03t/icZCvPCnkPKBl0OumnkszZf4eTmktYC1aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281457; c=relaxed/simple;
	bh=D1ANCdK0p2QUUqSuFfeE0GBTmHqui7DEAu2aljf2ba0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPKv+SBme0yzE1PIVE8jn4kNuMUMkG9NH0mc4LjWrPe6MX7YS5qACGr+3KOZV2XgroXtcXv1YQrIjel0rlgP7UJQPsqkx4r50C2td1rFRIjFrananBz++fBckzWoFXCq7qnjzBRLHS0GfOc+PPn745//Cm0XKfg65pRTlIjKbj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rK5BXFjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rK5BXFjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DDEC2BBFC;
	Thu, 13 Jun 2024 12:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281457;
	bh=D1ANCdK0p2QUUqSuFfeE0GBTmHqui7DEAu2aljf2ba0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rK5BXFjL6etfTjnP/k2b5IQoP8wkTRMHjwVocUZpeRfm7ID9ACTXPMj6p/ZWpODRJ
	 1E0SCmLFNGs1/sea4ZDcvr+KMbdgkA2WbaDH6k2rwsd9MBWRqUEJUEllzxypCp0Z3K
	 yeTlWZ3ZFjZTvv5v8JNYRBjFe1yhAuEyIIe0ky60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/317] powerpc/uaccess: Use asm goto for get_user when compiler supports it
Date: Thu, 13 Jun 2024 13:34:38 +0200
Message-ID: <20240613113257.605251513@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 5cd29b1fd3e8f2b45fe6d011588d832417defe31 ]

clang 11 and future GCC are supporting asm goto with outputs.

Use it to implement get_user in order to get better generated code.

Note that clang requires to set x in the default branch of
__get_user_size_goto() otherwise is compliant about x not being
initialised :puzzled:

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/403745b5aaa1b315bb4e8e46c1ba949e77eecec0.1615398265.git.christophe.leroy@csgroup.eu
Stable-dep-of: 50934945d542 ("powerpc/uaccess: Use YZ asm constraint for ld")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/uaccess.h | 55 ++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 6b808bcdecd52..d4d59f57c42d9 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -243,6 +243,59 @@ extern long __get_user_bad(void);
 		: "=r" (err)			\
 		: "b" (uaddr), "b" (kaddr), "i" (-EFAULT), "0" (err))
 
+#ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+
+#define __get_user_asm_goto(x, addr, label, op)			\
+	asm_volatile_goto(					\
+		"1:	"op"%U1%X1 %0, %1	# get_user\n"	\
+		EX_TABLE(1b, %l2)				\
+		: "=r" (x)					\
+		: "m"UPD_CONSTR (*addr)				\
+		:						\
+		: label)
+
+#ifdef __powerpc64__
+#define __get_user_asm2_goto(x, addr, label)			\
+	__get_user_asm_goto(x, addr, label, "ld")
+#else /* __powerpc64__ */
+#define __get_user_asm2_goto(x, addr, label)			\
+	asm_volatile_goto(					\
+		"1:	lwz%X1 %0, %1\n"			\
+		"2:	lwz%X1 %L0, %L1\n"			\
+		EX_TABLE(1b, %l2)				\
+		EX_TABLE(2b, %l2)				\
+		: "=r" (x)					\
+		: "m" (*addr)					\
+		:						\
+		: label)
+#endif /* __powerpc64__ */
+
+#define __get_user_size_goto(x, ptr, size, label)				\
+do {										\
+	BUILD_BUG_ON(size > sizeof(x));						\
+	switch (size) {								\
+	case 1: __get_user_asm_goto(x, (u8 __user *)ptr, label, "lbz"); break;	\
+	case 2: __get_user_asm_goto(x, (u16 __user *)ptr, label, "lhz"); break;	\
+	case 4: __get_user_asm_goto(x, (u32 __user *)ptr, label, "lwz"); break;	\
+	case 8: __get_user_asm2_goto(x, (u64 __user *)ptr, label);  break;	\
+	default: x = 0; BUILD_BUG();						\
+	}									\
+} while (0)
+
+#define __get_user_size_allowed(x, ptr, size, retval)			\
+do {									\
+		__label__ __gus_failed;					\
+									\
+		__get_user_size_goto(x, ptr, size, __gus_failed);	\
+		retval = 0;						\
+		break;							\
+__gus_failed:								\
+		x = 0;							\
+		retval = -EFAULT;					\
+} while (0)
+
+#else /* CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
+
 #define __get_user_asm(x, addr, err, op)		\
 	__asm__ __volatile__(				\
 		"1:	"op"%U2%X2 %1, %2	# get_user\n"	\
@@ -299,6 +352,8 @@ do {								\
 	prevent_read_from_user(ptr, size);			\
 } while (0)
 
+#endif /* CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
+
 /*
  * This is a type: either unsigned long, if the argument fits into
  * that type, or otherwise unsigned long long.
-- 
2.43.0



