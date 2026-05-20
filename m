Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF123EC2DB;
	Wed, 20 May 2026 17:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299034; cv=none; b=j8hThviCFwkWjMBTskG84GFDAdR8UzYObQgil1bYxBEf/KI9td5iRw7dtkHZe5DntiUDS/eDcyrnc8VtfC26PeV2T68xUggeL768Nwqo7mNtWmBMRNxY/xKjauieFGH7s3ZHWTTsXsavIqCZlNvMa1O+3FyyP6gHTCu1aIRX7tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299034; c=relaxed/simple;
	bh=cm30XwlV/RcgDIy6cqgVsWKj7cUqVU0gLMh+hKZT15U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzT3bSbtvyc2uHNE2Y8CLsGULgJC1O3m2yMEQOE9Ld6wkXOEnQSPJSVtTRg50eK+n4Q+oPbc0znTXf4/836W5oM+1cYk/DkvHtWeUjCY9KQJl2K7WN0AFFvuZhXR1Hs+0GImKb/rJbJvszJ4REnKs8wsY6UybiJCqPjed0qDgkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCDWwneI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCDWwneI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BAF1F000E9;
	Wed, 20 May 2026 17:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299033;
	bh=SKIB3zSq9VL4+RWFaReqy5vPXXuEu0bvjOyxLVxhUjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCDWwneIfKiKrfxY+p79M/keQ2ausoB7yKP0kbt+g4xrZmsGaaCIqsbsGRLsEoneK
	 P4h6fHvalx0UEF6DdKDRcb4iF4wsj9JAiGxB68qd25yjVt0fBBaqOnIMKZeiNIxRze
	 xaguOHhmviAz32+MTKS0eouPDXRF8W9u9BiRe6oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 637/957] tcp: annotate data-races around tp->bytes_sent
Date: Wed, 20 May 2026 18:18:40 +0200
Message-ID: <20260520162148.343297727@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0d6e991155c95..7d45a2aab18dd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4413,7 +4413,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_una)));
 	nla_put_u8(stats, TCP_NLA_CA_STATE, inet_csk(sk)->icsk_ca_state);
 
-	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, tp->bytes_sent,
+	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, READ_ONCE(tp->bytes_sent),
 			  TCP_NLA_PAD);
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS, tp->bytes_retrans,
 			  TCP_NLA_PAD);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e6aa54d2335c0..c2492f4be2151 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1605,7 +1605,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
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



