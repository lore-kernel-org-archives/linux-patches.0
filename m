Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD67400963;
	Wed, 30 Sep 2026 17:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789074; cv=none; b=Qk8PzZZqIbAdbmj0rSuuoLMa2SowS0TE8kmSADV9+x9AOlAcLKFKaYKOIfoC78gbYCpcBtZsDAhB1Rxpqx4ulMTYPaZiHhFcVVBn70q4IahJWS9rYG/VJ4Ld86/TvaDy25CzHZIDsJeC47Cxjebvu06F6lBquegUFmejBc+jFdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789074; c=relaxed/simple;
	bh=M5Hl1IFVnLHF+AzlO20ruuZARS78ZXuohSTZ2CV9h8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuPh0JD+G5rHAoDazLFBpdEpyyDc2BxUMWXyAvrnYW85C5PWH+iVklSS5CGzozOyGt9IEeZuOK4ZtnTNvTJRj/ets5C3EP7b1YpMxs6QhoJEVSyPO7cd15sqYHExXtIc2PbLVzDFpYLRWrFgm6FNFkmTfvBcV4aLGFeiccgRnU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQrpMzHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQrpMzHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15F41F000FF;
	Wed, 30 Sep 2026 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789073;
	bh=HB678qoMrbIt18Ylif0uupIZoGCfYEgk2S3NO5j3ORs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQrpMzHV/xeEqrw1VKy6lj+BPrUlGvD5C5S3OmY71rnh04IHEg23+4dckJglIlTLF
	 UjBCWvd9wEy+mwrLxBX0AZvJn3GMMX/jgANk89+mpdYOWg3jyKFlAzA24OORnvQQc7
	 Krgf3tgq6EQjI2s8QHg0jXSnj1PQt3lR2YTyax9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/877] libbpf: Reject truncated ldimm64 CO-RE relocations
Date: Wed, 30 Sep 2026 17:20:58 +0200
Message-ID: <20260930152422.158731413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit b4e875d397da451fb4e9c573ff4b86db53caba05 ]

CO-RE relocation of an ldimm64 instruction operates on two instruction
slots. A malformed BPF ELF can end a function after the first slot and
attach a CO-RE relocation to it. libbpf allocates the instruction array
according to the function symbol size, so the shared relocation code would
then access beyond the allocation.

Reject a terminal ldimm64 in libbpf's relocation loop, where the program
length is available, before resolving or applying the relocation. Both
resolved and unresolved relocations validate the absent second slot, and
unresolved relocation poisoning would additionally write past the array.

The in-kernel caller is protected by the verifier's early instruction-stream
check before it applies CO-RE relocations.

Fixes: eacaaed784e2 ("libbpf: Implement enum value-based CO-RE relocations")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/20260914140852.03DA21F0089B@smtp.kernel.org
Link: https://patch.msgid.link/20260917233222.2542500-11-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ffb0d1f7e9a08..214f8b48c1ea3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5983,6 +5983,13 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 				return -EINVAL;
 			insn = &prog->insns[insn_idx];
 
+			if (is_ldimm64_insn(insn) && (size_t)insn_idx + 1 >= prog->insns_cnt) {
+				pr_warn("prog '%s': relo #%d: insn #%d (LDIMM64) is truncated\n",
+					prog->name, i, insn_idx);
+				err = -EINVAL;
+				goto out;
+			}
+
 			err = record_relo_core(prog, rec, insn_idx);
 			if (err) {
 				pr_warn("prog '%s': relo #%d: failed to record relocation: %d\n",
-- 
2.53.0



