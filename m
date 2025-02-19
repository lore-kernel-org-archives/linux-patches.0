Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA06C1DE3BE;
	Wed, 19 Feb 2025 09:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955851; cv=none; b=apwoCzmcC1jMUw4nqNsU/RD2em+Tdy/Sks24wnFxh3ap4bqjm+Gi1ziIy0eDQZEpfwnU4t5usHScugFRFhiYIUqxPbGaW5JhdvVrCbz+zjrw3XRkw0brpvq9yp3HM4+R4FOl6HtAnTItNfdL3q3BqUsRcK/1ufQr1rzrLtSuVxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955851; c=relaxed/simple;
	bh=LBXayI0LbZL+pySY1u7h1ICCFFshJbBFODVYBGfmMbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNJKKbSH2k9Ta+wL2ImJAVM8GjJ2+rB/aGDmV6dFYEavrZmRhqcuz7zq/3i9Tqhck4bTmJ+WbHq4f9EhDNOhOlFjheTjqCgs7UMwJGv5m6Cyo04W9+mcsT2sgH03fFilv7AM9UUN/kir++tC/ntp6coMQoMdjbzOkxeyNl3CsYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwgROsLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwgROsLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49022C4CED1;
	Wed, 19 Feb 2025 09:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955851;
	bh=LBXayI0LbZL+pySY1u7h1ICCFFshJbBFODVYBGfmMbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TwgROsLOd+iZUWciOl3KlHtrab3UqwDuwqyrymyDQkT8a7aZRmVYCm7mLvdM1Wq3Y
	 bngheQjkeInZ0Xc/SXw/Twahx7Y5qslfx+MzCxYduLNlH2PehUoD04tSOFzJbHDzrq
	 r2U1V4UwyyLACAemmf3Z/Ax1rr8QjDtDvRUnAHnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/152] ipv4: use RCU protection in rt_is_expired()
Date: Wed, 19 Feb 2025 09:28:36 +0100
Message-ID: <20250219082554.134386019@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dd205fcc33d92d54eee4d7f21bb073af9bd5ce2b ]

rt_is_expired() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: e84f84f27647 ("netns: place rt_genid into struct net")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 15cf2949ce951..c96837e6626c3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -393,7 +393,13 @@ static inline int ip_rt_proc_init(void)
 
 static inline bool rt_is_expired(const struct rtable *rth)
 {
-	return rth->rt_genid != rt_genid_ipv4(dev_net(rth->dst.dev));
+	bool res;
+
+	rcu_read_lock();
+	res = rth->rt_genid != rt_genid_ipv4(dev_net_rcu(rth->dst.dev));
+	rcu_read_unlock();
+
+	return res;
 }
 
 void rt_cache_flush(struct net *net)
-- 
2.39.5



