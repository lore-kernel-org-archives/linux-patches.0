Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC293FC5B4;
	Wed, 20 May 2026 18:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302566; cv=none; b=U8uqz8BzFGI3OJCI5JATmKpy9T6+0YlwSe9z2iYXwKf1rXeu4fHh4SMc0/qFTB5DRyvCy8NW7mTNWJRB5pzQ2H0ECW3UAUtw9kQxt7NJW+yGCIyjgB7mz4vdSB2TCMmgFIIBaRg0v9gh5kCaa4EMbbEBEt1RpcyizaTu4gzJMlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302566; c=relaxed/simple;
	bh=jAWFfTx0HXmNtBWloYT+aQWSNJoyI5n7AflS1fb7AaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etNm0luK33tjIbALjCQn8Vox2n6+l0Fj+fujoz60Jao0rWs8KiaFtH6hkBwQ6k3wMsK+QOsu8c9ruu2K2f6/EhvHiwa0NyW+3IGuYHbRaEVGXg8rKZsANXTuruZpxVurbGZMI1wbOI6qStimcDjEh7c1JeXGx4OvvCkPMTb5y6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRY2Bq+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRY2Bq+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3478F1F000E9;
	Wed, 20 May 2026 18:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302564;
	bh=KQNy0Ap4TeMgnXHCTW1otaGU/phiQw9v80Jixw62vr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRY2Bq+yFs+iQ14T+8KrEsnk1/XDRCrQCSTz46DCfvrrA07LTniA1GYMXdUZnl+b5
	 QeotUoIj7vL1W9jaR6Uc1CJxeiWcrGTuSRYlWJnMfkNr2cDLUMMcsOvGZzut9uZAMa
	 U9yJf6jQ5xBiBJlnPkgM4XQlU52WRaqG1gmCO8e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 316/508] tcp: annotate data-races around tp->bytes_sent
Date: Wed, 20 May 2026 18:22:19 +0200
Message-ID: <20260520162105.483753843@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ee43e957ce2ec77b2ec47fef28f3c0df6ab01a31 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: ba113c3aa79a ("tcp: add data bytes sent stats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c        | 2 +-
 net/ipv4/tcp_output.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8187fefa52206..c6b58bbb43c8a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3986,7 +3986,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u32(stats, TCP_NLA_SNDQ_SIZE, tp->write_seq - tp->snd_una);
 	nla_put_u8(stats, TCP_NLA_CA_STATE, inet_csk(sk)->icsk_ca_state);
 
-	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, tp->bytes_sent,
+	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, READ_ONCE(tp->bytes_sent),
 			  TCP_NLA_PAD);
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS, tp->bytes_retrans,
 			  TCP_NLA_PAD);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5e2e14df787d4..1fd807236c651 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1402,7 +1402,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		tcp_event_data_sent(tp, sk);
 		WRITE_ONCE(tp->data_segs_out,
 			   tp->data_segs_out + tcp_skb_pcount(skb));
-		tp->bytes_sent += skb->len - tcp_header_size;
+		WRITE_ONCE(tp->bytes_sent,
+			   tp->bytes_sent + skb->len - tcp_header_size);
 	}
 
 	if (after(tcb->end_seq, tp->snd_nxt) || tcb->seq == tcb->end_seq)
-- 
2.53.0



