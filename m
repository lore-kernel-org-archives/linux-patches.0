Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6092B1F81A7;
	Wed,  6 Nov 2024 12:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897144; cv=none; b=EAhh/KAl4btWZpCOaLTD8XxBhaEsM8w7WED5AmqNgKB+YNI0itmviov2X7cAibtzDRDA7Qg0+XtnajHHZRJS0itTAucCYuBOITUf91g6EG3e4iBdflWiccCgHuTgiW9O96003jFvd5/rdIOfk4yP6PjAdtejo/vHAHC9DbINuiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897144; c=relaxed/simple;
	bh=pyPAEs02w/G8cFyGPwzWFaMY+pAx61Xh5UCvWUNof6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAm9B763MXuqRGpAncgSo8TxqjVRQl64jfZcSlNzaF7d1+DIA59yxKDgJ6mdBqktmqKaSD5VZtQs1MZkJWECe4jsUetX1aR022ONiJZPfGQ8owC9RoBIfV6CBZSrs86SSs7VWiVonBNrrRO9iD9I8OfXSkxlF78JDW3MPyv+2ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/M1xwi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/M1xwi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAE6C4CECD;
	Wed,  6 Nov 2024 12:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897144;
	bh=pyPAEs02w/G8cFyGPwzWFaMY+pAx61Xh5UCvWUNof6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/M1xwi8zyap8QeY4gS5vInigJWxQXVpMaW6haDyL/gOn2tRqBLWl9BstVAnkfPJN
	 WYlEoHTYxTMB9EbRqniwPfkmGkRZGQf/CgxCZ+DyIIiguu/hFLM2qyYTe3AoHR42y2
	 IAMetGq+3XReAcR9iCVrK/gcGhqSszfHmA3nxxnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/126] riscv: vdso: Prevent the compiler from inserting calls to memset()
Date: Wed,  6 Nov 2024 13:04:43 +0100
Message-ID: <20241106120308.296417236@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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
index 06e6b27f3bcc9..c1b68f962bada 100644
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



