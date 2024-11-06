Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B8A1CCB5F;
	Wed,  6 Nov 2024 13:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899259; cv=none; b=A8YIuL6fXy7vMivEGTp0wukFAXtx2dwwSCWoBWRT/Brlw5frK/c7gFZAp+dj4/IU9bQk3yXh7fQJp43nKke1MDSBqa4ddh5Tf7VIbCwudkK0nqoa+CMrKGem7nSvMKmEcTHRzyKVJ6XhhqaNqRlZ6ek3h9ZV2iuPVcatKng2Vfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899259; c=relaxed/simple;
	bh=CYwwqXuumP5h92NkvUCLkTiSUGixhDHBWBPYMpT8Cgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu0zm2dIg3T9xGucVBVNCxYytMaiJW5m9Ru7M4RB9TjVg2Y0ffKZAocgsuOfr6m2xiAVFzEVWtgqWr/uezqNjZVb5N6fqaZr3MenJtEhhEQYMX0CJsoyzx38uck4RNZOnlgWn+Wypm87h8ibf2kxKhm8Be3f5WIhcplwwp6G4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJTw4aZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJTw4aZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594BCC4CECD;
	Wed,  6 Nov 2024 13:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899259;
	bh=CYwwqXuumP5h92NkvUCLkTiSUGixhDHBWBPYMpT8Cgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJTw4aZIF7FaB5Be6S4c7tOwp0hRkeENV5mJMGc+kGCA4+6OjGb0LqGM7Ph7uzCIh
	 7yVc8QQGwr7ply2ailgiWzLQkhIPzz0f522oicxtunxIcCRH/Zj5gMOg53XyoZDF9t
	 5XgWHrF6Bobf/58dRQ/qsQs00Rx1h8+IlLhuyXBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/73] riscv: vdso: Prevent the compiler from inserting calls to memset()
Date: Wed,  6 Nov 2024 13:05:55 +0100
Message-ID: <20241106120301.486266314@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



