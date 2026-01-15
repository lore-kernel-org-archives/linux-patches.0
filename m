Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641FA3B8BAE;
	Thu, 15 Jan 2026 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497132; cv=none; b=ls7aJeCqutppVssJoV5TJIN616WaVDituwax0Kb6vat5SeRLJjdDLUwiHQ7EyKhTJon1u3PN8jsZ80/1Dx7rsofZVu5ByW00ykDxAAJ4UF0jN2lUaVhzcR5/jT7LVOYc/F/imu5cuA5mV4RODPIcgu4nNuxlZ/AWpkxHqeM1Bx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497132; c=relaxed/simple;
	bh=OQJQlcWcCGzz6F0ocL5pKeR2CmqdAa8FyAsjT9Gj1n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVB8zas26jfTiPH8mjJ7TDjsRMw0Mjkw0LS2rXeB/WjriR3WCpQjTLl+3j2PzXaC1AwPYPQ3dW/zEpBm/BIIRAnHheWAvaEqOw22yarLYaojym9Nv51QY8HJtklmOzt2DduvYpNoBf1gmKa3kFiS5ds8Wh+RacX5ZZDHdmPMlfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLZAI+sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLZAI+sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E382AC116D0;
	Thu, 15 Jan 2026 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497132;
	bh=OQJQlcWcCGzz6F0ocL5pKeR2CmqdAa8FyAsjT9Gj1n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLZAI+sd/x9vERQdZkU6BvPdZa+VRDC8VrYscVAhPbs9yKfzc0UdiSSMh1ffujL8Q
	 BHs+OoPngo93aIEHs56Pq93Ww9b3qh7b4u49kIMRLKx3cefCKVV4CLi7SWZZXB+P6l
	 8Jiit51Yxp2aBlCmblEMKcIzEsDMz3QxsGP7FGls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Heib <mheib@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/72] net: fix memory leak in skb_segment_list for GRO packets
Date: Thu, 15 Jan 2026 17:48:56 +0100
Message-ID: <20260115164145.164257018@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammad Heib <mheib@redhat.com>

[ Upstream commit 238e03d0466239410b72294b79494e43d4fabe77 ]

When skb_segment_list() is called during packet forwarding, it handles
packets that were aggregated by the GRO engine.

Historically, the segmentation logic in skb_segment_list assumes that
individual segments are split from a parent SKB and may need to carry
their own socket memory accounting. Accordingly, the code transfers
truesize from the parent to the newly created segments.

Prior to commit ed4cccef64c1 ("gro: fix ownership transfer"), this
truesize subtraction in skb_segment_list() was valid because fragments
still carry a reference to the original socket.

However, commit ed4cccef64c1 ("gro: fix ownership transfer") changed
this behavior by ensuring that fraglist entries are explicitly
orphaned (skb->sk = NULL) to prevent illegal orphaning later in the
stack. This change meant that the entire socket memory charge remained
with the head SKB, but the corresponding accounting logic in
skb_segment_list() was never updated.

As a result, the current code unconditionally adds each fragment's
truesize to delta_truesize and subtracts it from the parent SKB. Since
the fragments are no longer charged to the socket, this subtraction
results in an effective under-count of memory when the head is freed.
This causes sk_wmem_alloc to remain non-zero, preventing socket
destruction and leading to a persistent memory leak.

The leak can be observed via KMEMLEAK when tearing down the networking
environment:

unreferenced object 0xffff8881e6eb9100 (size 2048):
  comm "ping", pid 6720, jiffies 4295492526
  backtrace:
    kmem_cache_alloc_noprof+0x5c6/0x800
    sk_prot_alloc+0x5b/0x220
    sk_alloc+0x35/0xa00
    inet6_create.part.0+0x303/0x10d0
    __sock_create+0x248/0x640
    __sys_socket+0x11b/0x1d0

Since skb_segment_list() is exclusively used for SKB_GSO_FRAGLIST
packets constructed by GRO, the truesize adjustment is removed.

The call to skb_release_head_state() must be preserved. As documented in
commit cf673ed0e057 ("net: fix fraglist segmentation reference count
leak"), it is still required to correctly drop references to SKB
extensions that may be overwritten during __copy_skb_header().

Fixes: ed4cccef64c1 ("gro: fix ownership transfer")
Signed-off-by: Mohammad Heib <mheib@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260104213101.352887-1-mheib@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d8a3ada886ffb..ef24911af05a8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4045,12 +4045,14 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 {
 	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
 	unsigned int tnl_hlen = skb_tnl_header_len(skb);
-	unsigned int delta_truesize = 0;
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb, *tmp;
 	int len_diff, err;
 
+	/* Only skb_gro_receive_list generated skbs arrive here */
+	DEBUG_NET_WARN_ON_ONCE(!(skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST));
+
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
 	/* Ensure the head is writeable before touching the shared info */
@@ -4064,8 +4066,9 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
+		DEBUG_NET_WARN_ON_ONCE(nskb->sk);
+
 		err = 0;
-		delta_truesize += nskb->truesize;
 		if (skb_shared(nskb)) {
 			tmp = skb_clone(nskb, GFP_ATOMIC);
 			if (tmp) {
@@ -4108,7 +4111,6 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 			goto err_linearize;
 	}
 
-	skb->truesize = skb->truesize - delta_truesize;
 	skb->data_len = skb->data_len - delta_len;
 	skb->len = skb->len - delta_len;
 
-- 
2.51.0



