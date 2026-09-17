Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654613DCD86;
	Thu, 17 Sep 2026 17:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665181; cv=none; b=IRHOg0sAU31QiX44rQrDML30QL2iCIyPpk0zoStI29tnUAQd3TmzSCGF87FwxwtvSORZmLMvloRuFnU1+LUWM5tjQL+D9wX+mZSS4KYxeKTGCi1269Ac1tkFmNoTiS3c3sMBHBRoHkii2D6FJtPUT0VoL7qMaaKdcVkv7UrkVJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665181; c=relaxed/simple;
	bh=9XTvITCtFiJVXJwDO1bh18rkXRZvWHSpVfXWCsVGPM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lv0DqO5SXm6JyqIXPSqyvD7rqHlPoYp/TedEKMMxD3j8wtgiJeWqy6rYRqZnrF7qItx0nWXLXbERbF0Ikin000VSeXo1LucGzRfESi6hqi0wffIHXd6VfvzLuuOJW8LmdXIC1QQEiyUfAauGk9gXgPJMpilLQ2LvAKRp4feRkRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRDGNmNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRDGNmNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9111F000FF;
	Thu, 17 Sep 2026 17:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665180;
	bh=a6HcKzN1qu7xRAvlDR9gBaBpe/B+UKmqqdnxLXz4NYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRDGNmNizWO43ciCu36E4QfiZmeXvQuAASMCSUEmh955g93DQi599B45HWyPdnQuF
	 pY3/Iq1EUvzI7duy+rq4q5ZXVdwHqGC8I+MuX0AqJ5556mzCLYXo1t8tsi72sWWREi
	 qFNSlzBnwUjEcfh3oICTenSM1+NL88xm6EXuFdWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+83181a31faf9455499c5@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0620/1250] net: iptunnel: fix stale transport header during tunnel decapsulation
Date: Thu, 17 Sep 2026 16:06:55 +0100
Message-ID: <20260917151608.677767655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit 28a57fb2c5df4deb42a06e52fd36c14b37aa0034 ]

Syzbot reported a crash in qdisc_pkt_len_segs_init() caused by a stale
transport_header offset after tunnel decapsulation.

BUG: unable to handle page fault for address: ffffed102091a42e
Oops: Oops: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 340 Comm: qdisc_uaf_repro Not tainted 7.2.0-rc4-00061-g248951ddc14d #256 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__asan_load2
<IRQ>
qdisc_pkt_len_segs_init (net/core/dev.c:4145)
__dev_queue_xmit (net/core/dev.c:4787)
br_dev_queue_push_xmit (net/bridge/br_forward.c:53)
br_handle_frame_finish (net/bridge/br_input.c:229)
br_handle_frame (net/bridge/br_input.c:315)
__netif_receive_skb_core.constprop.0 (net/core/dev.c:6099)
__netif_receive_skb_list_core (net/core/dev.c:6287)
netif_receive_skb_list_internal (net/core/dev.c:6445)
napi_complete_done (net/core/dev.c:6813)
gro_cell_poll (net/core/gro_cells.c:74)
__napi_poll (net/core/dev.c:7735)
net_rx_action (net/core/dev.c:7798 net/core/dev.c:7955)
handle_softirqs (kernel/softirq.c:622)
do_softirq (kernel/softirq.c:523  kernel/softirq.c:510 )
__local_bh_enable_ip (kernel/softirq.c:450)
tun_get_user (drivers/net/tun.c:1986 (discriminator 1))
tun_chr_write_iter (drivers/net/tun.c:2032)

The issue is completely latent until qdisc read transport header in
commit 7fb4c1967011 ("net: pull headers in qdisc_pkt_len_segs_init()").
The crash requires four conditions to line up:

1. The incoming packet is encapsulated and carries GSO metadata. The outer
   transport header offset is stored in skb->transport_header while the
   packet is still in the outer tunnel context.
2. The tunnel receiver strips the outer headers. skb->data is advanced to
   the inner frame, but skb->transport_header is left pointing to the
   now-removed outer L4 header, so it becomes a negative offset relative to
   the new data.
3. The inner frame is not delivered to the local IP stack. Instead, it
   is forwarded at L2 by a bridge or HSR, so ip_rcv_core() never runs and
   the transport header is not reset to the inner L4 offset.
4. The forwarding path calls __dev_queue_xmit(), which enters
   qdisc_pkt_len_segs_init(). That function computes the GSO header length
   from skb_transport_offset(skb). Because the offset is negative, the
   unsigned cast overflows and pskb_may_pull(skb, hdr_len +
   sizeof(struct tcphdr)) reads past the end of the skb, triggering a
   KASAN fault or page fault.

The issue specifically requires GSO packets (shinfo->gso_size != 0), which
are processed/aggregated through gro_cells. Fix this by clearing
transport_header to the ~0U sentinel in gro_cell for all tunnnel driver.
GTP does not support GRO/GSO, drop the evil GSO packets in GTP directly.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+83181a31faf9455499c5@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69de2bee.a00a0220.475f0.0041.GAE@google.com/T/
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260825123909.1463121-1-dongchenchen2@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c      | 5 +++++
 include/linux/skbuff.h | 5 +++++
 net/core/gro_cells.c   | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 070f37cbddbf6..184cb367bbe13 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -318,6 +318,11 @@ static int gtp_inner_proto(struct sk_buff *skb, unsigned int hdrlen,
 static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 		  unsigned int hdrlen, unsigned int role, __u16 inner_proto)
 {
+	if (skb_is_gso(skb)) {
+		netdev_dbg(pctx->dev, "GSO is not supported in GTP\n");
+		goto err;
+	}
+
 	if (!gtp_check_ms(skb, pctx, hdrlen, role, inner_proto)) {
 		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
 		return 1;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 36a02653665ac..c9abf7e3accf4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3066,6 +3066,11 @@ static inline bool skb_transport_header_was_set(const struct sk_buff *skb)
 	return skb->transport_header != (typeof(skb->transport_header))~0U;
 }
 
+static inline void skb_unset_transport_header(struct sk_buff *skb)
+{
+	skb->transport_header = (typeof(skb->transport_header))~0U;
+}
+
 static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
 {
 	DEBUG_NET_WARN_ON_ONCE(!skb_transport_header_was_set(skb));
diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index a725d21159a6f..ca82da018be93 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -22,6 +22,8 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
 	if (unlikely(!(dev->flags & IFF_UP)))
 		goto drop;
 
+	skb_unset_transport_header(skb);
+
 	if (!gcells->cells || skb_cloned(skb) || netif_elide_gro(dev)) {
 		res = netif_rx(skb);
 		goto unlock;
-- 
2.53.0



