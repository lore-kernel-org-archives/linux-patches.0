Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C24D3B9600
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 07:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780386620; cv=none; b=a0MZPOnZ7U0b8zFCXTc9IWnko3vZilgkefAA4fPLY+e5Mjbz5Y8d+x1bc6I+EHhdVBZaPdpGjgTTJmMxk15rvmKzFUXXH8II7YraA0hWiOAfYHfxYcnKYFP1nza/jkemb4robv8ZJ+1bSDoQCi7PQGWYE+mOBgPdErOEhNGPOdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780386620; c=relaxed/simple;
	bh=r8JJSHfKw9Brkkcjw3TDT0i1OPaFOAg7fPAPfVj2Lec=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RUBUUTLeL/5M+8MUMUzFukB7WZZOxZgrZhwey2nRKqDaIyyvmvrJVclw9tWdcodJqxtSHwkyiiU2iimkybyPhJ+ZYJBt6lIaUu7141BJGLpCCpUA3fPRmsJou+C8eb3VTCa9HuvRXN2FPPik0QHsDfjEhLHk7Y3QKZcrbHQAO5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=d6uX4TgG; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="d6uX4TgG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=d6uX4TgGv6yot+IU0+JPwwvDwBJHBzykiSicikOxgodxZpH+fkeYwgHGBUqGq7rzIWMfgJj+lNOow
	 0ql+JDtHphqTba4Swg3OVsjLXuL/y7JLIMbTFSUGUosh0zC7YnYgo7dZOPdxmbR+tdB56046di2BwJ
	 uJgb+IeO0p5EHHrI=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-12-12001 (RichMail) with SMTP id 2ee16a1e8b375ef-0261c;
	Tue, 02 Jun 2026 15:50:19 +0800 (CST)
X-RM-TRANSID:2ee16a1e8b375ef-0261c
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
Subject: [PATCH 5.15.y] net: mctp: ensure our nlmsg responses are initialised
Date: Tue,  2 Jun 2026 15:50:14 +0800
Message-Id: <20260602075014.3210968-1-1468888505@139.com>
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
index aec7ffad2666..a11d5aca201c 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -55,6 +55,7 @@ static int mctp_fill_addrinfo(struct sk_buff *skb, struct netlink_callback *cb,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->ifa_family = AF_MCTP;
 	hdr->ifa_prefixlen = 0;
 	hdr->ifa_flags = 0;
diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index bc75a263719c..18a6be38f172 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -217,6 +217,7 @@ static int mctp_fill_neigh(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->ndm_family = AF_MCTP;
 	hdr->ndm_ifindex = dev->ifindex;
 	hdr->ndm_state = 0; // TODO other state bits?
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 48d32bfd3863..a93796eb0a09 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1031,6 +1031,7 @@ static int mctp_fill_rtinfo(struct sk_buff *skb, struct mctp_route *rt,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->rtm_family = AF_MCTP;
 
 	/* we use the _len fields as a number of EIDs, rather than
-- 
2.34.1


