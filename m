Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A127F28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26684C433D2;
	Mon, 30 Jan 2023 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087101;
	bh=/vEFgg09wF5YSjgFzgBQVAmj5cYnnCgev8QsubM81tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiULeeLZPRELY9NwEqDytI2479OpadlR3aAHra5TvOalnOvavsistZSwwD2JkxBdZ
	 Z6K0ijZqh1YQQJr4YhVk+IokZrK/qXP1VfYG2FREoUQLlZShPjYu5Wuw2uaeOeB5zP
	 JQuesYFjm4CYiWGO2UmsYdKmkxESnl0gTb/4IByk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Tesar <mtesar@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/313] netfilter: conntrack: handle tcp challenge acks during connection reuse
Date: Mon, 30 Jan 2023 14:48:52 +0100
Message-Id: <20230130134341.153578433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c410cb974f2ba562920ecb8492ee66945dcf88af ]

When a connection is re-used, following can happen:
[ connection starts to close, fin sent in either direction ]
 > syn   # initator quickly reuses connection
 < ack   # peer sends a challenge ack
 > rst   # rst, sequence number == ack_seq of previous challenge ack
 > syn   # this syn is expected to pass

Problem is that the rst will fail window validation, so it gets
tagged as invalid.

If ruleset drops such packets, we get repeated syn-retransmits until
initator gives up or peer starts responding with syn/ack.

Before the commit indicated in the "Fixes" tag below this used to work:

The challenge-ack made conntrack re-init state based on the challenge
ack itself, so the following rst would pass window validation.

Add challenge-ack support: If we get ack for syn, record the ack_seq,
and then check if the rst sequence number matches the last ack number
seen in reverse direction.

Fixes: c7aab4f17021 ("netfilter: nf_conntrack_tcp: re-init for syn packets only")
Reported-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 656631083177..3ac1af6f59fc 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1068,6 +1068,13 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 				ct->proto.tcp.last_flags |=
 					IP_CT_EXP_CHALLENGE_ACK;
 		}
+
+		/* possible challenge ack reply to syn */
+		if (old_state == TCP_CONNTRACK_SYN_SENT &&
+		    index == TCP_ACK_SET &&
+		    dir == IP_CT_DIR_REPLY)
+			ct->proto.tcp.last_ack = ntohl(th->ack_seq);
+
 		spin_unlock_bh(&ct->lock);
 		nf_ct_l4proto_log_invalid(skb, ct, state,
 					  "packet (index %d) in dir %d ignored, state %s",
@@ -1193,6 +1200,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			 * segments we ignored. */
 			goto in_window;
 		}
+
+		/* Reset in response to a challenge-ack we let through earlier */
+		if (old_state == TCP_CONNTRACK_SYN_SENT &&
+		    ct->proto.tcp.last_index == TCP_ACK_SET &&
+		    ct->proto.tcp.last_dir == IP_CT_DIR_REPLY &&
+		    ntohl(th->seq) == ct->proto.tcp.last_ack)
+			goto in_window;
+
 		break;
 	default:
 		/* Keep compilers happy. */
-- 
2.39.0



