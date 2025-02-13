Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2871F2222BB;
	Thu, 13 Feb 2025 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457984; cv=none; b=PxB23m8i7fXun2aYJIqHAhsj8+ZTJ3Nc6rhEQ4amb+oF3ClIIUv3dtD7u8pj9+5uzPh7BfL805wOoce01Xv75H9eu5t/vDP58v7CnlAVnyZnBnXgWwIy7+A5i6/3yB1nJdyCvLNg3qJxLgCqMszg9dqBvbaecuo8aOJYqFdKxNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457984; c=relaxed/simple;
	bh=d2DCSukSBSTlyCpgYcOSBNZ5kPK91d4tl4gMjVC4oqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OT8rKH9mCUk5sOee1PE8Q9ocVzSYtnMDV4XFBcJvw+jdMHMacm1k1cUDdS8QWez49vifGz2XeLo2+XaLiutd8hiA4NEBvPHG6JO3V6GOjmXNVKafW0taXVTioy0ddPrVwXovmi1tgyeHTPeOzxk6u3B2kzELTocScPy7PiF9JB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNtTJpTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNtTJpTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C333C4CED1;
	Thu, 13 Feb 2025 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457984;
	bh=d2DCSukSBSTlyCpgYcOSBNZ5kPK91d4tl4gMjVC4oqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNtTJpTbcK1sU6EJB8u4pqwuox30ntV443WBMekjHTG6N9ikF04GfEEdvb2ne4V+4
	 hDz9FNeso8l/45x3woW3a4t9yAzwQHshNE1sXY2l6ddVKB4EZVQZsW59WPF3uBk6xW
	 RAR/51S+Fcu010VqTKXE1ZwTt3vSOJcSFFvoXYgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Dengcheng Zhu <dzhu@wavecomp.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Ming Wang <wangming01@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 6.12 235/422] mips/math-emu: fix emulation of the prefx instruction
Date: Thu, 13 Feb 2025 15:26:24 +0100
Message-ID: <20250213142445.602987446@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

commit 42a39e4aa59a10aa4afdc14194f3ee63d2db94e1 upstream.

Currently, installation of Debian 12.8 for mipsel fails on machines
without an FPU [1]. This is caused by the fact that zstd (which is used
for initramfs compression) executes the prefx instruction, which is not
emulated properly by the kernel.

The prefx (Prefetch Indexed) instruction fetches data from memory into
the cache without any side effects. Though functionally unrelated, it
requires an FPU [2].

Bytecode format of this instruction ends on "001111" binary:

	(prefx instruction format) & 0x0000003f = 0x0000000f

The code in fpux_emu() runs like so:

	#define MIPSInst(x) x
	#define MIPSInst_FMA_FFMT(x) (MIPSInst(x) & 0x00000007)
	#define MIPSInst_FUNC(x) (MIPSInst(x) & 0x0000003f)
	enum cop1x_func { ..., pfetch_op = 0x0f, ... };

	...

	switch (MIPSInst_FMA_FFMT(ir)) {
	...

	case 0x3:
		if (MIPSInst_FUNC(ir) != pfetch_op)
			return SIGILL;

		/* ignore prefx operation */
		break;

	default:
		return SIGILL;
	}

That snippet above contains a logic error and the
	if (MIPSInst_FUNC(ir) != pfetch_op)
comparison always fires.

When MIPSInst_FUNC(ir) is equal to pfetch_op, ir must end on 001111
binary. In this case, MIPSInst_FMA_FFMT(ir) must be equal to 0x7, which
does not match that case label.

This causes emulation failure for the prefx instruction. Fix it.

This has been broken by
commit 919af8b96c89 ("MIPS: Make definitions of MIPSInst_FMA_{FUNC,FMTM} consistent with MIPS64 manual")
which modified the MIPSInst_FMA_FFMT macro without updating the users.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: stable@vger.kernel.org # after 3 weeks
Cc: Dengcheng Zhu <dzhu@wavecomp.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ming Wang <wangming01@loongson.cn>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Fixes: 919af8b96c89 ("MIPS: Make definitions of MIPSInst_FMA_{FUNC,FMTM} consistent with MIPS64 manual")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1091858
[2] MIPS Architecture For Programmers Volume II-A: The MIPS32 Instruction Set

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 arch/mips/math-emu/cp1emu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -1660,7 +1660,7 @@ static int fpux_emu(struct pt_regs *xcp,
 		break;
 	}
 
-	case 0x3:
+	case 0x7:
 		if (MIPSInst_FUNC(ir) != pfetch_op)
 			return SIGILL;
 


