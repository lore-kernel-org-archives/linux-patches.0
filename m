Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1345D6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764D7C433EF;
	Mon, 16 Jan 2023 16:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887026;
	bh=SlrN7PgJCVJHKKrkJ9Zglx1aI+ce2l3aE3FygM0DWPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZS57NQntppKDKEhnt2t6iMSc8EMLtBhjGw2FfJ8rC9kBWe3zTNaFXz7uHpFajHaFc
	 xtdITFLD+XJ272st2P36OVr7HiwVev8rB8QghqH8I10V3qnjBw7r3aIwO2An9i3t2C
	 22Gr5Jyn8wQs6gq60bzDUXLYEpNMgq5QBGY/zavk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Maloy <jon.maloy@ericsson.com>,
	Tuong Lien <tuong.t.lien@dektech.com.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 653/658] tipc: fix use-after-free in tipc_disc_rcv()
Date: Mon, 16 Jan 2023 16:52:21 +0100
Message-Id: <20230116154939.350511392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tuong Lien <tuong.t.lien@dektech.com.au>

commit 31e4ccc99eda8a5a7e6902c98bee6e78ffd3edb9 upstream.

In the function 'tipc_disc_rcv()', the 'msg_peer_net_hash()' is called
to read the header data field but after the message skb has been freed,
that might result in a garbage value...

This commit fixes it by defining a new local variable to store the data
first, just like the other header fields' handling.

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/discover.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -194,6 +194,7 @@ void tipc_disc_rcv(struct net *net, stru
 {
 	struct tipc_net *tn = tipc_net(net);
 	struct tipc_msg *hdr = buf_msg(skb);
+	u32 pnet_hash = msg_peer_net_hash(hdr);
 	u16 caps = msg_node_capabilities(hdr);
 	bool legacy = tn->legacy_addr_format;
 	u32 sugg = msg_sugg_node_addr(hdr);
@@ -245,9 +246,8 @@ void tipc_disc_rcv(struct net *net, stru
 		return;
 	if (!tipc_in_scope(legacy, b->domain, src))
 		return;
-	tipc_node_check_dest(net, src, peer_id, b, caps, signature,
-			     msg_peer_net_hash(hdr), &maddr, &respond,
-			     &dupl_addr);
+	tipc_node_check_dest(net, src, peer_id, b, caps, signature, pnet_hash,
+			     &maddr, &respond, &dupl_addr);
 	if (dupl_addr)
 		disc_dupl_alert(b, src, &maddr);
 	if (!respond)


