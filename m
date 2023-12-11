Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B7851C3E;
	Mon, 11 Dec 2023 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXeVWRty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A713C433C8;
	Mon, 11 Dec 2023 18:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319946;
	bh=mjREjfuY2F51oEo0495QwIFzwZb1OCKBzMchyN4P7KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXeVWRtyQq1kEhUUXR/hhSe2x4t2+PW3elCMKze3otmZ0T3fGrs+PQtwtGgvGGgp1
	 LycK/9ECa25hDQWqcxl8+Zsfy1u/eP00HsqGUXph1tI0EXMX9UtaRV6Lonsg8UVlMv
	 PQmEAEMiyAy45AAYmnuJx3w94MNOUNizHixkonVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/97] riscv: fix misaligned access handling of C.SWSP and C.SDSP
Date: Mon, 11 Dec 2023 19:21:49 +0100
Message-ID: <20231211182021.684380764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 22e0eb04837a63af111fae35a92f7577676b9bc8 ]

This is a backport of a fix that was done in OpenSBI: ec0559eb315b
("lib: sbi_misaligned_ldst: Fix handling of C.SWSP and C.SDSP").

Unlike C.LWSP/C.LDSP, these encodings can be used with the zero
register, so checking that the rs2 field is non-zero is unnecessary.

Additionally, the previous check was incorrect since it was checking
the immediate field of the instruction instead of the rs2 field.

Fixes: 956d705dd279 ("riscv: Unaligned load/store handling for M_MODE")
Signed-off-by: Clément Léger <cleger@rivosinc.com>
Link: https://lore.kernel.org/r/20231103090223.702340-1-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps_misaligned.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 46c4dafe3ba0e..b246c3dc69930 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -344,16 +344,14 @@ int handle_misaligned_store(struct pt_regs *regs)
 	} else if ((insn & INSN_MASK_C_SD) == INSN_MATCH_C_SD) {
 		len = 8;
 		val.data_ulong = GET_RS2S(insn, regs);
-	} else if ((insn & INSN_MASK_C_SDSP) == INSN_MATCH_C_SDSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+	} else if ((insn & INSN_MASK_C_SDSP) == INSN_MATCH_C_SDSP) {
 		len = 8;
 		val.data_ulong = GET_RS2C(insn, regs);
 #endif
 	} else if ((insn & INSN_MASK_C_SW) == INSN_MATCH_C_SW) {
 		len = 4;
 		val.data_ulong = GET_RS2S(insn, regs);
-	} else if ((insn & INSN_MASK_C_SWSP) == INSN_MATCH_C_SWSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+	} else if ((insn & INSN_MASK_C_SWSP) == INSN_MATCH_C_SWSP) {
 		len = 4;
 		val.data_ulong = GET_RS2C(insn, regs);
 	} else {
-- 
2.42.0



