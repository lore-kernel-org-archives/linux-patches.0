Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209538;
	b=3UG3scGqDvCc/oJ5uPsey6SPRSYTRMOtwqj3Hka2+hY/NurDM4d4w6KHcqHGfvraghBN
	 nzu3KVn+cSdgAn0X9BkC/B7s7+0JQajPtA4OFA8bimRu6WtpLDbhGuuf2ROsg6Z/jk9Zv
	 n6OTQZKa5a6MHlh8JfM5pzkuClbuQsveG1exi+7RQYxgMzCnT6cEVZHjS642R7taEpgaq
	 iU/wlItqHHr8oMFM+WUQMT9uXGvyPpNgWdobnvTlojGk9QBGAld187DslbJpv0TpZ0SX8
	 FeJV0f2YnLFjYqetZuOBrz51kZAF1m5Mx9fe6xN1JnIbxZNay/m6ohddO3WZh0m4/pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3A1Y+vf4kY6HjSlcZ/zcb0fRJYauHuIilMX0Br6uAHE=;
	b=JK003DU7x9mOsE8CVSZeRM/Ds+W4y4rDViBTBgj5Zb4UX1H9lN4TqLYeU6fVaHK4mRdp
	 mHJ2o4PWNwXDNy86902okKL1WMSDiNRGNpQupzNwTnjjBnwgOBdVda3N2P4DrPpR1e/ME
	 n2w0J+FKbtYRenuUmr+o18790mRUae3xiLSu1bN6btgpdmoLhNBtbPMKph5aryVV6q0cc
	 yAdo06tMm+YS2/j0IqcbfM3W+FeLryBKFKKVM3i7MieHvOS/58Rt/hSMWwEtTfCpG49j9
	 qf8vPhr76gI6AZ8FowGqPU5m50BpaYgB5fj9g5ZQO1UJpPUyRFQJM4gJfzzvTN15ZTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kQ2EtnRD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4818606A322;
	Wed, 28 Oct 2026 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kQ2EtnRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67FF1F01828;
	Wed, 28 Oct 2026 17:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209537;
	bh=3A1Y+vf4kY6HjSlcZ/zcb0fRJYauHuIilMX0Br6uAHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQ2EtnRDrPlTYlSAZVC+iMFoqj4cbR4mlITZMbgHl/qfhlutPoFIqrumfeCMFqoCs
	 hnRbq6LnP7lGOsJXMGczAxmIpv6YExayfyXQh5IksIy3g6/jg3iMro4e5veJfJfVa8
	 EmcAiV2GtLxWo1q8Qq8HvHFJ1YsGsMOuGlL0FU7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 469/516] tipc: protect node reset trace dump with node lock
Date: Wed, 28 Oct 2026 18:00:21 +0100
Message-ID: <20261028170014.593384762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1308,7 +1308,9 @@ static void tipc_node_reset_links(struct
 
 	pr_warn("Resetting all links to %x\n", n->addr);
 
+	tipc_node_write_lock(n);
 	trace_tipc_node_reset_links(n, true, " ");
+	tipc_node_write_unlock_fast(n);
 	for (i = 0; i < MAX_BEARERS; i++) {
 		tipc_node_link_down(n, i, false);
 	}


