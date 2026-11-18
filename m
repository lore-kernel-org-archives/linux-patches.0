Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032506;
	b=ayGnbbVyXboTmuN18fuy6nh5QJEy5TAsdRoSErjaoacJU17K9wkqGF6QNch1/kYvnYqe
	 r2ZODehzKyM4jNSpEJu2CmWc6z+Q20D82dwQaWm/6Cu0IP6SThfAndIKThZLpXD7/NhMr
	 Yr19IRmbdwA04xL8u2rV6pSK+HIxnX8ViA8YbldoYvA9iy16Pzoyg+8zi2n/2e2HEM/+z
	 EVgvuQlgjCXh0KDKmxN+rb5rgW4acUDYPpNeOjCv6Yipwh6CoT+MWNN/WQUJa6D7yp6BI
	 M33B4oN1v6JS2MwhIFQr52mAb4kkzAxvXdyfnGgKA14RqDh5OFoqWXVq0kw5GlpRL4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+StwH7i88KGDlVc0DrRXGfLENL7ugSerUoqy00Qt8Zs=;
	b=KRJT8STUlyRnGvuBV0gWKdOoPKr2edRpUiYVKBkz8Y+6vlez7Camr2+Ak44fzRoy0Slk
	 Ks6cUDaqhiGzJ1e2GtcRhskeJ1fZh8Yf3hBUIjVDkCBXf/XiN+HgwR5sIcQxFllHGAkOZ
	 SnTcJVMPa+FpSIcXWn1rmBKmkpizZXxeqtVQVeYhxfnNq+emViEXG1jqbgMPbtS0ytTj/
	 JrGjjuw5894bgJVFL5OTzGjD1jXcLu5qQjzLHljXC8aLDpSzGlE2cCVZ+TjRZE8w7Dam1
	 7DAUS1b62JN+VBGV6riu2UPN/a+T+jO5w0uJnF+zlACyxwo87Xiz9cKVqqokEvrPbMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFcl87b0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88798606A85E;
	Wed, 18 Nov 2026 20:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFcl87b0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DB21F000C4;
	Wed, 18 Nov 2026 20:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032506;
	bh=+StwH7i88KGDlVc0DrRXGfLENL7ugSerUoqy00Qt8Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFcl87b0VCsJDOQkMCp2qXiW7BWmNFMFnR3mLUBsZEu0bfb3hpXFyN8Dvv4YjGpMi
	 +viDWJahkQKt4/LiNJ76L8r4LD5UpoX9tPtC33tjmbHsqLHo9DUKU/GYQkhiVFF4jw
	 hCFVgOGVlu9eXPaZOHH35jkmPJl4mNLa1l06GvZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1436/1756] net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions
Date: Wed, 18 Nov 2026 15:59:23 +0100
Message-ID: <20261118150106.330842683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 475878f3acb3b..59c15561d9b67 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -635,6 +635,9 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct udphdr));
 	if (unlikely(err))
@@ -678,6 +681,9 @@ static int set_tcp(struct sk_buff *skb, struct sw_flow_key *flow_key,
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



