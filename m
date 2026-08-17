Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40ED3D5C07;
	Mon, 17 Aug 2026 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980246; cv=none; b=MOV5lVYeIs6zL3KeZo1wayDt0Zj91ZUIOt1WVy+ioiBghkv5szFQy+zd04fthbpgTriBQsPvLsK1HSkc6KfxXZg1LuVJD/kbY5wX1rmO5vu7OFZcwKdCddzjsIu8bszOoBuwkWzxUbYmaWS4MoxjMHSCYcHURK4fjtDzkxlTVbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980246; c=relaxed/simple;
	bh=CxKySc2rhZGU61PccykhsBGBAvQb8J7kkCPEXBIuP/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffg7tE7w1GEwfG2kMn3YeLAhYH6YiLhYjiCM2UFT3GIkIU3XNyHtOd1AhS1J1v0jixHCVTSt9HAB0+HTCzYUB5FPxep8STp5drZBUHY1qzKXwvxL6gN7sF7nLu4qZBHKb8SuJEY4XDcKjgyJ/Tm1uMIpRZ42gdHa5ZbCZCVZjps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kB1hFyZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kB1hFyZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B391F000E9;
	Mon, 17 Aug 2026 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980245;
	bh=Te8g5ZqWDY5G2WARrqDIUsj+C92Z2LZv2C/a1+OVXEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kB1hFyZgZwO8foWpo/Y2h2jwNN1mzLmqfZWl9n3+PL++JawSIpeBVhA1c+VGAIwbn
	 FM7UYuaI0JZFPkwU9GOcKP3FSYApy+sCMJKnxfKqh7lwSKwowfc9PLCoySYurWumkg
	 PtRd//9zuo5d1GueMkO7dysJBG4tqlGsOfDiux0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rife <jordan@jrife.io>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 506/609] bpf: tcp: Use bpf_tcp_iter_batch_item for bpf_tcp_iter_state batch items
Date: Mon, 17 Aug 2026 15:33:22 +0200
Message-ID: <20260817132600.795880487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan Rife <jordan@jrife.io>

[ Upstream commit efeb820951ebf3778830256496ff72d00d135310 ]

Prepare for the next patch that tracks cookies between iterations by
converting struct sock **batch to union bpf_tcp_iter_batch_item *batch
inside struct bpf_tcp_iter_state.

Signed-off-by: Jordan Rife <jordan@jrife.io>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Stable-dep-of: e5fd3f514e27 ("bpf: tcp: Fix use-after-free in bpf_iter_tcp_established_batch()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fb975e8f55ae5..9843e05343565 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2725,12 +2725,16 @@ static int tcp4_seq_show(struct seq_file *seq, void *v)
 }
 
 #ifdef CONFIG_BPF_SYSCALL
+union bpf_tcp_iter_batch_item {
+	struct sock *sk;
+};
+
 struct bpf_tcp_iter_state {
 	struct tcp_iter_state state;
 	unsigned int cur_sk;
 	unsigned int end_sk;
 	unsigned int max_sk;
-	struct sock **batch;
+	union bpf_tcp_iter_batch_item *batch;
 };
 
 struct bpf_iter__tcp {
@@ -2756,13 +2760,13 @@ static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
 	unsigned int cur_sk = iter->cur_sk;
 
 	while (cur_sk < iter->end_sk)
-		sock_gen_put(iter->batch[cur_sk++]);
+		sock_gen_put(iter->batch[cur_sk++].sk);
 }
 
 static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
 				      unsigned int new_batch_sz, gfp_t flags)
 {
-	struct sock **new_batch;
+	union bpf_tcp_iter_batch_item *new_batch;
 
 	new_batch = kvmalloc(sizeof(*new_batch) * new_batch_sz,
 			     flags | __GFP_NOWARN);
@@ -2786,7 +2790,7 @@ static unsigned int bpf_iter_tcp_listening_batch(struct seq_file *seq,
 	struct sock *sk;
 
 	sock_hold(*start_sk);
-	iter->batch[iter->end_sk++] = *start_sk;
+	iter->batch[iter->end_sk++].sk = *start_sk;
 
 	sk = sk_nulls_next(*start_sk);
 	*start_sk = NULL;
@@ -2794,7 +2798,7 @@ static unsigned int bpf_iter_tcp_listening_batch(struct seq_file *seq,
 		if (seq_sk_match(seq, sk)) {
 			if (iter->end_sk < iter->max_sk) {
 				sock_hold(sk);
-				iter->batch[iter->end_sk++] = sk;
+				iter->batch[iter->end_sk++].sk = sk;
 			} else if (!*start_sk) {
 				/* Remember where we left off. */
 				*start_sk = sk;
@@ -2815,7 +2819,7 @@ static unsigned int bpf_iter_tcp_established_batch(struct seq_file *seq,
 	struct sock *sk;
 
 	sock_hold(*start_sk);
-	iter->batch[iter->end_sk++] = *start_sk;
+	iter->batch[iter->end_sk++].sk = *start_sk;
 
 	sk = sk_nulls_next(*start_sk);
 	*start_sk = NULL;
@@ -2823,7 +2827,7 @@ static unsigned int bpf_iter_tcp_established_batch(struct seq_file *seq,
 		if (seq_sk_match(seq, sk)) {
 			if (iter->end_sk < iter->max_sk) {
 				sock_hold(sk);
-				iter->batch[iter->end_sk++] = sk;
+				iter->batch[iter->end_sk++].sk = sk;
 			} else if (!*start_sk) {
 				/* Remember where we left off. */
 				*start_sk = sk;
@@ -2927,7 +2931,7 @@ static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 	WARN_ON_ONCE(iter->end_sk != expected);
 done:
 	bpf_iter_tcp_unlock_bucket(seq);
-	return iter->batch[0];
+	return iter->batch[0].sk;
 }
 
 static void *bpf_iter_tcp_seq_start(struct seq_file *seq, loff_t *pos)
@@ -2962,11 +2966,11 @@ static void *bpf_iter_tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		 * st->bucket.  See tcp_seek_last_pos().
 		 */
 		st->offset++;
-		sock_gen_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++].sk);
 	}
 
 	if (iter->cur_sk < iter->end_sk)
-		sk = iter->batch[iter->cur_sk];
+		sk = iter->batch[iter->cur_sk].sk;
 	else
 		sk = bpf_iter_tcp_batch(seq);
 
-- 
2.53.0



