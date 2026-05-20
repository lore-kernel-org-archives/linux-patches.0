Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64673E120A;
	Wed, 20 May 2026 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296837; cv=none; b=G6HQwfFrzvcuIqBSSZAiNoUSYAE4N91mc3o5yg9bXQuQr/J+QQ51WLhj0U/7lN3HdwEcZJszLQDUFS9ZDAfBACAeH6grN06zMW5X4uWOg+XyR0TVqhdKZW0djd4XrjKPBC/4f6QOag/wDOLWz62I+cHDq7AN0KZc61f1ryNZnLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296837; c=relaxed/simple;
	bh=56pwM5rWVhP5bXdM8xvP+lKxFcsDqx5Rf1QWtViqiSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8IbQcuWH+TpSgPtQ2hEM06Wc5A0z8CJzELtZ2BFCa4qypxmDkNdvYiAXur45bY0K8NuYvfW+40pmvS51bVFwOdXj7cJFdje3Xk6FTmD2oaMrWX0dxavccrnRXLimaCEfj/O/A3Vf+40OkRz9W2kGGOBcrqV+JtvA6kBzfPOits=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeW5Kcqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeW5Kcqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1410A1F000E9;
	Wed, 20 May 2026 17:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296835;
	bh=XuIylzQnWMSbLaf2LRDewZ2a6PS/pZJUp847g8mqXpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeW5Kcqzzss5RI15sYflYQdVjuyfiUU+7zx/CZJodtq2eQNLv0deIcTM8fQQotmUc
	 1gRBoHLN7HoasVpMfV0gwNSo5CtoQf/MvrG5qrzUsgGD24G0CNj0bpMheuIKooUFye
	 DXFWEgdh8Ua04S5+IGwgx6v82lZ5X+wL7OkRvvfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Altan Hacigumus <ahacigu.linux@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0949/1146] tcp: make probe0 timer handle expired user timeout
Date: Wed, 20 May 2026 18:19:59 +0200
Message-ID: <20260520162209.710385689@linuxfoundation.org>
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
index 153c5888580ca..61631a2dcea7f 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -50,7 +50,8 @@ static u32 tcp_clamp_rto_to_user_timeout(const struct sock *sk)
 u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
-	u32 remaining, user_timeout;
+	u32 user_timeout;
+	s32 remaining;
 	s32 elapsed;
 
 	user_timeout = READ_ONCE(icsk->icsk_user_timeout);
@@ -61,7 +62,7 @@ u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 	if (unlikely(elapsed < 0))
 		elapsed = 0;
 	remaining = msecs_to_jiffies(user_timeout) - elapsed;
-	remaining = max_t(u32, remaining, TCP_TIMEOUT_MIN);
+	remaining = max_t(int, remaining, TCP_TIMEOUT_MIN);
 
 	return min_t(u32, remaining, when);
 }
-- 
2.53.0



