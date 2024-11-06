Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6317DA7F;
	Wed,  6 Nov 2024 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896292; cv=none; b=FIhRAZmBbSNQWYgNyT8nYQPGlUF1GZPbBn596BVqju6L49vQg/O9qO/5/0jXOyNUzMhxBDcIrN+8/HlxcXcuXaDnZeOouw2k9NewcNfKoVuEvP2UAkwcNVqyOPSWlA8UuwOKYDpN29aA5ZlN5QO25NxU112hre+W7+DzNSmTI+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896292; c=relaxed/simple;
	bh=oaUqqjrtaK16H9Sl3YjB/5SUpszKz+mkIagysHqG0rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWaY0ADesJzcKCoZbF8PA8PVWsyX7SYRK+iARDO4ZM8YH+/Po0IdiOGBXjpH8yW9c6xqJ/0UgPKbrpA0fZJQr8ZNxwa59ToAV9VhQKzSpeRPwciNBmx5xKHf2GIKoCw3+TsxudhZX51Rv6mIGQs3sbVBetKw/MUOepMOpzPsrKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjYnFXv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjYnFXv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A709CC4CECD;
	Wed,  6 Nov 2024 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896292;
	bh=oaUqqjrtaK16H9Sl3YjB/5SUpszKz+mkIagysHqG0rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjYnFXv7n3NjNRFBmRavcMjvEm36M1jv5BaqoFTF1Dh0E4n5ooH/2cAgczygHXOpE
	 eIEecCsQUhkze1JJCobk1BPcBXbjVyrs2kUDc/6PZTK692ow8Nda+8nfdBQxqM/8h5
	 M0u5iZyUjr/Ywfq7NXFrNLWwrYfpYrFeH5fZxYbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 153/245] riscv: vdso: Prevent the compiler from inserting calls to memset()
Date: Wed,  6 Nov 2024 13:03:26 +0100
Message-ID: <20241106120322.997474845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f7ef8ad9b550d..54a7fec25d5f8 100644
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



