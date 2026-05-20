Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77C4371CEA;
	Wed, 20 May 2026 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300225; cv=none; b=oUbe0ELuW70N59htH2bjM79hqmTGJdGnpAvEd1dtA/oJRLYZdYtoZhRQbFlPNEZlkDnGZvjsd0/6WcHmlWH2Oh2rTH+RC7gE9/Ek8r9pDM/dOvY6jjlwzQC8HLhQkccU2oN3l/vSsmSMELWEBvorNchVoad0sSmlBrDAV2j7D2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300225; c=relaxed/simple;
	bh=DZShloku85d2b2tPMKr21I8mp89jHeIbUgn2hZEtrAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvHForJbVlb4iCwa4yMlDK78d/EPeeqc1IQqIq408toiGuUw/mFX1NCa61YMiYCPfDGbpW4PhLK8aQNCX3ClLqlvbylfK7fXxWk9ztt7T5mLzSKvsmwtKVMrZ9YtmYJyRVh+es3rOm5e4aAmxOYq48voNuT3kSH/ZX2ypYcLXAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPygtsxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPygtsxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CD31F000E9;
	Wed, 20 May 2026 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300224;
	bh=XClW4fhF9VqGQHFa5/fJj3yteuP5IHc7osj8Xf7p3eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPygtsxCXLZE7W5HReqc4q/xsTpK1NrJT3WgNNcAklzeUPv0ZUc3oiy9Ogukif45E
	 vupqNXxtYgnYwntRB2GzIW7RSJ/8sft2V7fqJL7zsbL9CnHM6KnRfzUV/LnxJd5af7
	 n20KHm6LiLqRoqKDcA9wTELDvnxXQJh2TW0grsQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/666] bpf: Allow instructions with arena source and non-arena dest registers
Date: Wed, 20 May 2026 18:15:05 +0200
Message-ID: <20260520162113.263144553@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f5e9ee63fff99..56a74ce4a29b9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14434,11 +14434,20 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
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
@@ -14454,7 +14463,6 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 		ptr_reg = dst_reg;
 
 	if (BPF_SRC(insn->code) == BPF_X) {
-		src_reg = &regs[insn->src_reg];
 		if (src_reg->type != SCALAR_VALUE) {
 			if (dst_reg->type != SCALAR_VALUE) {
 				/* Combining two pointers by any ALU op yields
-- 
2.53.0



