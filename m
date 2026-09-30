Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414E541A502;
	Wed, 30 Sep 2026 19:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796979; cv=none; b=qPy9Krm4PIX1yt/i5Dd81txUAm+0+6fU2dJ1auxcJ42OiioRWaS5Zt22NJT7wXdGFREJC5PRvc3iaPXbMsowdBl/agsgk5NdZ0DkMFKnKsdRqs0aC4JPZisBqBkjJbmokWFl56vKniQ8rRizJ64ceYLjDkC4wOCjIQRQek1VXEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796979; c=relaxed/simple;
	bh=qIi5G4+f5sWWS0bc4RN7psbzBDnR3Ukyo4NiPKw/fS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqiuJe1+5s9JL/Nf0cOdfZUfekyxJzJCiui2tchVzipTi65zlDzEO2+yC8u2bPunHMPT05Z21V6d/58DG/w9bgei49dbqfJfL/AhaN2juful5YaMw32hgpB40DIGSov9gdZopS3T1jqtH8g9wWGUeHwIGJlksjoWpLmDo31CTA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8+qIJUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8+qIJUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9151F000FF;
	Wed, 30 Sep 2026 19:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796977;
	bh=ldulckd73WoFPI/egLzdfUKs5KWJ0sm5OQGOVgVhZqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8+qIJUELof+LVMhOgmasUWLkOldHmsrbceunT7SjU3nBydT82pXC2S1P/VtZojV9
	 r2LU7xRMLAuwPN7ZWqhQNwDOzk9Yqs6Rgw3Ngwdd3K4NifNRXGzTt+KJ+wySJDKyv9
	 XsenIDdv9Kqxif3llKLLOYYv0q6DpTKJ2XFoblJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1105/1193] llc: reserve device headroom for allocated frames
Date: Wed, 30 Sep 2026 17:29:49 +0200
Message-ID: <20260930152458.782488778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


