Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19993FC5A6;
	Wed, 20 May 2026 18:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301413; cv=none; b=Le7Z4RCWXY/5YNOizDimI4uOvP3dxXK9qc6osH+rTY9HBTsGBi625RN1UoO18932sYEukvhYADOpLJYWpU/mhnlaXJbaQttFSC//rzc2sqcG3VEX1Hut0F64gPXNPxyPVIWJgGRCr+m8L9XD0zu/HmSvQo7DXa/A2BGvm7YTgyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301413; c=relaxed/simple;
	bh=Bd8jklfnL8wHMWT3Wl694J8bJtgJDqyM25cB8rDla+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjUu+5gfByU3OMolpFQfcL2pkqY3RUCq94JdkqY5QNn0/gu5LhKajlwwc+jIRTldwR8KBCO7QirlnPtJMyWuC/HfgHGHPSu43N5QHErSdfx2YloD21F7HGjPYhsCd4xX8C1ZmWi6meYxfifaUl/Mt5EG5bLAKhJUcrOMUD6+al0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFs8A7Py; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFs8A7Py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD46F1F000E9;
	Wed, 20 May 2026 18:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301412;
	bh=ORGRiS1oY7/cKv6IXoWztq/LeXX/RebL6fkNpH2V4f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFs8A7PyRAcOlSvxhyBHW4HVIgIS5u09CyxgOaeZcC/M4erX5bTD8c+0B8vOSbGYG
	 0iVvQoLb3LU96FlbDqnB7ahgiWGqKcYS1Oq+bXNswQgF6XDNlpGk05q7lbNrcANWBc
	 paTnTX7NUF7tBdb8qn0dSOW6xytRreelMXIU8CCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Altan Hacigumus <ahacigu.linux@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 545/666] tcp: make probe0 timer handle expired user timeout
Date: Wed, 20 May 2026 18:22:36 +0200
Message-ID: <20260520162123.083914611@linuxfoundation.org>
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

From: Altan Hacigumus <ahacigu.linux@gmail.com>

[ Upstream commit 2b9f6f7065d4cfb65ba19126e0b35ac4544c3f3a ]

tcp_clamp_probe0_to_user_timeout() computes remaining time in jiffies
using subtraction with an unsigned lvalue.  If elapsed probing time
exceeds the configured TCP_USER_TIMEOUT, the underflow yields a large
value.

This ends up re-arming the probe timer for a full backoff interval
instead of expiring immediately, delaying connection teardown beyond
the configured timeout.

Fix this by preventing underflow so user-set timeout expiration is
handled correctly without extending the probe timer.

Fixes: 344db93ae3ee ("tcp: make TCP_USER_TIMEOUT accurate for zero window probes")
Link: https://lore.kernel.org/r/20260414013634.43997-1-ahacigu.linux@gmail.com
Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260424014639.54110-1-ahacigu.linux@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_timer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 79064580c8c0d..0cc8f19bc1024 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -49,7 +49,8 @@ static u32 tcp_clamp_rto_to_user_timeout(const struct sock *sk)
 u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
-	u32 remaining, user_timeout;
+	u32 user_timeout;
+	s32 remaining;
 	s32 elapsed;
 
 	user_timeout = READ_ONCE(icsk->icsk_user_timeout);
@@ -60,7 +61,7 @@ u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 	if (unlikely(elapsed < 0))
 		elapsed = 0;
 	remaining = msecs_to_jiffies(user_timeout) - elapsed;
-	remaining = max_t(u32, remaining, TCP_TIMEOUT_MIN);
+	remaining = max_t(int, remaining, TCP_TIMEOUT_MIN);
 
 	return min_t(u32, remaining, when);
 }
-- 
2.53.0



