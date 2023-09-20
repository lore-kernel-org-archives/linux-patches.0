Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848C818658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05372C433C7;
	Wed, 20 Sep 2023 11:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210649;
	bh=l0fGG4uA0rl8DjlQOtn1CObGCVsm/eFkPeJlJuNRliQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CB3eTjDXnybRhnMezTmO8/X9juWmazzUFej0q5EzDoyNsqHToRZ6om4qOyWc+x7/d
	 Z5oigWcNo7h3P2DngxBhYR58bLmAZRxnxd8iZw1uIsOk/RXMQvCXY82ZsOMr8IhXXp
	 0S6w8O9dVefbOAb0hqVOnfW7Nq9DVcN5qEGGU3QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <songshuaishuai@tinylab.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 153/211] riscv: kexec: Align the kexeced kernel entry
Date: Wed, 20 Sep 2023 13:29:57 +0200
Message-ID: <20230920112850.616376483@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Shuai <songshuaishuai@tinylab.org>

[ Upstream commit 1bfb2b618d52e59a4ef1896b46c4698ad2be66b7 ]

The current riscv boot protocol requires 2MB alignment for RV64
and 4MB alignment for RV32.

In KEXEC_FILE path, the elf_find_pbase() function should align
the kexeced kernel entry according to the requirement, otherwise
the kexeced kernel would silently BUG at the setup_vm().

Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
Signed-off-by: Song Shuai <songshuaishuai@tinylab.org>
Link: https://lore.kernel.org/r/20230906095817.364390-1-songshuaishuai@tinylab.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/elf_kexec.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index c08bb5c3b3857..b3b96ff46d193 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -98,7 +98,13 @@ static int elf_find_pbase(struct kimage *image, unsigned long kernel_len,
 	kbuf.image = image;
 	kbuf.buf_min = lowest_paddr;
 	kbuf.buf_max = ULONG_MAX;
-	kbuf.buf_align = PAGE_SIZE;
+
+	/*
+	 * Current riscv boot protocol requires 2MB alignment for
+	 * RV64 and 4MB alignment for RV32
+	 *
+	 */
+	kbuf.buf_align = PMD_SIZE;
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	kbuf.memsz = ALIGN(kernel_len, PAGE_SIZE);
 	kbuf.top_down = false;
-- 
2.40.1



