Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1528826B941;
	Tue,  8 Apr 2025 12:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115172; cv=none; b=kA/Nlcj7vewioJRctE6A5T2f7DVqWz4KnhqCCMOqDEK4o/mAzc1twjNjnZ0nLytl54P5ymPw+Iwb8d0Zt6um0WYPFJt40PRCJOb0TyT/bbxnHmdjJ/Pdd7ZvyHr48i2z6cBBb2elYpFraayRkBFLYdV0l5wRhzC+WMEH9lrt8Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115172; c=relaxed/simple;
	bh=rQZW21/IqW1QwdcXODAvpQl8slpHWCz+3omTEztDn0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRB4ko2rIrk9tZiTy2WKZQ5DScTSPIas/RcRLBip7Onuj4blQictC8b1sM4QS4HNiSZdZOyoTALFzXE/ADG7sdEnSLg+ir2SkThwFLZF8OoiOIseK84ARuSuT2hwNJkSxjcbi65GNx9F4D6Wbh/RNd8KrjWVDmcvV47yzqJDn48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1d720Fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1d720Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982A0C4CEEA;
	Tue,  8 Apr 2025 12:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115172;
	bh=rQZW21/IqW1QwdcXODAvpQl8slpHWCz+3omTEztDn0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1d720FkJBDoxa+NmEdmalx5OBqm+L2rr5uRVtozyIg5+TV2yJXUAiSWCroGysH28
	 KhKOKRVDMblvp19YiHJlneZzcIMJ9S+zhJyjsGf8FQ9edR0vgZDWKs2UEtOyD3Amho
	 OxlUucz99py0wHzgGTJH6jrQw3OEdifYtuAUgZKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 375/499] riscv/kexec_file: Handle R_RISCV_64 in purgatory relocator
Date: Tue,  8 Apr 2025 12:49:47 +0200
Message-ID: <20250408104900.582518079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 28093cfef5dd62f4cbd537f2bdf6f0bf85309c45 ]

Commit 58ff537109ac ("riscv: Omit optimized string routines when
using KASAN") introduced calls to EXPORT_SYMBOL() in assembly string
routines, which result in R_RISCV_64 relocations against
.export_symbol section. As these rountines are reused by RISC-V
purgatory and our relocator doesn't recognize these relocations, this
fails kexec-file-load with dmesg like

	[   11.344251] kexec_image: Unknown rela relocation: 2
	[   11.345972] kexec_image: Error loading purgatory ret=-8

Let's support R_RISCV_64 relocation to fix kexec on 64-bit RISC-V.
32-bit variant isn't covered since KEXEC_FILE and KEXEC_PURGATORY isn't
available.

Fixes: 58ff537109ac ("riscv: Omit optimized string routines when using KASAN")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Tested-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20250326051445.55131-2-ziyao@disroot.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/elf_kexec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index 3c37661801f95..e783a72d051f4 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -468,6 +468,9 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 		case R_RISCV_ALIGN:
 		case R_RISCV_RELAX:
 			break;
+		case R_RISCV_64:
+			*(u64 *)loc = val;
+			break;
 		default:
 			pr_err("Unknown rela relocation: %d\n", r_type);
 			return -ENOEXEC;
-- 
2.39.5



