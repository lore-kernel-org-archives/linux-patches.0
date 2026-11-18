Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039937;
	b=HO+Uqqdgjv7ZoR6WAeZe5tSmJ5LyEaY6Vk8Jw4PGxbHRWwvnoPxOVul8s7jOPS5evCT6
	 Z0NC3CdZBB2HZQhknQJ6rIqaTQVvz3mTSlAPgRuPPL8FCrAlc79ZTS8swUs7WUSao+gFu
	 1sTMRGM1gfSltraINw6IRtzBE3Owe32RyH6mlnfgQi8PTXZ01EUCr/MdFkgNAsz0nYJRL
	 2mxlDAtTQeVu+26lcyUj1UskwljDAsyPkEzzXWK32PJ4+rNGXSi5w5LjgTbXBB7K0h+2P
	 SX9yLffSeihsmJnjzyh6egQEHoQ1YvbGDyxpc+P9ef6I4e5TGZAhDfTMUr9YHfxZAew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uyi872vlthIFF+uRDLdlZC8wvi1NPL5BQRmUEr/f0NM=;
	b=j2MNAAnoQrykKM8tYKcMViSENr86v93z2eRqepL6ovJzvEZikyeTpJIknrREsqmNTnc7
	 NBEwIBI8Txu+rM5b0AxD2OXgwCI0L6Kagm812TBBtKT/IOmX1BIcI15ODEteOndFiXVpF
	 iqr+bqxxr4mznxrbpWPCReYm5E1KOUJ8g7wE+xNzCXyCQnOmcB66vadk8lavj24SDJbh/
	 GuqXPF3vVNA6N+vkKVvs+1oqkzGQnfVEQ5AKfeWMFV5hGwMiTDPWpMwboUTbHJPQNn84t
	 BO8tiT+ERxS2sXMJjUMRUSp8hzzIB5FXa1Yo4Z6xP9RqJX2l9yIzpmTCm98/Kdz2zXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQnrmPfw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1A9606A31C;
	Wed, 18 Nov 2026 22:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQnrmPfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED111F000C4;
	Wed, 18 Nov 2026 22:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039937;
	bh=Uyi872vlthIFF+uRDLdlZC8wvi1NPL5BQRmUEr/f0NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQnrmPfw8ZeiNsGHdFxvR/kh40XZ8rygv0/Fewx1VDReeJQLS4aDDeOGKpdWWT8IC
	 zyirRO953hQ+XYsPGt4nbvcxAVNVvSWyqm09fy/K2osmPhtW2RX3BiuYPIalhWGurr
	 ginlwCYgx5BbYeTfCerjHdYcyiNiJ7Z87XVd16JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2272/3318] bpf, lsm: Reject writes into the BPF LSM program context
Date: Wed, 18 Nov 2026 15:48:14 +0100
Message-ID: <20261118150429.952405941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit c42da1d3ba9d5067cf3f0676b98bcb3f5f9e3ce1 ]

The verifier types a load from a tracing-style context by its offset
alone: btf_ctx_access() looks the offset up in the attach hook's
prototype, and check_mem_access() stamps the resulting type onto the
destination register. Nothing tracks what the slot actually holds.
That is sound only as long as the context is read-only, and for BPF LSM
it is not. lsm_verifier_ops wires ->is_valid_access() straight to
btf_ctx_access(), which never looks at enum bpf_access_type, so a store
into the context passes verification. Every other user of the helper
either goes through bpf_tracing_btf_ctx_access() or open-codes the same
type != BPF_READ test first; BPF LSM is the only one that does neither.

A program can therefore store a scalar of its choosing into a context
slot, read the slot back, and get a register the verifier believes is a
trusted pointer of the hook's argument type. Handing that to a kfunc or
helper which dereferences a trusted argument turns it into an arbitrary
kernel access. Route BPF LSM through bpf_tracing_btf_ctx_access() like
everyone else.

Fixes: fc611f47f218 ("bpf: Introduce BPF_PROG_TYPE_LSM")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260915150739.284189-3-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 984e944a0221d..7904513373672 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -399,6 +399,6 @@ const struct bpf_prog_ops lsm_prog_ops = {
 };
 
 const struct bpf_verifier_ops lsm_verifier_ops = {
-	.get_func_proto = bpf_lsm_func_proto,
-	.is_valid_access = btf_ctx_access,
+	.get_func_proto		= bpf_lsm_func_proto,
+	.is_valid_access	= bpf_tracing_btf_ctx_access,
 };
-- 
2.53.0



