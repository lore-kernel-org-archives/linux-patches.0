Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469871A0DCA;
	Thu,  6 Jun 2024 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683675; cv=none; b=uyqluc/ZbXOv059I7rOyJWsYpolPRETtx8yQp7vuT9lRtEa5aYSKw8ogx6ctYhW8iLAMoG5rJMKhd6kZ4BTsoOrTrnESzD2U4krqEnqOqJUxl7S1s5/XmCHnVe6Z57ZP3ojWFZKtU2jt9Y2y7XtYun2kJyVtX7lWeEINzpEuYS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683675; c=relaxed/simple;
	bh=IbFDONNFybVvJzrBoG5alogljCvhQv1PT5ZGCQAwOCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smgjMf+0ps25QsnKb4Lw51vjOOO6GVPEWYPxHySHlKZy+WDYk/otbWSw9mPOJ0QTuXfcXJnHtNpjO2G+xM4rv8x+gGQhPkIjkFK21ykg/aXMNAzINeLqMIbTTkYfnVGQWlvz0Q9Ao9RvYrHULGWNBtHa1oxh030unTTDT3hYhag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtrPu0SJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtrPu0SJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2632DC2BD10;
	Thu,  6 Jun 2024 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683675;
	bh=IbFDONNFybVvJzrBoG5alogljCvhQv1PT5ZGCQAwOCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtrPu0SJ4/vVPlQyp8wEw+ndPggI6V3K+RbQa5/dqfBCqscH0Kl2+Iv1mj+R4WJft
	 anpgSPbFGUCGHs3jw7M+SgAFYvhIcn/e49Q9HIRqEwnvPcQttoHXL6Uz1r9PrgAzRS
	 3RNEsTf8Fnt3aSYJKVQ5uKZsO8PmoSi++tT40xWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 470/473] powerpc/uaccess: Use YZ asm constraint for ld
Date: Thu,  6 Jun 2024 16:06:39 +0200
Message-ID: <20240606131715.215950563@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 50934945d54238d2d6d8db4b7c1d4c90d2696c57 ]

The 'ld' instruction requires a 4-byte aligned displacement because it
is a DS-form instruction. But the "m" asm constraint doesn't enforce
that.

Add a special case of __get_user_asm2_goto() so that the "YZ" constraint
can be used for "ld".

The "Z" constraint is documented in the GCC manual PowerPC machine
constraints, and specifies a "memory operand accessed with indexed or
indirect addressing". "Y" is not documented in the manual but specifies
a "memory operand for a DS-form instruction". Using both allows the
compiler to generate a DS-form "ld" or X-form "ldx" as appropriate.

The change has to be conditional on CONFIG_PPC_KERNEL_PREFIXED because
the "Y" constraint does not guarantee 4-byte alignment when prefixed
instructions are enabled.

No build errors have been reported due to this, but the possibility is
there depending on compiler code generation decisions.

Fixes: c20beffeec3c ("powerpc/uaccess: Use flexible addressing with __put_user()/__get_user()")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240529123029.146953-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/uaccess.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 45d4c9cf3f3a2..60eead5d720a3 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -141,8 +141,19 @@ do {								\
 		: label)
 
 #ifdef __powerpc64__
+#ifdef CONFIG_PPC_KERNEL_PREFIXED
 #define __get_user_asm2_goto(x, addr, label)			\
 	__get_user_asm_goto(x, addr, label, "ld")
+#else
+#define __get_user_asm2_goto(x, addr, label)			\
+	asm_goto_output(					\
+		"1:	ld%U1%X1 %0, %1	# get_user\n"		\
+		EX_TABLE(1b, %l2)				\
+		: "=r" (x)					\
+		: DS_FORM_CONSTRAINT (*addr)			\
+		:						\
+		: label)
+#endif // CONFIG_PPC_KERNEL_PREFIXED
 #else /* __powerpc64__ */
 #define __get_user_asm2_goto(x, addr, label)			\
 	asm_goto_output(					\
-- 
2.43.0



