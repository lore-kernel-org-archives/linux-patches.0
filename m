Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D5E3B38AC
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 07:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780385788; cv=none; b=sVhlGuZ9BmUUUuzUHXj/Riy7xRejCtuyc/rbdFT9q5MGEgXr4Pzlw9DgV1fxJBT9/CVWq4SJWdkuRR+0EUL5EYg99mO4uv0ewRMqkU+f+XKMtd84E2C3Kxm2Q+2J1DNuSB9igOS5UNzT4S/co4BITdxrPtWTSvMhM88Iv/WgNS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780385788; c=relaxed/simple;
	bh=Sg2qPMeNeyuw/NqPm8wrriZb6ypvSn/sq+DRxgxDR8g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PFQ3Zw2m5fOZq6Vc3zSwVcH8YEmJUATX1VBItI51J5MiwXf2TA0O5p0KzWlYAJtm6A2oj7vZ9Sn8dovC8ND/giE7zzrLboAXB5yj6FHFKztTboeB7CTprZZtwDYE2OzIy2TxQzlkdsqMP5xzE9+KRMyPQgLVEJQLefwpd03BGQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=C90EEA/W; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="C90EEA/W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=C90EEA/WmY5MswcMj5MyPoDvQ1N6XcA5ujsLSw2ZM3en1q9bZa0vEZVseFovEJRMoP1uB3Aj5NbV7
	 KisCpeqOeYCw/hIhTmbTR0xXXpD683apUGE5+Lmq4M9xCWzyzMsFeL0oxC2Z4hyXNVb+mmh2WNgc+L
	 kGAfOa9UmvqmNK+k=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-07-12085 (RichMail) with SMTP id 2f356a1e87ee00a-0101c;
	Tue, 02 Jun 2026 15:36:18 +0800 (CST)
X-RM-TRANSID:2f356a1e87ee00a-0101c
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
Subject: [PATCH 6.6.y] net: mctp: ensure our nlmsg responses are initialised
Date: Tue,  2 Jun 2026 15:36:17 +0800
Message-Id: <20260602073617.2922418-1-1468888505@139.com>
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
index 8d1386601bbe..67576cb2728e 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -70,6 +70,7 @@ static int mctp_fill_addrinfo(struct sk_buff *skb,
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
index a565cf2bc733..6d6e19c04939 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1332,6 +1332,7 @@ static int mctp_fill_rtinfo(struct sk_buff *skb, struct mctp_route *rt,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->rtm_family = AF_MCTP;
 
 	/* we use the _len fields as a number of EIDs, rather than
-- 
2.34.1


