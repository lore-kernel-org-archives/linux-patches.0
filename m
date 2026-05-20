Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F02F36C9D2;
	Wed, 20 May 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297784; cv=none; b=UWxzcZQarEd1RStlp8XFAtc1G4Ukzm5+9rb0ksBMTroC2WUHPKvbDVYIbqYQV8tYpYVro553blDCkUFQ9YXmh9pLPjw/uneqCwVmWlMCiwWBpkdu2HLxADinddEX6ChcXGaL+zDgSNHvZPja9AocxsbyqJNHS2Jk8pDZWFbmwXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297784; c=relaxed/simple;
	bh=FelSZof7Fk+gFNwqETIXa/HiBuofeC9aQS5SYWeDca4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KH7auETDw8+kRDXEydn0uVjs+X9tHvOua7tThRvm4xZj6lt8c9YM5WFVd0vfkmuRVeZvHZAaGY8ADuQ0tBm/DxWW2e3Oo4B/LNa+yjzyKgwnL1fXsGn8QXo6dcW8kCnVj1wUymUq2CBb8OaucpH/fZ/n8K4hm/vNaV+2g5eTOMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgGt9OS3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgGt9OS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5801F000E9;
	Wed, 20 May 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297783;
	bh=nDLQYUtRJ43YWBZ4JA8pgdV1jYlpxYDrj5UkYSm2DZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgGt9OS3yY34KCVTHPT/Df+8QDZHMoEMWNKozj8vE4nBHnpioNhpeS1pQCZwIITj8
	 /6nQCut83X7EelY/NmglY+aB4iODt/TLlaKbDImuAX+LR2kU/zf0Iz9rpiiVt3Pwt6
	 f9EBt7NoNC13aX125dRJ8lFOALdsYwmlnvDhLDcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/957] bpf: Allow instructions with arena source and non-arena dest registers
Date: Wed, 20 May 2026 18:10:44 +0200
Message-ID: <20260520162138.040988403@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit ac61bffe91d4bda08806e12957c6d64756d042db ]

The compiler sometimes stores the result of a PTR_TO_ARENA and SCALAR
operation into the scalar register rather than the pointer register.
Relax the verifier to allow operations between a source arena register
and a destination non-arena register, marking the destination's value
as a PTR_TO_ARENA.

Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Acked-by: Song Liu <song@kernel.org>
Fixes: 6082b6c328b5 ("bpf: Recognize addr_space_cast instruction in the verifier.")
Link: https://lore.kernel.org/r/20260412174546.18684-2-emil@etsalapatis.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e8975e9761e26..153a7c1d32069 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15705,11 +15705,20 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	int err;
 
 	dst_reg = &regs[insn->dst_reg];
-	src_reg = NULL;
+	if (BPF_SRC(insn->code) == BPF_X)
+		src_reg = &regs[insn->src_reg];
+	else
+		src_reg = NULL;
 
-	if (dst_reg->type == PTR_TO_ARENA) {
+	/* Case where at least one operand is an arena. */
+	if (dst_reg->type == PTR_TO_ARENA || (src_reg && src_reg->type == PTR_TO_ARENA)) {
 		struct bpf_insn_aux_data *aux = cur_aux(env);
 
+		if (dst_reg->type != PTR_TO_ARENA)
+			*dst_reg = *src_reg;
+
+		dst_reg->subreg_def = env->insn_idx + 1;
+
 		if (BPF_CLASS(insn->code) == BPF_ALU64)
 			/*
 			 * 32-bit operations zero upper bits automatically.
@@ -15725,7 +15734,6 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 		ptr_reg = dst_reg;
 
 	if (BPF_SRC(insn->code) == BPF_X) {
-		src_reg = &regs[insn->src_reg];
 		if (src_reg->type != SCALAR_VALUE) {
 			if (dst_reg->type != SCALAR_VALUE) {
 				/* Combining two pointers by any ALU op yields
-- 
2.53.0



