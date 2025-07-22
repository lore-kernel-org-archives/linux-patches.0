Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8F12EAB76;
	Tue, 22 Jul 2025 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193574; cv=none; b=gCPX0/7/ldX4jCIceC7HlqZTMHW8Q8G7wtJcMmSCgO3LPHaMe4/aYqtQOph+VdB7SN87vfbb4xO2sQk10ZYR9lm0WUkAaM8DLOqWtk5007A3B+TgcXcAbjELy9nSnBrBc/d3JfPzSBeQGWoBQIE4o9NErp7FObRlC41CX2wZDUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193574; c=relaxed/simple;
	bh=JUPSFSsvfVfb/XMhinXzZhvUxVG40cuBkjPQ2cu82RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eElVFDKrJ6c3yW31Gcl6uLz8yX2m+g/FSKo9BBl2WgSy6OzwrG90/SHhDQvgmF57oDbPzHx5tkolF3sWDTHBzly7Qp8igLjBAvmogL+sBzIsS+wBUC5Pb3lIJvYUDCGnIywz5DGMXoHn0I8pCOT5pa2/mDfp3xY/5shZ/j4gjnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5vz3+2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5vz3+2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F142C4CEEB;
	Tue, 22 Jul 2025 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193573;
	bh=JUPSFSsvfVfb/XMhinXzZhvUxVG40cuBkjPQ2cu82RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5vz3+2duFTcEcVOVwn6/fzDu3kC15sSPe/zles6hta9slgNKeR0+3lbQXegPZsI1
	 XjjT0HGCiRvR2DJXzUi0adSyi3TGRqrm26UQqLWepXIzTbpUvr44CW1QHlXAVxDdlO
	 IwYyeWiwnSYJ+8l9NpVMQZrG3DvUUatzP6n8vPDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 132/187] riscv: traps_misaligned: properly sign extend value in misaligned load handler
Date: Tue, 22 Jul 2025 15:45:02 +0200
Message-ID: <20250722134350.657231889@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@suse.de>

[ Upstream commit b3510183ab7d63c71a3f5c89043d31686a76a34c ]

Add missing cast to signed long.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Fixes: 956d705dd279 ("riscv: Unaligned load/store handling for M_MODE")
Tested-by: Clément Léger <cleger@rivosinc.com>
Link: https://lore.kernel.org/r/mvmikk0goil.fsf@suse.de
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps_misaligned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index fe0ab912014ba..f3123f1d20505 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -460,7 +460,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
 	}
 
 	if (!fp)
-		SET_RD(insn, regs, val.data_ulong << shift >> shift);
+		SET_RD(insn, regs, (long)(val.data_ulong << shift) >> shift);
 	else if (len == 8)
 		set_f64_rd(insn, regs, val.data_u64);
 	else
-- 
2.39.5



