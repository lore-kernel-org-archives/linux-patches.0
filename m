Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CAE17731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E43C433C8;
	Wed,  9 Aug 2023 11:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579296;
	bh=iNBoEObbPZc+5k7PbCPGP4r9zMTpY0m5aIgwSVi1li8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeNVR040IwdOfLRe4lidTch256MGYTXfAa+NPdHE3DOlCMKhz9BUfkDVolIZlOGrz
	 myQsIFyK5Ocfki6BKd3YiZ3Fy3QEFkrwWLxhjY8gXU8sexccNo011itPfZC603sLvU
	 L0sI1Aeh2F2g7ehHwQDpEG1jyEuGFtsZW/OFKL6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 146/204] tcp: annotate data-races around fastopenq.max_qlen
Date: Wed,  9 Aug 2023 12:41:24 +0200
Message-ID: <20230809103647.464321299@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 70f360dd7042cb843635ece9d28335a4addff9eb ]

This field can be read locklessly.

Fixes: 1536e2857bd3 ("tcp: Add a TCP_FASTOPEN socket option to get a max backlog on its listner")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-12-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tcp.h     |    2 +-
 net/ipv4/tcp.c          |    2 +-
 net/ipv4/tcp_fastopen.c |    6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -425,7 +425,7 @@ static inline void fastopen_queue_tune(s
 	struct request_sock_queue *queue = &inet_csk(sk)->icsk_accept_queue;
 	int somaxconn = READ_ONCE(sock_net(sk)->core.sysctl_somaxconn);
 
-	queue->fastopenq.max_qlen = min_t(unsigned int, backlog, somaxconn);
+	WRITE_ONCE(queue->fastopenq.max_qlen, min_t(unsigned int, backlog, somaxconn));
 }
 
 static inline void tcp_move_syn(struct tcp_sock *tp,
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3193,7 +3193,7 @@ static int do_tcp_getsockopt(struct sock
 		break;
 
 	case TCP_FASTOPEN:
-		val = icsk->icsk_accept_queue.fastopenq.max_qlen;
+		val = READ_ONCE(icsk->icsk_accept_queue.fastopenq.max_qlen);
 		break;
 
 	case TCP_FASTOPEN_CONNECT:
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -239,6 +239,7 @@ static struct sock *tcp_fastopen_create_
 static bool tcp_fastopen_queue_check(struct sock *sk)
 {
 	struct fastopen_queue *fastopenq;
+	int max_qlen;
 
 	/* Make sure the listener has enabled fastopen, and we don't
 	 * exceed the max # of pending TFO requests allowed before trying
@@ -251,10 +252,11 @@ static bool tcp_fastopen_queue_check(str
 	 * temporarily vs a server not supporting Fast Open at all.
 	 */
 	fastopenq = &inet_csk(sk)->icsk_accept_queue.fastopenq;
-	if (fastopenq->max_qlen == 0)
+	max_qlen = READ_ONCE(fastopenq->max_qlen);
+	if (max_qlen == 0)
 		return false;
 
-	if (fastopenq->qlen >= fastopenq->max_qlen) {
+	if (fastopenq->qlen >= max_qlen) {
 		struct request_sock *req1;
 		spin_lock(&fastopenq->lock);
 		req1 = fastopenq->rskq_rst_head;


