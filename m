Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1527F280A52;
	Wed, 23 Apr 2025 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420464; cv=none; b=KQzrxv3aSxyRWLG82xRPwLN+F7Fqi30bBFmrKVnKJW1vJAZcpaHHeSgPq4js2ugokEMv9DhUif1ZbQLrYgrkMofomZpitr4I8QpuOD3Bffo6tiT4Ot5Y3ji2/5+4CZrpVuF6CVwhcdN+9jfIVhgshRZAoGXVHfU6h9MAy5WGfPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420464; c=relaxed/simple;
	bh=oDGwC/AdcWxK3ichHF3hr/l0sIZ834/4Wc+CFdFRFLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIPzrz9pXArngDUpvySj+JHcv+Z/8sfLGUuTbyW/JGuq1M3SWicrovR30Aq3pKv1nsO4mMk2HGZycXG45LicredIAU0nxOU22dqqh6KKcvDwC5Yt22SeDFsUtzD2Ir7KxD38D48+uCOryOuWOQH6d18DlzrOojxedWI5b+N0taM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/ojZg/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/ojZg/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D126C4CEE2;
	Wed, 23 Apr 2025 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420464;
	bh=oDGwC/AdcWxK3ichHF3hr/l0sIZ834/4Wc+CFdFRFLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/ojZg/rryHdrpLLgKnxtoNNrkaCQXzX6DBM0mIGnG0MhQEjJlOFIMwxbY5fKXUlv
	 hypqSvEEH4KMT+krx44WQm8Oq6WXGwo+kVCFsox1s+nkijEbRR7+xuMnY76s/tR6Dy
	 pFRmgznub7yK8kSjK69dlLJfLpT19n6Lv1+iTzjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	WangYuli <wangyuli@uniontech.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 094/241] riscv: KGDB: Remove ".option norvc/.option rvc" for kgdb_compiled_break
Date: Wed, 23 Apr 2025 16:42:38 +0200
Message-ID: <20250423142624.420219545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 550c2aa787d1b06efcb11de1877354502a1237f2 ]

[ Quoting Samuel Holland: ]

  This is a separate issue, but using ".option rvc" here is a bug.
  It will unconditionally enable the C extension for the rest of
  the file, even if the kernel is being built with CONFIG_RISCV_ISA_C=n.

[ Quoting Palmer Dabbelt: ]

  We're just looking at the address of kgdb_compiled_break, so it's
  fine if it ends up as a c.ebreak.

[ Quoting Alexandre Ghiti: ]

  .option norvc is used to prevent the assembler from using compressed
  instructions, but it's generally used when we need to ensure the
  size of the instructions that are used, which is not the case here
  as noted by Palmer since we only care about the address. So yes
  it will work fine with C enabled :)

So let's just remove them all.

Link: https://lore.kernel.org/all/4b4187c1-77e5-44b7-885f-d6826723dd9a@sifive.com/
Link: https://lore.kernel.org/all/mhng-69513841-5068-441d-be8f-2aeebdc56a08@palmer-ri-x1c9a/
Link: https://lore.kernel.org/all/23693e7f-4fff-40f3-a437-e06d827278a5@ghiti.fr/
Fixes: fe89bd2be866 ("riscv: Add KGDB support")
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/r/8B431C6A4626225C+20250411073222.56820-2-wangyuli@uniontech.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/kgdb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/kgdb.c b/arch/riscv/kernel/kgdb.c
index 5d1ce8dacaf58..9f3db3503dabd 100644
--- a/arch/riscv/kernel/kgdb.c
+++ b/arch/riscv/kernel/kgdb.c
@@ -257,9 +257,7 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
 noinline void arch_kgdb_breakpoint(void)
 {
 	asm(".global kgdb_compiled_break\n"
-	    ".option norvc\n"
-	    "kgdb_compiled_break: ebreak\n"
-	    ".option rvc\n");
+	    "kgdb_compiled_break: ebreak\n");
 }
 
 void kgdb_arch_handle_qxfer_pkt(char *remcom_in_buffer,
-- 
2.39.5



