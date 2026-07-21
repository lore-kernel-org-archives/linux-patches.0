Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D7D46A610;
	Tue, 21 Jul 2026 15:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649051; cv=none; b=VIPbanWEnLe/ncLBTn18fR1fbtv1MBudjT+ho6y/R3RKZfagJwA5A7aL7wFf+GdfB5eAPUL22kxlBsbgMlhs9o/LPgbtIiQ4RaciCWlQhryPoHIjmH2z5t6B9u691vH91+HFfaYU/j96PJkS1giwLufd4PGAtm/zsesCitgDrV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649051; c=relaxed/simple;
	bh=LWGKkIdwPy8v3r+9vvqo0UpCV75UTjKkUVqUJcMwgMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHGpt/sub4Sxb656S4dzsuOFSQIVkmlTh2/g53TEFHeu7E399XWpV5pzQ/6qoFC6HFn9set1uKKWrzM7lrKx/lwKfc32AVpzJQ3hloZXVEg20Z2MiCTSxBbcmbxSC7X5bkVLoU6sjED30UOv1eb5VvD4FrQuS9fdlJ1tF6xrI88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJZ91aPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJZ91aPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D641F000E9;
	Tue, 21 Jul 2026 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649049;
	bh=zqq6KRGcPykzMHr3YMsyeXvAT5I6taDd0gVaHjUPT5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJZ91aPnaFG/N5yXRQ4mbz77gGCn40O/kw+V83VCbzAcZTpbUQOIyurd+GBWEqq53
	 b1bsuxdioqMCQLLnLg+XLNleZKiFaNKj0I8HdV6NzGG/tS/I+60Qka8LAOCbu4a6nZ
	 OqUCjwpFIS/aVoVp+K7Whrj26v0YWGpawbmtABSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0431/2077] libbpf: Skip initial_value override on signed loaders
Date: Tue, 21 Jul 2026 17:01:44 +0200
Message-ID: <20260721152602.914545001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 61e084152328867fe2279cc790573aae39959cd5 ]

bpf_gen__map_update_elem() emits code that, when the host-supplied
loader ctx provides a non-NULL map_desc[idx].initial_value, overwrites
the blob value with bytes read from the host (bpf_copy_from_user /
bpf_probe_read_kernel) before the BPF_MAP_UPDATE_ELEM that populates
the program's .data/.rodata/.bss maps.

This override runs after emit_signature_match() has validated map->sha[],
and initial_value is part of neither the signed loader instructions nor
the hashed data blob. For a signed loader this lets an untrusted host
substitute global-variable contents into a program whose code carries
a valid signature, thus weakening what the signature attests to.

The blob already contains the signer-provided value (added via add_data()
and covered by the embedded, signed hash), so simply skip emitting the
override for signed loaders (gen_hash). Runtime initialization stays
available for the unsigned light-skeleton path as before. The jump
offsets within the override block are internal to it, so guarding the
whole block leaves them unchanged.

Fixes: ea923080c145 ("libbpf: Embed and verify the metadata hash in the loader")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260601150248.394863-5-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 39 +++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 91790dc82eb6c8..0cb14e030b8be6 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -1186,27 +1186,36 @@ void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *pvalue,
 	value = add_data(gen, pvalue, value_size);
 	key = add_data(gen, &zero, sizeof(zero));
 
-	/* if (map_desc[map_idx].initial_value) {
+	/*
+	 * if (map_desc[map_idx].initial_value) {
 	 *    if (ctx->flags & BPF_SKEL_KERNEL)
 	 *        bpf_probe_read_kernel(value, value_size, initial_value);
 	 *    else
 	 *        bpf_copy_from_user(value, value_size, initial_value);
 	 * }
+	 *
+	 * The runtime initial_value comes from the host-supplied loader
+	 * ctx and would overwrite the blob value after emit_signature_match()
+	 * has already validated map->sha[]. For a signed loader (gen_hash)
+	 * the attested blob value must be authoritative, so skip the override
+	 * and leave the hashed value in place.
 	 */
-	emit(gen, BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_6,
-			      sizeof(struct bpf_loader_ctx) +
-			      sizeof(struct bpf_map_desc) * map_idx +
-			      offsetof(struct bpf_map_desc, initial_value)));
-	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_3, 0, 8));
-	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
-					 0, 0, 0, value));
-	emit(gen, BPF_MOV64_IMM(BPF_REG_2, value_size));
-	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_6,
-			      offsetof(struct bpf_loader_ctx, flags)));
-	emit(gen, BPF_JMP_IMM(BPF_JSET, BPF_REG_0, BPF_SKEL_KERNEL, 2));
-	emit(gen, BPF_EMIT_CALL(BPF_FUNC_copy_from_user));
-	emit(gen, BPF_JMP_IMM(BPF_JA, 0, 0, 1));
-	emit(gen, BPF_EMIT_CALL(BPF_FUNC_probe_read_kernel));
+	if (!OPTS_GET(gen->opts, gen_hash, false)) {
+		emit(gen, BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_6,
+				      sizeof(struct bpf_loader_ctx) +
+				      sizeof(struct bpf_map_desc) * map_idx +
+				      offsetof(struct bpf_map_desc, initial_value)));
+		emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_3, 0, 8));
+		emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+						 0, 0, 0, value));
+		emit(gen, BPF_MOV64_IMM(BPF_REG_2, value_size));
+		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_6,
+				      offsetof(struct bpf_loader_ctx, flags)));
+		emit(gen, BPF_JMP_IMM(BPF_JSET, BPF_REG_0, BPF_SKEL_KERNEL, 2));
+		emit(gen, BPF_EMIT_CALL(BPF_FUNC_copy_from_user));
+		emit(gen, BPF_JMP_IMM(BPF_JA, 0, 0, 1));
+		emit(gen, BPF_EMIT_CALL(BPF_FUNC_probe_read_kernel));
+	}
 
 	map_update_attr = add_data(gen, &attr, attr_size);
 	pr_debug("gen: map_update_elem: idx %d, value: off %d size %d, attr: off %d size %d\n",
-- 
2.53.0



