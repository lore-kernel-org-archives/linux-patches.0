Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D743544A3EB;
	Fri,  7 Aug 2026 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114768; cv=none; b=hx1pF4V877lvFmvq9MLawY3KzkJSLibTwpW+gPYwP2PwcZ5B71g+mTgq+GBgbEmamhnTziDBui4g8+U+FsO6zJ70bJ0cSElu63oFlJJl+a0KLVvPp29CLBIlqUIJJYk3wAwhWXcTc7EUJRgkTVTefNan+VairbY7eedL6p4LZWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114768; c=relaxed/simple;
	bh=/JEjI3oEAe/KlgcRV4/Ru6cxxiGKnfjygrDiiXL0g7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2AHWfhsr+ts7ronDcHnOtLDqsD0wHqOdAFmeAwdlsWCN6xtTGBjfBbC5wue5w4snYUC4DuUBCcU7aOiDCvJaH77m871U9auCSc4A6DvI7GdV38RW8zg8UadBYX46ula6DrJTNgfEy+W0lrGmvCoyqGgb5VU8b4UkXoBwdcd3BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TifdIt5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TifdIt5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D711F000E9;
	Fri,  7 Aug 2026 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114766;
	bh=iYa5LzpX1ctrkxq8pUBDpoIpc+mmtZ4LyoGckhSjnd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TifdIt5ugIF9wWbCuD24px9FbgudJuejpYHZR+0DDI89U++zIiiIobYRnRNJWYBZe
	 Vfc+s/KK86ZDaP/YfNm9CTuhkdHUAQCS4AqVSjoAxGncnYszH3CiVXKf++LAuVT1cE
	 7PLo+SBjKnwbZSlxtoNs8C5degsiDjyFSa5ncxj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/396] netfilter: br_netfilter: Reallocate headroom if necessary in neigh_hh_bridge()
Date: Fri,  7 Aug 2026 16:32:44 +0200
Message-ID: <20260807143424.370744332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit b2870fc21601db9133bc70c48c603b487614fa3b ]

neigh_hh_bridge() assumes the skb always has sufficient headroom to copy
the aligned  L2 header. This assumption can trigger the crash reported
below using the following netfilter setup:

$modprobe br_netfilter
$sysctl -w net.bridge.bridge-nf-call-iptables=1

$root@OpenWrt:~# nft list ruleset
table ip nat {
        chain prerouting {
                type nat hook prerouting priority dstnat; policy accept;
                ip daddr 192.168.83.123 dnat to 192.168.83.120
        }
}

- iperf3 client (192.168.83.119) --> bridge (192.168.83.118) --> iperf3 server (192.168.83.120)

the iperf3 client is sending packet for 192.168.83.123 to the bridge device.

