Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6281ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931F0C433C8;
	Tue, 25 Jul 2023 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285728;
	bh=mEIt9wX94AlRzE12Yez72fq0XnmlenXfEeOOeths1JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/yDcIqdc36/dhy4D+na4VRqZbAZyj4mGBHSlv+SEuBD7b0ZiuG7LBOauaBZeEKjX
	 JKBFRX2+6oQI8P2U37R+9hSQrbmt5zfHVNxPT4Y9vYsL7aypJtsBNsDBYa5c0gBf+J
	 jKB4gGVgYyttdbl5U1MbqeyPEdcHOMVDYIFc1cRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 309/313] tcp: annotate data-races around tp->linger2
Date: Tue, 25 Jul 2023 12:47:42 +0200
Message-ID: <20230725104534.512924136@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9df5335ca974e688389c875546e5819778a80d59 ]

do_tcp_getsockopt() reads tp->linger2 while another cpu
might change its value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c6c73b9407098..b9475fcaa6c4f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3066,11 +3066,11 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 
 	case TCP_LINGER2:
 		if (val < 0)
-			tp->linger2 = -1;
+			WRITE_ONCE(tp->linger2, -1);
 		else if (val > TCP_FIN_TIMEOUT_MAX / HZ)
-			tp->linger2 = TCP_FIN_TIMEOUT_MAX;
+			WRITE_ONCE(tp->linger2, TCP_FIN_TIMEOUT_MAX);
 		else
-			tp->linger2 = val * HZ;
+			WRITE_ONCE(tp->linger2, val * HZ);
 		break;
 
 	case TCP_DEFER_ACCEPT:
@@ -3476,7 +3476,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		val = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
 		break;
 	case TCP_LINGER2:
-		val = tp->linger2;
+		val = READ_ONCE(tp->linger2);
 		if (val >= 0)
 			val = (val ? : READ_ONCE(net->ipv4.sysctl_tcp_fin_timeout)) / HZ;
 		break;
-- 
2.39.2



