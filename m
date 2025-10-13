Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888C126F2B3;
	Mon, 13 Oct 2025 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369927; cv=none; b=cMBYam/AY0YsqJ5k4UGDJt+Qyk1qAs8ZzYV+1kJixchLXaIQMKrf+eQVxSIScwocFS8nsooQOxLEmGXiGylKIWsT8l49FmpKs4Q9OsJb9b4i/CIznMctowLSvQOrfcyoBuJ9fGoXmhQH2ZL2xJ07Cx6gxxLMWC6DmDssa+pWMO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369927; c=relaxed/simple;
	bh=vcBpJlOuhr0FaaQ4q4te8oBoZ72+r2mtmYAwyJzByrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIkPOTsC1p+4YTvn15sAokYRKETtOiiye/Z0v35BV8BIK1SZTePQtXve2sPQ9H0xRyTEppXG15HpV0sJ0RW9xZvbmb81r7zoR2h8lVWdTw1he38TP1+WClU1IePakPI/X4AadQOV4mfbArrx4xnBuWZfpn14ZLdl1bf0hciE09A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2T/V9hKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2T/V9hKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1362CC4CEE7;
	Mon, 13 Oct 2025 15:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369927;
	bh=vcBpJlOuhr0FaaQ4q4te8oBoZ72+r2mtmYAwyJzByrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T/V9hKSmdc7Z5qQcBa42AP5YQNK100KSk3Q/3LRD2aAsZDtua5KdRal+B6olV/Jo
	 TuxkBIsVFly8ZipqSZIaMk+OE0/BSsq5MCxZwgViEJGCDTZ64X1z4XP2mV6e5Gd3aY
	 Vn3JT7QNlK0j0YcYCVoDL6jbPSwza7KlvSPRFqw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 384/563] mptcp: Use __sk_dst_get() and dst_dev_rcu() in mptcp_active_enable().
Date: Mon, 13 Oct 2025 16:44:05 +0200
Message-ID: <20251013144425.185476525@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 893c49a78d9f85e4b8081b908fb7c407d018106a ]

mptcp_active_enable() is called from subflow_finish_connect(),
which is icsk->icsk_af_ops->sk_rx_dst_set() and it's not always
under RCU.

Using sk_dst_get(sk)->dev could trigger UAF.

Let's use __sk_dst_get() and dst_dev_rcu().

Fixes: 27069e7cb3d1 ("mptcp: disable active MPTCP in case of blackhole")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250916214758.650211-8-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/ctrl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index c0e516872b4b5..e8ffa62ec183f 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -501,12 +501,15 @@ void mptcp_active_enable(struct sock *sk)
 	struct mptcp_pernet *pernet = mptcp_get_pernet(sock_net(sk));
 
 	if (atomic_read(&pernet->active_disable_times)) {
-		struct dst_entry *dst = sk_dst_get(sk);
+		struct net_device *dev;
+		struct dst_entry *dst;
 
-		if (dst && dst->dev && (dst->dev->flags & IFF_LOOPBACK))
+		rcu_read_lock();
+		dst = __sk_dst_get(sk);
+		dev = dst ? dst_dev_rcu(dst) : NULL;
+		if (dev && (dev->flags & IFF_LOOPBACK))
 			atomic_set(&pernet->active_disable_times, 0);
-
-		dst_release(dst);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.51.0



