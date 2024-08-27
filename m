Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6831C9EC8;
	Tue, 27 Aug 2024 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772465; cv=none; b=nQkC1dO+aku1iN7u/97QEwF4N0Eug4hlovJ47bAIxSzpprooMYgJlntZkjmDMEkaRdeSRKijZnd9A+ESEudjj4SllNllyXY8YYrdizcbDXJB23pbgOcG5xThAcJvHPZbZVZ+avfHUpeMyzTikN+GiEAm4uh/+3XUD8sdz+tR3rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772465; c=relaxed/simple;
	bh=1+kAkuHd5JgRI5i95sU7wKjo58aANzG0d8huV+IMkFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgVL3JwtsuTGhwlL7FyWrVMKrWXFKsb7p///PWyglXLlTpvXPorTUMMa1Lg+f/5jGiFCEExTmniwLYvPVm/s5HpkAMrYhXY3mr9QRGTkB/CToesOlnDxs+qIyLBOhypvSct3ikqDDuwbpbPotxeLzPNaFE0fkwYgBm3F4T3tNqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbEdMfSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbEdMfSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8A5C61040;
	Tue, 27 Aug 2024 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772465;
	bh=1+kAkuHd5JgRI5i95sU7wKjo58aANzG0d8huV+IMkFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbEdMfSWKEillm3YR0PyuF98mJXHUDOXlMLJ491Tmw4cbsOWFL65SVuOtoSlJ9+Qx
	 t3w0rwLtXmLbZFu6HjfMGdOYf5ViR1QoYuUfVWkqdgU4teAZUUBAvxDrXw69oIvO/7
	 Cv3LDNDzowuvJSoj3MNYktAvAo8mE1Qxb9rEZZwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 223/321] net: dsa: tag_ocelot: call only the relevant portion of __skb_vlan_pop() on TX
Date: Tue, 27 Aug 2024 16:38:51 +0200
Message-ID: <20240827143846.720227066@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0bcf2e4aca6c29a07555b713f2fb461dc38d5977 ]

ocelot_xmit_get_vlan_info() calls __skb_vlan_pop() as the most
appropriate helper I could find which strips away a VLAN header.
That's all I need it to do, but __skb_vlan_pop() has more logic, which
will become incompatible with the future revert of commit 6d1ccff62780
("net: reset mac header in dev_start_xmit()").

Namely, it performs a sanity check on skb_mac_header(), which will stop
being set after the above revert, so it will return an error instead of
removing the VLAN tag.

ocelot_xmit_get_vlan_info() gets called in 2 circumstances:

(1) the port is under a VLAN-aware bridge and the bridge sends
    VLAN-tagged packets

(2) the port is under a VLAN-aware bridge and somebody else (an 8021q
    upper) sends VLAN-tagged packets (using a VID that isn't in the
    bridge vlan tables)

In case (1), there is actually no bug to defend against, because
br_dev_xmit() calls skb_reset_mac_header() and things continue to work.

However, in case (2), illustrated using the commands below, it can be
seen that our intervention is needed, since __skb_vlan_pop() complains:

$ ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
$ ip link set $eth master br0 && ip link set $eth up
$ ip link add link $eth name $eth.100 type vlan id 100 && ip link set $eth.100 up
$ ip addr add 192.168.100.1/24 dev $eth.100

I could fend off the checks in __skb_vlan_pop() with some
skb_mac_header_was_set() calls, but seeing how few callers of
__skb_vlan_pop() there are from TX paths, that seems rather
unproductive.

As an alternative solution, extract the bare minimum logic to strip a
VLAN header, and move it to a new helper named vlan_remove_tag(), close
to the definition of vlan_insert_tag(). Document it appropriately and
make ocelot_xmit_get_vlan_info() call this smaller helper instead.

Seeing that it doesn't appear illegal to test skb->protocol in the TX
path, I guess it would be a good for vlan_remove_tag() to also absorb
the vlan_set_encap_proto() function call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 67c3ca2c5cfe ("net: mscc: ocelot: use ocelot_xmit_get_vlan_info() also for FDMA and register injection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_vlan.h | 21 +++++++++++++++++++++
 net/core/skbuff.c       |  8 +-------
 net/dsa/tag_ocelot.c    |  2 +-
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index e0d0a645be7cf..83266201746c1 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -704,6 +704,27 @@ static inline void vlan_set_encap_proto(struct sk_buff *skb,
 		skb->protocol = htons(ETH_P_802_2);
 }
 
+/**
+ * vlan_remove_tag - remove outer VLAN tag from payload
+ * @skb: skbuff to remove tag from
+ * @vlan_tci: buffer to store value
+ *
+ * Expects the skb to contain a VLAN tag in the payload, and to have skb->data
+ * pointing at the MAC header.
+ *
+ * Returns a new pointer to skb->data, or NULL on failure to pull.
+ */
+static inline void *vlan_remove_tag(struct sk_buff *skb, u16 *vlan_tci)
+{
+	struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data + ETH_HLEN);
+
+	*vlan_tci = ntohs(vhdr->h_vlan_TCI);
+
+	memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
+	vlan_set_encap_proto(skb, vhdr);
+	return __skb_pull(skb, VLAN_HLEN);
+}
+
 /**
  * skb_vlan_tagged - check if skb is vlan tagged.
  * @skb: skbuff to query
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4d46788cd493a..768b8d65a5baa 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5791,7 +5791,6 @@ EXPORT_SYMBOL(skb_ensure_writable);
  */
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci)
 {
-	struct vlan_hdr *vhdr;
 	int offset = skb->data - skb_mac_header(skb);
 	int err;
 
@@ -5807,13 +5806,8 @@ int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci)
 
 	skb_postpull_rcsum(skb, skb->data + (2 * ETH_ALEN), VLAN_HLEN);
 
-	vhdr = (struct vlan_hdr *)(skb->data + ETH_HLEN);
-	*vlan_tci = ntohs(vhdr->h_vlan_TCI);
-
-	memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
-	__skb_pull(skb, VLAN_HLEN);
+	vlan_remove_tag(skb, vlan_tci);
 
-	vlan_set_encap_proto(skb, vhdr);
 	skb->mac_header += VLAN_HLEN;
 
 	if (skb_network_offset(skb) < ETH_HLEN)
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index afca3cdf190a0..18dda9423fae5 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -26,7 +26,7 @@ static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
 	br_vlan_get_proto(br, &proto);
 
 	if (ntohs(hdr->h_vlan_proto) == proto) {
-		__skb_vlan_pop(skb, &tci);
+		vlan_remove_tag(skb, &tci);
 		*vlan_tci = tci;
 	} else {
 		rcu_read_lock();
-- 
2.43.0



