Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100F1345CDA
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 05:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776663826; cv=none; b=Do4196XKcnVgbeqxdCrTZwsUoQkFFbKwtnlWiMzgwrYi+4vvpDKGIgNXIajxAWK4aBvmf14is2/Vwhbm08WUesW4kVB4QOkRKdBDLhoamqmGGTX7TA9ABn9gokAxvQEuRAgvqHtwwP1zwlvyBRemeeGdrMS9KyqBoWBfBImEV4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776663826; c=relaxed/simple;
	bh=aVbyG8hmO8QBPDCIqF+eHjjGxHVD+FBHnipkxql8DTs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a4SR8eHynhsdVT+h4MdzWUMsBNMcI3mqcDfb1hOW+0fJFhEPDFniazaZlWE/+u88Rsgsu/E7aAR8/eZfR1jnWMWzkInPRJvIPGNy3xzYsp8V1JOVXRGnD6EIExxWgE+Qrh926fo1ZELfWw+UcsuewDmC0lLuPqhJhCyKYMjR9LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=l3fY/9in; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="l3fY/9in"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=l3fY/9intQESJ8HYLdyducwbcyPvpWMNwvDy82/38IllAETzA9WC9PIaLG21X5Oo8aH/EyfslaZad
	 Kyd1ZKmkNz9NZNsb3vVjdBB47kz1hzXVpNGpGdiRleLEhPTcFXBxZeAD5sZqSCfE+zAU/n2ep+8Tnz
	 7YYlubN+byeUZbZI=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-45-12076 (RichMail) with SMTP id 2f2c69e5bd04763-057d4;
	Mon, 20 Apr 2026 13:43:35 +0800 (CST)
X-RM-TRANSID:2f2c69e5bd04763-057d4
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	heminhong@kylinos.cn
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	david.lebrun@uclouvain.be,
	netdev@vger.kernel.org,
	andrea.mayer@uniroma2.it
Subject: [PATCH 5.10.y] ipv6: add NULL checks for idev in SRv6 paths
Date: Mon, 20 Apr 2026 13:43:34 +0800
Message-Id: <20260420054334.3043858-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit 06413793526251870e20402c39930804f14d59c0 ]

__in6_dev_get() can return NULL when the device has no IPv6 configuration
(e.g. MTU < IPV6_MIN_MTU or after NETDEV_UNREGISTER).

Add NULL checks for idev returned by __in6_dev_get() in both
seg6_hmac_validate_skb() and ipv6_srh_rcv() to prevent potential NULL
pointer dereferences.

Fixes: 1ababeba4a21 ("ipv6: implement dataplane support for rthdr type 4 (Segment Routing Header)")
Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260316073301.106643-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/ipv6/exthdrs.c   | 4 ++++
 net/ipv6/seg6_hmac.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index cdad9019c77c..dfa0fb3d6c35 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -361,6 +361,10 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 	hdr = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev) {
+		kfree_skb(skb);
+		return -1;
+	}
 
 	accept_seg6 = net->ipv6.devconf_all->seg6_enabled;
 	if (accept_seg6 > idev->cnf.seg6_enabled)
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index f82fcd8908e1..b52985c867c2 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -245,6 +245,8 @@ bool seg6_hmac_validate_skb(struct sk_buff *skb)
 	struct inet6_dev *idev;
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev)
+		return false;
 
 	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
-- 
2.34.1


