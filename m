Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C6919EEA2;
	Tue, 27 Aug 2024 15:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772604; cv=none; b=gXWXU6soDzEnihmSjId/NMNg/QIdpu7/PLIxXubJEzDVKkiCRAaysj5CXpP+fz07dyluTX90lwDwBpkv3Jdmw3Ce02Klo5UxXRBnAp+j+w+OTk6wJEu8K1XtWRvUSLWUlfxuKOSQbYqZze+C5GchTDOutomYVQlmLiPUPVDMGz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772604; c=relaxed/simple;
	bh=SPnHnYW3tVRVh98U+iW3xjSNlYtEcfLMawljcbSclAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ij6rScgrn0fwh/n1eZMZJ5CXIm2ZfThcRT9cHitvKUPI2/UnLcmippQuHo77f1Cryp9GpSBAmqGi73EbZ+DvEIaW7zTH0PtvzEC34aOce+wDOpwHyBtqyzCC7Hl0vr/7tlUe6t7J7AXr5oej3Byhdt4T6Ck4IO7my5l+0ATDzT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4sY4PUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4sY4PUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6ECC4AF15;
	Tue, 27 Aug 2024 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772604;
	bh=SPnHnYW3tVRVh98U+iW3xjSNlYtEcfLMawljcbSclAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4sY4PUUTo8a3d6Si3Vl1e8CWTeBhJ0BpJ6L8d21oZbybGX++VIeaxWUvjR3yoXF1
	 jGUMlTPhwMJAO7OfLLvnrKRkY+PsHiwW/UnTAp54kX4myQxEtwFHtv96K3U4G1X0oF
	 pe3BW8vCeAI0qyOOABHfiw/hY1CP/XXqm+RzW0kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/321] ip6_tunnel: Fix broken GRO
Date: Tue, 27 Aug 2024 16:39:05 +0200
Message-ID: <20240827143847.257637287@linuxfoundation.org>
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

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 4b3e33fcc38f7750604b065c55a43e94c5bc3145 ]

GRO code checks for matching layer 2 headers to see, if packet belongs
to the same flow and because ip6 tunnel set dev->hard_header_len
this check fails in cases, where it shouldn't. To fix this don't
set hard_header_len, but use needed_headroom like ipv4/ip_tunnel.c
does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Link: https://patch.msgid.link/20240815151419.109864-1-tbogendoerfer@suse.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2699915bb85be..f3324f2a40466 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1510,7 +1510,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			tdev = __dev_get_by_index(t->net, p->link);
 
 		if (tdev) {
-			dev->hard_header_len = tdev->hard_header_len + t_hlen;
+			dev->needed_headroom = tdev->hard_header_len +
+				tdev->needed_headroom + t_hlen;
 			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
 			mtu = mtu - t_hlen;
@@ -1734,7 +1735,9 @@ ip6_tnl_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 int ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct ip6_tnl *tnl = netdev_priv(dev);
+	int t_hlen;
 
+	t_hlen = tnl->hlen + sizeof(struct ipv6hdr);
 	if (tnl->parms.proto == IPPROTO_IPV6) {
 		if (new_mtu < IPV6_MIN_MTU)
 			return -EINVAL;
@@ -1743,10 +1746,10 @@ int ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
 			return -EINVAL;
 	}
 	if (tnl->parms.proto == IPPROTO_IPV6 || tnl->parms.proto == 0) {
-		if (new_mtu > IP6_MAX_MTU - dev->hard_header_len)
+		if (new_mtu > IP6_MAX_MTU - dev->hard_header_len - t_hlen)
 			return -EINVAL;
 	} else {
-		if (new_mtu > IP_MAX_MTU - dev->hard_header_len)
+		if (new_mtu > IP_MAX_MTU - dev->hard_header_len - t_hlen)
 			return -EINVAL;
 	}
 	dev->mtu = new_mtu;
@@ -1892,12 +1895,11 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
 	t_hlen = t->hlen + sizeof(struct ipv6hdr);
 
 	dev->type = ARPHRD_TUNNEL6;
-	dev->hard_header_len = LL_MAX_HEADER + t_hlen;
 	dev->mtu = ETH_DATA_LEN - t_hlen;
 	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 		dev->mtu -= 8;
 	dev->min_mtu = ETH_MIN_MTU;
-	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len;
+	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len - t_hlen;
 
 	netdev_hold(dev, &t->dev_tracker, GFP_KERNEL);
 	return 0;
-- 
2.43.0



