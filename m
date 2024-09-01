Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB352C6AF;
	Sun,  1 Sep 2024 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210311; cv=none; b=jEupeSvmzzmF+aqX4auPogBVypqxgVcEWdnjOFgchikbDN5SjVjUTj8GLrnBLJSsfZF4mhozdP4e2ruqdrge5RqsyMX1c5lefuhJEN/RaYZxMmsREz9I4iGJW8Ota3XdI5VvUo6hLe+TbLX3hN3nwrAtPCJt/SDxa9gBxo+ZI0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210311; c=relaxed/simple;
	bh=Wy9WOWxJoIdQryW9P6bHAo/q5Fkg/wnRHsKYJermfFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOj9j6/rBxlQyEdWoO7y8XVwgWYHQ4WVqJgjPJK8UoA1GHqiuHiuQuFxRvp/n4KCo8IYXe0snKXH70jdFDSTYAk36H0zrHbRvv1KLG6WE4UnUmHWP2sFol7CbK5ISs75EjPFo37b9p0PRHFxDY2r1Ly+lKP22ACycNfGxlFfOZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGBkP5kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGBkP5kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA275C4CEC4;
	Sun,  1 Sep 2024 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210311;
	bh=Wy9WOWxJoIdQryW9P6bHAo/q5Fkg/wnRHsKYJermfFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGBkP5kdDKaW5TJZn/EdV+hOE74pORB7Tl+z3JySejYBueXvs+4EzrNljWmvJzhQD
	 3laki1cMESVVE6FOlCkFmFn6Izi+Ou7qjB6Td0NrOGr1ta9oQoIvhdCJu6vwc5TzQx
	 U4Vuq1uw682FqMTq8VmpEl372dfNTRgHBR0yn7/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8407d9bb88cd4c6bf61a@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/215] netfilter: flowtable: validate vlan header
Date: Sun,  1 Sep 2024 18:17:44 +0200
Message-ID: <20240901160829.110409017@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6783ea220f8fe..7f746acb4b027 100644
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
index f3227f9316969..8fa16be0def2a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -254,6 +254,9 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 
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



