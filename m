Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4E71EA7E
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCC1C433C7;
	Tue, 25 Jul 2023 11:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283419;
	bh=BxUtbmQVW+vCjCO6RD6tkOQSgsY5/yvU/Jql9vdtM9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSkM/ITqGbGPFBJSQt6pGbmHlySt/m+eDvzt5wfPyERFC7liqj6qYEs7lFWW4UUHP
	 7A6JporlVJwKGtq+/SiqXOle3L0WgAIx8Jqk7x61y+ibxVY0wtrFDrHOBAs5qUYTHe
	 d/2Q02O8BJ84muUE+PRUu7oQze59j7qvO0bqTlM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 70/78] tcp: annotate data-races around tp->linger2
Date: Tue, 25 Jul 2023 12:47:01 +0200
Message-ID: <20230725104453.992915750@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
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
index 4077b456e3838..58f202fd6f269 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3590,11 +3590,11 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 
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
@@ -3995,7 +3995,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			READ_ONCE(net->ipv4.sysctl_tcp_syn_retries);
 		break;
 	case TCP_LINGER2:
-		val = tp->linger2;
+		val = READ_ONCE(tp->linger2);
 		if (val >= 0)
 			val = (val ? : READ_ONCE(net->ipv4.sysctl_tcp_fin_timeout)) / HZ;
 		break;
-- 
2.39.2



