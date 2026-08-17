Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF643C7DF;
	Mon, 17 Aug 2026 13:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974136; cv=none; b=dWGzQU0HXM4WaMsutcJFMHbJiyurHrrgzhzsyxVgP1aNnkHfvpRtPvtA8gzC2LWBbT7RcOb7CrEyy8U8hPR85O8n+/Oj7XsU80vGPrydXr7x63v/9knndLqs0gV5HUaB33cMtbh0UMZiJvI5DzPmnZseq1ddej7aIfTtyt7MDMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974136; c=relaxed/simple;
	bh=6Fw3GpLFNp+EikksDpSTjODsApDpjQSe6TOaLbNnh5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8D3fFfoRnSpl12S6qapfyORujyhmFUZZh4ldejTaxByikgZ44oiGRH/ZDjBxH5F/wco5wTzqmwsQN1xk0xUNS0ZaXvrIX501DTfZfr7XjfNc3qXpsOmBeVCiCz7bi0CjCoNNUr3vnbofre2hUyMPUZy5xVtN+IyOCjvX/UPbZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7sQ7tLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7sQ7tLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629081F00A3A;
	Mon, 17 Aug 2026 13:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974134;
	bh=NerAmgeddrheol4Agpf48/W35aiT76C7PPWjXS/4stI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7sQ7tLA5p7YBoK49oOC2XkU4d68+biPTFkQaP5wpkucTTKo3pU8WO27pZtiPnNDM
	 DpcLhycoPfasCsBwMnohrvUSvDypdCRSlLP/8Vg8Sj1HX6EsqP7LD77dc1ny0VQEBU
	 f1Lt7LEtvh/tIbjeA97kh8Dw0hzBeerT64e8o6jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 101/271] netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()
Date: Mon, 17 Aug 2026 15:30:26 +0200
Message-ID: <20260817132540.964582177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0b78decce8a9b..c9e332fafcb5c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -310,6 +310,7 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      struct dst_entry *dst)
 {
 	skb_orphan(skb);
+	skb_dst_drop(skb);
 	skb_dst_set_noref(skb, dst);
 	dst_output(state->net, state->sk, skb);
 	return NF_STOLEN;
@@ -861,6 +862,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
@@ -1178,6 +1180,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-- 
2.53.0



