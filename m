Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050135;
	b=Bwp69k7jvsCX6C5xSEge6Tyub7VyHfeKapzUpRxCO/73NQ8Ix0Q2OF/IiiCP3/NWl6x8
	 gS19bFNIhLM0AQUwpvS/z8oNZbXgnRIBVQPFItBRtNEmKZEbdyjUoglsiW2DRQUvI4BGL
	 8+wDVd8qvfWonay8Ps5o43PEQDBU9yBRCY+tHollylTleuK/42q86T4mHEWRsfCzRqYfu
	 oZluZYmkQs14qRHmLsEhhyQhiEuXRfdKJmBxJRvdf4UpVnUBlq82Qoe9ebcowhlW2Thu2
	 cQo50177atVtwGCCftUyCXo+rtwr8WzeYsLkQl7qV0ZuFcYikqJlre41O4KnLFjWJ8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DpepdfYnzR8P9NIKdfA3mwsxVuRDbkxsuhqLOMp3I3A=;
	b=vGAizGKGOnvEpLRS9THLy2BQ+xgcS0O1VpVKALmjN3RZHzrNQVSIejO3gg+fpW4YmaCK
	 FlSYso6WQ4yGFi2tWwf1IFOoK+RDnuPtBvYSslRP381TyblgajhV/smgwoLugJpBa4Ewt
	 6q6qjrN9zxeTEkb0YCYbM5PMMEa9RJ1mxJ7qjwdSLmk7xL5WKSWCYfz4nwc1AIyyfqy01
	 RsYVLnFSrEROSyKy5s4s487pHzg89XnuHIuRcWPpQVwaPMXpIpjJK3HnjMX8Mi5DSZMwZ
	 nJSd2mL/H9WJBk3Zr0YhOsEPk8PcwZidXqZNrqfESJTe2RuvOpDG0mhPu1spFhH4R1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhBJJign;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4BC606A325;
	Thu, 19 Nov 2026 01:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhBJJign
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301ED1F000C4;
	Thu, 19 Nov 2026 01:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050135;
	bh=DpepdfYnzR8P9NIKdfA3mwsxVuRDbkxsuhqLOMp3I3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhBJJignKI936vf1Of2ImzKfoRWXnoV7IyE8ZoirqPqsFmYcULM9I8OhdytvjbCKY
	 wnFXnwfj07jT5OBqyWJf/Elw3skLfFcPKaPQ2WFSDLHmOEZa/kXlPpQ9/ATbPGNUK+
	 UO2rrf1KhabCuSxb5M/ZPB80QfP6RrOEYhPRz6I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2600/2857] bpf: Use the socket of a sk_lookup test run under RCU
Date: Wed, 18 Nov 2026 16:00:34 +0100
Message-ID: <20261118150335.157015788@linuxfoundation.org>
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
index 8233451e659a5..9a08795bbf9d3 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1650,20 +1650,19 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
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
 
 	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
 	if (!ret)
-- 
2.53.0



