Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A13C14A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBCFC433C7;
	Thu, 24 Aug 2023 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897624;
	bh=S84RXrUxG+9CwhP+XBO8MSjgujJBlBhh08pDwAwtq10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mam0CigQw7D7qwllDSZHhND8nmHoD/y2BPWrEBhijJE9FmxQ711ns7sOQ3tAptFsF
	 0+YV+Es/QjkEr9mw/MNrvbuuMJVpZrb3LnCH2PLcXUuXJu5GBh+THYc32BiW1lTPUC
	 7EMuksWxmLyHfw0sVD6ck99Tj9l8i7ZHUw9jPDQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/135] riscv: lib: uaccess: fold fixups into body
Date: Thu, 24 Aug 2023 19:09:38 +0200
Message-ID: <20230824170621.860014190@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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



