Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625425;
	b=dFrIsIL0xLFh9GXjaeutu6gCc/XWsGUa6Iz5eM1EBvn0NS8wfjl/q346iVrWcSirUDnd
	 FDj7GHycmzVGn6GRBCXaJzxdmcuS6dyJfrG2G3Z/BCTDLmo6Lvz8IG2J+xJopqdomSBG9
	 k02mm8pMXTx5oImLIVKhLZMJ07U5RKtVyPZIs3Qed0vIZeK0GyNM34YK8cDt2lv8ql5yb
	 +KmWA8Niax9OqF/PqTrRHCWk2zBhqilWU3ZC37D4IGGWjGJlRI7m9DoKTtx7k2VAcMTWg
	 D9NOiwGcRlA7MbkGdXI3qESveKTh2dbiaKfvv0xMkH1Uf/kOk6uJYLCzhvQDXSr94uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C0A84dPMXpgGRX685oTu9W+q9mrdmUUTg3cppKaNuis=;
	b=2al1jJqYlNxMQz6CN5cIqe5E9CConzCTq27x0zzQxd6EDGPoq5lYfBuPx88TmcKO3Nx1
	 15NHu8sxvnBVH5utwhbLBqgjMs7qMDeh/50KqeTzR50dontpyoEB5tYLZblufRSen7FKo
	 qFbsD9ica5sihTkr/nE0gR9ZhdKom34l67HdJIVPazf+4hJFSNAKUDd70CoGpeo/mv0YB
	 zy7Nq/h70LuN7FEa3b89JyZ/6790OiQ1VdqAvhwzF8PzOIxZz6tDxlhl2Ygu9mLLCadZF
	 W1ekjDGGGrtRmL/J1OfT8x8neP5WY1zJbd4D7lsQoIiD/IZcFeV5+fDi3LAAFjcPYcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycCnWAMp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1FB606A323;
	Wed, 25 Nov 2026 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycCnWAMp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9DD1F000C0;
	Wed, 25 Nov 2026 16:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625425;
	bh=C0A84dPMXpgGRX685oTu9W+q9mrdmUUTg3cppKaNuis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycCnWAMpiKCMqB36/+HGzSTdvDB+fKFFHYtd2k0yKtt1Y9csEloXVFcIFY+0vAcdG
	 fVSeofvi2rfRLAZo6QRcBL6xfbmrlZ8tD8G5xFn/CPr9teoF3xcw2oALklmUa9YCgR
	 oOKyuxsf7LlyTu70JJG8VuIFCN94Cct32NXPfolk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 510/816] bpf: Assume no bounds for a writable tp with tail calls
Date: Wed, 25 Nov 2026 15:34:18 +0100
Message-ID: <20261125143900.990293015@linuxfoundation.org>
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

[ Upstream commit cd0490e671d70326d70c7d36e82388939fd9b071 ]

A writable raw tracepoint hands a buffer to the program.  The verifier
notes how far the program reaches into it, and bpf_probe_register() refuses
a program that reaches further than the tracepoint allows.  A program that
does not touch the buffer passes, and can tail-call one of its type that
reads and writes behind it.

Take a BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE program with a tail call to
reach as far as can be, as for the stack, the packet and the buffers of
iterators.  It cannot be attached any more.  Plain raw tracepoint programs,
for which the limit is zero, cannot get at the buffer, and a tail call
stays within one type: they are left alone.

Fixes: 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-28-alexei.starovoitov@gmail.com
[ sashal: Moved the tail_call fixup hunk from fixups.c's bpf_do_misc_fixups() to verifier.c's do_misc_fixups(), since this tree has no fixups.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 15a02a4c08d22..34b82d3eff66f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21568,6 +21568,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			prog->aux->max_pkt_offset = MAX_PACKET_OFF;
 			prog->aux->max_rdonly_access = U32_MAX;
 			prog->aux->max_rdwr_access = U32_MAX;
+			if (prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE)
+				prog->aux->max_tp_access = U32_MAX;
 
 			/* mark bpf_tail_call as different opcode to avoid
 			 * conditional branch in the interpreter for every normal
-- 
2.53.0



