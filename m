Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFB4143C55;
	Thu, 13 Jun 2024 11:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279817; cv=none; b=Tqjgeg2ZWkf50hz2XwFEy6DnnC7lLidqwWxZMCFXthVOINV7JGYiA1HrqeYCMUIpZBPd8Pg89v81oEoxfm7/WfbMuKDJbq3dNbQTrGCQXqI0eBR2tso25mNpcZS5vSoX50Ljhi2mV9wUaHV9i/V8J4AQNWTm0IEstQCIgDHM7Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279817; c=relaxed/simple;
	bh=1SJR4crF0L5xjC3dyr/6/nXFRSugH/kCkVexHIMoD1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPTS4raT/Z4v00jbD1P0xw7QgDWEYTO9ENRAL3o2fuNRUHQtCmKD/0kxyGw+SsFe+4PuUkL99BV+ftffbe2lilHfiv4byVCcC2/mjoJdzZ73uJnTOaAPSZdurQa588kb94/fw6tfQ2P0smY4/tnAgmISD8aIwrSQtRxzkWkaETw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GISTYUFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GISTYUFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7FEC2BBFC;
	Thu, 13 Jun 2024 11:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279817;
	bh=1SJR4crF0L5xjC3dyr/6/nXFRSugH/kCkVexHIMoD1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GISTYUFZFBZ3hhjtXCYgU27DsOGc1KNst4iKjw5v8pWxjl/3RMERbB+/RutV5oJ/c
	 rIvFqTQP9BOFPrs+7Sy/mAt+hEUzwj+c+3AoST0bfTi1cppX9x/WX6duAO1qb0nNlZ
	 5Z65g0wiKsKwoRneaCHf/QRSAimGw+opS35NgSuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Wei <luwei32@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/202] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
Date: Thu, 13 Jun 2024 13:32:24 +0200
Message-ID: <20240613113229.549428726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit ec791d8149ff60c40ad2074af3b92a39c916a03f ]

The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
in tcp_add_backlog(), the variable limit is caculated by adding
sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
of int and overflow. This patch reduces the limit budget by
halving the sndbuf to solve this issue since ACK packets are much
smaller than the payload.

Fixes: c9c3321257e1 ("tcp: add tcp_add_backlog()")
Signed-off-by: Lu Wei <luwei32@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ec00ed472bdb ("tcp: avoid premature drops in tcp_add_backlog()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1567072071633..d29d4b8192643 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1781,11 +1781,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	__skb_push(skb, hdrlen);
 
 no_coalesce:
+	limit = (u32)READ_ONCE(sk->sk_rcvbuf) + (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);
+
 	/* Only socket owner can try to collapse/prune rx queues
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
+	limit += 64 * 1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
-- 
2.43.0



