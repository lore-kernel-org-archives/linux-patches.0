Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28115330D43;
	Wed, 20 May 2026 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294854; cv=none; b=uUtMIiq6e3tQDU4IOMkAxI9bgO1mLc+1slj/0eiki3Wrgmpa+Oe/MWLAmxxn9Y7jmotjcEsR0eJ6g00rbPpUCqkPIkAlGWXG4DyEElXyTl2WUgSq2A/XgqtIQv4OKurKgXMplqMiFnwTY1KhR1qDxh+gXbP/qfTc/LqODV1Yhbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294854; c=relaxed/simple;
	bh=bnnoTAyEhYqOgfcHQSIVCb08P89DioaghNV74Q/q3wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwjHmxjLoOBeIibfeUWVUhwmpuTklswrVgIyPFVh2mb+uwYrXMBJ7jGhP4O2kcOR7ugKr0SqIEGNID4bA7nQkEXFt2mIFbwldw5YMygd38OATX8LSJuc4vkjrmPMscXB5XbntIvaEIRAhl+8yn6bkiMKmnnYq1/R/QuwbhEzA4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfsACGcK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfsACGcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEAA1F000E9;
	Wed, 20 May 2026 16:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294853;
	bh=U5z5pngaht9IfgiB8JLSHkLaPHX6ysKS19h6l/YAytc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfsACGcKfPOIiipeHW49Uhza4IMVHY6nDiFLEPCEyERLQ2ven8hwnNFc54A6SHMvP
	 ZGb/jFnnbAfz6xWAKcIq42KV/+7lbZ5GQBI1TMPw5/Hc5HwkUCniQnt8ULGuqhF1so
	 40eWFLM3wFlUhXo9F9gbTeUN8EwHy0TSETkHzQK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0196/1146] bpf: Allow instructions with arena source and non-arena dest registers
Date: Wed, 20 May 2026 18:07:26 +0200
Message-ID: <20260520162152.711421652@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 5eaba53162d20..b26a599be947f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16222,11 +16222,20 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
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
@@ -16242,7 +16251,6 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 		ptr_reg = dst_reg;
 
 	if (BPF_SRC(insn->code) == BPF_X) {
-		src_reg = &regs[insn->src_reg];
 		if (src_reg->type != SCALAR_VALUE) {
 			if (dst_reg->type != SCALAR_VALUE) {
 				/* Combining two pointers by any ALU op yields
-- 
2.53.0



