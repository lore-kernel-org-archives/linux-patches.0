Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756AD2472B4;
	Tue, 29 Apr 2025 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946942; cv=none; b=iLc58ABI1dmh9CSdmw4bxFRkKe62wUHGmDbbpmLjx2Exp/fL/wOfEc/5E0IF5KPpZSRzl5WWlsiFFYKza+UZd2WboIrP46Vs2XDU18/+Krt/WwMGm5Ro9AYZIkqDp3ayX/zoZJ4wvkMh5W3nd92vCFFOUhn7b30ZFWX4oQS+l0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946942; c=relaxed/simple;
	bh=DrplOJlCq5THQGtn/R7xrX1Ydzm4VnWPYJ/5Z+ejzQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNEblTiavPPl9Pg6dKUXpVSFbEYiVAtOkX86cA5zxdhRWqUuQeGOpOGfjvTagJvMRwpY98IbiVn2MZJwJYiMlB1jTPFPdHcnUNTOLv//UmEIjwwo16KLZgbTTXgecv8wP8AIdS0IUMVfwhi7XJ+n0mq6+xSumo0QGnlmtbnbmKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVvsVxyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVvsVxyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F7BC4CEE3;
	Tue, 29 Apr 2025 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946942;
	bh=DrplOJlCq5THQGtn/R7xrX1Ydzm4VnWPYJ/5Z+ejzQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVvsVxyJBYwgWoQhLuVLu4ziOEgTkogIE+7qA2CJxi6IUfdHwZCnbVJL/77G3xpjv
	 ATz95y46xo4VAVRX6zvsQJrBBYkx02ZMU+dALs4Se2dL3+PKEDZmoF7pHEp7SrEf9m
	 anQQBWmh1EWkyQ+TEQKqyBtXnZmYi1uZbW/A1xJA=
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
Subject: [PATCH 5.10 119/286] riscv: KGDB: Remove ".option norvc/.option rvc" for kgdb_compiled_break
Date: Tue, 29 Apr 2025 18:40:23 +0200
Message-ID: <20250429161112.752106143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b0db3350d243b..1d83b36967212 100644
--- a/arch/riscv/kernel/kgdb.c
+++ b/arch/riscv/kernel/kgdb.c
@@ -276,9 +276,7 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
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



