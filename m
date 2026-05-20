Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A3B31CA4E;
	Wed, 20 May 2026 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296407; cv=none; b=Is9VChf+1SWryOKgNBsrdBLohch0735DfMez5lgqRGD8AJioXQoYQutGZ2BZB5ZSVSTG3v7CZX4TP9u0aq1Qsfp8odF3TAbj1/ILVk5adauK2MT7LLHB9IHlAScIIPzmb4+Bs7dGCbgqHOsLVie1YYfTpDdGnLEX4AkNYWG5PCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296407; c=relaxed/simple;
	bh=+Wg/3s5ZlnuENRFD5HZajq76WlviFVzM1Bsdy+KCNlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJYKPT9C6HooRg6CYoeIDXQGb8GuKi3ATuQDK4NCMkyoCvfIetsCVC0/gbeMIY5A/S8cxAzfuqOlDiMqhF8GtJQqo1zudueBBQRpeYyRU059IBmdEF4/Xtu+Z3QpjlYN54a6xy0ha6ie2TFV7mebLtgg51nriPQmfnBzJc6fpLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKof5KtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKof5KtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD4E1F000E9;
	Wed, 20 May 2026 17:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296406;
	bh=cFES1C/HBnnIR9mIl2zqatd6CSrJKeyMQxPoURuecWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKof5KtQnwSVrcbAm2A1ZOG5i7FiA6kkMGLToXH5aPy3yhqIResnNJD4xKucIWSGO
	 Efl/mFAhHecuBzTRxjbr+ZMZClG5+VTBmkjAyB+6vewqNI9nofmF3DroUqQc2kzjJn
	 JJ6kBmxPFr5Oi+JT9y2jclvDXmLazc/2/9EKIzLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0788/1146] tcp: annotate data-races around tp->dsack_dups
Date: Wed, 20 May 2026 18:17:18 +0200
Message-ID: <20260520162206.056539575@linuxfoundation.org>
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
index 368b576cfe369..a5231c685f90b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4499,7 +4499,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 			  TCP_NLA_PAD);
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS,
 			  READ_ONCE(tp->bytes_retrans), TCP_NLA_PAD);
-	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, tp->dsack_dups);
+	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, READ_ONCE(tp->dsack_dups));
 	nla_put_u32(stats, TCP_NLA_REORD_SEEN, tp->reord_seen);
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b9bd42f9d08b5..285baeb060a06 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1247,7 +1247,7 @@ static u32 tcp_dsack_seen(struct tcp_sock *tp, u32 start_seq,
 	else if (tp->tlp_high_seq && tp->tlp_high_seq == end_seq)
 		state->flag |= FLAG_DSACK_TLP;
 
-	tp->dsack_dups += dup_segs;
+	WRITE_ONCE(tp->dsack_dups, tp->dsack_dups + dup_segs);
 	/* Skip the DSACK if dup segs weren't retransmitted by sender */
 	if (tp->dsack_dups > tp->total_retrans)
 		return 0;
-- 
2.53.0



