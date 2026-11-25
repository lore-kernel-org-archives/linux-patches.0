Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625575;
	b=4lDkrBH4L4288Pi7RwiRiSb7Um6El086z2VDUKunPpRY8D3uZKpr6O3znfqRN+ajqId8
	 kINLhWet+tjq8ARA3FQXX2iG28kW+9kxBPW/wss+z/gvvQjV8C0GvSx7P46s3BiO9ohDe
	 fME4YFhzQj05W6+f2ehYIOoymVx2pmorS1/sWXtb6F9xFw4Qq1z+cd26yHLze3nCmTZTl
	 tTuToVSdR2kR5B49bE7zogrjB70YJ5m0Q7JVG84wIPadpFSp6CPNespCTgYHRTbQavLQj
	 MeSmgVesSD4Q/DjOuQ6jKglGhqgt8riCRMzU/vsRvIMtjqWd+Mi+DBj1dXA5N/QkJ0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FV87LFIAJU/OHB8MvKwq2Nrqz10Di/Ib+S+82+Gk4fw=;
	b=xhH7qbCVts+tA9zHEUZbCodhK32tH3QGqIIlNs0t1mLY6sy/Lf8UnJw0fYdQNBeklyfJ
	 JcvYk0q/3fLjQdumfDkQYouL8Adeta31Sqcw5ooYahC8Ztf64NGgw3PqA1ECwjiWvMKNq
	 5lVwFBtOHPOrDrYNwihfdc7iiGm015ZFL5p69wQp6WfFPbNVgkUFygN6n5icexjw/wUma
	 451d8byAUznAbq88NkadJ17XWqDakLV1NjO54q5s+2ltvW4NAk/dlC4lwbqt+K0Fgg9we
	 MFun2A793fUirR/I/5yVHHiQbnakYXRgKZGalXmDRI+z4xEt65wGnFAgEntqjAYP8cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1SDAny/9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC8C606A332;
	Wed, 25 Nov 2026 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SDAny/9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185791F00A01;
	Wed, 25 Nov 2026 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625575;
	bh=FV87LFIAJU/OHB8MvKwq2Nrqz10Di/Ib+S+82+Gk4fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SDAny/9VCf6mnRwEr+0jUCIofrWepa2UwQ+cjvTQp/H+kgnFBL+3y+hFNQB8KDVK
	 +Sz/gX+zRr8MG252JofHe/wgMNsizvEW8MkQRmJBkQYMOcOHgswsUXQ6NvW3gPnsDV
	 xrKWp0CALjZpzMQBhBJEY+LCettZWHJLWrdH8cBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Woojin Ji <random6.xyz@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 517/816] bpf: Zero-extend the index in inlined bpf_get_func_arg()
Date: Wed, 25 Nov 2026 15:34:25 +0100
Message-ID: <20261125143901.153881794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Woojin Ji <random6.xyz@gmail.com>

[ Upstream commit 1c1dda9ba9f3af9cd511a197dcc86de2465d8fe5 ]

bpf_get_func_arg() takes a u32 index, but the inlined expansion compared
only the low 32 bits of R2 with the argument count and then shifted the
full 64-bit register to compute the context address. R2 is ARG_ANYTHING,
so nothing guarantees that its upper bits are zero: an index of
1ULL << 32 passes the bounds check as index zero while the load is
performed at ctx + (1ULL << 35).

Shift the index as a 32-bit value. When the 32-bit bounds check passes,
the low 32 bits of R2 are below R0, and R0 is at most 255: the trampoline
arm masks the argument count with 0xFF and the raw_tp arm uses the BTF
argument count minus one, which the verifier caps at MAX_BPF_FUNC_ARGS.
The 3-bit shift therefore cannot overflow and it clears the upper bits of
the register. Widening the comparison instead would reject indices whose
low 32 bits are valid. The check itself is unchanged, so this cannot
change which programs are accepted, only the address that is computed.

Fixes: f92c1e183604 ("bpf: Add get_func_[arg|ret|arg_cnt] helpers")
Signed-off-by: Woojin Ji <random6.xyz@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261018-get-func-arg-v2-1-048848b3eddf@gmail.com
[ sashal: Changed the inlined bpf_get_func_arg() shift to BPF_ALU32_IMM in do_misc_fixups() in verifier.c, since the fixups file doesn't exist here and only the tracing arm is present. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index dd7445537b1e3..a5ffecbaa7bf9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21867,7 +21867,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			/* Load nr_args from ctx - 8 */
 			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
 			insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 6);
-			insn_buf[2] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_2, 3);
+			insn_buf[2] = BPF_ALU32_IMM(BPF_LSH, BPF_REG_2, 3);
 			insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
 			insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
 			insn_buf[5] = BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
-- 
2.53.0



