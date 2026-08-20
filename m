Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49514381AFB;
	Thu, 20 Aug 2026 15:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239332; cv=none; b=KY7dxBslgogkO8h8n5rylKfTl6NMyGXbzrl79gxOBMVX4GH/dTfOvShJV2PlrEHpyrGFa/TST2/SncC7UjvKAxFLRAP+eem8MwTnq5A41aky8qcpYIOh4IuE2xT2bcGsqKVH30tknB9WVlFJDk91U3FZ0AWZgtbezJHdvA5W+sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239332; c=relaxed/simple;
	bh=bWEeAb2bwQtZS+hrBeo/BeKUEDu1GhNEnoBn+u+Q/fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+vZDiRASdIupLQAdCrDA4u93vAPFX9iqih2X07/6gQaNGpV3FnuJWFtahWI4B3VKi5MxR6ohKTMlZCaYlBP7eq4Yv8vAxqmX4zvOwXAJpoJiDfGrMl7ehwmFdPmJOzVh5KKs3buK11svBX+ju0YHbB2XfNadYfDit2XsZsmacc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alOL3CeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alOL3CeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FF21F000E9;
	Thu, 20 Aug 2026 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239331;
	bh=zL5V52vMahxBDvaeg1PNl+8fgeVH3alAFY7ep5+Wm2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alOL3CeMmkrOgAJb7VeS33S6S3EoxjNQi+2SBgqEA+8BgsFFSR/40WYfpUOGlZ1ei
	 4dn5uVuaUOQNjcXOprBp9vy2z05EiEhLlS9HLwKmsDqer4Rxh41MSNzpBVZHQTDbd9
	 sEUqy3R/Ur/lLDVeTN0TZgsRs+L07ZPdzgpNhsbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/220] bpf: Fix linked reg delta tracking when src_reg == dst_reg
Date: Thu, 20 Aug 2026 16:53:12 +0200
Message-ID: <20260820145223.562434329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

commit d7f14173c0d5866c3cae759dee560ad1bed10d2e upstream.

Consider the case of rX += rX where src_reg and dst_reg are pointers to
the same bpf_reg_state in adjust_reg_min_max_vals(). The latter first
modifies the dst_reg in-place, and later in the delta tracking, the
subsequent is_reg_const(src_reg)/reg_const_value(src_reg) reads the
post-{add,sub} value instead of the original source.

This is problematic since it sets an incorrect delta, which sync_linked_regs()
then propagates to linked registers, thus creating a verifier-vs-runtime
mismatch. Fix it by just skipping this corner case.

Fixes: 98d7ca374ba4 ("bpf: Track delta between "linked" registers.")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260407192421.508817-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[shung-hsi.yu: contextual difference due to commit 7a433e519364 ("bpf: Support
negative offsets, BPF_SUB, and alu32 for linked register tracking") not
backported. ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 275c9fabc955..582be2211ffc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14544,7 +14544,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	 */
 	if (env->bpf_capable &&
 	    BPF_OP(insn->code) == BPF_ADD && !alu32 &&
-	    dst_reg->id && is_reg_const(src_reg, false)) {
+	    dst_reg->id && is_reg_const(src_reg, false) &&
+	    !(BPF_SRC(insn->code) == BPF_X && insn->src_reg == insn->dst_reg)) {
 		u64 val = reg_const_value(src_reg, false);
 
 		if ((dst_reg->id & BPF_ADD_CONST) ||
-- 
2.53.0



