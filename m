Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044709;
	b=R1VgvvhItx6CQh2EQQ7quYzkwXbaLr3TQWtVRP6VwrnnDi84F2F5tZjyM8u4/Au7wQgD
	 ZholNdmpq23HFrYrbDJNeOo2sHtf6zbzWNllRQ6kh9ams+gbx936J6TV58YFb0iOG7HmJ
	 XEYmPvWIWphHgj6houG5vActZoouQJlyUZu+Meb821ejN8B2TIluJFyQI8wSO9tCZqhXV
	 LaKDSZype9BNM6ZNNdXO5JfZGk3GExyPooXJ4YKXTXN+3F21XrdEU9iEwhHQrsR7J5k38
	 5HG9EZ7t5sYPU9ke/jakjd1SwPot0wB1lFozF02ZvcegQ80QESrG3aPMbMwcNtTiqUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uOzjii382DdQ8u9jgD+P4gJzhwUkR1ZTdUwue28hwNI=;
	b=bNW5QIgy1Ovz7oYkKL2dWL8fBoiUqdZ3n799baR9nG29GUyTAphQ9vVc9z9ou7VQj4oo
	 g0FUW0bS2zmFDKlfXhAc4m6VkTsGKnKI7o3lUYWWcZtnicMVlnLuiC3o7Zu2IsJy9Aazv
	 AfxZTIy0EjiF547lDnFuQWie+TrsfDYclXYOSxiO37jbl5x74DhyOsvSaWzldCzuIkATw
	 xfeawuPRrLXArbCxGpnmfBkm8z5+TjVFyPZTJnZYJKYsQ3rqXd6WF2TTLmUIJRmtMnYfG
	 Wo9UNNkUHichQrSWgV9mKkFxgetufzfmt/EbeNinitR5AeQ+zCVWqf1BV03n78Go97Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fc4Hsfow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324EE606A325;
	Wed, 18 Nov 2026 23:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fc4Hsfow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8708F1F000C4;
	Wed, 18 Nov 2026 23:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044709;
	bh=uOzjii382DdQ8u9jgD+P4gJzhwUkR1ZTdUwue28hwNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fc4HsfowEGY73qMnonU2ijJgGRbmmmnBfkHZHwLOFSFEEoVZ6CV9V22G/qJy69NNb
	 7NbqGF5l3Vlv4bR7dIv6W9Gz7GiSsylY9tzW0XlRFmKc0Quhtb1L/UmBe0BLZghzww
	 Uk8fONfMUChOS7XDCj0Zn7dMk0BLO8P7GvdXgJ+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 0662/2857] netfilter: conntrack: always lower timeout for non-closing RST packets
Date: Wed, 18 Nov 2026 15:28:16 +0100
Message-ID: <20261118150225.388165411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 73df81b38cb7f70a347a97370386378a86e53019 upstream.

The existing check might extend the timeout if the ESTABLISHED timeout
has been tuned to be lower than UNACK via sysctl. Reported by sashiko.

Fixes: bf80e6802273 ("netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1334,7 +1334,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else if (unlikely(index == TCP_RST_SET &&
-			  new_state == TCP_CONNTRACK_ESTABLISHED))
+			  new_state == TCP_CONNTRACK_ESTABLISHED) &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&


