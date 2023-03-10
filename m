Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78DE847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D937C433D2;
	Fri, 10 Mar 2023 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456443;
	bh=tGZrE5RsUHxyVgFh8Oclc0pNwUCohNtA6FkoIdw5jDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWduGGQXrnMixpmhp0qGwMyqOX4ewzs1+bLAqu8XzrWTkaOMr12CXcpNz29pa95Ru
	 NOFoezWUZ0TzpVIvM3z1o+Ev0BJP4o9X7GXJbtlQ8m1nf8UmCzVvJEG7POQBPLpLWK
	 a9n7hgGFS3LtFpmdim3mGlfKOnQtscAzTsWaVFnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Frederick Lawler <fred@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 174/193] tcp: tcp_check_req() can be called from process context
Date: Fri, 10 Mar 2023 14:39:16 +0100
Message-Id: <20230310133716.908762655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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

[ Upstream commit 580f98cc33a260bb8c6a39ae2921b29586b84fdf ]

This is a follow up of commit 0a375c822497 ("tcp: tcp_rtx_synack()
can be called from process context").

Frederick Lawler reported another "__this_cpu_add() in preemptible"
warning caused by the same reason.

In my former patch I took care of tcp_rtx_synack()
but forgot that tcp_check_req() also contained some SNMP updates.

Note that some parts of tcp_check_req() always run in BH context,
I added a comment to clarify this.

Fixes: 8336886f786f ("tcp: TCP Fast Open Server - support TFO listeners")
Link: https://lore.kernel.org/netdev/8cd33923-a21d-397c-e46b-2a068c287b03@cloudflare.com/T/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Frederick Lawler <fred@cloudflare.com>
Tested-by: Frederick Lawler <fred@cloudflare.com>
Link: https://lore.kernel.org/r/20230227083336.4153089-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_minisocks.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 61584638dba7f..21fe6f6a0e4fe 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -557,6 +557,9 @@ EXPORT_SYMBOL(tcp_create_openreq_child);
  * validation and inside tcp_v4_reqsk_send_ack(). Can we do better?
  *
  * We don't need to initialize tmp_opt.sack_ok as we don't use the results
+ *
+ * Note: If @fastopen is true, this can be called from process context.
+ *       Otherwise, this is from BH context.
  */
 
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
@@ -709,7 +712,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 					  &tcp_rsk(req)->last_oow_ack_time))
 			req->rsk_ops->send_ack(sk, skb, req);
 		if (paws_reject)
-			__NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
 		return NULL;
 	}
 
@@ -728,7 +731,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 *	   "fourth, check the SYN bit"
 	 */
 	if (flg & (TCP_FLAG_RST|TCP_FLAG_SYN)) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 		goto embryonic_reset;
 	}
 
-- 
2.39.2



