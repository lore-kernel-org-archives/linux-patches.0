Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ED326B0BD;
	Thu, 13 Feb 2025 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460576; cv=none; b=hhHkUrbHRYiArh4Pq48HLhYy5xojp11bdW2mpNw/mSJchVHODLGOuxpCENIREkBpMAl6Z6WWO0mHHtijZ7UpgsiIhuUCqMoIA1DPr7kyBBIEuumQxb+HLcFJELan5eUka6jqkC8p3/vyLcPAkJURtC7vKs8m7cTNv1eW0JedOa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460576; c=relaxed/simple;
	bh=0kaBPuhSnOL1RPG6UK5siq+6ZW/MjI7RwOoQoNTlMnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m7bh4U85oAbQUF6TEQXrK52Z2G7mTThHsQIg2J7kvPsc1zHEqmkFl4Jb1mYtJBPuRDt8wKAYu31cvh/Jm/HrTI+asjmCsJQaswjhRDMN0DWzAlVpIbQ1bMCw2Bp+dhrxCKIqS+usQcl7wy4Z3MaEYNJcAohlq7X1WP1zuWc2RiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2COgXbY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2COgXbY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A0FC4CED1;
	Thu, 13 Feb 2025 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460576;
	bh=0kaBPuhSnOL1RPG6UK5siq+6ZW/MjI7RwOoQoNTlMnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2COgXbY7OmGCS0E0a21nje2OvlVgKxHwG7EtwxiqYpkLesu+y0FsXB/LF/4b7lMGk
	 Q73h34IqDZer5tVur7A9ybynV2nslXKKZySwrK2Aj+Bo7toFjtVbWo2t0PE0ALz4FE
	 nFK3LjJZ3qpS8Ow3StYY5vWNedO2g64HomMFH77A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Dengcheng Zhu <dzhu@wavecomp.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Ming Wang <wangming01@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 6.6 152/273] mips/math-emu: fix emulation of the prefx instruction
Date: Thu, 13 Feb 2025 15:28:44 +0100
Message-ID: <20250213142413.343492720@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


