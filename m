Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210094;
	b=gNFBlk5nZz0anWCrHjf+junz1rRnroOnQQK6OafWtnOY4NTkgfEGKsnXU5x4QJSMgQH6
	 J1lh3yUsWlefhFKXNZweWdRC5WuhCt6XUvX50m/qwg0Eii/YGXP+sDcgepaZZYFI4qj8z
	 /koHFa32y9+7sxuKHV6VP5ip+e6/ta3F0v/UBTgVzPYybBr8Swkq7fjd9YPlOBga7rzG+
	 W7HVU28enq1qlbnxjR07DwBaq2WRQuzCUXvNTMh292LoWfTegaEuYc158V9jCoJ9jewQF
	 gq9XL7EMTp/XPikoh81K7uD651M4lgf6Vvc0xT14GA1zIeCy8oGirJNNO1rgwZvAEdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Vj04Tf92L3eyw3XcNVQiqT46yy6iqLHkB2JB4HRemY=;
	b=iP30vhCZ9duow27spLZ4rvh6iNvYIbdFuWu0BNAx6m+/XBS+UXDC6wnex2hXIUU0NdV8
	 daGI5MHw4tiWOjvK3ei294AxGb5WMlNenpJOZ4SXr+FSVk0af6rXraoNxb9GHobeEwaw1
	 2EPFELqa0LWjk+2PnidAZ62OrZ/VbaG05tBj6NEeKfrqIIZQuMIL8eXtVyBnz4PcBrYB+
	 SQ7WX+Jpn4Ij+OljasuV0vAqPatTjhYIZl7w7zdsFofjMm1AXueCRXneBH45skhXIc+9J
	 5RIjfcxM9epQd2Ym48o96UdorfxkC6WafYpWVQk/x32C4CXuwqLqJEBgCfdTWrmjCbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8cjnDnF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD22C606A336;
	Wed, 28 Oct 2026 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8cjnDnF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B5F1F01829;
	Wed, 28 Oct 2026 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210093;
	bh=2Vj04Tf92L3eyw3XcNVQiqT46yy6iqLHkB2JB4HRemY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8cjnDnFD+zfhmiI7KWd+kB8+2yDUPdVLRSW84aZlgp3iOXdzndtpkP97Q6B7W9rb
	 8GqXHBL8Kx+lbQCQuBoftuxwcbrt5t4EN/+vtOrZdiU6q3WXSTVc/IFeL/qe+7afCN
	 EsdqyNRDnYuejW5aSyAOQiCI0b3COfSNzwhL4ikc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 074/168] tipc: protect node reset trace dump with node lock
Date: Wed, 28 Oct 2026 18:00:10 +0100
Message-ID: <20261028165944.835916616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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


