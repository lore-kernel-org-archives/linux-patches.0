Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157938005E;
	Mon,  8 Apr 2024 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583172; cv=none; b=sdE5exb9p0XigW11xbItaMnVS3TtGo32KLPQyVq7APWBRhq6PWUDSG/c3Rr6aaOHPjaGlU4wni6O3/28bk+ISzyc3hxQtkcSEnGYT0yJN+ckmDOAOvOZUuq63mgx/HVDhQP0hAtKwp/GIVvbP3BIm6tFT/fia52m/GueoxmCMuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583172; c=relaxed/simple;
	bh=HNdAQYJ4jfEIveXkPPkEJFDhy+6hgGlDHuAVzpIdsj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDMW6UsPqZqROViMEB/+NN2tvqR5XtdjnzuOY5IlMojE/GH+d35KP4VVaum7jW0Q+ieA1ScuIi9zgQf+s3EBCAPMCdOsPLO6/QU/s/J3QEPjJtFoGKURIg7au2DqLVZ543qpPMc2y6mvRePxJt6IBS4oFnrRnu/YrRpDlqhxfx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKtF0CbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKtF0CbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5199BC433F1;
	Mon,  8 Apr 2024 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583171;
	bh=HNdAQYJ4jfEIveXkPPkEJFDhy+6hgGlDHuAVzpIdsj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKtF0CbKVN4aIdqhWyyFOpXqoAnrX+jfcSYgXEjLIhakTNe8oGSx9umdcUwt2hydT
	 u2qobT18T3xrIKFQ+Gt3lmzK/Imy6tLO01XtMfajtAya2I50sdKCaE5dOdSTFdVMah
	 d6oDD9bPMwKrVTBj5l7H+T7Aor1324+shXNgIK8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Artemev <roman.artemev@syntacore.com>,
	Vladimir Isaev <vladimir.isaev@syntacore.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 148/273] riscv: hwprobe: do not produce frtace relocation
Date: Mon,  8 Apr 2024 14:57:03 +0200
Message-ID: <20240408125313.881923022@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Isaev <vladimir.isaev@syntacore.com>

[ Upstream commit ad14f7ca9f0d9fdf73d1fd61aaf8248d46ffc849 ]

Such relocation causes crash of android linker similar to one
described in commit e05d57dcb8c7
("riscv: Fixup __vdso_gettimeofday broke dynamic ftrace").

Looks like this relocation is added by CONFIG_DYNAMIC_FTRACE which is
disabled in the default android kernel.

Before:

readelf -rW arch/riscv/kernel/vdso/vdso.so:

Relocation section '.rela.dyn' at offset 0xd00 contains 1 entry:
    Offset             Info             Type
0000000000000d20  0000000000000003 R_RISCV_RELATIVE

objdump:
0000000000000c86 <__vdso_riscv_hwprobe@@LINUX_4.15>:
 c86:   0001                    nop
 c88:   0001                    nop
 c8a:   0001                    nop
 c8c:   0001                    nop
 c8e:   e211                    bnez    a2,c92 <__vdso_riscv_hwprobe...

After:
readelf -rW arch/riscv/kernel/vdso/vdso.so:

There are no relocations in this file.

objdump:
0000000000000c86 <__vdso_riscv_hwprobe@@LINUX_4.15>:
 c86:   e211                    bnez    a2,c8a <__vdso_riscv_hwprobe...
 c88:   c6b9                    beqz    a3,cd6 <__vdso_riscv_hwprobe...
 c8a:   e739                    bnez    a4,cd8 <__vdso_riscv_hwprobe...
 c8c:   ffffd797                auipc   a5,0xffffd

Also disable SCS since it also should not be available in vdso.

Fixes: aa5af0aa90ba ("RISC-V: Add hwprobe vDSO function and data")
Signed-off-by: Roman Artemev <roman.artemev@syntacore.com>
Signed-off-by: Vladimir Isaev <vladimir.isaev@syntacore.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20240313085843.17661-1-vladimir.isaev@syntacore.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 9b517fe1b8a8e..272c431ac5b9f 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -37,6 +37,7 @@ endif
 
 # Disable -pg to prevent insert call site
 CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
+CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
 
 # Disable profiling and instrumentation for VDSO code
 GCOV_PROFILE := n
-- 
2.43.0



