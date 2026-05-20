Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D189347515;
	Wed, 20 May 2026 18:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301166; cv=none; b=ZRRi2GtVpGehn8Qp4fCSOAWqHBNMW1cEwVX91NRTvsjgX+QbIjh488reym7ULY8kZjioK5b6sWPI316ufOMURK/KPy/cuCUvS+VYRkTMRUKZwI9dNHgVaK5nNDYd6C+kfWs1U++ImoJUiCsqa191RPmh6OCJAdxtjEe/PkeEI4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301166; c=relaxed/simple;
	bh=pouCNr7CdaqQrz4AjkMLHVWTdT6eiAIIxc2qEpZEzYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Po75EI/Cni+qIqxr/VhP6P8BbUxoxwCjIKKVO0BfSpsw92imT/hFuNhT21ZjmxcOvdlX7mz5KhQrF4ROOQdqcrKjYvXNWjI+QWcvj/T/RHv0dnDw18x/4vUTgzDFXiXwesWsK+0fo/IfrdBDKlWfsb92x53Hj/iyoRD9T9vkWnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6WhDR/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6WhDR/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE291F00893;
	Wed, 20 May 2026 18:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301165;
	bh=kgMKQrHKLv/P6hB/0dv3qtJPyWJsUhisOJWQ6UD76SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6WhDR/11O8KbuO5LoWidDP999X4afEj/aphDM31v0wul6AW57TadM7o8bnV04Ip+
	 hcpvui7d4XS6GXlseYomp+HT9sbSfs5uorFUsTwvR7JXktaXx2s7jPDua3W3GkTJu8
	 41U2M0bHAhfzGYSeMQYrtH2ZhhPwnGMbgC3V6oos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 451/666] tcp: annotate data-races around tp->bytes_sent
Date: Wed, 20 May 2026 18:21:02 +0200
Message-ID: <20260520162121.045334085@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16ee72717e039..08678dd21950e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4302,7 +4302,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_una)));
 	nla_put_u8(stats, TCP_NLA_CA_STATE, inet_csk(sk)->icsk_ca_state);
 
-	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, tp->bytes_sent,
+	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, READ_ONCE(tp->bytes_sent),
 			  TCP_NLA_PAD);
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS, tp->bytes_retrans,
 			  TCP_NLA_PAD);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 59a0ef96b4d85..5d1aa41592720 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1448,7 +1448,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
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



