Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA0F12C48F;
	Tue, 30 Apr 2024 10:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474148; cv=none; b=M2dmwqByhFuRriRfpggZCT6gbuK1GsLY9fHo/2279GqifXHrxjtC9nUpHfqeyhBoL9oRCx3RMI/ldjVTOcE95r4427OgM3Rihg3a+/jycAaRUnH2oNiF8mzxyMfaDIexdMnM9U9PxpOhctA2Ro1fOrFSIpqaqaFniQo5oXaWzdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474148; c=relaxed/simple;
	bh=uHB+PtxkCefDm/hHieWi0SffDjYUaS2RyD2xwKlcrTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvQ6fV8BzYjJzvDL6XS/KxX1dxEt6gtwyfMuv/v3b4VvIBvkdYzCLAFV3UFfGKFHR4cSqRrYwXzUqRa3kaF/a3wOrHlkJ87t976gZC+2JGDBZ3zDZiTsEbLuiXaTVrB/UlKkH03GHat2XThqijukz08b7wxKTre6bXX+et1/A2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8VEg1aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8VEg1aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEE8C4AF1C;
	Tue, 30 Apr 2024 10:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474147;
	bh=uHB+PtxkCefDm/hHieWi0SffDjYUaS2RyD2xwKlcrTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8VEg1aNNm5xw8wsO1er7VIjYiQF3rMTh0Olza63zUC3DLbxgl3PAgrZhwK+wKXTM
	 xS6eNlHSC8PrAlBVDdUYlY0O4yxI0/aeLb5g5w5muhekCQI6BwvONdlDRM1yptuGUj
	 Pmhyrc5su39mRR0eIcJmjJbZFZS6Bb3U2IcwuGJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Eric Dumazet <edumazet@google.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 071/228] tcp: Fix Use-After-Free in tcp_ao_connect_init
Date: Tue, 30 Apr 2024 12:37:29 +0200
Message-ID: <20240430103105.855651018@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 80e679b352c3ce5158f3f778cfb77eb767e586fb ]

Since call_rcu, which is called in the hlist_for_each_entry_rcu traversal
of tcp_ao_connect_init, is not part of the RCU read critical section, it
is possible that the RCU grace period will pass during the traversal and
the key will be free.

To prevent this, it should be changed to hlist_for_each_entry_safe.

Fixes: 7c2ffaf21bd6 ("net/tcp: Calculate TCP-AO traffic keys")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://lore.kernel.org/r/ZiYu9NJ/ClR8uSkH@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ao.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 87db432c6bb4a..254d6e3f93fa7 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1068,6 +1068,7 @@ void tcp_ao_connect_init(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_ao_info *ao_info;
+	struct hlist_node *next;
 	union tcp_ao_addr *addr;
 	struct tcp_ao_key *key;
 	int family, l3index;
@@ -1090,7 +1091,7 @@ void tcp_ao_connect_init(struct sock *sk)
 	l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
 						 sk->sk_bound_dev_if);
 
-	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+	hlist_for_each_entry_safe(key, next, &ao_info->head, node) {
 		if (!tcp_ao_key_cmp(key, l3index, addr, key->prefixlen, family, -1, -1))
 			continue;
 
-- 
2.43.0



