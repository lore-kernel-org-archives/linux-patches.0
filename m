Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048392;
	b=iDF284Ke2ljETEze8IHuj8GZlxPeI5lb4q2Ob3lz0mQ38BKQ/MQsHT9YZEIbZh10gkoq
	 2Pqd3rtrE3DkFiCOlOSNtoSt1un+iFpuXk4DUWeDSnDDRfQZ/Q6DkhmApcDPYKseK4aed
	 3Dwaxv3STyhr1Akj2MU73t7koN6Kla1HY3P/LpP61a090HaaLbRwiFJQ7fzm/308fwVWd
	 No6TpOLPlJO1XvJvu6edsBk7m5x+sj2ssUxslAgkn/OZ1nePj1WRnbXnBqakr6Id1YHxO
	 5i29sQY9Ci2VKvrwIiF3ejANpQfrHPLj4TfSpDe7PWh7NOnPWj18qx1/mi1Hyg8tPoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rePSK+Bywl9VT1rQ4nlEmP75GYxkTv3jeGAT3wkWbWc=;
	b=EPZvXlhwbuca1KaFG9fkyNFFILiTbdd+Cm9EZYN1PCZpMjlXG8+tNLRKtiDfcBJA/eU3
	 MSoy2KjtQ6HvENdQvX6HV/nsMvYEnUsy8yzZWbHfWrc2mA6gZ2Klic7IsSPSyJGoaIrJx
	 MQHul7IvmI/9UZt/o1ok7vewKj3BglyNV31FCpm4KzyYta0g88K6Hd5x7atokOd3c1RA5
	 v9QedqTZQEV2a0GPtgUY7R3Fm2FKdq4fTG3bGzYV3qxJTyDPvMxFECY3O03TTj1yzhNKx
	 ksyXaKSpjG5DqbrQRlpNlUL/ELlhC5V+LpUNAUWEGPfljauNelbcZA0Swjap5gpgUbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjzhrifZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800C060A3803;
	Thu, 19 Nov 2026 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjzhrifZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D560A1F000C4;
	Thu, 19 Nov 2026 00:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048392;
	bh=rePSK+Bywl9VT1rQ4nlEmP75GYxkTv3jeGAT3wkWbWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjzhrifZan5D/Cykdt2hefDniZFDjynYOav20zsUQLm/lEoRLjr5ljKEYV2c8W//L
	 17Mr9s+MP8IsOyhDB6B+J71pVsyqBORBujDZJyVfhEQ4B714s4iMZgBwThktzFkH+s
	 Byw2Dl2Y8kT4XGQ6glSed5Nir88kExviw/YNpdN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1977/2857] bpf, lsm: Reject writes into the BPF LSM program context
Date: Wed, 18 Nov 2026 15:50:11 +0100
Message-ID: <20261118150312.569835272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e7e195a2e5f98..f26faa9a35db1 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -381,6 +381,6 @@ const struct bpf_prog_ops lsm_prog_ops = {
 };
 
 const struct bpf_verifier_ops lsm_verifier_ops = {
-	.get_func_proto = bpf_lsm_func_proto,
-	.is_valid_access = btf_ctx_access,
+	.get_func_proto		= bpf_lsm_func_proto,
+	.is_valid_access	= bpf_tracing_btf_ctx_access,
 };
-- 
2.53.0



