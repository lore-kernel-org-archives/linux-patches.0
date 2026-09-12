Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC50241F378;
	Sat, 12 Sep 2026 10:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210196; cv=none; b=Jn9hVjY4VLzY46u4pFHMi6l1oCgSAvScNSsA6/dwb31+k8svB3JXUre/j8UyKvlttVd625Del3MmN7jEH/3yKMXQaterQT3cru6LsIo7RdDVnAc2bZkLZ7ygfAKugeMogH6TVhJNj9UU5Y9M57Auac/pjLMJYKOq+UlHxyEAIto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210196; c=relaxed/simple;
	bh=nl9BLGO7a9BCjNe+zUAGQourC23m+epKE7f9+NSYq1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWBUPr2CvCRCEuPZg0iFpOEvyyTkZeYoS2RImdG7ORsZMdsZcJo6d7AXeVex9XHColA7tiBsGOjUj34nvnqXxkIuhrJ1RS7nBoPxFVl7vi9MLluBSokKgshToZwCgPfgpQqPSE9ETfK01XiztplLmd8zJaAZnOwdA1y96EylRDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtD/OOj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtD/OOj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9407E1F00893;
	Sat, 12 Sep 2026 10:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210192;
	bh=iz1mzviU8n2uyGKsP9NMBuAAjWh+7qXWXDY7DyG6NB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtD/OOj494XaQhCN7dscqv/zcXNom3is3QibtUX+T8RXmEwDgbTkgvDhqEN8KB7Md
	 rECyJw8VSNHv3rt7zTvN5tY5Sz2hXUgos8wWvzFsmiQBm51r4mv7BC+73RN4LzCaKD
	 XjTDvuUY17B1O/MfBcjgaKwLP15tJiQsL4uljwkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Puranjay Mohan <puranjay@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0977/1518] bpf, arm64: Fix exception table metadata for arena load-acquire
Date: Sat, 12 Sep 2026 08:52:26 +0200
Message-ID: <20260912065645.558783791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit af22d273aa1f61fb86ec712b3ed785da73c3296e ]

Same problem as on x86-64: add_exception_handler() decides whether an
instruction is a load by its class, and a load-acquire is of BPF_STX
class even though it reads from src_reg into dst_reg. As a result ...

  if (BPF_CLASS(insn->code) != BPF_LDX)
          dst_reg = DONT_CLEAR;

... drops the register to clear, and ...

  if (BPF_CLASS(insn->code) == BPF_LDX)
          arena_reg = bpf2a64[insn->src_reg];
  else
          arena_reg = bpf2a64[insn->dst_reg];

... hands ex_handler_bpf() the value register instead of the address
register. A load-acquire from an arena pointer that faults on an
unmapped page is therefore reported as a WRITE at a bogus address,
and dst_reg keeps its previous value instead of being cleared to 0.

Note that emit_atomic_ld_st() already picks src_reg as the address
for BPF_LOAD_ACQ, so only the exception table metadata was out of sync
with the emitted access.

Same as on x86-64, use bpf_atomic_is_load_acq() so a load-acquire takes
the load path.

Fixes: 9bb12368d539 ("bpf, arm64: Support load-acquire and store-release instructions")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/bpf/20260806201047.333389-4-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index c563bae8fce1c..bcfadc49d2096 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1168,7 +1168,12 @@ static int add_exception_handler(const struct bpf_insn *insn,
 
 	ex->insn = ins_offset;
 
-	if (BPF_CLASS(insn->code) != BPF_LDX)
+	/*
+	 * A load-acquire is of BPF_STX class, but reads from src_reg into
+	 * dst_reg like a BPF_LDX does, hence it must not be treated as a store
+	 * here.
+	 */
+	if (BPF_CLASS(insn->code) != BPF_LDX && !bpf_atomic_is_load_acq(insn))
 		dst_reg = DONT_CLEAR;
 
 	ex->fixup = FIELD_PREP(BPF_FIXUP_REG_MASK, dst_reg);
@@ -1183,7 +1188,7 @@ static int add_exception_handler(const struct bpf_insn *insn,
 		 * memory access. Pass the reg holding the unmodified 32-bit address to
 		 * ex_handler_bpf.
 		 */
-		if (BPF_CLASS(insn->code) == BPF_LDX)
+		if (BPF_CLASS(insn->code) == BPF_LDX || bpf_atomic_is_load_acq(insn))
 			arena_reg = bpf2a64[insn->src_reg];
 		else
 			arena_reg = bpf2a64[insn->dst_reg];
-- 
2.53.0



