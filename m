Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2663B19BC;
	Fri,  4 Sep 2026 05:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499949; cv=none; b=pKA5jkHs0i3DJlE9E1iL5gEw2C1tHcr2rCkrXRCRGKD45j5Iwf3vFM6ACFdCxzQsGmZmHFs92WYW29VZ7+pIZwUpvc7Z3CIrNSGSZ9i6bMZTE4SgQ7SLnrjkbtoBTqKK/02U8H6mZm+bOcR7ZcsSMyPSETXfFgJ29O6N8ueTyHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499949; c=relaxed/simple;
	bh=daKuvL7Nr+YG5J/d226G4wXaY+WjstF8RPL9Zm04tWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5x/xs3IJgxv2ALVUFtrOrK1JcXMMmYFXE/U25oCZDrd5t7bUYx0ZJ/JM6SGG8GhElAq6EgshTeo5vQMKc0SlmwfBgYx15bLZr+65TvAibb8bV92zwnJ3icz6H8DI+TgUhTDYaWdZ0/s88aab248Jc4QSvov/Vh9S+LIZrMunRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Baoh23oU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Baoh23oU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2961F00A3D;
	Fri,  4 Sep 2026 05:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499947;
	bh=/ZplAIcrmK26zskYcN5u1iGFquCIfrnwdXsGUIf+8jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Baoh23oUPG0RjbZaHKoJL3kGzv4QtuZFjakb3uMe1t9JVQRjn8My5Pdusreg6lUf5
	 7ZojRoNoXpe1UZqtdKy+bV1A5uHoHI3vrsCulv01W30LV+f1EtuhC+p5l4uBb4aFI1
	 IcNLnT4hl7QukTCYty3eLCbsbXCXPgx6U0o0p5Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 598/713] net: tun: bound receive headroom
Date: Fri,  4 Sep 2026 06:59:26 +0200
Message-ID: <20260904045817.228097577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1107,11 +1107,16 @@ static netdev_features_t tun_net_fix_fea
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
@@ -1822,7 +1827,13 @@ static ssize_t tun_get_user(struct tun_s
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
@@ -1842,7 +1853,7 @@ static ssize_t tun_get_user(struct tun_s
 		skb->dev = tun->dev;
 		break;
 	case IFF_TAP:
-		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
+		if (!pskb_may_pull(skb, ETH_HLEN)) {
 			err = -ENOMEM;
 			drop_reason = SKB_DROP_REASON_HDR_TRUNC;
 			goto drop;


