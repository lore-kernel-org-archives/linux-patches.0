Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F0D125AE
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B179C433C8;
	Thu, 24 Aug 2023 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889358;
	bh=PhZJsjBzRZbfyiK2Z+IAXDRAjWUefcarXFlvqx9qENY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsMmJJRoDP7rFKJ+3zHkRiBcnvBXYfz4T1aD1ZPeamn5vG7C2/xAW9J2CXVc/haf/
	 NdQ4hNBEANwQS4kRBDqj3nI1f2npP4AtwxSviCQJSYu8o0NA2rSclxjhC4mn5hQ+jH
	 gNQFPKNE8pT+AYRDszH2FDiPqX9X3mtFkjgat4uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Lifu <chenlifu@huawei.com>,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/135] riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit
Date: Thu, 24 Aug 2023 16:50:50 +0200
Message-ID: <20230824145031.575712293@linuxfoundation.org>
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

From: Chen Lifu <chenlifu@huawei.com>

[ Upstream commit c08b4848f596fd95543197463b5162bd7bab2442 ]

Since commit 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
and commit ebcbd75e3962 ("riscv: Fix the bug in memory access fixup code"),
if __clear_user and __copy_user return from an fixup branch,
CSR_STATUS SR_SUM bit will be set, it is a vulnerability, so that
S-mode memory accesses to pages that are accessible by U-mode will success.
Disable S-mode access to U-mode memory should clear SR_SUM bit.

Fixes: 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
Fixes: ebcbd75e3962 ("riscv: Fix the bug in memory access fixup code")
Signed-off-by: Chen Lifu <chenlifu@huawei.com>
Reviewed-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://lore.kernel.org/r/20220615014714.1650349-1-chenlifu@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 4b05b993900d ("riscv: uaccess: Return the number of bytes effectively not copied")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/uaccess.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index baddd6a0d0229..039050172d083 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -178,7 +178,7 @@ ENTRY(__asm_copy_from_user)
 	/* Exception fixup code */
 10:
 	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
+	csrc CSR_STATUS, t6
 	mv a0, t5
 	ret
 ENDPROC(__asm_copy_to_user)
@@ -230,7 +230,7 @@ ENTRY(__clear_user)
 	/* Exception fixup code */
 11:
 	/* Disable access to user memory */
-	csrs CSR_STATUS, t6
+	csrc CSR_STATUS, t6
 	mv a0, a1
 	ret
 ENDPROC(__clear_user)
-- 
2.40.1



