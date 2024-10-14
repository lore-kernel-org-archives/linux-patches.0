Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005754595B;
	Mon, 14 Oct 2024 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916856; cv=none; b=WkiDWS8aYk7knSNEP4zKiP9pwUar0ebkwQNw57VvTZ3VAw6pndVlh0DISqFI+r39bhymWSCLHJTOqA64lVe71/1o9pJxdSmqSqxAnoKIwcWZRag2n499eFoQwsu8zIyn/2Ani6TxXCiszNgRELSQ+Be+DGC38iZLpwlP3n2UPhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916856; c=relaxed/simple;
	bh=/QcHuTzLan98W2X3rgDvs97/VanWOoBkK05/+MoEJ0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2V+qz5RDqirb22WKNUSSZxv24C13gy2/Gbh7SVQUDM8YQsNuvv8MdMJ+hvtO/9FIYPeo8RP6E5K0G0a98tjS7V9RdS6oyVdz/oOaehW7R9p0SfmpC6zanXOxNPzSVG0Jpx2ALRMmP6js2j45uOBev9Rkg37Ayugzd0jqf5w0GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPggeaop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPggeaop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15070C4CECF;
	Mon, 14 Oct 2024 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916855;
	bh=/QcHuTzLan98W2X3rgDvs97/VanWOoBkK05/+MoEJ0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPggeaopcAdmaZ0WSnc6BVTdTXWyYrHhngHg1C1tQN5+c4bhosPs1RodaxU791IiJ
	 htnNcvN7Dfc5ZEMy9sMyTOyx3IA5hIO3e9Gq/9uMe0izAwz5dDlcAVDvpnTqjjqmpq
	 b6a26eOeE4Ky8c+Ibza+vIiietZaVZSUwudmzkfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr@tesarici.cz>,
	Ying Sun <sunying@isrc.iscas.ac.cn>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/213] riscv/kexec_file: Fix relocation type R_RISCV_ADD16 and R_RISCV_SUB16 unknown
Date: Mon, 14 Oct 2024 16:19:50 +0200
Message-ID: <20241014141046.255684944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Ying Sun <sunying@isrc.iscas.ac.cn>

[ Upstream commit c6ebf2c528470a09be77d0d9df2c6617ea037ac5 ]

Runs on the kernel with CONFIG_RISCV_ALTERNATIVE enabled:
  kexec -sl vmlinux

Error:
  kexec_image: Unknown rela relocation: 34
  kexec_image: Error loading purgatory ret=-8
and
  kexec_image: Unknown rela relocation: 38
  kexec_image: Error loading purgatory ret=-8

The purgatory code uses the 16-bit addition and subtraction relocation
type, but not handled, resulting in kexec_file_load failure.
So add handle to arch_kexec_apply_relocations_add().

Tested on RISC-V64 Qemu-virt, issue fixed.

Co-developed-by: Petr Tesarik <petr@tesarici.cz>
Signed-off-by: Petr Tesarik <petr@tesarici.cz>
Signed-off-by: Ying Sun <sunying@isrc.iscas.ac.cn>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20240711083236.2859632-1-sunying@isrc.iscas.ac.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/elf_kexec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index e60fbd8660c4a..8c32bf1eedda0 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -444,6 +444,12 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 			*(u32 *)loc = CLEAN_IMM(CJTYPE, *(u32 *)loc) |
 				 ENCODE_CJTYPE_IMM(val - addr);
 			break;
+		case R_RISCV_ADD16:
+			*(u16 *)loc += val;
+			break;
+		case R_RISCV_SUB16:
+			*(u16 *)loc -= val;
+			break;
 		case R_RISCV_ADD32:
 			*(u32 *)loc += val;
 			break;
-- 
2.43.0



