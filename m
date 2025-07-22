Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6B62E36E8;
	Tue, 22 Jul 2025 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192966; cv=none; b=APBYMzho7k0p1wnhGTheWE/1TRZvExLxuY3/PIld/DgDRf2peIBGzsg1iB8XON1xiK7n87oiy58yiOEYpCJuUbIfcPyWdeEEe1FZ63WXLcR1ijPQkMQWJz73yEAjbR0P17c7OUBqyqzjdoC6F7EQj4QaLnMWP3432l2mHOsi3P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192966; c=relaxed/simple;
	bh=wKVHvyZFfvN4vkl/pTJJ3bdsmboG+jjIvdISl5Y5w6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eS1/v+170/TKA2zjy97i2QlyOYBKugG47CNjHTsmNcJvkzNQC5YydSpI0MzloFzFmi8VlGt3HD8bfcB+VP4iM2QWWT4/kzaOK2xLgp3llMneP5ZCElLmkgYUEh6sTcUHGt6lRxxQZpGsiQTLYoCxsfroRLR1AfKyQaLc/EscxWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAFXdVnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAFXdVnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B939EC4CEEB;
	Tue, 22 Jul 2025 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192966;
	bh=wKVHvyZFfvN4vkl/pTJJ3bdsmboG+jjIvdISl5Y5w6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAFXdVnEB54B3Kk4YCkfMfZ9Vn98iZiESKH2XEhKgqb/kHCggmr7vFPoT6CHKO05C
	 q6lls8GNHIBUfSqtFUBMkqED4SMI+wMBof3sMs1/lD3NE5pZU3FX6uG577t4c0XCb+
	 10nE6KGegXHOxIyOr+XFzXysXbUfb5fz/w4WhWrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/158] riscv: traps_misaligned: properly sign extend value in misaligned load handler
Date: Tue, 22 Jul 2025 15:44:56 +0200
Message-ID: <20250722134344.932619873@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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
index d14bfc23e315b..4128aa5e0c763 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -436,7 +436,7 @@ int handle_misaligned_load(struct pt_regs *regs)
 	}
 
 	if (!fp)
-		SET_RD(insn, regs, val.data_ulong << shift >> shift);
+		SET_RD(insn, regs, (long)(val.data_ulong << shift) >> shift);
 	else if (len == 8)
 		set_f64_rd(insn, regs, val.data_u64);
 	else
-- 
2.39.5



