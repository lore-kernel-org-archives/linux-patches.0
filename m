Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85BD1E22EF;
	Wed,  6 Nov 2024 12:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896868; cv=none; b=qpryev/D8rJdNOyxS2qglyx39jcWipqFMhXUopIJu/jw2jx5BBVgTmllQfb8na3hysjb4+xO+Ct9ulROqmIgLymDbA2GGTp+GbTPc6KDn8ZDvlmc6h8z2MKcRu/pzIqf9eaCAiECTmIH/1rJQtDr2cob3h//DsoslkPZacZ8Ptc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896868; c=relaxed/simple;
	bh=75PoIYLhJts//wQ/GnQRQuPe4x19ar8GAN2Yp69dfeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U34/Tz1D6oiQwayXN9v5TYShjBY46rb3wDUBPfIYBOy0B0uA38cM88TouJZYarQKUa0/SJkO9Zv1DnsB0D5k5RZjKXPrMTMaIDyQ0QbA/jEN8PjjBaxtqlTEkpv8p3WQr2bYSfewDK7vl7PI2/LxjOpBBcLLTTiG2RC0t4wCv30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hozxvmn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hozxvmn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0DCC4CECD;
	Wed,  6 Nov 2024 12:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896868;
	bh=75PoIYLhJts//wQ/GnQRQuPe4x19ar8GAN2Yp69dfeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hozxvmn+Snytcj4lZG6nMZMP6U9gb7qNNkYsdwNM2qW4ePDGKOV1nDp08DBH+aMoQ
	 MFzItwMLpWgktmHNGgjyHlzlW8RUC5hBDHueEX+OVJica+2I85QZ3V+JCrMSZg2CBc
	 OKuTEK6w6dL6JDwiX1KPvvqRzDC3chvk+he1AAc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/110] riscv: vdso: Prevent the compiler from inserting calls to memset()
Date: Wed,  6 Nov 2024 13:05:04 +0100
Message-ID: <20241106120305.884243730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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
index f4ac7ff56bcea..53fe5e2ab32ed 100644
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



