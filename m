Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E8C33E36A;
	Sat, 30 May 2026 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161676; cv=none; b=Tz8qErQJfapgyLUTLM4PqCDYx5zXvkpyCf2X1PhB/pCiNBbN7vIGId3gZRBKvEU9Om5c1d9nm8q1W2FCEy7uvfFqfZeF5gw0pVeTnleAylB1Kkl8xyhQM8OQSqctZtJAJUovnpcXyfQUJuzSXRtJpLf9xfpdJd13jYZlfH4x9dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161676; c=relaxed/simple;
	bh=K1pPmuplptRng2H0CV5zU3gY8QTtBXaAP5HbdRjs4Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLnOWmDAPGP/7W+ZVDUBXtd1jGwMZtOUiUdsY16ynLfoT6VLMZV1QQoSBlCWWkPiUIFhJAZHAhZEsIU1j4fN4k821S1xmTZzGCAJOdIA/qYAKmyBElrCEtENxJxQgmCuPbi7+Ejw4ukwHQ2m98rM+Wv8OjES0gO5L7C3WR0zgmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnPIGyR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnPIGyR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010E01F00893;
	Sat, 30 May 2026 17:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161675;
	bh=rRCyWsiKTtboVfzUZZXJEtCDn3Hoh9PN9xsyoCRkGl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnPIGyR7uvuprihSr7UX2A/VToN3p3adwLtYeFgggSN+9GvGP3xdOBr288yHvQxYd
	 4zWlCPOUQAcDPe+WRj/Qs7qMdjsv1THiNQANDpCfjJl5mbjHm2AevI+bQtpIIx1kwe
	 yUdC0p3dw4DgOeRtWPsSbLFoyDciDuKcjl7MeME4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 693/969] tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)
Date: Sat, 30 May 2026 18:03:37 +0200
Message-ID: <20260530160319.647422297@linuxfoundation.org>
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

[ Upstream commit 3a63b3d160560ef51e43fb4c880a5cde8078053c ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() annotations to keep KCSAN happy.

WRITE_ONCE() annotations are already present.

Fixes: e08ab0b377a1 ("tcp: add bytes not sent to SCM_TIMESTAMPING_OPT_STATS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-14-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 518b439531b16..076aa73c99fa8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4117,7 +4117,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
-		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
+		    max_t(int, 0,
+			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_nxt)));
 	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
 			  TCP_NLA_PAD);
 	if (ack_skb)
-- 
2.53.0



