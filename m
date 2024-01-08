Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31FA5101D;
	Mon,  8 Jan 2024 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7m1qh5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14481C433CA;
	Mon,  8 Jan 2024 15:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728298;
	bh=EzhUHVzb5iaF5t6MKgp3eQqXzDOG+Q2DsDDStNJvV8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7m1qh5ds8BthJbIGBRMhqbV4X0wcUIo+Owv9oGOyQ6scI2KGHvvfNQHuUX8c7BUV
	 sviyOrNtKw+U3vgrIC/lOwd75ti5ZHWwpj93HZhVnSoa92aiyiWMQqJMW0C+tCWdVK
	 kWKL+sSIM7iPqYK38uGezuNrNddq0kotPhY4mXmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yangbo Lu <yangbo.lu@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/150] net: annotate data-races around sk->sk_bind_phc
Date: Mon,  8 Jan 2024 16:34:44 +0100
Message-ID: <20240108153512.804313448@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 251cd405a9e6e70b92fe5afbdd17fd5caf9d3266 ]

sk->sk_bind_phc is read locklessly. Add corresponding annotations.

Fixes: d463126e23f1 ("net: sock: extend SO_TIMESTAMPING for PHC binding")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7f6ca95d16b9 ("net: Implement missing getsockopt(SO_TIMESTAMPING_NEW)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 net/socket.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 929055bc0cc7b..49b7f252ddae4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -890,7 +890,7 @@ static int sock_timestamping_bind_phc(struct sock *sk, int phc_index)
 	if (!match)
 		return -EINVAL;
 
-	sk->sk_bind_phc = phc_index;
+	WRITE_ONCE(sk->sk_bind_phc, phc_index);
 
 	return 0;
 }
@@ -1706,7 +1706,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 	case SO_TIMESTAMPING_OLD:
 		lv = sizeof(v.timestamping);
 		v.timestamping.flags = READ_ONCE(sk->sk_tsflags);
-		v.timestamping.bind_phc = sk->sk_bind_phc;
+		v.timestamping.bind_phc = READ_ONCE(sk->sk_bind_phc);
 		break;
 
 	case SO_RCVTIMEO_OLD:
diff --git a/net/socket.c b/net/socket.c
index 9c1fb94b12851..07470724e7358 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -940,7 +940,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 
 		if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
 			hwtstamp = ptp_convert_timestamp(&hwtstamp,
-							 sk->sk_bind_phc);
+							 READ_ONCE(sk->sk_bind_phc));
 
 		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
 			empty = 0;
-- 
2.43.0



