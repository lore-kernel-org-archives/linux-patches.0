Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624574;
	b=NwIRlbVjx3QYRTKATI3N+ZQYjrEWdVCEPO3JTdyxdxG/IASL9Ypf9hg1zItxvPlnezBD
	 5tVjoaCMwJLiozLE0JCTlsEONsLzuXtvQGyISYidDZP4Pvk+mXM4pRkj9xIs5AFji9bd+
	 FuTP0tOOQdglGpFjAAgU5KxyOFDOkxegoVTlEYqrLltHse2m82PYzVW7RivF+lU3mxdlG
	 6BgV7mGOoQWZgEoUsQkOSRNfwn+S/aoX607kBlaORfmMYOPVDdlDlKU+z7r4lv4hI2npU
	 rV8Nrk5/yWhB1xZOEnAaBgschABfEnZpsAq4CZ51aRRPiD9xDLq0f/+EyFeLGGCOC1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b9qoVNwS4KsmT4uCv57HBxnq/GzZdw+ahMX+r0U1P6A=;
	b=oTvKwh5JE2IlGKnLXCI2MGxCfHZcgHXR29W1Vq1HoJ0HPJt7d90vp/tJvqfrr0SAuORN
	 zO8lRL33VHFe5O6yVgEpI2xFjRv+N19OCRXFlfn2hEXdPejax6s9LkAHs0kuwZNq8WTsv
	 wZmQsfdyUp22EyUxAoj4FFiFh6BEQ5d5JoV4FS2dTaiNpE0ZLapsTLFTfHgvpfEwKntYr
	 gEZNA8e99ttKeSVZ16R46MMDwsMkjVJaZ9iEsVPTzrKnCVlfpM5kaBtNZ1xJG0ZGIWX7u
	 RQnPu+bw+5ErOnVPp2BiEKvNiHa1KqFkX1yobyHYOOVWawHrnQc42z0KGhRW45KGF2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onQsQIXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6FE606A33A;
	Wed, 25 Nov 2026 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onQsQIXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3289D1F000D4;
	Wed, 25 Nov 2026 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624573;
	bh=b9qoVNwS4KsmT4uCv57HBxnq/GzZdw+ahMX+r0U1P6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onQsQIXh6jZh+MA/pPgCyWob7mXtQFG67GZIhb0UqHOvDXnbYTxxuzcen481EtlHx
	 yX4mawkSpYy1VyMlmJkyyoQOs9Dz5dAPZf+xFBmKqDzYRLqVa7XUVbiIr5QpsHDd3g
	 3vcoiApY1DJuAJcYGUszs+pXhVVdoyts7FIi/7KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/816] tcp: ipv6: free ireq->ipv6_opt after an RCU grace period
Date: Wed, 25 Nov 2026 15:29:46 +0100
Message-ID: <20261125143854.718166235@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit fafbc4051123d5459ea6950899cec08ed946e278 ]

ireq->ipv6_opt is only set by calipso_req_setattr(), when a CALIPSO
NetLabel mapping is configured.

Request socket migration (net.ipv4.tcp_migrate_req=1, or a
BPF_SK_REUSEPORT_SELECT_OR_MIGRATE program) clones the request
socket with inet_reqsk_clone(), so that the old request socket and
its clone share the same ipv6_opt, then reqsk_migrate_reset() clears
the pointer in the old one.

Another cpu holding a reference on the old request socket can still
be using these options, sending a SYNACK from tcp_v6_send_synack()
or creating a child in tcp_v6_syn_recv_sock(), when the clone
is freed. tcp_v6_reqsk_destructor() frees ipv6_opt with a plain
kfree(), leading to a use-after-free.

Both readers already run under RCU, like their IPv4 counterparts.
Use kfree_rcu() in tcp_v6_reqsk_destructor(), as commit e3f33b0a1d89
("ipv4: free inet_opt and ireq_opt after an RCU grace period") did
for ireq_opt.

Fixes: c905dee62232 ("tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/179369559062.488856.15441115725436277776@kernel.org/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Tested-by: Linkui Xiao <xiaolinkui@kylinos.cn>
Link: https://patch.msgid.link/20261103090011.4128420-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5bd82a5d87960..431d958272b8d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -575,7 +575,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 
 static void tcp_v6_reqsk_destructor(struct request_sock *req)
 {
-	kfree(inet_rsk(req)->ipv6_opt);
+	kfree_rcu(inet_rsk(req)->ipv6_opt, rcu);
 	consume_skb(inet_rsk(req)->pktopts);
 }
 
-- 
2.53.0



