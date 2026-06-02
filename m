Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F783B3BF4
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780386617; cv=none; b=g95HtRMk3QDlL8aOXOcp9XZ37LPvw9R9OfCi2QsPkCvtFeqbLjyY40UhACZhgVh5zn36crgM5fkZCtJIK2pVBAzlxaBM6M10rhiRbCXBdYPNRTnjFwSZpAe8hKS15os0kidhZI5754VhLzSH8NqMjcJbJIbuOoCXG0umJERhdi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780386617; c=relaxed/simple;
	bh=WtN4eaIts+Ftcwn9eMgaXtTeXR/Gk9lkpwWarXWxRCo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o6cgdfywNGi58FXTzK48gP/X2fMC8THPxdYvu0HuESn5eaXkND+GFCcJMjrb4/m3lqkEO25dowkv1/QymZZb7EiaJPgAl5d40Fht5vlsXVU8tTGn4UJFHEtSdmVJs5XnLEh3T8YhnVxWPjbD6YOhmIYiM8/nALFwSq+UkzTVnkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=O6bM1H6a; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="O6bM1H6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=O6bM1H6aJU3LrKKjAq/eUb2UlvzkpxTmQ2vyVTubqr++xoyICwZI2Y595b+y/CrxhgcvWYBHqHJmt
	 73q9MNMtqkjIpdyhcy1Lqw5hW6EyX6SaFRewjv3EYgcPmWjEIX+kfjNrER0qsp0TePpWTGCqmjYV8v
	 NXut8Ozl9G97TmIw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-45-12076 (RichMail) with SMTP id 2f2c6a1e8b2a7ba-027e8;
	Tue, 02 Jun 2026 15:50:06 +0800 (CST)
X-RM-TRANSID:2f2c6a1e8b2a7ba-027e8
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	jk@codeconstruct.com.au
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	matt@codeconstruct.com.au,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 6.1.y] net: mctp: ensure our nlmsg responses are initialised
Date: Tue,  2 Jun 2026 15:50:05 +0800
Message-Id: <20260602075005.3210862-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit a6a9bc544b675d8b5180f2718ec985ad267b5cbf ]

Syed Faraz Abrar (@farazsth98) from Zellic, and Pumpkin (@u1f383) from
DEVCORE Research Team working with Trend Micro Zero Day Initiative
report that a RTM_GETNEIGH will return uninitalised data in the pad
bytes of the ndmsg data.

Ensure we're initialising the netlink data to zero, in the link, addr
and neigh response messages.

Fixes: 831119f88781 ("mctp: Add neighbour netlink interface")
Fixes: 06d2f4c583a7 ("mctp: Add netlink route management")
Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260209-dev-mctp-nlmsg-v1-1-f1e30c346a43@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/mctp/device.c | 1 +
 net/mctp/neigh.c  | 1 +
 net/mctp/route.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 85cc5f31f1e7..fd368249246d 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -71,6 +71,7 @@ static int mctp_fill_addrinfo(struct sk_buff *skb,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->ifa_family = AF_MCTP;
 	hdr->ifa_prefixlen = 0;
 	hdr->ifa_flags = 0;
diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index 590f642413e4..c0151a69d2b7 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -218,6 +218,7 @@ static int mctp_fill_neigh(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->ndm_family = AF_MCTP;
 	hdr->ndm_ifindex = dev->ifindex;
 	hdr->ndm_state = 0; // TODO other state bits?
diff --git a/net/mctp/route.c b/net/mctp/route.c
index fdeaf80691e5..c9b0b7542243 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1331,6 +1331,7 @@ static int mctp_fill_rtinfo(struct sk_buff *skb, struct mctp_route *rt,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->rtm_family = AF_MCTP;
 
 	/* we use the _len fields as a number of EIDs, rather than
-- 
2.34.1


