Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624695;
	b=wtkqtSK2Yh6AtsZS9FN0sdxpMHdC4gnnNAZd8+T02U29Nhsycg786a1mkvlFxSmigp/O
	 k0HRBcz/sLtp/4B/2V52Yra/jMfFmGVZF3yZE4NytWf+WrcS0m0ZthBZW3sBYT+XNqXig
	 p9TPlDhq3a53E7pGPlGrLMZVtNHWSY5m1ZxhWh/PRDIjOzDKZBWbPJdsVxhqbBVKzryg6
	 N7lEVrooyrb8L12I4BMhqnAs3Wvx3otzzR5fg+bRQpLf9DRaZXh7FMdgrc94k8vqFPudv
	 Mk3HiERBprJbZDF/E17n4pgACy/DjHq5thLavsgNe1GttKrFJubzpfTREr1v4Mdd2pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Roaxm81J4+fQB4eebeAnU/yq0ub4wGo3zdhurn60RHo=;
	b=whkYCJvPfU1mnBlThHjgatT7eMfz+BfD3xcSO5d1tiAf3vlSa4e8GIc2m9PlCkJKoJG1
	 s08p7TomsSutV9St9AJ+y2TSeLVr+DiW+taXk25cgZQ17n9NLK/q7/mmXq8FcqhQhy5dQ
	 WjhllIMjwCc5bXdiw3zwl62/dHiJFqx8oXeUMscrOKaKFFLgx+0TkH1oAWWZRcvgcUCjg
	 chSVY1pXd4xoa3741xeJg5KudbOXMWezZRlqOxyCslATh7I6xvuVYQF6tbc0b+6obDFTi
	 W5HkXCaOdtrSadUomt+W41S8SxDKWXA8NEwaKHxInnUxdoZSAZcd7mzWVYfeGxzlncA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NAnhVjor;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9DF606A321;
	Wed, 25 Nov 2026 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NAnhVjor
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4E71F000C6;
	Wed, 25 Nov 2026 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624695;
	bh=Roaxm81J4+fQB4eebeAnU/yq0ub4wGo3zdhurn60RHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAnhVjorM7jZkugIIJU2YEAS2cs40uVHaXuy+EC1djZ9BjWARks9vIgv0DcIqXQzk
	 aLkM9rOOewbqrjF09k8DdVu/gza3qVyNILavvkBnMt8znOEh+xoVz/psfLk3VWfRd6
	 Yop9Q2pw2Qi6RWLK8UJBqfKda7raKgRvBETbTrfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 232/816] tcp: initialize send sequence numbers before deferring TFO
Date: Wed, 25 Nov 2026 15:29:40 +0100
Message-ID: <20261125143854.579335572@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 57889a8f6d49fc153aa0017d13086ab736567f8a ]

TCP_FASTOPEN_CONNECT can return from connect() before tcp_connect_init()
when a cached cookie or cookieless Fast Open allows deferring the SYN.
At this point write_seq contains the initial sequence number, while
snd_una and snd_nxt have not been initialized to that sequence number.

Consequently, inet_diag and /proc/net/tcp{,6} report the initial
sequence number as the send queue length despite no SYN or payload being
queued.

Initialize snd_una and snd_nxt to write_seq before marking the
connection as deferred. Both sequence-based queue lengths then remain
zero until the first write starts the connection and runs
tcp_connect_init().

Fixes: 19f6d3f3c842 ("net/tcp-fastopen: Add new API support")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20261102035943.9700-1-qingfang.deng@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index fbcd7d8c8d99e..ac4fa51240290 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -455,6 +455,8 @@ bool tcp_fastopen_defer_connect(struct sock *sk, int *err)
 
 	if (tp->fastopen_connect && !tp->fastopen_req) {
 		if (tcp_fastopen_cookie_check(sk, &mss, &cookie)) {
+			WRITE_ONCE(tp->snd_una, tp->write_seq);
+			WRITE_ONCE(tp->snd_nxt, tp->write_seq);
 			inet_set_bit(DEFER_CONNECT, sk);
 			return true;
 		}
-- 
2.53.0



