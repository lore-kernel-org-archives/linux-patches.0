Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1764C2727E2;
	Mon, 13 Apr 2026 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096460; cv=none; b=TOOj4f49azIgN599Ex+Yl/lj+bWloMVUV8viSoJe7hQ4bm0nPq4gPLP60/p8FMEQv+Jd6aQfzgoimQzak66L97Gfhd1NzANVq4ij24XK0Mw9LfwaRMRd+0zYcDyux8Y8kMKvKW/yEFylBKdq0uP4cgXdqh0xdM+rx8Fzm/2I3/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096460; c=relaxed/simple;
	bh=Xs7vFqRcXaXefp6Lr4Se0rfRq768QxWjnRnbdVqYHDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVYRtDANPuqLFZcOojrXl10WijjK934rg7urda6NiKBRmwj/fEK1LQWlp2GiZSmj7f0LMCka1SKXTSaE8mTbt9cQURo5Y4kqh2OLFHvgjSTDzN3KdTVtJ5TiI9Z8a2NxqGCxfLSEAE75qffcTrTPlo7I5SY23jpqTIPPgk7KNv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQXYNe7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQXYNe7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3531C2BCB4;
	Mon, 13 Apr 2026 16:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096460;
	bh=Xs7vFqRcXaXefp6Lr4Se0rfRq768QxWjnRnbdVqYHDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQXYNe7PjdvefSTsh4/i0s/ZtFYhvL1Tk42AZ8GRip82bQwfedAPd3ciaKJv0zIrH
	 pQ4bZOBGYxXs6l4SyrRqIFr1F2TdO8ifATFjyaf0B27ZpuLfFaMiROZ+GxsBeXn3MQ
	 5pnhWxOT+60aCIdkxukMlhRgBqFOPkx6I0lHnmxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuan Do <tuan@calif.io>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 20/83] netfilter: nft_ct: fix use-after-free in timeout object destroy
Date: Mon, 13 Apr 2026 17:59:48 +0200
Message-ID: <20260413155731.779438510@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Tuan Do <tuan@calif.io>

commit f8dca15a1b190787bbd03285304b569631160eda upstream.

nft_ct_timeout_obj_destroy() frees the timeout object with kfree()
immediately after nf_ct_untimeout(), without waiting for an RCU grace
period. Concurrent packet processing on other CPUs may still hold
RCU-protected references to the timeout object obtained via
rcu_dereference() in nf_ct_timeout_data().

Add an rcu_head to struct nf_ct_timeout and use kfree_rcu() to defer
freeing until after an RCU grace period, matching the approach already
used in nfnetlink_cttimeout.c.

KASAN report:
 BUG: KASAN: slab-use-after-free in nf_conntrack_tcp_packet+0x1381/0x29d0
 Read of size 4 at addr ffff8881035fe19c by task exploit/80

 Call Trace:
  nf_conntrack_tcp_packet+0x1381/0x29d0
  nf_conntrack_in+0x612/0x8b0
  nf_hook_slow+0x70/0x100
  __ip_local_out+0x1b2/0x210
  tcp_sendmsg_locked+0x722/0x1580
  __sys_sendto+0x2d8/0x320

 Allocated by task 75:
  nft_ct_timeout_obj_init+0xf6/0x290
  nft_obj_init+0x107/0x1b0
  nf_tables_newobj+0x680/0x9c0
  nfnetlink_rcv_batch+0xc29/0xe00

 Freed by task 26:
  nft_obj_destroy+0x3f/0xa0
  nf_tables_trans_destroy_work+0x51c/0x5c0
  process_one_work+0x2c4/0x5a0

Fixes: 7e0b2b57f01d ("netfilter: nft_ct: add ct timeout support")
Cc: stable@vger.kernel.org
Signed-off-by: Tuan Do <tuan@calif.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_conntrack_timeout.h |    1 +
 net/netfilter/nft_ct.c                       |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -14,6 +14,7 @@
 struct nf_ct_timeout {
 	__u16			l3num;
 	const struct nf_conntrack_l4proto *l4proto;
+	struct rcu_head		rcu;
 	char			data[];
 };
 
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1021,7 +1021,7 @@ static void nft_ct_timeout_obj_destroy(c
 	nf_queue_nf_hook_drop(ctx->net);
 	nf_ct_untimeout(ctx->net, timeout);
 	nf_ct_netns_put(ctx->net, ctx->family);
-	kfree(priv->timeout);
+	kfree_rcu(priv->timeout, rcu);
 }
 
 static int nft_ct_timeout_obj_dump(struct sk_buff *skb,


