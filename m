Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A623A9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CA8C433C8;
	Sun, 13 Aug 2023 21:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962418;
	bh=MllDxO+r2owiIE4X8K95KkvgQFR8co0iOhGwkFgHu8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlMDkyjd23PFHlxYcIuFf1quizLsqKF6M78n9zLiAkIdk0WhfoFXmKLopUtydzbx5
	 tJOQcZqQWtcNfHrXSi9IfJFOuE04xgBdHG+4xamef5+Z+ayZyLBLDBNxtM6PTIubbQ
	 0nHZMN2evAzETEFdqI+Z7ID8NgGVjKxcmUZr9EmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Duwe <duwe@suse.de>,
	Petr Tesarik <petr.tesarik.ext@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 021/149] riscv/kexec: load initrd high in available memory
Date: Sun, 13 Aug 2023 23:17:46 +0200
Message-ID: <20230813211719.433118263@linuxfoundation.org>
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

commit 49af7a2cd5f678217b8b4f86a29411aebebf3e78 upstream.

When initrd is loaded low, the secondary kernel fails like this:

 INITRD: 0xdc581000+0x00eef000 overlaps in-use memory region

This initrd load address corresponds to the _end symbol, but the
reservation is aligned on PMD_SIZE, as explained by a comment in
setup_bootmem().

It is technically possible to align the initrd load address accordingly,
leaving a hole between the end of kernel and the initrd, but it is much
simpler to allocate the initrd top-down.

Fixes: 838b3e28488f ("RISC-V: Load purgatory in kexec_file")
Signed-off-by: Torsten Duwe <duwe@suse.de>
Signed-off-by: Petr Tesarik <petr.tesarik.ext@huawei.com>
Cc: stable@vger.kernel.org
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/all/67c8eb9eea25717c2c8208d9bfbfaa39e6e2a1c6.1690365011.git.petr.tesarik.ext@huawei.com/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/elf_kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index 38390d3bdcac..c08bb5c3b385 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -281,7 +281,7 @@ static void *elf_kexec_load(struct kimage *image, char *kernel_buf,
 		kbuf.buffer = initrd;
 		kbuf.bufsz = kbuf.memsz = initrd_len;
 		kbuf.buf_align = PAGE_SIZE;
-		kbuf.top_down = false;
+		kbuf.top_down = true;
 		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 		ret = kexec_add_buffer(&kbuf);
 		if (ret)
-- 
2.41.0



