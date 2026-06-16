Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F9644A72C;
	Tue, 16 Jun 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623558; cv=none; b=bsrcsoSIJyxKyq4nzjBA6z/YlyzMQBnM9ri40DD0MkbkIovLl8QQ8kYV1KqA7boEdoiAdvnoJ7pv4jjS62N9UA2UAdn+apUXzwSp/DI8SGdbfmP22ANQVQ1YJ5A2RKJ+suWhofU2bJt8RmsLC+i6YtvSP6o0b/w+tEkrOVIQ9OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623558; c=relaxed/simple;
	bh=mTGeKIxangur7t7OwYIPwe2HJs5uzi/vwTZdvXUuDWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdeEZZFK5Yx5RAMgb0+uK6mme8H1w+N8H5clUxxyDe5DkBjhPtLV0Ip6Jw6Nl4trf+IECkO6Fuw+uIoVEEbyH2KQ+d4pUA8vUtLuo5Ev9XWO0sOanjK/6Hw8Mg2XXdwR0xbQYqIROnlQpOtCZszkmo/hJYi2SKWdoJYRlmXnaOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ba6cwCgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ba6cwCgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC61F00A3D;
	Tue, 16 Jun 2026 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623557;
	bh=r2F37/MvcvY1yeC8niW6AG9wX0gdH1Pcbg7llcmO+RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ba6cwCglGWExCBM14TZVZ4a1xlsWnYJC2PIOIVqLZwDs7a8zR+hAfsXCQY5MvWWXK
	 mAZSLSdEfrdECoglUUunHODvXXpNGWCkKMaWcMLKaAt1rwFl6csOQBNLSn5zrVeZWx
	 GI4tE6838mLIME4e16SJ3rbmesuBgfneCBBL1gNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 144/378] netfilter: nf_log: validate MAC header was set before dumping it
Date: Tue, 16 Jun 2026 20:26:15 +0530
Message-ID: <20260616145117.845780594@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit a84b6fedbc97078788be78dbdd7517d143ad1a77 ]

The fallback path of dump_mac_header() guards the MAC header access
only with "skb->mac_header != skb->network_header", without checking
skb_mac_header_was_set(). When the MAC header is unset, mac_header is
0xffff, so the test passes and skb_mac_header(skb) returns
skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
dev->hard_header_len bytes out of bounds into the kernel log.

This is reachable via the netdev logger: nf_log_unknown_packet() calls
dump_mac_header() unconditionally, and an skb sent through AF_PACKET
with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
unset (__dev_queue_xmit(), which would reset it, is bypassed).

Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
uses, and replace the open-coded MAC header length test with
skb_mac_header_len(). Only skbs with an unset MAC header are affected;
valid ones are dumped as before.

 BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/nf_log_syslog.c:831)
 Read of size 1 at addr ffff88800ea49d3f by task exploit/148
 Call Trace:
  kasan_report (mm/kasan/report.c:595)
  dump_mac_header (net/netfilter/nf_log_syslog.c:831)
  nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfilter/nf_log_syslog.c:963)
  nf_log_packet (net/netfilter/nf_log.c:260)
  nft_log_eval (net/netfilter/nft_log.c:60)
  nft_do_chain (net/netfilter/nf_tables_core.c:285)
  nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
  nf_hook_slow (net/netfilter/core.c:619)
  nf_hook_direct_egress (net/packet/af_packet.c:257)
  packet_xmit (net/packet/af_packet.c:280)
  packet_sendmsg (net/packet/af_packet.c:3114)
  __sys_sendto (net/socket.c:2265)

Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_log_syslog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 41503847d9d7fb..c0462d403157a9 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -801,8 +801,8 @@ static void dump_mac_header(struct nf_log_buf *m,
 
 fallback:
 	nf_log_buf_add(m, "MAC=");
-	if (dev->hard_header_len &&
-	    skb->mac_header != skb->network_header) {
+	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
+	    skb_mac_header_len(skb) != 0) {
 		const unsigned char *p = skb_mac_header(skb);
 		unsigned int i;
 
-- 
2.53.0