[ 1579.036575] Unable to handle kernel write to read-only memory at virtual address ffffff8004d76ffe
[ 1579.045482] Mem abort info:
[ 1579.048273]   ESR = 0x000000009600004f
[ 1579.052024]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1579.057363]   SET = 0, FnV = 0
[ 1579.060417]   EA = 0, S1PTW = 0
[ 1579.063550]   FSC = 0x0f: level 3 permission fault
[ 1579.068345] Data abort info:
[ 1579.071224]   ISV = 0, ISS = 0x0000004f, ISS2 = 0x00000000
[ 1579.076720]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[ 1579.081770]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[ 1579.087092] swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000080dc4000
[ 1579.093794] [ffffff8004d76ffe] pgd=180000009ffff003, p4d=180000009ffff003, pud=180000009ffff003, pmd=180000009ffe3003, pte=0060000084d76787
[ 1579.106343] Internal error: Oops: 000000009600004f [#1] SMP
[ 1579.193824] CPU: 0 UID: 0 PID: 235 Comm: napi/qdma_eth-3 Tainted: G           O       6.12.57 #0
[ 1579.202614] Tainted: [O]=OOT_MODULE
[ 1579.206102] Hardware name: Airoha AN7581 Evaluation Board (DT)
[ 1579.211929] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 1579.218889] pc : br_nf_pre_routing_finish_bridge+0x1ac/0xcc8 [br_netfilter]
[ 1579.225859] lr : br_nf_pre_routing_finish_bridge+0x18c/0xcc8 [br_netfilter]
[ 1579.232822] sp : ffffffc0817cba20
[ 1579.236128] x29: ffffffc0817cba20 x28: 0000000000000000 x27: ffffff8002b89000
[ 1579.243273] x26: ffffff8004d7700e x25: 0000000000000008 x24: 0000000000000000
[ 1579.250416] x23: ffffffc08179d4c0 x22: 0000000000000000 x21: ffffffc08179d4c0
[ 1579.257561] x20: ffffff8004d9b800 x19: ffffff8015010000 x18: 0000000000000014
[ 1579.264704] x17: ffffffbf9e930000 x16: ffffffc0817c8000 x15: 0000000000000070
[ 1579.271848] x14: 0000000000000080 x13: 0000000000000001 x12: 0000000000000000
[ 1579.278993] x11: ffffffc0798caae0 x10: ffffff8014db6fd8 x9 : 0000000000000000
[ 1579.286136] x8 : 0000000000000003 x7 : ffffffc08171f628 x6 : 000000001a3b83d3
[ 1579.293281] x5 : 0000000000000000 x4 : 1beb76f22fee0000 x3 : ffffff8004d7700e
[ 1579.300425] x2 : 0000000000000000 x1 : ffffff8004d9b8bc x0 : ffffff80026ed000
[ 1579.307570] Call trace:
[ 1579.310018]  br_nf_pre_routing_finish_bridge+0x1ac/0xcc8 [br_netfilter]
[ 1579.316632]  br_nf_hook_thresh+0xd4/0x14bc [br_netfilter]
[ 1579.322032]  br_nf_hook_thresh+0x250/0x14bc [br_netfilter]
[ 1579.327517]  br_nf_hook_thresh+0x76c/0x14bc [br_netfilter]
[ 1579.333003]  br_handle_frame+0x180/0x480
[ 1579.336935]  __netif_receive_skb_core.constprop.0+0x540/0xf40
[ 1579.342682]  __netif_receive_skb_one_core+0x28/0x50
[ 1579.347561]  process_backlog+0x98/0x1e0
[ 1579.351398]  __napi_poll+0x34/0x1c4
[ 1579.354887]  net_rx_action+0x178/0x330
[ 1579.358638]  handle_softirqs+0x108/0x2d4
[ 1579.362560]  __do_softirq+0x10/0x18
[ 1579.366051]  ____do_softirq+0xc/0x20
[ 1579.369627]  call_on_irq_stack+0x30/0x4c
[ 1579.373550]  do_softirq_own_stack+0x18/0x20
[ 1579.377734]  do_softirq+0x4c/0x60
[ 1579.381050]  __local_bh_enable_ip+0x88/0x98
[ 1579.385234]  napi_threaded_poll_loop+0x188/0x21c
[ 1579.389853]  napi_threaded_poll+0x70/0x80
[ 1579.393863]  kthread+0xd8/0xdc
[ 1579.396918]  ret_from_fork+0x10/0x20
[ 1579.400499] Code: 88dffc22 3707ffc2 f9406663 f9406684 (f81f0064)
[ 1579.406589] ---[ end trace 0000000000000000 ]---
[ 1579.411209] Kernel panic - not syncing: Oops: Fatal exception in interrupt
[ 1579.418083] SMP: stopping secondary CPUs
[ 1579.422012] Kernel Offset: disabled

Fix the issue reallocating the skb headroom if necessary in neigh_hh_bridge routine.

Fixes: e179e6322ac33 ("netfilter: bridge-netfilter: Fix MAC header handling with IP DNAT")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h         | 8 ++++++--
 net/bridge/br_netfilter_hooks.c | 6 +++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 4a30bd458c5a..c13c758aca7e 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -480,11 +480,15 @@ static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 static inline int neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
 {
-	unsigned int seq, hh_alen;
+	unsigned int seq, hh_alen = HH_DATA_ALIGN(ETH_HLEN);
+	int err;
+
+	err = skb_cow_head(skb, hh_alen);
+	if (err)
+		return err;
 
 	do {
 		seq = read_seqbegin(&hh->hh_lock);
-		hh_alen = HH_DATA_ALIGN(ETH_HLEN);
 		memcpy(skb->data - hh_alen, hh->hh_data, ETH_ALEN + hh_alen - ETH_HLEN);
 	} while (read_seqretry(&hh->hh_lock, seq));
 	return 0;
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 083e2fe96441..6544c18febef 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -296,7 +296,11 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
 				goto free_skb;
 			}
 
-			neigh_hh_bridge(&neigh->hh, skb);
+			if (neigh_hh_bridge(&neigh->hh, skb)) {
+				neigh_release(neigh);
+				goto free_skb;
+			}
+
 			skb->dev = br_indev;
 
 			ret = br_handle_frame_finish(net, sk, skb);
-- 
2.53.0



