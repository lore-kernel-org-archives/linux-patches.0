Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407536FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5CAC433C7;
	Sun, 17 Sep 2023 19:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980208;
	bh=QoMy6hAzx2AtxZOxJL87yM76XEFe735vEhjVxp/v2U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdUrziZEiznSL3wCyfB+LtYGtolBW07GrK3zmhpzKGKZEl+9U5XK0fThdRRm4Avec
	 HE/wZHIdxgaEFDdDQGu1SQOMV1Zb9VILJd0rzl9ejyu2XmXQk9r3W3iZ8NPC+TmWcA
	 OTHK9zCanQHZkgMANZjLLbCg8YW5vKVll8mKrH/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yangbo Lu <yangbo.lu@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 123/285] net: annotate data-races around sk->sk_bind_phc
Date: Sun, 17 Sep 2023 21:12:03 +0200
Message-ID: <20230917191055.921019545@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 251cd405a9e6e70b92fe5afbdd17fd5caf9d3266 ]

sk->sk_bind_phc is read locklessly. Add corresponding annotations.

Fixes: d463126e23f1 ("net: sock: extend SO_TIMESTAMPING for PHC binding")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 net/socket.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index fea5961c51fd1..0a687c8fbed7f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -894,7 +894,7 @@ static int sock_timestamping_bind_phc(struct sock *sk, int phc_index)
 	if (!match)
 		return -EINVAL;
 
-	sk->sk_bind_phc = phc_index;
+	WRITE_ONCE(sk->sk_bind_phc, phc_index);
 
 	return 0;
 }
@@ -1719,7 +1719,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 	case SO_TIMESTAMPING_OLD:
 		lv = sizeof(v.timestamping);
 		v.timestamping.flags = READ_ONCE(sk->sk_tsflags);
-		v.timestamping.bind_phc = sk->sk_bind_phc;
+		v.timestamping.bind_phc = READ_ONCE(sk->sk_bind_phc);
 		break;
 
 	case SO_RCVTIMEO_OLD:
diff --git a/net/socket.c b/net/socket.c
index 6bba7818b593d..b5639a6500158 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -935,7 +935,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 
 		if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
 			hwtstamp = ptp_convert_timestamp(&hwtstamp,
-							 sk->sk_bind_phc);
+							 READ_ONCE(sk->sk_bind_phc));
 
 		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
 			empty = 0;
-- 
2.40.1



