Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B70426D37;
	Fri,  4 Sep 2026 06:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502809; cv=none; b=CTgrr5XseI5ahaM5vVRttypeYH6KTcXLLGmkfzawVKJgIDMj6bH8YzfJilMJ7HhGwus3s3aqHvAKf5zpNbxeG59dTTg2Fsvm3+BHk24YdA/2eWNDA81OiKwAO19WeojJ+/vR3l5wOAiW+805oLFbtkEH3/H94uQddHbj90hX4EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502809; c=relaxed/simple;
	bh=FTZInDbaPqN8EBeVvhSkX/RANME0gvEopc6HsLFfDnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GT5YN6E44YVp6RfE1IJaSHiobby8CXcxIFA3BbLmoFvVVeKaDJCLQxBlmcuMMXkbTgw3W6H4hW66y/2JJbPJev00ZpfuGMmiA60eKbRlcwGAcp3wuMHKdLakmTURXR9I6HQJcMg+WuFcsgef7iJah1jEEsAJusouGO1gGR6rf64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFLpdW2u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFLpdW2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FC91F00A3E;
	Fri,  4 Sep 2026 06:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502807;
	bh=Bn9Vz9fAKFNaxlRHvqjAwFMbtTLEk01f7xsbC4k8zrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFLpdW2u9iOMpBIao/lrkwYu6HCYPbMxeGpySjequTea7DvOzZmNAWl8qkvf/QOQ7
	 bsMiKGKBNAN7CZPIR/xkke+Nl8p1HEdg3/QHuN/ncF0sdClQId+xSsNIXsjMbCe2A+
	 V7d6Vh2xjTURmJNtgmw1jc3LMKcZMFq8CAgMxpMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 337/403] net: tun: bound receive headroom
Date: Fri,  4 Sep 2026 07:02:20 +0200
Message-ID: <20260904045742.483179004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asim Viladi Oglu Manizada <manizada@pm.me>

commit 447c9303942c439a117d9b76ce6d6e2116b38ee7 upstream.

tun_get_user() uses tun->align both as skb headroom and when choosing how
much packet data to keep linear. OVS can propagate an oversized headroom
request from another port to TUN or TAP.

When align is larger than the usable space in a one-page skb head,
SKB_MAX_HEAD(align) underflows and the result becomes negative when stored
in good_linear. That value later wraps when assigned to the size_t linear
variable, and tun_alloc_skb() can place skb->data outside the allocated
head.

Bound the headroom stored by TUN to the one-page skb-head budget and the
largest non-sentinel 16-bit skb header offset. Leave one linear byte for
raw TUN and a complete Ethernet header for TAP, including NET_IP_ALIGN.

Also pull the raw-TUN protocol byte and the TAP Ethernet header before
accessing them, so these checks remain safe for nonlinear skbs supplied by
other allocation paths.

Fixes: eaea34b23c46 ("net/tun: implement ndo_set_rx_headroom")
Cc: stable@vger.kernel.org
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260812012139.2134643-1-manizada@pm.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1170,11 +1170,16 @@ static netdev_features_t tun_net_fix_fea
 static void tun_set_headroom(struct net_device *dev, int new_hr)
 {
 	struct tun_struct *tun = netdev_priv(dev);
+	size_t max_headroom;
 
-	if (new_hr < NET_SKB_PAD)
-		new_hr = NET_SKB_PAD;
+	max_headroom = min_t(size_t, SKB_MAX_HEAD(0), U16_MAX - 1);
 
-	tun->align = new_hr;
+	if ((tun->flags & TUN_TYPE_MASK) == IFF_TAP)
+		max_headroom -= ETH_HLEN + NET_IP_ALIGN;
+	else
+		max_headroom -= 1;
+
+	tun->align = clamp_t(int, new_hr, NET_SKB_PAD, max_headroom);
 }
 
 static void
@@ -1877,7 +1882,13 @@ static ssize_t tun_get_user(struct tun_s
 	switch (tun->flags & TUN_TYPE_MASK) {
 	case IFF_TUN:
 		if (tun->flags & IFF_NO_PI) {
-			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
+			u8 ip_version;
+
+			if (!pskb_may_pull(skb, 1)) {
+				err = -EINVAL;
+				goto drop;
+			}
+			ip_version = skb->data[0] >> 4;
 
 			switch (ip_version) {
 			case 4:
@@ -1897,7 +1908,7 @@ static ssize_t tun_get_user(struct tun_s
 		skb->dev = tun->dev;
 		break;
 	case IFF_TAP:
-		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
+		if (!pskb_may_pull(skb, ETH_HLEN)) {
 			err = -ENOMEM;
 			drop_reason = SKB_DROP_REASON_HDR_TRUNC;
 			goto drop;


