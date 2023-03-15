Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFA74431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D696BC433A1;
	Wed, 15 Mar 2023 12:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882793;
	bh=MEWy9jYQtJUgVgdRBkx/fEha9fIERmdhTAgWins58QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbeg1zozJjio5toJhuoKkXKDtfTb0qIfNu4GkaJl1FiFvg8JtKfOAeFUvHWGXQBIP
	 DeEyF+cjD2OHKyOluoaat+D6sACr+soqYzqV619iyyY2AuZdlaYFdfiPm9L2izG65/
	 59mZXjvtQO8zM2YyOeuxo3ADyBU/5KDN4JN1ifKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Simon Horman <simon.horman@corigine.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/68] net/smc: fix fallback failed while sendmsg with fastopen
Date: Wed, 15 Mar 2023 13:12:41 +0100
Message-Id: <20230315115727.968416414@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit ce7ca794712f186da99719e8b4e97bd5ddbb04c3 ]

Before determining whether the msg has unsupported options, it has been
prematurely terminated by the wrong status check.

For the application, the general usages of MSG_FASTOPEN likes

fd = socket(...)
/* rather than connect */
sendto(fd, data, len, MSG_FASTOPEN)

Hence, We need to check the flag before state check, because the sock
state here is always SMC_INIT when applications tries MSG_FASTOPEN.
Once we found unsupported options, fallback it to TCP.

Fixes: ee9dfbef02d1 ("net/smc: handle sockopts forcing fallback")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>

v2 -> v1: Optimize code style
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5d696b7fb47e1..b398d72a7bc39 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1542,16 +1542,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = -EPIPE;
+	int rc;
 
 	smc = smc_sk(sk);
 	lock_sock(sk);
-	if ((sk->sk_state != SMC_ACTIVE) &&
-	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
-	    (sk->sk_state != SMC_INIT))
-		goto out;
 
+	/* SMC does not support connect with fastopen */
 	if (msg->msg_flags & MSG_FASTOPEN) {
+		/* not connected yet, fallback */
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
 			smc_switch_to_fallback(smc);
 			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
@@ -1559,6 +1557,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			rc = -EINVAL;
 			goto out;
 		}
+	} else if ((sk->sk_state != SMC_ACTIVE) &&
+		   (sk->sk_state != SMC_APPCLOSEWAIT1) &&
+		   (sk->sk_state != SMC_INIT)) {
+		rc = -EPIPE;
+		goto out;
 	}
 
 	if (smc->use_fallback)
-- 
2.39.2



