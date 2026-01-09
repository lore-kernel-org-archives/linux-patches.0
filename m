Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B8035C19C;
	Fri,  9 Jan 2026 12:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962821; cv=none; b=NbrbJXU95f0G/Gumkm8Bi5ELGOHxif0TyJoX1anEd3udxTtfrlILXFXbZSQe3lUk7sSGCNII1l+ZMjLvUdtxdyMxOtyHP+DFMMqNfeLdcqSc+TfuaMp9W1WFZaZqdTdURPO1dCbymPcJyo/bSlkYtUUzlDO3LkSozgQsKAI1o4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962821; c=relaxed/simple;
	bh=WVKF4nYu0/aT48/mE5tyMllhBcmIjdRHhi5SJlyOJ1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/UJXAgl/DBIXLA93Oe40DqINGyOCwN7tFnE/snYzBQ/JubqHKPXZFLyvRG0guUK6+p+Y9p/gIsG6RyNlwljiZtyE5+asXkLmGAIPaYu7zUBBu/G1UC1KjxBCyWbHpXn7fPmpDIwiFMf9VKOEqhM7d7bOjK2+5sxpwWA6JTxBnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHUNR/LE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHUNR/LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C265C4CEF1;
	Fri,  9 Jan 2026 12:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962821;
	bh=WVKF4nYu0/aT48/mE5tyMllhBcmIjdRHhi5SJlyOJ1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHUNR/LECQSW8MyRguy8t9+2ymz3BpAWnb7Yy/EX1EmBfU9S/c8XxiRo/0xOJ+4ed
	 MIP/I1U31rooflgHgy7VC2I967ckpJNCwFOM6c1bliKLDZixMEC06PECDP4Ve896nH
	 6B2l9c/GPMCSruHcKvXr63wt1b3cmRMck5YPWc2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 500/634] LoongArch: BPF: Zero-extend bpf_tail_call() index
Date: Fri,  9 Jan 2026 12:42:58 +0100
Message-ID: <20260109112136.368823382@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit eb71f5c433e1c6dff089b315881dec40a88a7baf upstream.

The bpf_tail_call() index should be treated as a u32 value. Let's
zero-extend it to avoid calling wrong BPF progs. See similar fixes
for x86 [1]) and arm64 ([2]) for more details.

  [1]: https://github.com/torvalds/linux/commit/90caccdd8cc0215705f18b92771b449b01e2474a
  [2]: https://github.com/torvalds/linux/commit/16338a9b3ac30740d49f5dfed81bac0ffa53b9c7

Cc: stable@vger.kernel.org
Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -224,6 +224,8 @@ static int emit_bpf_tail_call(struct jit
 	 *	 goto out;
 	 */
 	tc_ninsn = insn ? ctx->offset[insn+1] - ctx->offset[insn] : ctx->offset[0];
+	emit_zext_32(ctx, a2, true);
+
 	off = offsetof(struct bpf_array, map.max_entries);
 	emit_insn(ctx, ldwu, t1, a1, off);
 	/* bgeu $a2, $t1, jmp_offset */


