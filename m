Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055177;
	b=D7hsBJ30ZnnnRicjYjr4s8hkJAhW+VQTT/nwAP2c/aKcQfGTnm1epNKS8SoB8+/RPrFi
	 RCjHQ4cV/Q7VMnOOT9tiRTMRVFSu5brTYOmgzcpiZChSGxvvl32L6zIC/NFye7WoyY3c4
	 HtgsXm/sPfkoAhjLJcsiXjo2GSr2Xp3hbUDORWd9YSQKj168OrNZhPcfUs8wBV/G9jdYB
	 QPJ8/JZGPUs6xk7wpoenu+hfkAQwSu3sheG2Z6NRpcD9wFk9PBjt15ZXWapBMZsXq4QFS
	 F3zJhOjK+JPcGZlZg6wBAe/kWxNY391xTHvENZ2onez8lHxrXMl9TgGt8GsxDMu6iqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KBlFds4zEWydXezLaJuroGa32K5MPpbWxXuuzWZANzA=;
	b=ywJMEvwv5dSS9dH89C0lDIzo2/FtuKKCgV88s1+ZXDyP1m3TAU4Y4M40X2e9k22sZ7w2
	 +nhEpww4gmUPUUOl/hs3O4wOKAWmEH5IkhLKp7y4m0a6bE65ce53FQTPg63IPrQcApl9S
	 VsXdoehT7H0Fxwr96YysGoCnGScN3V5bOpxsTLaFbmyfc3OoKoePf24IcwWKbKUR+L/6Q
	 /v4gBsTD0K22RgektFenDqQ6u56N/Y0VF5RzjlbmYgL9wcn88dJyncUJYkF2KaKPQx6rA
	 RQBoCOxLX15tDY/CCB5ugtGXJ8J3ttYAaYKqsrt8fiBh4mbY4i28eWS+TOl5GUJBndQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00FI6gC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFBF606A31C;
	Thu, 19 Nov 2026 02:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00FI6gC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685401F000C4;
	Thu, 19 Nov 2026 02:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055177;
	bh=KBlFds4zEWydXezLaJuroGa32K5MPpbWxXuuzWZANzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00FI6gC5VgF38ebk8WfNxYDSKFnwEHZ2EayV8eT1On+Sp5m2PQa5UlbWVFzKpwu3G
	 2jFoRXRPyzDkd8+wTtYtyVrL1voffPcZYBCs39+Hco/6XvzLDztLzsUCKYYheaYg7X
	 2SUdA6oCMw1z67nhfLUa8u9DM2dQV8FIiLdMYpXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1537/2214] bpf, lsm: Reject writes into the BPF LSM program context
Date: Wed, 18 Nov 2026 15:53:33 +0100
Message-ID: <20261118150113.648170289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 02913d8610414..07be0ecfd020d 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -223,6 +223,6 @@ const struct bpf_prog_ops lsm_prog_ops = {
 };
 
 const struct bpf_verifier_ops lsm_verifier_ops = {
-	.get_func_proto = bpf_lsm_func_proto,
-	.is_valid_access = btf_ctx_access,
+	.get_func_proto		= bpf_lsm_func_proto,
+	.is_valid_access	= bpf_tracing_btf_ctx_access,
 };
-- 
2.53.0



