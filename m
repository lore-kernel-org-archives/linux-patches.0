Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9607171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ADAC4339B;
	Mon, 22 May 2023 19:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784896;
	bh=dyW9TWjA7QYobcsTuhtZlscVfnaI8GO8weXHBZ11q8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4bDq40uuQ6vuvvX6eq5Mn4aFbjs7B3lPPZhHVWbdRIRyAxxHd0jKT6xOp0SI9pBe
	 LVtjjNC7RlvJ+QKki2a/iGODHu7d2fFG2wqI7WjKsCKoytNmHFbWovhJaSGk9NQbgo
	 81CkdKF2iSHU7fETaDRVop+2lnjb3xF+8/XtqyqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Traynor <ktraynor@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	William Tu <u9012063@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 237/364] erspan: get the proto with the md version for collect_md
Date: Mon, 22 May 2023 20:09:02 +0100
Message-Id: <20230522190418.628312221@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit d80fc101d2eb9b3188c228d61223890aeea480a4 ]

In commit 20704bd1633d ("erspan: build the header with the right proto
according to erspan_ver"), it gets the proto with t->parms.erspan_ver,
but t->parms.erspan_ver is not used by collect_md branch, and instead
it should get the proto with md->version for collect_md.

Thanks to Kevin for pointing this out.

Fixes: 20704bd1633d ("erspan: build the header with the right proto according to erspan_ver")
Fixes: 94d7d8f29287 ("ip6_gre: add erspan v2 support")
Reported-by: Kevin Traynor <ktraynor@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index a4ecfc9d25930..da80974ad23ae 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1015,12 +1015,14 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 					    ntohl(tun_id),
 					    ntohl(md->u.index), truncate,
 					    false);
+			proto = htons(ETH_P_ERSPAN);
 		} else if (md->version == 2) {
 			erspan_build_header_v2(skb,
 					       ntohl(tun_id),
 					       md->u.md2.dir,
 					       get_hwid(&md->u.md2),
 					       truncate, false);
+			proto = htons(ETH_P_ERSPAN2);
 		} else {
 			goto tx_err;
 		}
@@ -1043,24 +1045,25 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 			break;
 		}
 
-		if (t->parms.erspan_ver == 1)
+		if (t->parms.erspan_ver == 1) {
 			erspan_build_header(skb, ntohl(t->parms.o_key),
 					    t->parms.index,
 					    truncate, false);
-		else if (t->parms.erspan_ver == 2)
+			proto = htons(ETH_P_ERSPAN);
+		} else if (t->parms.erspan_ver == 2) {
 			erspan_build_header_v2(skb, ntohl(t->parms.o_key),
 					       t->parms.dir,
 					       t->parms.hwid,
 					       truncate, false);
-		else
+			proto = htons(ETH_P_ERSPAN2);
+		} else {
 			goto tx_err;
+		}
 
 		fl6.daddr = t->parms.raddr;
 	}
 
 	/* Push GRE header. */
-	proto = (t->parms.erspan_ver == 1) ? htons(ETH_P_ERSPAN)
-					   : htons(ETH_P_ERSPAN2);
 	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(atomic_fetch_inc(&t->o_seqno)));
 
 	/* TooBig packet may have updated dst->dev's mtu */
-- 
2.39.2



