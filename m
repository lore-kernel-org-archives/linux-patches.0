Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398D4126C02;
	Sun,  7 Sep 2025 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277947; cv=none; b=McaJXVLngoBeLGa8eLtsAL1VJezUa1SCEOOfgblIcYgcDKwjgheExlB6dtuMMhnKQK/eY7T+xBxR2iUMI12IlJ8JP/r0pUOgnUhaUa1E5iju9nJIfvTrp2eC2xXRme7KoFwzlfId2iSuvHEqJOewdjJcmRu0pk6jyTV1ya2B2Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277947; c=relaxed/simple;
	bh=1fP/qaY9EPpDz/9GJ2y5DeZHWghlh0YAtZZCkRzOUwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJcSBATaWcJHMvmLD3+PKEBAaGFQAkKpVxtUH3v/q5vEzyUHMB0CzOfesK6+r1u5dnOZL9k7CxBoijEI1AWWZGQfgagYJI53NH0x7O6cyZwiVhaIBAPs6S/vXb5ryCd9SLSaaR7HNsunWJN1EVZmFgY8M7sois1Y1CWmnYkMPI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzoFqOpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzoFqOpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEE4C4CEF0;
	Sun,  7 Sep 2025 20:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277947;
	bh=1fP/qaY9EPpDz/9GJ2y5DeZHWghlh0YAtZZCkRzOUwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzoFqOpkSv3TPOSz4R+VSURLzdxY8qw7AmD15WelnCCpngU5bnYBefcv994waWCFQ
	 bH57RhD9j/bZ2s6ryXCHE9wsHI/LGjY1/3aFesxZWlDGjNwUblc9dNG61nLnGRLVeB
	 2k2c0kmo+x67pEMiqnBI/tsYt8OwwCoNIlhaZ1HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 174/183] riscv: Only allow LTO with CMODEL_MEDANY
Date: Sun,  7 Sep 2025 22:00:01 +0200
Message-ID: <20250907195619.957663564@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 41f9049cff324b7033e6ed1ded7dfff803cf550a upstream.

When building with CONFIG_CMODEL_MEDLOW and CONFIG_LTO_CLANG, there is a
series of errors due to some files being unconditionally compiled with
'-mcmodel=medany', mismatching with the rest of the kernel built with
'-mcmodel=medlow':

  ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 899908), and 'i32 1' from vmlinux.a(net-traces.o at 1014628)

Only allow LTO to be performed when CONFIG_CMODEL_MEDANY is enabled to
ensure there will be no code model mismatch errors. An alternative
solution would be disabling LTO for the files with a different code
model than the main kernel like some specialized areas of the kernel do
but doing that for individual files is not as sustainable than
forbidding the combination altogether.

Cc: stable@vger.kernel.org
Fixes: 021d23428bdb ("RISC-V: build: Allow LTO to be selected")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506290255.KBVM83vZ-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250710-riscv-restrict-lto-to-medany-v1-1-b1dac9871ecf@kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -69,7 +69,7 @@ config RISCV
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS if MMU
 	# LLD >= 14: https://github.com/llvm/llvm-project/issues/50505
-	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000
+	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000 && CMODEL_MEDANY
 	select ARCH_SUPPORTS_LTO_CLANG_THIN if LLD_VERSION >= 140000
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU


