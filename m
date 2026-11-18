Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042013;
	b=TKOWUd6xWymjyS+5EuZJN/k5O80Epk8PZwCpH9tpDwbUf10fCtCEUbmoeyTODhl3Khjq
	 WmXyckCDTUe2X9KpZ5XkVvcd8bszTZAN2OoG2WUDhJm1GDoGNUZW/80FGlEcRlmn2k1vb
	 Ta4tPrEOe4VDJtLyp/ABfyGz0JV1xyVoGljEWItuj0gnK/4ltpc11GUL/eElrUKDSosmL
	 NrlDl3SJDJ0yusDl7mU5cHAMmMgpitGlwuMei9b8n72gZKr9W4WyRg90zCC24SHMvf00d
	 IgZ9J74uRuOWo9zAryAr0tQgmxkIIXo7jyrz5VB8E2aKP1Nnurnb5tTgcIiI4FZxulA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lvgopu5w54amn0FyfvToEEcNnWJysfbuwMuOZkDQve4=;
	b=aObrmTyRaJ8Yg3FupWvSyuPvvdFD3M776DQFkcc3rGBXpPO36Jj6YCTN8fg8zejGN9Px
	 IKH737jCZ/vuzyf20I4HgNvxkcHNH8vOosmsi0uz5J/SCvGDexw1txbfLqf0MhD/c4Et3
	 DeAQUz4I/DPel4y1ss+ndAhfZVVddkwHJCkkKS9Zd6bgZ8aNNsSumyl+50Hz/LfwhmNE5
	 fLNNCcReRT4okYPTABbVGnyVllotgqQEyCy8sOe00csaOedhRLyxqE0N9ZKPlwfY4zcgg
	 v/bnXEQgDOrG0vrUsx241w8Y5pLvIx58FEhjZQCp2Kh2N2u2p27GlnQPA/eUPdrsPog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rovsY4UV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AD6606A325;
	Wed, 18 Nov 2026 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rovsY4UV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3F11F000C4;
	Wed, 18 Nov 2026 22:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042013;
	bh=lvgopu5w54amn0FyfvToEEcNnWJysfbuwMuOZkDQve4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rovsY4UVlliCMA7IXU3tvcjngMrjDSeEb9pk6SJslel2iFLMRoUXuXBpSsrtCEvuT
	 EZLgmpdQTVUSsKgFWjOdeHqiQ2nMWpbfrYO5p7pMoyA5LsXVAtn1kWPfb/Xit6XM9B
	 ADkwdVnkvMsBFVqi2bvdtlt+rF1TdFd44O14iVnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3018/3318] bpf: Use the socket of a sk_lookup test run under RCU
Date: Wed, 18 Nov 2026 16:00:40 +0100
Message-ID: <20261118150450.755133455@linuxfoundation.org>
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
index 5d7e87459e74b..92f2606152343 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1583,20 +1583,19 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
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



