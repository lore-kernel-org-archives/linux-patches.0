Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C8D3F5BFC;
	Wed, 30 Sep 2026 18:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793173; cv=none; b=J6VGDXgkXeU8hEZkP5dbygWuaRlYrZj5JooyKE9qdQjoMbJC4PbYgyjqGIq+Y+5lhQpLUYU6gc2cfR0vm4cxf6lBzoVPrQKosD3vJlMC7vF5+h+HIbDUrPdjwR8QnFoW8yjhZAQq8HZWEba3duis+qSCrugKL3A6SDAqrGV9qhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793173; c=relaxed/simple;
	bh=0v8gJCuRQnhKp65jZvaUZ2Co9UOFPOBVVsRygelFYlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5BiqtiK2nUVThG5p2i0GGzeHOmHbdQHdq4st/fjyvljvAD3shRMePODdxgx9pJB8bnuQq1hedWC8zSp1AmFjzACoRxQ1tCN5AOZzkNnpuRgWTbCR2E43zLt03xScjWgEneWPNgOaga8w/+CLnCfHOxFMfVkeCdqjy7mweJj+tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3hfim/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3hfim/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B24D1F000FF;
	Wed, 30 Sep 2026 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793172;
	bh=IOPmq6iHjCuuiXaQV4buwqYh7pMo7lWFYVabfgu4SZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3hfim/tFJ49AZUiqqIPzY2EjfjTK8DpyQ+QbL6RHWdgfuF/95YzrqPfqgEFMT3At
	 n8qrztUFO4NaQ/cjknRF9bZLZm1/xv0PX60tW5g8lNSWVKUJNmLj9V+ImppKsvweCA
	 D0mHpAkbYNaYPXDNgEE60N3fgtILWc1y6TwZD0U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/395] bpf: Fix immediate JMP JEQ/JNE on MIPS32
Date: Wed, 30 Sep 2026 17:27:02 +0200
Message-ID: <20260930152344.118131692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit db762fd96be225bd06161c9631160c755d891693 ]

An addu instruction was emitted instead of addiu, causing the immediate
value 1 to be interpreted as register $at. This made the comparison
result invalid when the immediate operand was negative. Note that $at
is mapped to BPF_REG_AX, which is used for constant blinding.

Fix the instruction to use the immediate form.

Found with test_bpf on MIPS32r1 emulated by QEMU.

Fixes: eb63cfcd2ee8 ("mips, bpf: Add eBPF JIT for 32-bit MIPS")
Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260923105158.3514342-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/net/bpf_jit_comp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/net/bpf_jit_comp32.c b/arch/mips/net/bpf_jit_comp32.c
index 40a878b672f5d..15a2a153dc873 100644
--- a/arch/mips/net/bpf_jit_comp32.c
+++ b/arch/mips/net/bpf_jit_comp32.c
@@ -1111,7 +1111,7 @@ static void emit_jmp_i64(struct jit_context *ctx,
 			emit(ctx, xor, tmp, lo(dst), tmp);
 		}
 		if (imm < 0) { /* Compare sign extension */
-			emit(ctx, addu, MIPS_R_T9, hi(dst), 1);
+			emit(ctx, addiu, MIPS_R_T9, hi(dst), 1);
 			emit(ctx, or, tmp, tmp, MIPS_R_T9);
 		} else {       /* Compare zero extension */
 			emit(ctx, or, tmp, tmp, hi(dst));
-- 
2.53.0



