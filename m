Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E4612E4D;
	Tue, 27 Aug 2024 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771434; cv=none; b=igNhpL0VQ+GylB6wY0mCLThljLhrVfsaVcqpVCHHL6OuJNht6b/c8au/Xx121PPyllt6ajYb1KHue6KNm63toe7lMVxhFN9Nhtuj+DOR5L6jsjj3j0dnXYnRP0WRRQa7HTvkmRgPf4YFsEuOCBovYJRtZyR5VHfgBlcU+1LD1pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771434; c=relaxed/simple;
	bh=r6b9L30D7Rnka36MWQm7ipKl7PQKMisjLoWdAQfokNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EISmkXF5ahwZACPpUtLCc2+n4RvcqjV4kbyL/49sfFc71/6HzxRkMWkj5z1BFNvYsmyle9tgGpKJH4tRq8WbDhYnO8BSLCblZBfz1z5oaE4GW46oUdQfyIHR60fSsdDW6qDw++mP+dtVT7QuLlGSnT2GBRGF3SdWKwY6/O+z1xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzyfU+Lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzyfU+Lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA12C4AF63;
	Tue, 27 Aug 2024 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771434;
	bh=r6b9L30D7Rnka36MWQm7ipKl7PQKMisjLoWdAQfokNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzyfU+LhD+EVZE/3lNb7miL+dxJfEOkKjMjYaWJSI8cfpgvsbNvKovXnQIIEG6oD2
	 T8J8aqXPKqjLHLWoJD/fVfADWXvb5mR8DVL0+jfqFXRa6Lsvb+Gsq8jjlAD/8H1L5+
	 AMTWlaK68tTbgX+Uydk+6mHVYNveOjaQ3Ztg3WF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8407d9bb88cd4c6bf61a@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 186/273] netfilter: flowtable: validate vlan header
Date: Tue, 27 Aug 2024 16:38:30 +0200
Message-ID: <20240827143840.486386194@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c2c005234dcd3..98edcaa37b38d 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -281,6 +281,9 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 
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



