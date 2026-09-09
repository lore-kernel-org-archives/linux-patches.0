Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D82558FD23;
	Wed,  9 Sep 2026 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963992; cv=none; b=I/R0kFmk4U+a+HH/ueRRHhXt0M4cdIi6JUz5TkhwKqxCPTYrBDZ6Hjh1GuUpd/vcPNg7RBo+5nnbuW7NS1scfaC5nDAUa5Sd23tkqGzI2/iCIV62vV1fR4GF4LncgFCBO90qdYUAXE7HNLNNc/84rDXUjQ7fw/65i/JjX+sYuWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963992; c=relaxed/simple;
	bh=0OCDWslRtaB5bGONZZ1LGYIcQRiVsluFJpFD2DbhLVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyoHC19+EtZYrkCmgKHX4AGgF1HHL6D1A5SHxkGmLTzN4oGdZv1iyP5tWXcdHg7pjNGm5hBoYmtVS4WLlmUkQV02X2zyhHBYHiQM9PzNHXDUo7sOnru1JC6ctXAu0c2kYcNqPmEOBP3nkZhfBIaSqC4WZDXqLv8EBGZJdfWdqQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=147uqnd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="147uqnd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000B11F00A3A;
	Wed,  9 Sep 2026 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963990;
	bh=462QNAXGyHb+b+txfIb8Yct+FifLWQMz5E04AN413VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=147uqnd8lKbRJIQaEhh/yimv/375IEVk0FdGHG+NP+TJTYwatq5FmSAGkR4ZrjJ7u
	 ZEcOR6aYDOBtCG+ylC9tZ3UhAH56IReu+Bt+qmZpJQOcEPW749wX674e4Aqh+biHWV
	 O9CMWydp4aeEtSMoGuPxed6hAegPIFOvUVYvJFiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 267/583] LoongArch: BPF: Optimize redundant TCC loads in epilogue
Date: Wed,  9 Sep 2026 15:39:12 +0200
Message-ID: <20260909134247.344826841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit fd3cb1bfeb9d98618bd709bfee9c1133e9f189e6 upstream.

The legacy epilogue implementation pops the tail call counter (TCC)
context via a redundant double-load pattern. It first decrements the
load_offset by 2 slots to fetch 'tcc_ptr', and then immediately bumps
it back up by 1 slot to load the original 'tcc' value into REG_TCC,
unnecessarily overwriting the register.

Optimize this sequence by adjusting the load_offset by only 1 slot.
This aligns the offset directly with the higher stack slot containing
the entry TCC counter (or caller state), allowing us to restore the
REG_TCC register safely with a single load.

This removes one redundant instruction from the epilogue hot path,
improves code readability, and ensures the correct TCC register context
is handed back cleanly upon normal return.

Cc: stable@vger.kernel.org
Fixes: c0fcc955ff82 ("LoongArch: BPF: Fix the tailcall hierarchy")
Fixes: ef54c517a937 ("LoongArch: BPF: Implement PROBE_MEM32 pseudo instructions")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -228,14 +228,8 @@ static void __build_epilogue(struct jit_
 	load_offset -= sizeof(long);
 	emit_insn(ctx, ldd, LOONGARCH_GPR_S5, LOONGARCH_GPR_SP, load_offset);
 
-	/*
-	 * When push into the stack, follow the order of tcc then tcc_ptr.
-	 * When pop from the stack, first pop tcc_ptr then followed by tcc.
-	 */
-	load_offset -= 2 * sizeof(long);
-	emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, load_offset);
-
-	load_offset += sizeof(long);
+	/* Only restore the TCC state into REG_TCC from the higher slot */
+	load_offset -= sizeof(long);
 	emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, load_offset);
 
 	emit_insn(ctx, addid, LOONGARCH_GPR_SP, LOONGARCH_GPR_SP, stack_adjust);


