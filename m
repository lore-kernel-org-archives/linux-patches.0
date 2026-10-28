Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211935;
	b=Hd9e2KcDS77sK17JUdcG9MeiRPwTeB+iL6a4o+MOSUqwyBq+cy5A5w/oM58coziUQGVs
	 LWsAsJcOn/CduEbRxvqZ23dNawHUUulf0/qcLdQjJhcmS1PH5K+aimN/eLvO/BIm938Fo
	 zt9YNYDi74uXqvzd1VhL1dtnMbXW4R7shI5tjRE0/ghhSWf87TaWc7yghnkw1s6ek9ams
	 e615IWiIFj565iNbb+gV5ETv1ctfO0M3lYA4iJd2meE7H+GlT+zCA5IFurmxe8ticBYXb
	 OdSGt1mYkrOAvOd5/Nl9k//JAq2pmAZHYM6LQr/r81uyU4GSodNBZaU5/EY9ASHdPCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+vOsPjkjDEhUyb3jrAvTuNWsJ+i+c319npLwmHyZnM=;
	b=jyby/v6UYTniIFl0rtJj8raIoteXZbsoEVc7P8AnKvgni7IfIw9CAydOXAZzSgOaYOxC
	 5d/dpOr5Vhj84KClBfFLun6zg28I926Gvqnpvq8y2aJ/c/0GlIXyh5CPgqG4YekyBidE+
	 ho0byyaCUc0a5DXHG7BU+XmdvlsSFC1Zvu97niBuobh+g6keyMYcHS/FmHoKRvkvkWiuP
	 kGQkXPUXBPlhBxJpWadbIclp6FaDMOA3LumomP+KpihNUbzsi0UrqnkhMGx1jH7R/pbqJ
	 gFpLoxfUhX3IVJzn7E8lrNM8w+INEtjcQt+CzUaiMssE2q8euF3zdeWxlWKbClMHAww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrFNRNvz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA941606A31C;
	Wed, 28 Oct 2026 18:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrFNRNvz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481841F01825;
	Wed, 28 Oct 2026 18:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211934;
	bh=c+vOsPjkjDEhUyb3jrAvTuNWsJ+i+c319npLwmHyZnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrFNRNvzxhAiv34/J14M8hEpPxBlBOgYEmmzK9102kQIywQe+P3+i/AV2kDtLhBvy
	 +nF6qABimmvvwGzWfMUfSLnmmvsbKSwheG/duFBHRpemAKjywBJke5UVsVGY4Ecdi9
	 /1XAXIhH0JF6qZGftEktb0Z/hLQkMkQgjCS33MsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 515/571] tipc: protect node reset trace dump with node lock
Date: Wed, 28 Oct 2026 18:01:02 +0100
Message-ID: <20261028170020.249510214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit dddf197f29ba5e47a476dde82bf542ca2e0d5e5e upstream.

The tipc_node_reset_links trace event asks tipc_node_dump() to walk the
node's link entries. Unlike the other node events that request link data,
this event runs without the node lock.

This permits bearer teardown to free a link while the trace callback is
dumping it:

  CPU 0                                CPU 1
  trace_tipc_node_reset_links()
    tipc_node_dump()
      l = n->links[0].link
                                       tipc_node_write_lock()
                                       kfree(l)
                                       n->links[0].link = NULL
                                       tipc_node_write_unlock()
      tipc_link_dump(l)

tipc_link_dump() then dereferences the stale pointer. KASAN reported:

  BUG: KASAN: slab-use-after-free in tipc_link_dump
  Read of size 4 by task poc/115
  Call Trace:
   tipc_link_dump+0x10cb/0x16b0
   tipc_node_dump+0x4bb/0x740
   trace_event_raw_event_tipc_node_class+0x258/0x360
   tipc_node_reset_links+0x14d/0x1a0
   tipc_rcv+0x13f5/0x3030
   tipc_udp_recv+0x4e3/0x670
  Allocated by task 0:
   tipc_link_create+0x1e1/0x1020
   tipc_node_check_dest+0x7d2/0x11a0
   tipc_disc_rcv+0xdbf/0x1430
  Freed by task 89:
   kfree+0x131/0x3c0
   tipc_node_link_down+0x267/0x4b0
   tipc_node_delete_links+0xec/0x160
   bearer_disable+0x107/0x260

Take the node write lock around the trace event. This serializes the
dump against tipc_node_link_down(delete=true), which frees the link
under the same write lock.

Fixes: eb18a510b5cd ("tipc: add trace_events for tipc node")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260825190141.242219-1-nicoyip.dev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1335,7 +1335,9 @@ static void tipc_node_reset_links(struct
 
 	pr_warn("Resetting all links to %x\n", n->addr);
 
+	tipc_node_write_lock(n);
 	trace_tipc_node_reset_links(n, true, " ");
+	tipc_node_write_unlock_fast(n);
 	for (i = 0; i < MAX_BEARERS; i++) {
 		tipc_node_link_down(n, i, false);
 	}


