Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027302;
	b=y5CDjBjRxCaRDH6pMCCcRgW0sMjvrsMTT30DviTPdnQ6ekM6CzsUyke2ZPWFUsHT7OwD
	 x77rNIkTwW6TWlivGSXbKOV62NxjXp4WG74kvPaResfH9RuwzXE6CiZ5NOE+kUtJMcMVR
	 oFJjD8/SXwXpafFJlw/r83c9bzM5AgqtrSsOOaksAf4VIrmn1mi1plWUKqbXa2PuGPrnR
	 KhuNqv2t81V5M1zpQz3h9354sDnjGLnYs7p9nGo5wnwfF8QIs67LzNHQfgpFLRoyVTsQ1
	 E+1/BsMyANpPcv2mcgdxeJoC9nmkfhiEbcB9xXyRcGwCYPNtQljwCF68UYX71lIs7tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qr0PsC/XhYLw8CpfnaCMLmOeJSbY1rpNHtucrux/jp0=;
	b=12E3R63B7S1NfWwRsvn/LaJOkW1HV8FdcurUSWKK+cuuZ3eTpYXGXSsMWW+TDONUSPN0
	 8SlFSvIBSqF6OxP7n0d1hVfz8KUABOeAN+VxOVqI0AGwDbyNt1C4gzcWsVeMDpnmoZpd6
	 0vcTh9F8W0UDCJx1XSHUcdrlg5z1stTNUknDVlDe73nbiEhc11Ar/VkyK3qtlzD9+OV7c
	 pGLQNHf/C6eWAnkyHispnAvUoYh8YNjw3MMZrcny+Pm6X8fdf0sc3OYOQYgaf7vSvDRvh
	 RHTP78+YHOAGUhKWHAG+wb+BvTmLzwSKnWNpqfYRqRX5lUezGUK04KKaAVlrHvRFfuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="woDS/3MY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F692606A31C;
	Wed, 18 Nov 2026 18:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=woDS/3MY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E041F000C4;
	Wed, 18 Nov 2026 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027301;
	bh=qr0PsC/XhYLw8CpfnaCMLmOeJSbY1rpNHtucrux/jp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=woDS/3MYv5Wb2QJBlnPjdP1nvV3rNbcPFwy47+gap3Vse0/FCWdQl0YCxbXufg74F
	 dgAkics47lhgMZiyw4QxEFE+t6dxNuYM/cZKt0o3kZtF6kcLHknZgxmqGNcUWeI/LH
	 PuVwHsapzsj8OUPiW1folzRYvaj465WZBCfd04y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1742/2151] bpf: Use the socket of a sk_lookup test run under RCU
Date: Wed, 18 Nov 2026 15:57:57 +0100
Message-ID: <20261118150225.320384751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit 6aff0129f327b159c86a54e6bea64a027630ff6b ]

bpf_sk_lookup_assign() accepts only sockets which are freed by RCU, and
takes no reference. bpf_prog_test_run_sk_lookup() looks at sk_reuseport of
the selected socket and generates its cookie, which is a write, behind
bpf_test_timer_leave(), that is outside of the RCU read side critical
section in which the program ran. If the socket is closed in the meantime
it may be gone.

Do both before the section ends.

Fixes: 7c32e8f8bc33 ("bpf: Add PROG_TEST_RUN support for sk_lookup programs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-7-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index ebec805711279..6e08eadbb1177 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1608,20 +1608,19 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 		ctx.selected_sk = NULL;
 		retval = BPF_PROG_SK_LOOKUP_RUN_ARRAY(progs, ctx, bpf_prog_run);
 	} while (bpf_test_timer_continue(&t, 1, repeat, &ret, &duration));
-	bpf_test_timer_leave(&t);
-
-	if (ret < 0)
-		goto out;
 
+	/* Nothing but RCU keeps the selected socket */
 	user_ctx->cookie = 0;
-	if (ctx.selected_sk) {
-		if (ctx.selected_sk->sk_reuseport && !ctx.no_reuseport) {
+	if (!ret && ctx.selected_sk) {
+		if (ctx.selected_sk->sk_reuseport && !ctx.no_reuseport)
 			ret = -EOPNOTSUPP;
-			goto out;
-		}
-
-		user_ctx->cookie = sock_gen_cookie(ctx.selected_sk);
+		else
+			user_ctx->cookie = sock_gen_cookie(ctx.selected_sk);
 	}
+	bpf_test_timer_leave(&t);
+
+	if (ret < 0)
+		goto out;
 
 	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, 0, retval, duration);
 	if (!ret)
-- 
2.53.0



