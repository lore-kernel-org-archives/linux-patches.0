Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9931A256C;
	Thu,  6 Jun 2024 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683756; cv=none; b=DEKLn2EHbwfRPgCGLbS1sNRa0OEincQXO7+wg0UQSxw2ikkTGip4FhYPcdXhduUeMjC9Ucoa67fMlbbRCIrLgkb1EGj6+SKWL5yA5UnlFtR8bEgIbcGNj/xyhBOxJ0hHNgq3AcrAjEfVU28hqSUGxS90qFwz7WsaN0BISsfG9Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683756; c=relaxed/simple;
	bh=LWfIVKmrnJBBN/9bX7ycPYHrHAaCoGha6kSZnfeHWZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQA+cTedccUFb5yrNJpNUeo5ZbiiIxSQC4Uj0Sq3eNpmOjHJPToMBLoWplCqKFmOEmXOAvvr1ZYrJth4reGMf2hgDvFLTDCLCzbDwxeJ/UroeHdjC95wXp8o0+N/GO8h+MX+nqHSnkyZsALJ10q+kMYnnOWGBo5r3lARKkB7MfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaSqt5mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaSqt5mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512E0C2BD10;
	Thu,  6 Jun 2024 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683756;
	bh=LWfIVKmrnJBBN/9bX7ycPYHrHAaCoGha6kSZnfeHWZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaSqt5mmHuR/Dwb/cojQTX6tEfNitCHvNiJnknB+cN0iZhR/K645LLqCWrr/N4Tqo
	 EWyOBpNbY7Os2g68svZRpoNd/0Q06+p6e+EC/TSZJFk53Vdc4qwjvC0PylKSaPtuw4
	 3PMd05TtGTPqF/Gwq4K5VNOtMSSBcXD4eEVMNRBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 729/744] powerpc/uaccess: Use YZ asm constraint for ld
Date: Thu,  6 Jun 2024 16:06:41 +0200
Message-ID: <20240606131755.849411796@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 4c96de9cd1e99..ad8e5f72c59a0 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -165,8 +165,19 @@ do {								\
 #endif
 
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



