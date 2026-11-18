Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029903;
	b=hVLZCgPgpW09I41fx0CYDGO78FWecxyBV0DVcAD2hWa0Kjytuq7oxMg1f371NJ+1+G/c
	 Ohw/ntf85qferrEGsHFvZiYCV05Y8/kstVc/xZEqNmQtpzp2I7QnIl4+boIO3owMTpIWq
	 e5sDs4dzS1MXlc2CXvNn3HnPceBSdVqOH6zLwsJfnj40JufjDTMM+CDar4TmqN/WVIZsZ
	 bLZbyH8DqAj6GbUM2N+wPE07s+LJovd5LN8NxZ9iGOP2MjXQVP0HpPckaTiAbfvvEbTie
	 n4p2MJy/Zz/ymFXAbgNjCUrgCCrkRmvt74ZQnjq3MIARnVlatvOQDPmx4RToBgEmXCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KEd83sWKawCW5qV3cDe/BTQM9u4CQRx10cYNjILJqqk=;
	b=ORuDpX4JNC8g6191qBxPi5UedlCEZfYV/JuW3vvlTOtlKKWqtskucYUaJvO8N9Vj1jCm
	 UiDfQxS0rH4PlD3aofs2VYYixR5FPpqWYjLbVrc4Q68sceiyQJOyz+4RFcZ/2daL61li2
	 TkVZWov2VoKT38P2w4afWbzqshmNGr5n5cmRYDCxaWS5M0CazsO34fcTRJgEsocDlMXk3
	 i54BA7LPHGI776rd80pSjQhAnOHPpQatn2D4W7G3lKTQ9vDN2Qg15rC5Ic8lRpMTEVWWK
	 DZyaBhd3Dgw3OzAoUL25OkVJUrCtCRcAs4aMehZQbQ5dWx25hxaH1LVWegGb7oIYypQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHdRaNPZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1537606A33B;
	Wed, 18 Nov 2026 19:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHdRaNPZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6AF1F000C5;
	Wed, 18 Nov 2026 19:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029903;
	bh=KEd83sWKawCW5qV3cDe/BTQM9u4CQRx10cYNjILJqqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHdRaNPZTroOpcD1xr4nPVmhuTBGtkrzvwsoTxjI0f9DTydmUbGrHgzFH+THb0Sk5
	 6p0ZKKXa9rJ7s3IG5kQL2xlY/Lt4gNbOwMjaWlej8Q25kUEZ0doZ0ccmnduIowove2
	 LnOccQDyege1HA8WIME6bw+PNkhGd994JUPXj86o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0473/1756] bpf, lsm: Reject writes into the BPF LSM program context
Date: Wed, 18 Nov 2026 15:43:20 +0100
Message-ID: <20261118150027.703992730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 140c63a816d09..64d1769fd1584 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -408,8 +408,8 @@ const struct bpf_prog_ops lsm_prog_ops = {
 };
 
 const struct bpf_verifier_ops lsm_verifier_ops = {
-	.get_func_proto = bpf_lsm_func_proto,
-	.is_valid_access = btf_ctx_access,
+	.get_func_proto		= bpf_lsm_func_proto,
+	.is_valid_access	= bpf_tracing_btf_ctx_access,
 };
 
 /* hooks return 0 or 1 */
-- 
2.53.0



