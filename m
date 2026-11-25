Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625479;
	b=OQlMz6RVsQVp/7SNzP1qCVlsyNcyvYYMso49NaLSlCLkYJaR4Ib39WGow/9HPgoM3Ooc
	 3FUOWBHl2xttGb4yY2F66a52Fl/2E3WyJ9fafjCy9EYIh6DwCCwfTT/5zi7KsIzPxarSn
	 viokJ+WRg9g5UQATKL8jJKLPnfvqeXO6RRDreRuv2ZfqCzU8oE38EvHEhrdpuLf1+3c0B
	 kV8xgyiIrZpKQKvT2Z3rqpfJ/zz9G5zWHttCoWsVJJBLimw6aApzwU7qj6A/at0xaPUF+
	 mBHbUIuu1hzkmmMrIUfhoAj0pMZf8mNq9bYXOJf5Z3jhN7jCmupUXHvIJRIIkaBuSuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iWWYEFtkjJ4SVT/Iz8IEcY+OUOkyjPQd2yKKD4Pt3Xs=;
	b=IRF3AtB5/YjrkQfDPks8a5gr5ITDYNkUWww2GWMMeb/LyB13Jk81I226riY46SMsIaj9
	 RQ+WqzlTp5HkLQlOyBHK431PwOhIQW0xVFLIyxP8SiBIvcpdA9BXzv6tnYKARWqwQY+29
	 lUUCeS/wi4JtuiYc/a/3IpXe5KBqg5wwJcYRR56Ky9DiFYXpOszLXbCXjOI9y/KNwcPje
	 In2Usr+e+ZUTi6TiyNJtVh8ii2d8sjRihVQTvWCInjQZEFc+Ahw9wAjd55JpUH6VaWY9T
	 CuGLFBbA9U9nAEWMKI3G68O3WLW098qPDj5W/YJip0oTPjsyOHQ0UBUIJMAt+XhaWBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAkeQytJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E47606A327;
	Wed, 25 Nov 2026 16:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAkeQytJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7985A1F000D2;
	Wed, 25 Nov 2026 16:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625479;
	bh=iWWYEFtkjJ4SVT/Iz8IEcY+OUOkyjPQd2yKKD4Pt3Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAkeQytJBILOZLkY1EjlJQ4+sjfRbNKwnQcoTWK4CVCtygmvoM5CiQpmn3MIKNwrr
	 yeacM98JUYY8mPgh8EHxhp81XbIXsoSPczChVt2vRImeCQQqSTDjTSSBPoTSDbFSzk
	 EGlxr/+OkdOKRZRH2zzr0COwn2omATmqYeSqnByc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 513/816] bpf: Let bpf_dynptr_write() mark a global function
Date: Wed, 25 Nov 2026 15:34:21 +0100
Message-ID: <20261125143901.060919232@linuxfoundation.org>
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

[ Upstream commit 589998616e0f9190ba6f6644a19532c5b2ba66d0 ]

The caller of a global function loses its packet pointers if the function
may change packet data. That is found out by a scan for calls of the
helpers which bpf_helper_changes_pkt_data() lists.

bpf_dynptr_write() is not on the list, because it depends on the type of
the dynptr: check_helper_call() looks at it. The scan cannot do that, and
so a global function which makes a dynptr from the skb, or gets one as an
argument, and writes through it counts as harmless. The write can
reallocate the head of the skb, and the caller goes on with pointers into
the old one, which has been freed.

Let every call of bpf_dynptr_write() mark the function, as a tail call
does. The same mark decides whether a program may replace a function.

Fixes: 51081a3f25c7 ("bpf: track changes_pkt_data property for global functions")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-10-alexei.starovoitov@gmail.com
[ sashal: Ported the change to the CFG code in verifier.c, since cfg.c doesn't exist here, and wrapped the condition in a bpf_helper_call(insn) check because there is no src_reg if/else split. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 34b82d3eff66f..9818cdbfb9724 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17089,7 +17089,10 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 			mark_prune_point(env, t);
 			mark_jmp_point(env, t);
 		}
-		if (bpf_helper_call(insn) && bpf_helper_changes_pkt_data(insn->imm))
+		/* nobody knows yet whether the dynptr is that of an skb */
+		if (bpf_helper_call(insn) &&
+		    (bpf_helper_changes_pkt_data(insn->imm) ||
+		     insn->imm == BPF_FUNC_dynptr_write))
 			mark_subprog_changes_pkt_data(env, t);
 		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
 			struct bpf_kfunc_call_arg_meta meta;
-- 
2.53.0



