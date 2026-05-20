Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A293EAC8F;
	Wed, 20 May 2026 17:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296405; cv=none; b=fCM/JQ5xQenJWjSqywlgi4YfvBAdCDZm4JCASmqAO4MBl3GsBXugA5L5bQrzfR1GIkuylCG6a+0gwj8ExwVxFMXaowogPdwnOBrpApAdhOHyje+OhC/L0uR9CQ/TSPH0ydHkBkK+/zYQMJdJoW3yyqkwP5pB3juwrxazvzfRwOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296405; c=relaxed/simple;
	bh=TuLFmc5O/HpcCuQwijmqYzdYL70aHnQcYOqEshWxNOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJJUsA0aVRTFxHj9hFVGZETn3W1AIzD7wdMX+DzJLaPYGgOosTI0naT1zIEbAU373F1pRA0YYtsyD6qh+LGO9wPPUOpKbrxsJpm5afVfcu2N3qOKQkBs5DYy0iI/u8yUT8GDDY7fxTfcn9mVbZ0o4lPgDTeRXQ+zuBUKDfxLJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewFrQVra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewFrQVra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016071F00893;
	Wed, 20 May 2026 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296403;
	bh=FW/6J8V8eJ3VmT3GG3XG0Ey1L0P4RlQGstAddP6UO58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewFrQVraXxZ4ZywfuwET0CnqiGgaw+2YTfYFUiDl+RIIGBBs/ZGnGAPK6xRHrMPbk
	 E7n6oclys0zeJmaRcJON9GG1yzu3mYdVi+o9i7ku8vAq8YsSF7I6XdbtyQKgeUsGSE
	 TE3p8XJzOK18S4Wpq8aDqmQpIG1nzLdQnCk+PxpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0787/1146] tcp: annotate data-races around tp->bytes_retrans
Date: Wed, 20 May 2026 18:17:17 +0200
Message-ID: <20260520162206.032868344@linuxfoundation.org>
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

[ Upstream commit 5efc7b9f7cbd43401f1af81d3d7f2be00f93390d ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: fb31c9b9f6c8 ("tcp: add data bytes retransmitted stats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c        | 4 ++--
 net/ipv4/tcp_output.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 10c36a68de4b1..368b576cfe369 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4497,8 +4497,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, READ_ONCE(tp->bytes_sent),
 			  TCP_NLA_PAD);
-	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS, tp->bytes_retrans,
-			  TCP_NLA_PAD);
+	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS,
+			  READ_ONCE(tp->bytes_retrans), TCP_NLA_PAD);
 	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, tp->dsack_dups);
 	nla_put_u32(stats, TCP_NLA_REORD_SEEN, tp->reord_seen);
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2c9ca89aa9e50..51e7f40e7e313 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3627,7 +3627,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
 	WRITE_ONCE(tp->total_retrans, tp->total_retrans + segs);
-	tp->bytes_retrans += skb->len;
+	WRITE_ONCE(tp->bytes_retrans, tp->bytes_retrans + skb->len);
 
 	/* make sure skb->data is aligned on arches that require it
 	 * and check if ack-trimming & collapsing extended the headroom
-- 
2.53.0



