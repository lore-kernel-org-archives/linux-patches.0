Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738EE346769;
	Thu,  2 Jul 2026 16:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009688; cv=none; b=VMMQ5ixaMLpUgiS8rFZUSzffZt6DYpeitmz7VUfiPARLcMEO0w8VKrlMPwDemcPIpczbvX1xgMwS2SC8NRlLWCsC8HVa2UBNZhBO7ZQgcH5BHZwmHlVxZU/qvOXDTIEUTXNKzcZumTUd6dtaM3KWSjXIfjFAvLOx9KEibMHIpNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009688; c=relaxed/simple;
	bh=MEZ0bv3UK3u6q0YqC0Sj7RXEsb31Ya30ojimth/9Y94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXIxZZE/S9E7UNLRgeusTesWc/G3m+xwYEHcuyFysbEmm/+RGU66Xr+uKNjrii69EACp+Datdf6D4G8HeDURqVaE7dvJcOKsGos2ORn1rHmF2HqFIU85xcNnQT+9k0hUYKVOXd6TvgtITssfaH8iLNbQh40ic1WdJ5D9jHXfiUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QTCLdbO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QTCLdbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9EF1F00A3A;
	Thu,  2 Jul 2026 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009686;
	bh=Fv5nlmaETBhULDtwvbD6vnsLCwUdTk6gpC4azq5j6K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QTCLdbOAigPF2OA0MUS6Mf5QUyWtziDtSCWw/8FzC8o8kAVcTEegSaNTVIUrdjPf
	 f15pxjY8h0UlirEFBR1e90m2ZmaNI8MMeLmCAWbyjdgcQEZH59MO0hT4yBMgvcHmGm
	 OlkXiB25MJ5j9lUwgl9xuRBAeCoeU4AR0SYMpfPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/95] batman-adv: frag: avoid underflow of TTL
Date: Thu,  2 Jul 2026 18:19:45 +0200
Message-ID: <20260702155110.091718111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 493d9d2528e1a09b090e4b37f0f553def7bd5ce9 upstream.

Packets with a TTL are using it to limit the amount of time this packet can
be forwarded. But for batadv_frag_packet, the TTL was always only reduced
but it was never evaluated. It could even underflow without any effect.

Check the TTL in batadv_frag_skb_fwd() before attempting to prepare it for
forwarding. This keeps it in sync with the not fragmented unicast packet.

Cc: stable@kernel.org
Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/fragmentation.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index fbf030c57ac04d..0138b0953e10b5 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -420,6 +420,13 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
 	 */
 	total_size = ntohs(packet->total_size);
 	if (total_size > neigh_node->if_incoming->net_dev->mtu) {
+		if (packet->ttl < 2) {
+			kfree_skb(skb);
+			*rx_result = NET_RX_DROP;
+			ret = true;
+			goto out;
+		}
+
 		if (skb_cow(skb, ETH_HLEN) < 0) {
 			kfree_skb(skb);
 			*rx_result = NET_RX_DROP;
-- 
2.53.0



