Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24794DDB2B;
	Wed, 30 Sep 2026 18:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793374; cv=none; b=ozIYRFSFN7FbzMKuZCDtCo5NITO7QByrUw7Pxp4jllk43dxpM4RUVkhrIHbosDoeekIuXI55PjLgDTrXALOS4xfig98O7yaNJH0B93aRhdbhPn4INP1+nSfoXuK1HVevkUd/he6N93HG/+kRUaC3c89wa4ww2+1gdee4o1QbTYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793374; c=relaxed/simple;
	bh=FE/n8A6Zh+6y8BMZZQ1txwEbWm2QhXFfl3QY5NDrgeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSCKu3WupspwlqJ6Eb+0bu7RvgfSQm71bp2GgOm+qxQZP7w8XDd9jKMXrwECmNMIFnQ2KBHp4ul0Re/TZcU9k24q7rzSuvwbk4AzErJ38U7CsGFKgxZFIw2j/ju7phmAAUJL/O+/x/N4QhbCVGpXR6quQIyPw8F6S2+TELQpRTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0AJT2l0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0AJT2l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF691F000FF;
	Wed, 30 Sep 2026 18:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793372;
	bh=iZWgeBozh+NYzfUfkOkt42S4DdkJUIPcs8nymyrzsM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0AJT2l0pQHHMzWNatLFeROm32PzWlKQLuW3uibjAZqkCM4pW+Tg9CWoPfheEJ9rN
	 h/E/MzAX0M9DCxLHsovjHlEzPEjMaq3lGIG4bqzudwPKJ7HpOl7mRiwAM0KJkTrcfZ
	 MUe1w7BJHxc/XZfyzJMwYBGs/Pt5tYrGq+uPnxcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 233/395] llc: reserve device headroom for allocated frames
Date: Wed, 30 Sep 2026 17:28:15 +0200
Message-ID: <20260930152345.716529790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Zixuan Chai <petalzu987@gmail.com>

commit 72b5b9a28b996e09b8b5b944370c79851bb68f52 upstream.

llc_alloc_frame() reserves link-layer headroom using the device type.
This is insufficient for stacked Ethernet devices such as VLAN devices,
where vlan_dev_hard_header() pushes a VLAN header before the lower
device's Ethernet header. An LLC response on such a device can
therefore underflow skb headroom in eth_header().

Use LL_RESERVED_SPACE() to account for the device's actual required
headroom while preserving the existing LLC device-type check.

Fixes: bf9ae5386bca ("llc: use dev_hard_header")
Cc: stable@vger.kernel.org
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260924012613.2533934-1-weir@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/llc_sap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -25,12 +25,12 @@
 #include <linux/llc.h>
 #include <linux/slab.h>
 
-static int llc_mac_header_len(unsigned short devtype)
+static int llc_mac_header_len(struct net_device *dev)
 {
-	switch (devtype) {
+	switch (dev->type) {
 	case ARPHRD_ETHER:
 	case ARPHRD_LOOPBACK:
-		return sizeof(struct ethhdr);
+		return LL_RESERVED_SPACE(dev);
 	}
 	return 0;
 }
@@ -51,7 +51,7 @@ struct sk_buff *llc_alloc_frame(struct s
 	int hlen = type == LLC_PDU_TYPE_U ? 3 : 4;
 	struct sk_buff *skb;
 
-	hlen += llc_mac_header_len(dev->type);
+	hlen += llc_mac_header_len(dev);
 	skb = alloc_skb(hlen + data_size, GFP_ATOMIC);
 
 	if (skb) {


