Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B3B371D00;
	Wed, 20 May 2026 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294757; cv=none; b=T9Ky3Xq49UnQup+j/MBmEr1H9P6Gb26Tg7XVDtlimDrWUV1NVPXbEN3P72vv5CdgrICg1Z6BH0KvYam4fobsodhgGP1xx9bGNgLW9TcZL/WF9vu+c5BVIfiJzxg5Lb//t63RoQBAR6Fr6RNDUa3+QmbAo5HhCoPSoG1/SQxZ5xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294757; c=relaxed/simple;
	bh=/TGCwWpIrkUeLc/RoEfG1mmLjgpkPZwti3AQY8zgLDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkqhhqqEHCgbv8FAw2upvkOi0BUpKqdk7F48B92PclRhVx8PTbHE/2Ra5gfLJjCjkStI62Eoaiy3H7+WwdmQxlH105+4n5rPJ+dmPsrv3tjp4FVg2qpqz5OrpyoAb+fG4tU1GIxUkG+UmBv3EWJYSRQTjJ2KXfjFjVDuZu+hue8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FD584ATU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FD584ATU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778641F000E9;
	Wed, 20 May 2026 16:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294756;
	bh=Her/mSLDA9Cejb6DmN0kmDORX15CpnhLxZBRIRJK+ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD584ATUo2e7cYVSJXijtCrZAF7T4bTaaEkQ3sGWAr6xo+2PH/afBSlOnhmlKTh0o
	 NZ3UYpqG3QRrAAMfVw7Bu19Wwv/EH+wB0HQbEOyZZiCfSmIzSbbO3QJj6JZFWCOb4e
	 sTtQ408eAcouZFgnw8opOn+znibtZlVkkwWrTEbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0159/1146] bpf: Fix linked reg delta tracking when src_reg == dst_reg
Date: Wed, 20 May 2026 18:06:49 +0200
Message-ID: <20260520162151.896261896@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d7f14173c0d5866c3cae759dee560ad1bed10d2e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8d00bd0f8b79d..0507df13fe2d6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16325,7 +16325,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	 */
 	if (env->bpf_capable &&
 	    (BPF_OP(insn->code) == BPF_ADD || BPF_OP(insn->code) == BPF_SUB) &&
-	    dst_reg->id && is_reg_const(src_reg, alu32)) {
+	    dst_reg->id && is_reg_const(src_reg, alu32) &&
+	    !(BPF_SRC(insn->code) == BPF_X && insn->src_reg == insn->dst_reg)) {
 		u64 val = reg_const_value(src_reg, alu32);
 		s32 off;
 
-- 
2.53.0



