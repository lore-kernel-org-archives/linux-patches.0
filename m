Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622645;
	b=dWfIJAFJfVSKeH1AXJxDaiy/IFMtqCNyfnUM8HsxLnNGfswpI4SlRg0T+KfI81Yfo6qw
	 ax8UmYWLt0YLZi9wP4OvONebAuEemte9tdBSrjsN+P1+Rz7FVy7Lofu1v4GydAdtA/4uX
	 fBC6Jur503k/4D+asTi9sJzt4d0PI9HzZ5c8TrMdG8dgf2YUacKYNiAqpIedCBPRsl0kY
	 8e4ernYTKq41q8S/7dn80KvdW9KkxpY0xMqvaIGvUkivBErHtjI3O8lx3M8LnMK4msj3v
	 OnObOEaTBiVTzlfznRmNfj8FgOr/DcGkUYrKs1DW0fZ+Usj2WiO6qrwLbuAIrZLUHjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6tDAorsmyNmukgf2n3ux9dLJulNtCiVf23/kZBrh3Dk=;
	b=EGeMZ36A8CqRR/TtVEUQdLvR6GnY5N1DszIf/Ib3FZCXxmSHKuxN4fEs0kN83NF0CfVU
	 Yh925GlLd73HxvyCrDNGEdP7mghYH51jd7IqyiCet09K66TuHAzGaLnZhlLHAw7jjm1Kl
	 SIgpSbT1hFQZzgqFSFROSYpyK7Q6KyddqjsKxjElJ4LDrQH/XOsENOMO8H2BLpduigNNC
	 DzBiFncVcxBjm7kZoWfia3J/tnPQwnS/9kWQMXH8/M5p7Qy5elVaEoRoXG2qe0NswN/3q
	 QydsHoKGl4U3XLKhXJJHqMuaDMywBC73f+8g0G35epCsFACJ0hpYL/X8OwzMDX47Mow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arND6OQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E164606A32A;
	Wed, 25 Nov 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arND6OQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F661F000CA;
	Wed, 25 Nov 2026 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622645;
	bh=6tDAorsmyNmukgf2n3ux9dLJulNtCiVf23/kZBrh3Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arND6OQ6ep09LDglU6rsENOJdgnAZ2iLH3VSClhxI1HpO+EMwaiRagj3xAneHe9pi
	 Nf5BDU4CciDFnoMoaaeWUPKDmidyM7mEngK2+sW2jn1kEa8aTcZ/QE9Q4A7Dx8rWq1
	 oOgZUCHKIe/le5uoJLd6s8knIGWTGdMk3S8CFJ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 604/990] bpf: Assume no bounds for buffers behind a tail call
Date: Wed, 25 Nov 2026 15:32:51 +0100
Message-ID: <20261125143836.240723672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7fa323d77688e8b62b2f0bf6c3208a2c96d4a5e7 ]

The bpf_map_elem, bpf_sk_storage_map and sockmap iterators hand the key
and the value of an element to the program as buffers.  The verifier notes
how far a program reaches into them, and the iterator compares that with
the map when the program is attached.  A program that does not touch the
buffers passes.  It can tail-call another program of the same target,
which gets the same context, and whose reach nobody compares with the
map:

  BUG: KASAN: slab-out-of-bounds in ___bpf_prog_run+0xa46a/0xae80

The program array can be filled at any time, so there is nothing to look
at when the link is made.  For the same reason a program with a tail call
is taken to use the whole stack and the whole packet.  Take it to reach
as far as can be into the buffers as well, so that these iterators refuse
it with -EACCES.

Fixes: d6c4503cc296 ("bpf: Implement bpf iterator for hash maps")
Fixes: 5ce6e77c7edf ("bpf: Implement bpf iterator for sock local storage map")
Fixes: 0365351524d7 ("net: Allow iterating sockmap and sockhash")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-26-alexei.starovoitov@gmail.com
[ sashal: Moved the added max_rdonly_access = U32_MAX line into do_misc_fixups() in verifier.c, since this tree still has the fixups code there and not in a separate file. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ca27c14004ce3..13da4dd120d74 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23176,6 +23176,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			if (!allow_tail_call_in_subprogs(env))
 				prog->aux->stack_depth = MAX_BPF_STACK;
 			prog->aux->max_pkt_offset = MAX_PACKET_OFF;
+			prog->aux->max_rdonly_access = U32_MAX;
+			prog->aux->max_rdwr_access = U32_MAX;
 
 			/* mark bpf_tail_call as different opcode to avoid
 			 * conditional branch in the interpreter for every normal
-- 
2.53.0



