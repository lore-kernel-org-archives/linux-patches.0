Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465D21F4733;
	Wed,  6 Nov 2024 12:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897667; cv=none; b=dJ+I48JaIOU9CEiYJc2bsGSCMMAdy+7rtWBN7KxKBbPvsLEgtL6+IFeRz3C8+t1TNW79jKUxAqifykYgGuQmC0NOePnqqY5f20aYMaoUWIzn5PBQIqroxokJKDD0wbzF4QA/VhkhkuHvjZXZohNHjUcj21WucT3vbQ8k0MM5Ebs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897667; c=relaxed/simple;
	bh=Tqheekx0SFn4/eMGzOJoesEQg3IFI/WsS4Vsr+gkyI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCF9BHvolhTk9s2HpAAU+k3XxKD+8/08dDzzAKrPsuNdTHioIhf+0dZlWYSuz2ZWFUyYmQjj1lmUjrSVkp7qMg4hUbtbTR1pqzJxYSow5idH/lS7FD6jP2TDK3ldur53oZUdy1e/q88ROzTCF5nNjkR4qcu5BtbZuNYo6rzWtu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POMvG06a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POMvG06a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1604C4CED4;
	Wed,  6 Nov 2024 12:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897667;
	bh=Tqheekx0SFn4/eMGzOJoesEQg3IFI/WsS4Vsr+gkyI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POMvG06aa51iExHCPk3jVUm20udYfIvgyhP/k6NcbO/yyLq2c5+rEF8mM2C5LEHKP
	 ITp1r/KmncTcwNeLusYsOf4H2BkpRLMf/pKOLdENdHRqTzS+eRUXfa/U8gWSS31xU7
	 ovrBViglk34efPcHNx1WX5VMc9CBk4MnmTEqV64I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/151] riscv: vdso: Prevent the compiler from inserting calls to memset()
Date: Wed,  6 Nov 2024 13:05:01 +0100
Message-ID: <20241106120311.977949405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit bf40167d54d55d4b54d0103713d86a8638fb9290 ]

The compiler is smart enough to insert a call to memset() in
riscv_vdso_get_cpus(), which generates a dynamic relocation.

So prevent this by using -fno-builtin option.

Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20241016083625.136311-2-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index e8aa7c3800075..d58f32a2035b1 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -18,6 +18,7 @@ obj-vdso = $(patsubst %, %.o, $(vdso-syms)) note.o
 
 ccflags-y := -fno-stack-protector
 ccflags-y += -DDISABLE_BRANCH_PROFILING
+ccflags-y += -fno-builtin
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)
-- 
2.43.0



