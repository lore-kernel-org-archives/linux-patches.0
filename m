Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2E21527AC;
	Fri,  6 Dec 2024 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496588; cv=none; b=HgOyjx659TUko/OyB3y1OcZ0J4mZyq/TcbEF9e6fZD7MHgA/y9vSRY775uyP8wsh3vWU8eQBDnIKJA7d//wRMYtSZW3cEVYF/ijBfyGmI6IyqSUdFWNn+uKgez+LtlR4SMjvSrZU4EwfyNDXKbSZte4ruBQYUVXt/yK9q2poCpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496588; c=relaxed/simple;
	bh=NeeS7YLYOlnVWmb4Khv/x/M+Qzc7LhUvBtV8q5z3NYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyhRToHjqJNDtDAXvowJbVBasSuBHG9Ri/WKV07wYHW4rtN0I8fzJ/Ww5MgT0rXSt8gWr4r1tWKRK/Pw5I2Zcy8rFCwqnr4XpS11c6/IPMP42omBSI0UE2fNUu/Ft6w5rorUpgggBCXPXMncPHuvCQqaNvAUDB/0Uy+KcBpArME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHke+DL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHke+DL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82105C4CED1;
	Fri,  6 Dec 2024 14:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496588;
	bh=NeeS7YLYOlnVWmb4Khv/x/M+Qzc7LhUvBtV8q5z3NYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHke+DL8Ddco4MQsCxmYn5MOgLXzoszZ/Kpu3KBW6S24GBGUok3D2X/dea18urnaL
	 H1T/p1cezKiNYhj2OEiDsinhRpp2TAVz5ukERMvcWwzKziXJTIv3HnWXM8wlN04CnL
	 akSfVyM8yw8qnoJyzBdRrw3HMxUEw4ivFZqKoEZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/676] arm64: probes: Disable kprobes/uprobes on MOPS instructions
Date: Fri,  6 Dec 2024 15:27:48 +0100
Message-ID: <20241206143655.268350168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kristina Martsenko <kristina.martsenko@arm.com>

[ Upstream commit c56c599d9002d44f559be3852b371db46adac87c ]

FEAT_MOPS instructions require that all three instructions (prologue,
main and epilogue) appear consecutively in memory. Placing a
kprobe/uprobe on one of them doesn't work as only a single instruction
gets executed out-of-line or simulated. So don't allow placing a probe
on a MOPS instruction.

Fixes: b7564127ffcb ("arm64: mops: detect and enable FEAT_MOPS")
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Link: https://lore.kernel.org/r/20240930161051.3777828-2-kristina.martsenko@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/insn.h          | 1 +
 arch/arm64/kernel/probes/decode-insn.c | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index db1aeacd4cd99..0ccf51afde31a 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -347,6 +347,7 @@ __AARCH64_INSN_FUNCS(ldrsw_lit,	0xFF000000, 0x98000000)
 __AARCH64_INSN_FUNCS(exclusive,	0x3F800000, 0x08000000)
 __AARCH64_INSN_FUNCS(load_ex,	0x3F400000, 0x08400000)
 __AARCH64_INSN_FUNCS(store_ex,	0x3F400000, 0x08000000)
+__AARCH64_INSN_FUNCS(mops,	0x3B200C00, 0x19000400)
 __AARCH64_INSN_FUNCS(stp,	0x7FC00000, 0x29000000)
 __AARCH64_INSN_FUNCS(ldp,	0x7FC00000, 0x29400000)
 __AARCH64_INSN_FUNCS(stp_post,	0x7FC00000, 0x28800000)
diff --git a/arch/arm64/kernel/probes/decode-insn.c b/arch/arm64/kernel/probes/decode-insn.c
index 3496d6169e59b..42b69936cee34 100644
--- a/arch/arm64/kernel/probes/decode-insn.c
+++ b/arch/arm64/kernel/probes/decode-insn.c
@@ -58,10 +58,13 @@ static bool __kprobes aarch64_insn_is_steppable(u32 insn)
 	 * Instructions which load PC relative literals are not going to work
 	 * when executed from an XOL slot. Instructions doing an exclusive
 	 * load/store are not going to complete successfully when single-step
-	 * exception handling happens in the middle of the sequence.
+	 * exception handling happens in the middle of the sequence. Memory
+	 * copy/set instructions require that all three instructions be placed
+	 * consecutively in memory.
 	 */
 	if (aarch64_insn_uses_literal(insn) ||
-	    aarch64_insn_is_exclusive(insn))
+	    aarch64_insn_is_exclusive(insn) ||
+	    aarch64_insn_is_mops(insn))
 		return false;
 
 	return true;
-- 
2.43.0



