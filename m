Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608A01ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E3AC433C8;
	Tue, 25 Jul 2023 11:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285726;
	bh=zs3202jNfM2n7iLCh53NrKI38RiH4wN2ZjHVM+T1qjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogrEw52TSgh3DkHip6h4ZIunCkw/n1didiUvTcyMT9P8sg0nbrew3QRxhMYBBiqxg
	 uaUGtPYIz8TgDVCD1B1h0/ffAsYAwbf6NgLryAMptP+HwGvoK0Z7mXQMUb3AxhfNSw
	 XmewSvJ+ozOkapI8qSXIfTmHL2QA3t9It4GuRru8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cambda Zhu <cambda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 308/313] net: Replace the limit of TCP_LINGER2 with TCP_FIN_TIMEOUT_MAX
Date: Tue, 25 Jul 2023 12:47:41 +0200
Message-ID: <20230725104534.464555111@linuxfoundation.org>
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

From: Cambda Zhu <cambda@linux.alibaba.com>

[ Upstream commit f0628c524fd188c3f9418e12478dfdfadacba815 ]

This patch changes the behavior of TCP_LINGER2 about its limit. The
sysctl_tcp_fin_timeout used to be the limit of TCP_LINGER2 but now it's
only the default value. A new macro named TCP_FIN_TIMEOUT_MAX is added
as the limit of TCP_LINGER2, which is 2 minutes.

Since TCP_LINGER2 used sysctl_tcp_fin_timeout as the default value
and the limit in the past, the system administrator cannot set the
default value for most of sockets and let some sockets have a greater
timeout. It might be a mistake that let the sysctl to be the limit of
the TCP_LINGER2. Maybe we can add a new sysctl to set the max of
TCP_LINGER2, but FIN-WAIT-2 timeout is usually no need to be too long
and 2 minutes are legal considering TCP specs.

Changes in v3:
- Remove the new socket option and change the TCP_LINGER2 behavior so
  that the timeout can be set to value between sysctl_tcp_fin_timeout
  and 2 minutes.

Changes in v2:
- Add int overflow check for the new socket option.

Changes in v1:
- Add a new socket option to set timeout greater than
  sysctl_tcp_fin_timeout.

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9df5335ca974 ("tcp: annotate data-races around tp->linger2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 1 +
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 077feeca6c99e..2f456bed33ec3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -125,6 +125,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 				  * to combine FIN-WAIT-2 timeout with
 				  * TIME-WAIT timer.
 				  */
+#define TCP_FIN_TIMEOUT_MAX (120 * HZ) /* max TCP_LINGER2 value (two minutes) */
 
 #define TCP_DELACK_MAX	((unsigned)(HZ/5))	/* maximal time to delay before sending an ACK */
 #if HZ >= 100
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e33abcff56080..c6c73b9407098 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3067,8 +3067,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 	case TCP_LINGER2:
 		if (val < 0)
 			tp->linger2 = -1;
-		else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ)
-			tp->linger2 = 0;
+		else if (val > TCP_FIN_TIMEOUT_MAX / HZ)
+			tp->linger2 = TCP_FIN_TIMEOUT_MAX;
 		else
 			tp->linger2 = val * HZ;
 		break;
-- 
2.39.2



