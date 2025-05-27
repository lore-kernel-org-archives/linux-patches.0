Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6173C01;
	Tue, 27 May 2025 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367395; cv=none; b=iNXGZEQeRZHQ4Mmstnbl0g7iEV8qqLN4ndU0aoLZ6LewFDZGnWU6giD2gCcaQJP2ZLv4KaZVG3kvBec6D3b2CcdR3V61LRiAesuQQvQUjlpCM7svRnsef/st4yPg2g0vBWgzZBA2rfceIUIhBHNr54+hqsi53AV7n+Fofgd7fJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367395; c=relaxed/simple;
	bh=MijYgIoH+fMAYaomhrkMMS/c07aP37iUp+2dQdJWhQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uj1A8csrRJWKNhq+xRqDXSjC6kJTl2RrwwKW1Lx/+x9PZFfa5iY21FYTE08wBDsxtootPF2kvgJZ1sRKHlMesiEwGas/v/zgGZsbqg8tFRQWvyIAqKa5k+A/vOt8MIycxiGL347cZIPSz+3p5Bat8p7VxQmKg7WNJE9KNl+ueCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJw8tTvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJw8tTvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A8EC4CEE9;
	Tue, 27 May 2025 17:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367394;
	bh=MijYgIoH+fMAYaomhrkMMS/c07aP37iUp+2dQdJWhQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJw8tTvSonvHMJWErvJbjE8G5ayOpL9Q2eQk91h88XFaMSF02LE3jlM0oXesqN3Gz
	 Z/+yuilskya7mWfIttbspELZOd/J/VVdRDXJqO2+s8RKDI7XafBlrVtcFkcX6/EOc1
	 TTOQT5kd/lmhtuiszkvpSq7RvM3RjDmqPWhj6IUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 373/783] bpf: arm64: Silence "UBSAN: negation-overflow" warning
Date: Tue, 27 May 2025 18:22:50 +0200
Message-ID: <20250527162528.276407428@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit 239860828f8660e2be487e2fbdae2640cce3fd67 ]

With UBSAN, test_bpf.ko triggers warnings like:

UBSAN: negation-overflow in arch/arm64/net/bpf_jit_comp.c:1333:28
negation of -2147483648 cannot be represented in type 's32' (aka 'int'):

Silence these warnings by casting imm to u32 first.

Reported-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Song Liu <song@kernel.org>
Tested-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20250218080240.2431257-1-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 3126881fe6768..970c49bb7ed47 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -274,7 +274,7 @@ static inline void emit_a64_add_i(const bool is64, const int dst, const int src,
 {
 	if (is_addsub_imm(imm)) {
 		emit(A64_ADD_I(is64, dst, src, imm), ctx);
-	} else if (is_addsub_imm(-imm)) {
+	} else if (is_addsub_imm(-(u32)imm)) {
 		emit(A64_SUB_I(is64, dst, src, -imm), ctx);
 	} else {
 		emit_a64_mov_i(is64, tmp, imm, ctx);
@@ -1208,7 +1208,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU64 | BPF_SUB | BPF_K:
 		if (is_addsub_imm(imm)) {
 			emit(A64_SUB_I(is64, dst, dst, imm), ctx);
-		} else if (is_addsub_imm(-imm)) {
+		} else if (is_addsub_imm(-(u32)imm)) {
 			emit(A64_ADD_I(is64, dst, dst, -imm), ctx);
 		} else {
 			emit_a64_mov_i(is64, tmp, imm, ctx);
@@ -1379,7 +1379,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP32 | BPF_JSLE | BPF_K:
 		if (is_addsub_imm(imm)) {
 			emit(A64_CMP_I(is64, dst, imm), ctx);
-		} else if (is_addsub_imm(-imm)) {
+		} else if (is_addsub_imm(-(u32)imm)) {
 			emit(A64_CMN_I(is64, dst, -imm), ctx);
 		} else {
 			emit_a64_mov_i(is64, tmp, imm, ctx);
-- 
2.39.5



