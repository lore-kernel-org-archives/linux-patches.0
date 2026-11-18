Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021097;
	b=nzrWFsFNyNGA6fwBn2EgFirtuYWZPOfQOLKv8eE084BV9mn9WAh1hzdEy/6cNHtZOrW9
	 9vTVxqlBNaF6clkDu2EYx9wYwboJjR6cQy9Pabn7kdU9+fpg02a1+IGyMDcMimeu7ErKG
	 HVtwWDWk8PTeNZ/aa8Ckmooghw2xoUW+itbneib+sbf0bcbMflg76BdevwKXw/gTEiguS
	 lnnFX3N1EbkOXnGsJHOu79S+2ro5zXcfw1EsZOGN2q3wX599QLYVSrFhD3w+B6267xRLi
	 +YqbyiKBNh3dPapZnVU+cXg5j4QyCt4xlG50KCfmy8KgpVaxqWdH6MgX+4oLBalIKNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1buO3io9XPTb7aBGk9daYJ71GwcqDaaGMTNcsXX51PQ=;
	b=XYhMvTHIFCj3+Q7cZKjPe3tTH8NeKvxdgKgEOPETI6hqyanpNFWMyOnWnY7yPfUXWRB/
	 WAmBPE1MDrEFSlHUk5KEzMCoUQpxn1nug17DXjIBFDkwIU4LB6OqWDn0R18KIOzUSwiAU
	 tF4kaEqyEWIKET71AvviHNIRljOIBUaHJoFOR6jxOsUeayCzgOMebiBvNFM8Hfu7oMb5k
	 623gJZMFV7aF/vgbOgrhuFDEu0i62Tau5k88Gg+dB5068V2hzgaohdBmfXVIgZWFAZ66w
	 NDUl0l5KrVJ204/9DKyIjaVxCmqjtNAdYGuqGI77xCKAqNUHZMvTYyl4FhojBZIEQ3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhnI56Kr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395C6606A331;
	Wed, 18 Nov 2026 16:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhnI56Kr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8909E1F000C4;
	Wed, 18 Nov 2026 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021097;
	bh=1buO3io9XPTb7aBGk9daYJ71GwcqDaaGMTNcsXX51PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhnI56Krcoa9A25TZMLeNFQk8mX1HIOJ6Kdq7xBxFVbbgL7fPXqjyKtCXwTlCEmB+
	 4ivcTEaqD4NdbIbdzC7H/0jPcJYoVDS+oI2n/QhgmGyZJFDe6MysG3bIQ0dw0Od8am
	 RhO6x/+cuE63P3KzSWBXLmPAJdbladtjgAWkJTYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Woojin Ji <random6.xyz@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2145/2651] bpf: Zero-extend the index in inlined bpf_get_func_arg()
Date: Wed, 18 Nov 2026 15:56:25 +0100
Message-ID: <20261118150403.068089908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/fixups.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index 3dcae0625a88a..5a5f7ec21f2dc 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -2330,7 +2330,7 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 				cnt = 2;
 			}
 			insn_buf[cnt++] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 6);
-			insn_buf[cnt++] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_2, 3);
+			insn_buf[cnt++] = BPF_ALU32_IMM(BPF_LSH, BPF_REG_2, 3);
 			insn_buf[cnt++] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
 			insn_buf[cnt++] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
 			insn_buf[cnt++] = BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
-- 
2.53.0



