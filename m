Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073F114A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3D9C433C7;
	Thu, 24 Aug 2023 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897626;
	bh=NDP2qKVTCvPF4P95/1EifrEvA6DWBO0oKqzR4tb9Ecs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDeLrcX4lj9g4f6I5DI+TJeZF3Z60oz+P6HfiNeXfhbcL3oWiaoLoQdyL6QCr8ViF
	 05ZA1TuEwDR3C8GTyHoO1C0ZGPYfRh4b5nVDEgOK6YZx9hwThjNiIFC+Mkz4JF0nYl
	 tu5GwMlkwl5QCLRzjAe7Xq50mFvr56Jr7IkzK29c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Lifu <chenlifu@huawei.com>,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/135] riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit
Date: Thu, 24 Aug 2023 19:09:39 +0200
Message-ID: <20230824170621.899919916@linuxfoundation.org>
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



