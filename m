Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042172;
	b=kSheNBrwjYnRdHIIeHZUt52ZmROKj31mg1ilb9QKlJ99dufHryGRCIwQqQLY20BV3lbk
	 BAlU11b9U8h+AEqvf8wQN2VTcu/D/FiroN5DbnTjT7Iv3KGu+7ZxqZUIzLjadHdTUqnRQ
	 a2stYiViByEIbzwoXdp/KZVA3knNfmF9Xn6f4/2jghAfpXuGLvo/iq5a2UX65olmDSLTE
	 SCiwzmY95UVMYVFnguUYGlcUIlDuKaB3X+QrVRdEvw62oyIblIoCmTxDhyU79CkSuigDO
	 Xo6PkEf6ijkuA0ZTBGSSx5EY/HsFe9nesq8r6EkfkqN//9JqPjaDFUNMENz1+YvKuwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eEvZVKDl6j6Yg7w9CvUkHtie3/lXXwwO8Emnljh1IA4=;
	b=ZRRNzp3l7qemRUPhHa1YeDh1WTdZDoA6bDeyetxxdecdTc1V0vGYyO+mMS0Ivu8pks4I
	 AWT/gcYn/Gmgdv/sjCh5tPbv/k9gs7g6nIILazuo+OEf8p+iq9DPkMQnwBBQHRTR+gRHL
	 pIuAir1/RjpW42kpRRmW8XnPq9XXZ6RQzyOXukucFWzQRNu8BuZcMCwwdaVT8Nn2GvBW0
	 ebvejDET4N7XM9w4WKa/UXp6VXHg/2DN4o8avStPfPtpIHRL4GoilvkQPPlef54FIBvH7
	 rRS2clrv7L5FH306UObDi8mEekNq39tiuce6UubeEGtZpajmzn7eSQN0x1nGzroY8OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBsJBHLW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C28606A325;
	Wed, 18 Nov 2026 22:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBsJBHLW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A021F000C4;
	Wed, 18 Nov 2026 22:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042171;
	bh=eEvZVKDl6j6Yg7w9CvUkHtie3/lXXwwO8Emnljh1IA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBsJBHLWWdJhUN3gdzQak/uZwY5l6gnCqmuvwMKbVaYRF45oteM/x0C8B5M/bdVdK
	 pXqHBpmb5ldN0Zk6De+tiXXcTHzAbvm8HcQDsHRlfyjnKVY7BZLO3yQF1i9LgZ4uRx
	 fIWQVvYyPAeiDmzRymdwyKHlAAfQWfrTdiUKgviI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3068/3318] net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions
Date: Wed, 18 Nov 2026 16:01:30 +0100
Message-ID: <20261118150452.154996976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 14c0350142ab0a10ebeefed03b779df23749e16a ]

An IPv4 later fragment carries no L4 header, but key extraction leaves
ip.proto set to the real protocol and the flow may wildcard the frag
field, so validate_set() accepts such packets. set_tcp() and set_udp()
then treat the first bytes of the fragment payload as an L4 header,
rewrite them as ports and patch the bytes at the checksum offset,
corrupting the packet.

Skip these actions for OVS_FRAG_TYPE_LATER. IPv6 later fragments are not
affected, since their ip.proto is NEXTHDR_FRAGMENT and validate_set()
rejects L4 set actions for them.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261015124749.4694-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index c525eb456609a..8511e70890b45 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -619,6 +619,9 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct udphdr));
 	if (unlikely(err))
@@ -662,6 +665,9 @@ static int set_tcp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct tcphdr));
 	if (unlikely(err))
-- 
2.53.0



