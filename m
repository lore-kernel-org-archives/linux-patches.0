Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E544340293;
	Sat, 30 May 2026 17:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161672; cv=none; b=OGmrqmNj2RbHwHTrkyAMAUosJsn6a1FyXo6UYMz9Gsp7wF0l3Y/2Hflgxx/w5H7hKzxi0sNReG9mfww92pTczvULYH7iZwyb7fbtHFvvqYkQ1PQx2MKQ5xfRklrWSe42Ap5UM9JgOayguNMTnE3CRZ4ArSTS2do5UqGSu6d/MiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161672; c=relaxed/simple;
	bh=/FwmKjk8dw+GRlt9oWkmUOuyBOvTs5hhWGWM3fQbdr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+s6d73SOiMMsS0dsD9oGAO2ovUMW7i+Alh0KK66cwnst6XApaXkGPYxrc7ExhiIdTKZ036a9gLNinqlzZgLBAHy/Rcm3CC9Vd4XlL6/JPqlgPRU8pb4izGuY3kAp85jmyDSUUAZ5icvQP8i/rAWmXhN2KqkehomeqWc59nDO2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM/gDh6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM/gDh6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB78D1F00893;
	Sat, 30 May 2026 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161671;
	bh=6rtIKbK6bd+9zWxnB9J8ZP+2hymc1GQw4JubBYzwp10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aM/gDh6hpCDHzCvlUpJEajxmB92r0+0WCFwmrVfI89yDJTp7uu6zBc8mIwSeFKPcD
	 XWWGIJKSw1G8lAItHoW5UC16dpJ4K+w5jBp8F7KB81qLhjg46zw1+DwHMfJATxq2oh
	 sO7o6P/zNYo4Bll1x551ardBrwJYcVKFaHPDXFFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 692/969] tcp: annotate data-races around tp->dsack_dups
Date: Sat, 30 May 2026 18:03:36 +0200
Message-ID: <20260530160319.619615687@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a984705ca88b976bf1087978fd98b7f3993da88c ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: 7e10b6554ff2 ("tcp: add dsack blocks received stats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-10-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c       | 2 +-
 net/ipv4/tcp_input.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c60f8c69c19f5..518b439531b16 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4112,7 +4112,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 			  TCP_NLA_PAD);
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS,
 			  READ_ONCE(tp->bytes_retrans), TCP_NLA_PAD);
-	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, tp->dsack_dups);
+	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, READ_ONCE(tp->dsack_dups));
 	nla_put_u32(stats, TCP_NLA_REORD_SEEN, tp->reord_seen);
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9b40204248488..645ff379c4254 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1023,7 +1023,7 @@ static u32 tcp_dsack_seen(struct tcp_sock *tp, u32 start_seq,
 	else if (tp->tlp_high_seq && tp->tlp_high_seq == end_seq)
 		state->flag |= FLAG_DSACK_TLP;
 
-	tp->dsack_dups += dup_segs;
+	WRITE_ONCE(tp->dsack_dups, tp->dsack_dups + dup_segs);
 	/* Skip the DSACK if dup segs weren't retransmitted by sender */
 	if (tp->dsack_dups > tp->total_retrans)
 		return 0;
-- 
2.53.0



