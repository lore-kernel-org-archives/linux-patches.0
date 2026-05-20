Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C723F076F;
	Wed, 20 May 2026 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296418; cv=none; b=jgF2dP9Edg8WB6E47moCvgM5VR5I/paGJE4og/zNbtdvAMiRep8jS4cW/X+iT2rGm4Y2TQI/09eYzoL7QIhICW5sXC4xkPVYFCMxwVnQEeyOUsFfF+vwKJAvQSrjzbXeyuxhXzmtxSMIsI2Gvo9aURYCWH0LITD2kGbTZSPymIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296418; c=relaxed/simple;
	bh=O4h1D0c6cqPKMGJPbE8R4i9sofg0hRfTqtlxEaon82I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X685bXpKuQmrnOizrnH4MV6b8MxGl2hIcqEHfjDmuOdakAB2NVzM4WP8/9VU4NcjmbtZDx0fioRMhRRmUdKu6KIXJ9e3wQpDsWSeslFnQ046yhr5U4FLyEcKZJa+nwjJbLWDMI9eBZhzF5s9P+CBxqJoBKo/abpYywZYkas9dtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+H2Xrgo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+H2Xrgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F51D1F000E9;
	Wed, 20 May 2026 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296416;
	bh=m4of09v7AswZgbtFbhBYH3YbHkGMcVclX+Lkq7iXf0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+H2XrgoB8s8TlzLcDgvLDBgjTG3fih5JlV8p/TuZas1xa9y/e3DP33NoUcsWPCfW
	 SOyRzTzKnaHPASw/yp5XsliT2tHd1OrBBsHlI2Wak9eV8VWxZ/2QG+2VakUR14ndfM
	 Ab5TGjWiK7iStVeHRcU3Lhw8fvgTHP3pxO8ODWko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0792/1146] tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)
Date: Wed, 20 May 2026 18:17:22 +0200
Message-ID: <20260520162206.148653305@linuxfoundation.org>
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
index 60ca350fb5341..c27bee7b31146 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4506,7 +4506,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH,
 		    READ_ONCE(tp->timeout_rehash));
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
-		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
+		    max_t(int, 0,
+			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_nxt)));
 	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
 			  TCP_NLA_PAD);
 	if (ack_skb)
-- 
2.53.0



