Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531D43D411F;
	Wed,  8 Apr 2026 18:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672964; cv=none; b=X0mbGiJZ7Vd7dL+magNU8jcaZOyIQYTcVPUs3hanNimp22MRduz+qExjBg5YSyR2HzwdGcPMli7qOp+EnjDsc9Xr6unGL59UFB4MaMc1mDxMfFkqMx36X3pIj/j9ntIFMNaPq8l96KuC0dTbGgtoKVzawiS7EVsTGPacbfnwKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672964; c=relaxed/simple;
	bh=o1gKXhjIb9Za+mAT5Cxe75/VLcPbzJEpXt3nOxxZjc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrG8TinawDQ6KT8+7UGWIuuRO7KTAWAXy7l0CdvzqYQ7nAhP+0mcug0AAT/qya1oTc5JeK9UdnMZfVlMsYAIWWh4jqSfEJ4c7vu1BI7WxEGjyZIGAfEQHTAI2i3kgyitR54eJCtWpP20gZ3+Pd/qCIJo1GowxnqtZceFEhNIkO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAJUBlTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAJUBlTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7AAC19421;
	Wed,  8 Apr 2026 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672964;
	bh=o1gKXhjIb9Za+mAT5Cxe75/VLcPbzJEpXt3nOxxZjc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAJUBlTASULjBW/D1DM97LkLRn2nIpDJSaNS0ucOViyzoLi/Ez2xyfpk4di7AF9hi
	 5vnJBcli3I//6H5UvK3uhy+3B9OyjGQkjtPWlgKVWGSZeicAipMdSThnNmkxG9k3Rm
	 3WvHZVI218hlr5TiYEjZD/jWYF24tWtGp2kSr7pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/277] net: introduce mangleid_features
Date: Wed,  8 Apr 2026 20:00:34 +0200
Message-ID: <20260408175935.688667703@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 31c5a71d982b57df75858974634c2f0a338f2fc6 ]

Some/most devices implementing gso_partial need to disable the GSO partial
features when the IP ID can't be mangled; to that extend each of them
implements something alike the following[1]:

	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
		features &= ~NETIF_F_TSO;

in the ndo_features_check() op, which leads to a bit of duplicate code.

Later patch in the series will implement GSO partial support for virtual
devices, and the current status quo will require more duplicate code and
a new indirect call in the TX path for them.

Introduce the mangleid_features mask, allowing the core to disable NIC
features based on/requiring MANGLEID, without any further intervention
from the driver.

The same functionality could be alternatively implemented adding a single
boolean flag to the struct net_device, but would require an additional
checks in ndo_features_check().

Also note that [1] is incorrect if the NIC additionally implements
NETIF_F_GSO_UDP_L4, mangleid_features transparently handle even such a
case.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/5a7cdaeea40b0a29b88e525b6c942d73ed3b8ce7.1769011015.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ddc748a391dd ("net: use skb_header_pointer() for TCPv4 GSO frag_off check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 3 +++
 net/core/dev.c            | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 20bd42fa160c9..fc55157a44860 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1817,6 +1817,8 @@ enum netdev_reg_state {
  *
  *	@mpls_features:	Mask of features inheritable by MPLS
  *	@gso_partial_features: value(s) from NETIF_F_GSO\*
+ *	@mangleid_features:	Mask of features requiring MANGLEID, will be
+ *				disabled together with the latter.
  *
  *	@ifindex:	interface index
  *	@group:		The group the device belongs to
@@ -2205,6 +2207,7 @@ struct net_device {
 	netdev_features_t	vlan_features;
 	netdev_features_t	hw_enc_features;
 	netdev_features_t	mpls_features;
+	netdev_features_t	mangleid_features;
 
 	unsigned int		min_mtu;
 	unsigned int		max_mtu;
diff --git a/net/core/dev.c b/net/core/dev.c
index c8e49eef45198..90b029c311a14 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3795,7 +3795,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			features &= ~NETIF_F_TSO_MANGLEID;
+			features &= ~dev->mangleid_features;
 	}
 
 	/* NETIF_F_IPV6_CSUM does not support IPv6 extension headers,
@@ -11295,6 +11295,9 @@ int register_netdevice(struct net_device *dev)
 	if (dev->hw_enc_features & NETIF_F_TSO)
 		dev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
+	/* TSO_MANGLEID belongs in mangleid_features by definition */
+	dev->mangleid_features |= NETIF_F_TSO_MANGLEID;
+
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
 	 */
 	dev->vlan_features |= NETIF_F_HIGHDMA;
-- 
2.53.0



