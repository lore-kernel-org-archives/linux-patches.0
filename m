Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29D22C6AF;
	Sun,  1 Sep 2024 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210358; cv=none; b=SQPgRjkUh1DrrfbyFIL1hUXGYIpRadOnZZTwxrY21gLQ/3svIoN1cZf4QioshfLTdzmbcvH1sUIqBFy8XqhmMtMhWOElj3QkTabszTnoieswi05xEgsyps9N+4ZmMXwt/lKSKaKM1l72PlD5jzhRJWP79iJTMfauT2/TgdgWPDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210358; c=relaxed/simple;
	bh=XF7QdoucP3l785WQ3f480E7PtWBSNfvg+XGPcvwOtYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqqF9wXJsqxyoMOCWIbZLDjDXHPNdkEyIU3//73UVEStGmCMPqdxd/tDSiBJNechVkBnu1gqtPhi/ZntMaye6C7uIwTDHw9TBjHJQ6UD+R+n60XE9XMLSIwFuVjolr056rSUzlZZvHWqZC53E5toBkcVCBgCmV/FCCLoItGo7HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eX8WlZ5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eX8WlZ5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58629C4CEC3;
	Sun,  1 Sep 2024 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210358;
	bh=XF7QdoucP3l785WQ3f480E7PtWBSNfvg+XGPcvwOtYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eX8WlZ5qptCQKEQKQqV1gGcsyzsgxcn8QtHqeqqf3xmbB8d+b7oMtIylojVlmdXbU
	 jgLO8iaNdTOnNihvmLL1rNdMprhoWY6DmclB9gD/Jm0D3xW3NxHVPu/mRmMtrGp75S
	 O6Iqmwb0Dwbn0Ovd9N4TChjLO4HP3n3/mSwW3zm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/215] ip6_tunnel: Fix broken GRO
Date: Sun,  1 Sep 2024 18:17:30 +0200
Message-ID: <20240901160828.581388035@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d370a71c97520..5955fca601b3a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1501,7 +1501,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			tdev = __dev_get_by_index(t->net, p->link);
 
 		if (tdev) {
-			dev->hard_header_len = tdev->hard_header_len + t_hlen;
+			dev->needed_headroom = tdev->hard_header_len +
+				tdev->needed_headroom + t_hlen;
 			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
 			mtu = mtu - t_hlen;
@@ -1729,7 +1730,9 @@ ip6_tnl_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 int ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct ip6_tnl *tnl = netdev_priv(dev);
+	int t_hlen;
 
+	t_hlen = tnl->hlen + sizeof(struct ipv6hdr);
 	if (tnl->parms.proto == IPPROTO_IPV6) {
 		if (new_mtu < IPV6_MIN_MTU)
 			return -EINVAL;
@@ -1738,10 +1741,10 @@ int ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
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
@@ -1887,12 +1890,11 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
 	t_hlen = t->hlen + sizeof(struct ipv6hdr);
 
 	dev->type = ARPHRD_TUNNEL6;
-	dev->hard_header_len = LL_MAX_HEADER + t_hlen;
 	dev->mtu = ETH_DATA_LEN - t_hlen;
 	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 		dev->mtu -= 8;
 	dev->min_mtu = ETH_MIN_MTU;
-	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len;
+	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len - t_hlen;
 
 	dev_hold(dev);
 	return 0;
-- 
2.43.0



