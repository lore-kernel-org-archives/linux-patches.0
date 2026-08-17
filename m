Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C63B3DB964;
	Mon, 17 Aug 2026 13:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974903; cv=none; b=Q7kBEqoe+sOzfKq7a257iWNOSK329kmH/Zck+448Wcox1ARGzm7JnxKxnItxjmQItc8/6hazidleY7/+kr+C7wclInyqX4a2LT3l6pSkNLC+px6+Hf5QxHcggnWnwbXzNQeXXxIKS84CeN4ey8agwhEoDxl5tuANWxacDprt+Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974903; c=relaxed/simple;
	bh=xDFrgBWrONmDl1ih7ATlQvoERcnvFcu9cO03enzbIh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTnyxapcLS5jlDwo6Ytbq6QmYPTNrjOMQc1o0TfXLG1slgdJsXGq6rWHD1XZd0jCHuUwbIsKKj3fW2hgFnq95WS7Rlb7F+segN1EGWEahZXjEBWy7V5cu7tEpXY4vaYk4pej4BQd3WfYygWzsL2qSpw/G8gMUcMkFxH83laUrpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLKOIDHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLKOIDHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EC81F00A3A;
	Mon, 17 Aug 2026 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974898;
	bh=jY5HoUwvedNP+8abZbYZF5CsORl8ZJR0BwgkzY7MKek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLKOIDHIkaKUE5vNLuBfiUnlsJnnE6tvV6nBxv0ijxMlIfGjrUFwTZoPeej+JLrI4
	 9Mksu4FPkkdBUAbxuTRNP0VDs0sD3tccEmHfbfb2qbo2VJQgjTFLWydMqyoqIdSJwb
	 nLxGmcBwIVcf6vmFEd4K1RcGnBHdrz5ZD1f+4yEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/250] netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()
Date: Mon, 17 Aug 2026 15:30:53 +0200
Message-ID: <20260817132540.247719314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8aecf0bbcc72605592134c917c222207d8f63ab0 ]

Incoming skbs passing through netfilter flowtable offload hooks (or XFRM
offload path) might already carry a ref-counted dst_entry assigned during
earlier RX or routing steps.

Calling skb_dst_set_noref() when skb already holds a ref-counted dst
overwrites skb->_skb_refdst, leaking the previous dst_entry reference
count and triggering a DEBUG_NET_WARN_ON_ONCE assertion in
skb_dst_check_unset():

  WARNING: at skb_dst_check_unset include/linux/skbuff.h:1170
  WARNING: at skb_dst_set_noref include/linux/skbuff.h:1234
  WARNING: at nf_flow_offload_ip_hook+0xf6c/0x2b60 net/netfilter/nf_flow_table_ip.c:864

Drop any existing dst_entry reference with skb_dst_drop(skb) before
setting the non-referenced flowtable destination.

Fixes: 2a79fd3908ac ("netfilter: nf_flow_table: attach dst to skbs")
Reported-by: syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a71b141.9511d2ce.1fc5b9.033b.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://patch.msgid.link/20260804093328.1831847-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index eb4f6a11e779f..4dcc30e7f9e5e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -272,6 +272,7 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      struct dst_entry *dst)
 {
 	skb_orphan(skb);
+	skb_dst_drop(skb);
 	skb_dst_set_noref(skb, dst);
 	dst_output(state->net, state->sk, skb);
 	return NF_STOLEN;
@@ -464,6 +465,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
@@ -768,6 +770,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-- 
2.53.0



