Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625512;
	b=NyuEvw6/0+vMWahDVOXWC725WzhMjOQkoGplCI/wBPpHT/HsWoe4hltc5SzYjdQCGjOy
	 Q4VBib/2gsualQpHYtOwWAOGWBmMtyzcs6HrFx7x0emqvsp+y2q6KVIJWhh2m9DefQOJV
	 cmb6C0yFgKwC8yMZW7axEGYdrlXrcBsx4nYOip0hdk0CyNpN0b1i9taxRFAGNMCtxUIC8
	 FF4cum0zZH7yjOaXiXGCaDgNND8DREcR2Zcax57/hpNznLVw0p1Z0/78HqFo9eOU+aFFn
	 HQln3NraRIfeqL25sH3dM1a4TcqEELoZ1s17pzMJR6G1yog6fg4NNnG+gruOokBoLBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dpmo8O15si8x4J1vary6ty4Q1wgmyNAdyV9KouaBPUY=;
	b=dg4xpt1HeeVOWiBbn4KRHRonCOBT4d7HjmCSF+tu6Z2+nngrFET5YbAw9L2wjRgLQdXF
	 M7luyLjdBVwTxOt5VyXODohW2+dpcyDH6vLxu7+dqmaOuqNH7bY+54RiSZAMsNsC/qHgu
	 C8QPIE4MW8/eEuOb9MRsF9qHzraQAyWYpNWFPdNmzsowFJivh55Q/VwjhsiSFwsbihMVD
	 SUQzGOs6mTOlSlruDkDeJrPa+0pd2RtfovBZA2ktwtv4FLV/aBxJhuHza5ffPln2s7j5z
	 80KX0+/vfLQX6+yQuXiuOdmUE7dHgGHv+qeETodUZ+X0UVv0xDcklYRGQenLR2CiDVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=04O4xvUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5769A606A31E;
	Wed, 25 Nov 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=04O4xvUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A950C1F000C0;
	Wed, 25 Nov 2026 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625512;
	bh=dpmo8O15si8x4J1vary6ty4Q1wgmyNAdyV9KouaBPUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04O4xvUUQFePXR4Y3vXw1QOd631Ag+HFjUVsFuSiHIIYnO8LRpygdL/yJ9DhBFAdt
	 ZIfE5IkNXcSEsRF4SWxST8Y9xPwj0QOZIs0QT70eK1fjitT/z/sj83XFN1b01G+ALu
	 gxlEk8E+EgUkAytAzZKcR8GgZ4hKfOfvs0ETt5sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 514/816] bpf: Dont take a dynptr argument for a local dynptr
Date: Wed, 25 Nov 2026 15:34:22 +0100
Message-ID: <20261125143901.084072762@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b7f97db88948aa511bcd989978f181e1367e0e8b ]

A global function is verified on its own. A dynptr which it gets as an
argument is assumed to be of type BPF_DYNPTR_TYPE_LOCAL, but the callers
may pass one of any type, that of an skb for example.

The type decides whether a write through the dynptr invalidates packet
pointers, and whether a slice of it is invalidated together with them.
Inside of the function neither happens. It can take a packet pointer from
its context argument, or a slice from the dynptr, write through the dynptr
and go on using the pointer, although the write may have reallocated the
head of the skb.

Assume the type of an skb dynptr instead. Nothing becomes forbidden for the
dynptr itself, and a clone inherits the caution. The dynptr which the
callback of bpf_user_ringbuf_drain() gets is known to be local, and stays
so.

Fixes: a64bfe618665 ("bpf: add support for passing dynptr pointer to global subprog")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-11-alexei.starovoitov@gmail.com
[ sashal: adjusted context for the older tree: dropped the trailing 0 argument to __mark_dynptr_reg() and kept the existing ARG_PTR_TO_DYNPTR | MEM_RDONLY guard and do_check_common() signature. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9818cdbfb9724..dd7445537b1e3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22372,8 +22372,12 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 				reg->type = SCALAR_VALUE;
 				mark_reg_unknown(env, regs, i);
 			} else if (arg->arg_type == (ARG_PTR_TO_DYNPTR | MEM_RDONLY)) {
-				/* assume unspecial LOCAL dynptr type */
-				__mark_dynptr_reg(reg, BPF_DYNPTR_TYPE_LOCAL, true, ++env->id_gen);
+				/*
+				 * The callers may hand in a dynptr of any type.
+				 * Take it for that of an skb, so that a write
+				 * through it and its slices are treated with care.
+				 */
+				__mark_dynptr_reg(reg, BPF_DYNPTR_TYPE_SKB, true, ++env->id_gen);
 			} else if (base_type(arg->arg_type) == ARG_PTR_TO_MEM) {
 				reg->type = PTR_TO_MEM;
 				if (arg->arg_type & PTR_MAYBE_NULL)
-- 
2.53.0



