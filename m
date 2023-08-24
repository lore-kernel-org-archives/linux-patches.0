Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCA6125AE
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5F3C433C7;
	Thu, 24 Aug 2023 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889355;
	bh=xSVVkuCK4fYucYXZiOV4TUrXc84XqKOLG1Z9nJHDiMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVhEvApasLFu1OQpCa7RThzBNNr4brvcKcJMw5aJ/vIQS7Prr6d4mR3FEPX+Pz9ZO
	 cRpDSL2fXXl01TuPrwij0F+OR5yw1ZkM4ScvtIwZ9q3xlucUNsXOneBQY1uGOsGGga
	 Ea/jTJ8h6affCOvM/TZ0UvJgjA7jY1DZr6Kv3/3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/135] riscv: lib: uaccess: fold fixups into body
Date: Thu, 24 Aug 2023 16:50:49 +0200
Message-ID: <20230824145031.541342473@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 9d504f9aa5c1b76673018da9503e76b351a24b8c ]

uaccess functions such __asm_copy_to_user(),  __arch_copy_from_user()
and __clear_user() place their exception fixups in the `.fixup` section
without any clear association with themselves. If we backtrace the
fixup code, it will be symbolized as an offset from the nearest prior
symbol.

Similar as arm64 does, we must move fixups into the body of the
functions themselves, after the usual fast-path returns.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 4b05b993900d ("riscv: uaccess: Return the number of bytes effectively not copied")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/uaccess.S | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index bceb0629e440e..baddd6a0d0229 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -174,6 +174,13 @@ ENTRY(__asm_copy_from_user)
 	csrc CSR_STATUS, t6
 	li	a0, 0
 	ret
+
+	/* Exception fixup code */
+10:
+	/* Disable access to user memory */
+	csrs CSR_STATUS, t6
+	mv a0, t5
+	ret
 ENDPROC(__asm_copy_to_user)
 ENDPROC(__asm_copy_from_user)
 EXPORT_SYMBOL(__asm_copy_to_user)
@@ -219,19 +226,12 @@ ENTRY(__clear_user)
 	addi a0, a0, 1
 	bltu a0, a3, 5b
 	j 3b
-ENDPROC(__clear_user)
-EXPORT_SYMBOL(__clear_user)
 
-	.section .fixup,"ax"
-	.balign 4
-	/* Fixup code for __copy_user(10) and __clear_user(11) */
-10:
-	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
-	mv a0, t5
-	ret
+	/* Exception fixup code */
 11:
+	/* Disable access to user memory */
 	csrs CSR_STATUS, t6
 	mv a0, a1
 	ret
-	.previous
+ENDPROC(__clear_user)
+EXPORT_SYMBOL(__clear_user)
-- 
2.40.1



