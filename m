Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020886;
	b=j7/y7rBNqmCrdLO8Lt7J4UY4AdJ81ED6b6q6DHKyJZ68PfIje/NByozFepbzkxBJwM+S
	 iXwIv0s9CY0fZVyQl4NKWR6ej59RCn1nScPWHmXkG676dkS5dYU/n18FNgbydV0Uqcgux
	 /kxzitCvdhBA++/tzcmgBDnXcY4LxYjfEa5nsTVOYX5adMYM3SYqBW96/v3koY8MBp1h2
	 CSnZrnQC00tiAWVYKp4vIz3tGnSq771jM2AOUQCr7njkBew00Uqe6sTCb84ZRjYJzCWC4
	 SWfviPvSvLTCjrEo9Hb7clbpfMA40rjVRXXFT03jI0qzTX1OKRK1ItszhqZy7g4+lqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6G0WyXMqwUFucwhZblR/bUjo/iS9XgV2C9Rhf+f4Yck=;
	b=fkn4YCD6hmDpzvLBTaJpbMKwKVK7av5WiNQi3r/R+hkiBJTnLWIj8hF2+4YUTOIyKOlD
	 lMvMC1BCSP6xxPDxL4mo5pMl8gZPpeIPxMedJdpAhPchykp9Aa7PiClXU3yx5g+4+n4zX
	 wLoNW4q1QuFV0O4gA54sR/Urbznt7rPJNKZv1IE16tO8KUdUGgkokwj9ymnuOdylIDUgr
	 VKT4oYkTNQUHfJ54RfsTAKrAuVsGbeKqk9neMfHonpcnclKt7s+XDAlJgKoNGrmL23Gcq
	 bzXLsXEaNoYsCusRp7G+KJjd92GASEC7tpQmSG2NVj//0p6aQdwItJwI7x0TxgFHOog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X+KtW/Nu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF68F60A260F;
	Wed, 18 Nov 2026 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+KtW/Nu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B2B1F000C4;
	Wed, 18 Nov 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020886;
	bh=6G0WyXMqwUFucwhZblR/bUjo/iS9XgV2C9Rhf+f4Yck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+KtW/NuLzjzHdCdbtMiHVeCvfaEHISvqonA1dEDDJhP2nblT8ViN5SdQbGZgAKPk
	 /F8OVFeY+mOVbWr4JDSXhnvOG9XaxhyKnXbA7D+kTR5BgDRPz6crKWFAraLNZp4lNt
	 6Kiq80etASqRFoaauCtZdvmKcZ5fddhxiA6IDmLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2112/2651] bpf: Assume no bounds for buffers behind a tail call
Date: Wed, 18 Nov 2026 15:55:52 +0100
Message-ID: <20261118150401.983001991@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/fixups.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index 6f2c15b47c329..7968e81100b89 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -2018,6 +2018,8 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 			if (!bpf_allow_tail_call_in_subprogs(env))
 				prog->aux->stack_depth = MAX_BPF_STACK;
 			prog->aux->max_pkt_offset = MAX_PACKET_OFF;
+			prog->aux->max_rdonly_access = U32_MAX;
+			prog->aux->max_rdwr_access = U32_MAX;
 
 			/* mark bpf_tail_call as different opcode to avoid
 			 * conditional branch in the interpreter for every normal
-- 
2.53.0



