Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE21729E11A;
	Sat, 30 May 2026 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166631; cv=none; b=O1AaEXwn2XlljrJ+jxMbL+W9Hd1JqP0eXBsNjfyjxp/7RcCzr6pgRON7GTrRIW7pFzpagR6xTw/ii4ePZgKuinGGI/hLkheImqOuYIKARWxffY48stnhqaQguH0yfC++5HCi88w/kBNjSpOtkAgFPt++8/RAW5zzUnXQKBe9I6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166631; c=relaxed/simple;
	bh=xvo66VrihuWuG1v35OJj5yYWw7fb4zgr1nrAzMAIwFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWi+KPVOX7ImjPaTxeXfKFo6qD/mTbBzYNOJ3BchxuYLNVfhBcxDGdM2v3XMA8oJEuUsqOraCjWNg/EBrzLik2omXp39WJreWFJBxFDLW3PsrjGDHWpYXSsh9Q2U5HLK5ZH6IT3QNnp93vzrlTCkwrXEaJiCsMJkWlGAAYjxLPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ3sShyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ3sShyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19901F00893;
	Sat, 30 May 2026 18:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166630;
	bh=tm3VrYr00zeEfvUdahTslaBmqqyOOzeo6RVJSvtBOCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQ3sShySxPDVuXk3fDzqrFqjA0q6NgUtt7DfSFMErpfntobhGjEkaDUZA3uERlvbM
	 BK9tZ4cEYh6W2abr9n7kZ0k6pzVELG1bbbnNkoEdefmo6Sjr5u9tA+3Xq7j1f1Naoe
	 Y+McOBDZmbrm4am8a9n0k5HJD0P2qLQbtStNvStI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/589] tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)
Date: Sat, 30 May 2026 18:05:04 +0200
Message-ID: <20260530160235.848532379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5998e2b6f5ec7..b5752cdefb4db 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3729,7 +3729,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
-		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
+		    max_t(int, 0,
+			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_nxt)));
 	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
 			  TCP_NLA_PAD);
 
-- 
2.53.0



