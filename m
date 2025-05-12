Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99C6296D23;
	Mon, 12 May 2025 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072311; cv=none; b=GNb8G4z4+P5zsd8wznhXxiodrzrgnvcRjTgN/3905TvuCX5AVAuPy61WgheioroMTZ7p89jz0z/Enx6HidQr89SqM36rZIneV+VcPF0mfDLg2T780tGz2kB2dCY6s6/wCcYJ2OqSd4y7arViiS2PG+s4ZHLh0g8LrZAudN5zjOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072311; c=relaxed/simple;
	bh=SBpKJ08t79N8HkZHePw3hcisk0M/S0npX+r1mhkrcrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbWIO53Vcta4dGOeFmXdVBl4X7+/pxnSqvP2hbuI8T3zFWAss1HS6op8Xys55hU8MPonmRPzkbuRnKQZm8tBLxQu6DMQidAZturUnFZD/adoScZAC49zsv7oThXVdLTyvjaB/vmBshc2vuCYTcyDVeHWzBiEJwAbuN4s6KiBZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvhoIbff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvhoIbff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274B4C4CEE7;
	Mon, 12 May 2025 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072311;
	bh=SBpKJ08t79N8HkZHePw3hcisk0M/S0npX+r1mhkrcrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvhoIbffwXt0fKnwATdT7/jo4qSbQNF2JrMZGRBoElvowYwE97SzzdESQbRp+hrdV
	 TpCtXyETK2sK9xfkKD8MRm0oslOnzCgeP2oAwXYwc3L2ifZ/JYuntoyTED5T3dhxOc
	 LDeb6PWCRNwLjANEqeRGtbQUiNlhwnCoWaNIqyvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 159/197] MIPS: Fix MAX_REG_OFFSET
Date: Mon, 12 May 2025 19:40:09 +0200
Message-ID: <20250512172050.858228370@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c44572e0cc13c9afff83fd333135a0aa9b27ba26 ]

Fix MAX_REG_OFFSET to point to the last register in 'pt_regs' and not to
the marker itself, which could allow regs_get_register() to return an
invalid offset.

Fixes: 40e084a506eb ("MIPS: Add uprobes support.")
Suggested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/ptrace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index 85fa9962266a2..ef72c46b55688 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -65,7 +65,8 @@ static inline void instruction_pointer_set(struct pt_regs *regs,
 
 /* Query offset/name of register from its name/offset */
 extern int regs_query_register_offset(const char *name);
-#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last))
+#define MAX_REG_OFFSET \
+	(offsetof(struct pt_regs, __last) - sizeof(unsigned long))
 
 /**
  * regs_get_register() - get register value from its offset
-- 
2.39.5



