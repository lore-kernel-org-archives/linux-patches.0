Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0D119F485;
	Tue, 27 Aug 2024 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772571; cv=none; b=e5891XIa1Y1Z+Cvo3294G0x9a4fM9mseW8CMj9KGagAqxmFj9oIq+duAx5teUhwB8oIZBZL0NzmZS5u/grw3veMKwg5llGWwd86SMmuECz2ib43CtO2Rda9OtJcBSsakj7T+cqzQi1ni0Np26z3ZniUoNqPayaEzbyY783mzdas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772571; c=relaxed/simple;
	bh=edtodNoOfSvh0r1LKR76iE/IBFzPoAz3kIaaZixsWNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKuUyFEaVLnRu25EWdsAfCezWDGkYkdkv0R9BlIBIo+SaxKzGCK4xPyf8WUZHOX/lqRfTi7638XL1HnesvqcN34wFgmDWc1adNrpkfJdoPeOkh2wJav27Ixn3g1AByAz5JHGtjswcVV8s1+b3TXUd1W01QKD/AAOKK6gD/Mmc5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEkvz4mQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEkvz4mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E3DC6107E;
	Tue, 27 Aug 2024 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772570;
	bh=edtodNoOfSvh0r1LKR76iE/IBFzPoAz3kIaaZixsWNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEkvz4mQZpbcN3TtSu/Y5EoBYQVVltWhLogACttl4Ldl6VbVE9b7VL4vsg29gDbsw
	 zig+3RKVgmSMlabqnzG1RoByAmKT/AKM/W7w0A2AY7I5kD179UBWCx7/1bcVmHYweZ
	 YIG4jRzOQTsEAPbhhL7rsx+N149LGt2rHdWLCa6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8407d9bb88cd4c6bf61a@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/321] netfilter: flowtable: validate vlan header
Date: Tue, 27 Aug 2024 16:39:22 +0200
Message-ID: <20240827143847.912870403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6ea14ccb60c8ab829349979b22b58a941ec4a3ee ]

Ensure there is sufficient room to access the protocol field of the
VLAN header, validate it once before the flowtable lookup.

=====================================================
BUG: KMSAN: uninit-value in nf_flow_offload_inet_hook+0x45a/0x5f0 net/netfilter/nf_flow_table_inet.c:32
 nf_flow_offload_inet_hook+0x45a/0x5f0 net/netfilter/nf_flow_table_inet.c:32
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
 nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
 nf_ingress net/core/dev.c:5440 [inline]

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Reported-by: syzbot+8407d9bb88cd4c6bf61a@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_inet.c | 3 +++
 net/netfilter/nf_flow_table_ip.c   | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 6eef15648b7b0..b0f1991719324 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -17,6 +17,9 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
+		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
+			return NF_ACCEPT;
+
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		proto = veth->h_vlan_encapsulated_proto;
 		break;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 22bc0e3d8a0b5..34be2c9bc39d8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -275,6 +275,9 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
+		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
+			return false;
+
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		if (veth->h_vlan_encapsulated_proto == proto) {
 			*offset += VLAN_HLEN;
-- 
2.43.0



