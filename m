Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F688134D1;
	Sat,  3 Feb 2024 04:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933477; cv=none; b=s1bIyNIOwH/jl4H4Rl7XawJjakZTH4bAOY0kz/d/+vVozZgl3iCiuXarTeIO6evPCyzI/Wi2Sn4Vujpm24sqM4xT7FG+P922S7Vap/M/OAhoaamriZNHI7tDwwmDH9tEeTpv4imou0rIyDvcq2m403pFsiNrH9dmi4eQIdS04DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933477; c=relaxed/simple;
	bh=P17p+VVOVuFnNkYhECs4jLtChdv+AL4EvtO/Ukb4ulw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oil7VVPhMktCHgiJyt1fwRYukEpHeZ3QTdd1nRRHcy/huLlCAO8zBcF4DsG3O6s/qHBGPbooWGHx36+zAyy59iQ6NkOKp4gEbMNa+i3zHa+Kv8ejHIV4+8AW2Vx3PUaEsu1+wfhtnSK2dwvxvHnl67foMWx74FMaj5dGZckcovA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWgcMNyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWgcMNyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4978AC43390;
	Sat,  3 Feb 2024 04:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933477;
	bh=P17p+VVOVuFnNkYhECs4jLtChdv+AL4EvtO/Ukb4ulw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWgcMNyzCXuTSb91JO+/CQ3iBi2wxZE7pXiBKNa13bHm/qkHzMWNnbxnHLXpwn3Ne
	 MrguxwY694Ft3h0zQqnfngs+Ef3APNsHhOOsZTYEqgMDiHzXsZ6XNnZhqTPlY8io5C
	 fLmrz05dYwvfR7oKNr7LFsUrxX/Lb5QttNmZETkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Schaefer <ryanschf@amazon.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/219] netfilter: conntrack: correct window scaling with retransmitted SYN
Date: Fri,  2 Feb 2024 20:06:16 -0800
Message-ID: <20240203035345.576867852@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Ryan Schaefer <ryanschf@amazon.com>

[ Upstream commit fb366fc7541a1de521ab3df58471746aa793b833 ]

commit c7aab4f17021 ("netfilter: nf_conntrack_tcp: re-init for syn packets
only") introduces a bug where SYNs in ORIGINAL direction on reused 5-tuple
result in incorrect window scale negotiation. This commit merged the SYN
re-initialization and simultaneous open or SYN retransmits cases. Merging
this block added the logic in tcp_init_sender() that performed window scale
negotiation to the retransmitted syn case. Previously. this would only
result in updating the sender's scale and flags. After the merge the
additional logic results in improperly clearing the scale in ORIGINAL
direction before any packets in the REPLY direction are received. This
results in packets incorrectly being marked invalid for being
out-of-window.

This can be reproduced with the following trace:

Packet Sequence:
> Flags [S], seq 1687765604, win 62727, options [.. wscale 7], length 0
> Flags [S], seq 1944817196, win 62727, options [.. wscale 7], length 0

In order to fix the issue, only evaluate window negotiation for packets
in the REPLY direction. This was tested with simultaneous open, fast
open, and the above reproduction.

Fixes: c7aab4f17021 ("netfilter: nf_conntrack_tcp: re-init for syn packets only")
Signed-off-by: Ryan Schaefer <ryanschf@amazon.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3ac1af6f59fc..e0092bf273fd 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -457,7 +457,8 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
 			    const struct sk_buff *skb,
 			    unsigned int dataoff,
 			    const struct tcphdr *tcph,
-			    u32 end, u32 win)
+			    u32 end, u32 win,
+			    enum ip_conntrack_dir dir)
 {
 	/* SYN-ACK in reply to a SYN
 	 * or SYN from reply direction in simultaneous open.
@@ -471,7 +472,8 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
 	 * Both sides must send the Window Scale option
 	 * to enable window scaling in either direction.
 	 */
-	if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
+	if (dir == IP_CT_DIR_REPLY &&
+	    !(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
 	      receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE)) {
 		sender->td_scale = 0;
 		receiver->td_scale = 0;
@@ -542,7 +544,7 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 		if (tcph->syn) {
 			tcp_init_sender(sender, receiver,
 					skb, dataoff, tcph,
-					end, win);
+					end, win, dir);
 			if (!tcph->ack)
 				/* Simultaneous open */
 				return NFCT_TCP_ACCEPT;
@@ -585,7 +587,7 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 		 */
 		tcp_init_sender(sender, receiver,
 				skb, dataoff, tcph,
-				end, win);
+				end, win, dir);
 
 		if (dir == IP_CT_DIR_REPLY && !tcph->ack)
 			return NFCT_TCP_ACCEPT;
-- 
2.43.0



