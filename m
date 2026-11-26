Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705158;
	b=AKtdR2DwOOrV0xI4TV6HZsmf38V0IN4CxOpTGtICpdBvjPhqAs667hzAOrnvvGkkAL5C
	 ro70ihSpXFjfm3hUTruupY+zfGVSMHBM/t1215H3x5tJBOw1jzj/rAXe+99aIxJx38DZX
	 jx4vuvTu/p4kIR0YBiuXrSzMpsbflOAZ5D9TS8d8aeoEhfWIMOL810eeHuejkCa4N4k+2
	 UuNTJJzAyMHAL6dL+0uT6ev3/ZsV1doFzCU2dJJaEmImKxKmmeoBXV0cOdhzmRKQedizF
	 ES0gS2ufY8X8IixMyYANmqN/T3bjbgUq92TdfPNgP5zEpZInNV0r1+B/ZtC4M03A6GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=STfNeVd6QDXOUcLPE28DkW6L0rTVWCEWgqLJRCZuGMs=;
	b=xwnc98xG9xJDybe0PWeOmWvPoIPh8Ql4+k0RwK6Rr5wnHVSkCp6r2C5JzH4/KgXMhCEf
	 5LYeAXhFi1FdLqXkcrHD9yMnPVWVlRKU8uZ0nMmUQFUvXQeoOHHnxsZ4G4akomNRl3pMR
	 cDHPpwmZ9RQ1hMf/dLH4lVtNEofvMDPuwkP1wJ2cbTnaZscYs3NfXyIAhxY3vm0c+0W+7
	 oxSTqfbCHbIIoiyyyIEVs7CAg2axsQC3DY/59NcbroByNyYSIwm/PIu9R2qNLDVb5GwgN
	 ReHME3KlwkfWCGQgfxxKa7k7HrgIpty0Gx+j6qkakXaeMwpfEav1SXJZrV/JXAe4z+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sC1tc/NK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86966606A31C;
	Thu, 26 Nov 2026 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sC1tc/NK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6057F1F000C4;
	Thu, 26 Nov 2026 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705157;
	bh=STfNeVd6QDXOUcLPE28DkW6L0rTVWCEWgqLJRCZuGMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sC1tc/NKc53jlxTtbc89X88tdsr7iNHY8IfAoRmB8n3OxUIPagRmm2ODFhaemXqh4
	 gOO2sOmRY369Owe6eZ+eqE/QSvkwwYdr5YlfaMT0mQ9eTi/yKrxCOXEamkNs9Eq7ID
	 Quc4NQioSbtMxTNzuFz2RhyzcytkX2sooas8Rtgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Cheng Yongkang <teel4res@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/319] net: bridge: disable MRP ports before the FDB flush in del_nbp()
Date: Thu, 26 Nov 2026 15:37:51 +0100
Message-ID: <20261126144009.069701691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

[ Upstream commit 37dfd0efbfffc20a57e41c2eb349ac49b1ca1ff8 ]

del_nbp() flushes the port's FDB entries before it unregisters the RX
handler. For a normal port, br_stp_disable_port() moves the port to
BR_STATE_DISABLED before this cleanup.

That does not hold for an MRP ring port. br_set_state() ignores state
changes while BR_MRP_AWARE_BIT is set, so br_stp_disable_port() leaves
the port state alone. br_mrp_port_del() then restores forwarding when
the bridge is up before clearing the bit. A frame received between
br_fdb_cleanup_by_dst() and netdev_rx_handler_unregister() can therefore
create a new FDB entry referencing the dying port. Nothing removes that
entry before destroy_nbp_rcu() frees the port, so a later frame to the
learned MAC can be forwarded through the freed port.

Remove the MRP and CFM instances before disabling the port, so that
br_stp_disable_port() actually transitions it to BR_STATE_DISABLED.
With CONFIG_BRIDGE_VLAN_FILTERING=y, synchronize_net() in
nbp_vlan_group_unpublish() also drains receive paths that could still
learn with the old state before the final FDB cleanup.

Found through an LLM-assisted source code analysis workflow and
reproduced on net with KASAN and CONFIG_BRIDGE_VLAN_FILTERING=y in QEMU.
A diagnostic switchdev module accepts MRP objects and delays the
NETDEV_CHANGEUPPER callback for 1.5 s, holding del_nbp() after the FDB
cleanup and before RX handler removal. The reproducer floods the MRP
port with rotating source MACs, waits for the port's RCU callback
through the module's rcu_barrier(), then sends frames to those MACs
from another port. The unpatched kernel reports:

  BUG: KASAN: slab-use-after-free in br_forward+0xb1/0x820
  Call Trace:
   <IRQ>
   br_forward+0xb1/0x820
   br_handle_frame_finish+0x148b/0x1e50
   br_handle_frame+0x90a/0x15c0

With this patch, three runs of six cycles each reach the delay without
a KASAN report.

Fixes: 6536993371fa ("bridge: mrp: Integrate MRP into the bridge")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261012123051.GA714215@shredder/
Closes: https://lore.kernel.org/netdev/20261022090431.3641707-1-teel4res@gmail.com/
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261101044840.1595584-1-1020691186@qq.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_if.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 7fb8014b84699..fd11b04173893 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -330,13 +330,13 @@ static void del_nbp(struct net_bridge_port *p)
 
 	nbp_delete_promisc(p);
 
+	br_mrp_port_del(br, p);
+	br_cfm_port_del(br, p);
+
 	spin_lock_bh(&br->lock);
 	br_stp_disable_port(p);
 	spin_unlock_bh(&br->lock);
 
-	br_mrp_port_del(br, p);
-	br_cfm_port_del(br, p);
-
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
 
 	list_del_rcu(&p->list);
-- 
2.53.0



