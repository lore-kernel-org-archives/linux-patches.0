Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7432D9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1B7C433C7;
	Sun, 13 Aug 2023 21:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962443;
	bh=xAXx/zt6cnBCjCtuRM7IT7sXecnhScjP6kdh0cGl7Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyqHtd+G3bi0uIp6tJck7P1m6y09kG3plWO+YZZpLIhIzhBFiWlNIxdJhcElK5GTY
	 FgmKTDqDlnqPptJNmMgt38qlQO4Xaic2GdBZ58ZluC7iIz83g3cBfyZP8icxs9Qvst
	 azwxkPzmkka47wWVI6AlTRV3KlAlPCN+FEho7Kns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Duwe <duwe@suse.de>,
	Petr Tesarik <petr.tesarik.ext@huawei.com>,
	Li Zhengyu <lizhengyu3@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 023/149] riscv/kexec: handle R_RISCV_CALL_PLT relocation type
Date: Sun, 13 Aug 2023 23:17:48 +0200
Message-ID: <20230813211719.493069405@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Torsten Duwe <duwe@suse.de>

commit d0b4f95a51038becce4bdab4789aa7ce59d4ea6e upstream.

R_RISCV_CALL has been deprecated and replaced by R_RISCV_CALL_PLT. See Enum
18-19 in Table 3. Relocation types here:

https://github.com/riscv-non-isa/riscv-elf-psabi-doc/blob/master/riscv-elf.adoc

It was deprecated in ("Deprecated R_RISCV_CALL, prefer R_RISCV_CALL_PLT"):

https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/a0dced85018d7a0ec17023c9389cbd70b1dbc1b0

Recent tools (at least GNU binutils-2.40) already use R_RISCV_CALL_PLT.
Kernels built with such binutils fail kexec_load_file(2) with:

 kexec_image: Unknown rela relocation: 19
 kexec_image: Error loading purgatory ret=-8

The binary code at the call site remains the same, so tell
arch_kexec_apply_relocations_add() to handle _PLT alike.

Fixes: 838b3e28488f ("RISC-V: Load purgatory in kexec_file")
Signed-off-by: Torsten Duwe <duwe@suse.de>
Signed-off-by: Petr Tesarik <petr.tesarik.ext@huawei.com>
Cc: Li Zhengyu <lizhengyu3@huawei.com>
Cc: stable@vger.kernel.org
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/all/b046b164af8efd33bbdb7d4003273bdf9196a5b0.1690365011.git.petr.tesarik.ext@huawei.com/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/elf_kexec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index 5372b708fae2..38390d3bdcac 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -425,6 +425,7 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 		 * sym, instead of searching the whole relsec.
 		 */
 		case R_RISCV_PCREL_HI20:
+		case R_RISCV_CALL_PLT:
 		case R_RISCV_CALL:
 			*(u64 *)loc = CLEAN_IMM(UITYPE, *(u64 *)loc) |
 				 ENCODE_UJTYPE_IMM(val - addr);
-- 
2.41.0



