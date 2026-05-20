Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E74331220;
	Wed, 20 May 2026 17:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296431; cv=none; b=KnMfCJoGknHlwsVqwFoAF9ZAJotV6PhG7EcCtZbk8vDPtQPlLM6bUoCsXHmGKxoA7rkckL+21S1Wvg0ZLooRYeoIq4fY82cyyKtlwEAAUKWTn/R4Sh1Z05Dk2gZYUpQOnVMrQu9nFv1Rp2+VXyKWseQI9wqpn5RbdAFGJqqfpS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296431; c=relaxed/simple;
	bh=C1t+ABc+O/zACDdA5naC1IEZfgmIa2z80yla8+ft2OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQhlTEvgmxhueVyYmGpMd0rZpdupqum4EUqpmHqJICvjVeck/v6zKUx+LSweaS7FqU6aRKJoXmbN7SzRxDdD+Ax62BNK4CyqLdx3tK2O1rxVqK7NmZ2ERcqUmQ+jJbVGVqPl3x5sG6jMbWyWk/SYwha17jrRuNggmcjhamfTwxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrPcvY/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrPcvY/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481CC1F000E9;
	Wed, 20 May 2026 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296429;
	bh=70J+rOjdQlaR2Rsumglu/egxVoYQOeTbf8gH+idFwk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrPcvY/ETQB7s3lvOcysXxVPsGTuQFOBpta08Eeo/cscePkoYJVfUY5FI5CdVmTWz
	 rd18lB+QQqxbYbZkoUxYNr6/Nj7mFu9fn87CXlq5SsEejcAho3uLQ4Z71EsuDVPSso
	 +gi8rVYhR9y547Yxl2Nu3JjUjzWjkw5BKFDB2ZCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0779/1146] tcp: inline tcp_chrono_start()
Date: Wed, 20 May 2026 18:17:09 +0200
Message-ID: <20260520162205.844743032@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d6d4ff335db2d9242937ca474d292010acd35c38 ]

tcp_chrono_start() is small enough, and used in TCP sendmsg()
fast path (from tcp_skb_entail()).

Note clang is already inlining it from functions in tcp_output.c.

Inlining it improves performance and reduces bloat :

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/2 grow/shrink: 1/0 up/down: 1/-84 (-83)
Function                                     old     new   delta
tcp_skb_entail                               280     281      +1
__pfx_tcp_chrono_start                        16       -     -16
tcp_chrono_start                              68       -     -68
Total: Before=25192434, After=25192351, chg -0.00%

Note that tcp_chrono_stop() is too big.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20260308123549.2924460-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 267bf3cf9a6f ("tcp: annotate data-races in tcp_get_info_chrono_stats()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h     | 25 ++++++++++++++++++++++++-
 net/ipv4/tcp_output.c | 24 ------------------------
 2 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 978eea2d5df04..905587114d444 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2156,7 +2156,30 @@ enum tcp_chrono {
 	__TCP_CHRONO_MAX,
 };
 
-void tcp_chrono_start(struct sock *sk, const enum tcp_chrono type);
+static inline void tcp_chrono_set(struct tcp_sock *tp, const enum tcp_chrono new)
+{
+	const u32 now = tcp_jiffies32;
+	enum tcp_chrono old = tp->chrono_type;
+
+	if (old > TCP_CHRONO_UNSPEC)
+		tp->chrono_stat[old - 1] += now - tp->chrono_start;
+	tp->chrono_start = now;
+	tp->chrono_type = new;
+}
+
+static inline void tcp_chrono_start(struct sock *sk, const enum tcp_chrono type)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	/* If there are multiple conditions worthy of tracking in a
+	 * chronograph then the highest priority enum takes precedence
+	 * over the other conditions. So that if something "more interesting"
+	 * starts happening, stop the previous chrono and start a new one.
+	 */
+	if (type > tp->chrono_type)
+		tcp_chrono_set(tp, type);
+}
+
 void tcp_chrono_stop(struct sock *sk, const enum tcp_chrono type);
 
 /* This helper is needed, because skb->tcp_tsorted_anchor uses
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 326b58ff1118d..7b8a2c8213e18 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2878,30 +2878,6 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 	return false;
 }
 
-static void tcp_chrono_set(struct tcp_sock *tp, const enum tcp_chrono new)
-{
-	const u32 now = tcp_jiffies32;
-	enum tcp_chrono old = tp->chrono_type;
-
-	if (old > TCP_CHRONO_UNSPEC)
-		tp->chrono_stat[old - 1] += now - tp->chrono_start;
-	tp->chrono_start = now;
-	tp->chrono_type = new;
-}
-
-void tcp_chrono_start(struct sock *sk, const enum tcp_chrono type)
-{
-	struct tcp_sock *tp = tcp_sk(sk);
-
-	/* If there are multiple conditions worthy of tracking in a
-	 * chronograph then the highest priority enum takes precedence
-	 * over the other conditions. So that if something "more interesting"
-	 * starts happening, stop the previous chrono and start a new one.
-	 */
-	if (type > tp->chrono_type)
-		tcp_chrono_set(tp, type);
-}
-
 void tcp_chrono_stop(struct sock *sk, const enum tcp_chrono type)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-- 
2.53.0



