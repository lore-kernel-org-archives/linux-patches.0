Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26603433BE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJ585b1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C11CC433C8;
	Wed, 15 Nov 2023 19:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077059;
	bh=Sv7UZtcd2O65gKOOGeUbkfCze14UAAZnwG4v7hh9koc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJ585b1NLuzCrIIFQvJydVPgmOOKKxVkfuw/fOwTyyYMp3nvKMypI37tZhEk2wXSj
	 nzsIzujEicaIjFzC4jMs2CCDmYfkjlbCI2IYfRXuPfTCTjuU9Xakx7vgmkY10ggeR3
	 itGRS5nYWGWaOddpJrgDYHoMQ3KsdLUnhm1x6ySs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paul Moore <paul@paul-moore.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 508/550] dccp/tcp: Call security_inet_conn_request() after setting IPv6 addresses.
Date: Wed, 15 Nov 2023 14:18:12 -0500
Message-ID: <20231115191636.136447038@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 23be1e0e2a83a8543214d2599a31d9a2185a796b ]

Initially, commit 4237c75c0a35 ("[MLSXFRM]: Auto-labeling of child
sockets") introduced security_inet_conn_request() in some functions
where reqsk is allocated.  The hook is added just after the allocation,
so reqsk's IPv6 remote address was not initialised then.

However, SELinux/Smack started to read it in netlbl_req_setattr()
after commit e1adea927080 ("calipso: Allow request sockets to be
relabelled by the lsm.").

Commit 284904aa7946 ("lsm: Relocate the IPv4 security_inet_conn_request()
hooks") fixed that kind of issue only in TCPv4 because IPv6 labeling was
not supported at that time.  Finally, the same issue was introduced again
in IPv6.

Let's apply the same fix on DCCPv6 and TCPv6.

Fixes: e1adea927080 ("calipso: Allow request sockets to be relabelled by the lsm.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/ipv6.c       | 6 +++---
 net/ipv6/syncookies.c | 7 ++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index c693a570682fb..6f5a556f4f6d7 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -360,15 +360,15 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (dccp_parse_options(sk, dreq, skb))
 		goto drop_and_free;
 
-	if (security_inet_conn_request(sk, skb, req))
-		goto drop_and_free;
-
 	ireq = inet_rsk(req);
 	ireq->ir_v6_rmt_addr = ipv6_hdr(skb)->saddr;
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
 	ireq->ireq_family = AF_INET6;
 	ireq->ir_mark = inet_request_mark(sk, skb);
 
+	if (security_inet_conn_request(sk, skb, req))
+		goto drop_and_free;
+
 	if (ipv6_opt_accepted(sk, skb, IP6CB(skb)) ||
 	    np->rxopt.bits.rxinfo || np->rxopt.bits.rxoinfo ||
 	    np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim) {
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 5014aa6634527..8698b49dfc8de 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -180,14 +180,15 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	treq = tcp_rsk(req);
 	treq->tfo_listener = false;
 
-	if (security_inet_conn_request(sk, skb, req))
-		goto out_free;
-
 	req->mss = mss;
 	ireq->ir_rmt_port = th->source;
 	ireq->ir_num = ntohs(th->dest);
 	ireq->ir_v6_rmt_addr = ipv6_hdr(skb)->saddr;
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
+
+	if (security_inet_conn_request(sk, skb, req))
+		goto out_free;
+
 	if (ipv6_opt_accepted(sk, skb, &TCP_SKB_CB(skb)->header.h6) ||
 	    np->rxopt.bits.rxinfo || np->rxopt.bits.rxoinfo ||
 	    np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim) {
-- 
2.42.0



