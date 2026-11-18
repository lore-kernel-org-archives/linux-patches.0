Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020926;
	b=nIejpNtb824mrs2dTe+cqm+ApTa4rkaopfhZjwGMCAh0KEkU4w5SXjR6ZlVBTxXM9ZvU
	 VfI61wMeDpL+A/GvYAQ7gK99FvNQ9Qr+JFIrEzg+nk4nRjw9aXdQWGXXnnQxt4AvQQ7Wy
	 LXfsZ6+uCvm9BL5QHkiINsLmFuXEp2wm5zsPaLhhgIOs8YdASsPyUvJckYLZ212i5iuPQ
	 apw3AU38up9m+6sUkS7LMWJ2vmFlmowLqeL68Gz7ba25FFC0yT4k6XYGrRzyyRswVrJzj
	 ViUesIym/aiwGvqqU8DvGVqcZdy/NEs/LtJmpevZWQjMb8iUisLNis0HeakVYsJ4mJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tsFzFyB5r8s0Uwg9qC3cMESbuQPEUBygrRXfebW1/u4=;
	b=H9kCkGRAsrH2XekeC2uJ4HWOlJM67wbHbepcAl66DI6j5KXMrrxCkWg7DB5Ps31Ydubv
	 1TY3tB2SsjbFmh4tW3Hp1DUQWz/NagujN6L8ZOKJ6+U/19mSPcL9aBbwcs3pszQ0ZQsvw
	 reFrmnysBzE3/2Q6QjTuMZkpuL/ySzTXLYFCxKX206qqGkK218ldvZKG7v6iBYm8dADgU
	 ZB9isM6WXSvQJQmN4A2NFd6bL5O+386fi5c0pk3Erp+81+RCXAbzi0bLP/trmbhkIvHpb
	 Fx5F7nvv/R0c9B63F2q77bwgVVUcY98HjcLAYMMGiTYJ9sLzf9u+kUtXVytOQHdqGew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuujmGrb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE71606A32F;
	Wed, 18 Nov 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuujmGrb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4656A1F000C4;
	Wed, 18 Nov 2026 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020925;
	bh=tsFzFyB5r8s0Uwg9qC3cMESbuQPEUBygrRXfebW1/u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuujmGrbMnjGnrbUDSMuJpu2x7HpCOjRJLnxAyXq5SN2YRa9xIc7k+yqNA4XFA1eT
	 Rogn4tSw4SfWhxdsOwUG8x3RX/OBRIsqGRMImmNwm1z0hzxl7I8ptItpDY6p4p3U6o
	 GOwlJP/BfyRF7XDVtCDqG+PUCEWy7BsP0eR4/90Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2125/2651] bpf: Use the socket of a sk_lookup test run under RCU
Date: Wed, 18 Nov 2026 15:56:05 +0100
Message-ID: <20261118150402.410001076@linuxfoundation.org>
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
index d73cd247f8cd0..3043a7393c29c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1656,20 +1656,19 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
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



