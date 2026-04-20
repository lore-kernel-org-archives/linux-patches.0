Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9341D29E114
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 05:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776663782; cv=none; b=gDAY0XsdG8sjDrEV9XEyqgdttM1D/LQvV/b5Wnx1O3j7xCe2U460Akcy7ye14ymTu2yOeCncQkfeCXD5rSYyZ8vchDOMqRR1brO5VwuaQx6h9qAkey6yApGpymKy+o3BZFs1LBkipk0lDEGwTNA053GC6wPHD+nTu8qRicuu0+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776663782; c=relaxed/simple;
	bh=S+E4YfUt/nhC2VFntQ2C78zHJ8wfTR9NhfWnmKNpeAg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E/UgJw++r3mIqQRhCqGIi78wHzR5dk8Uk3rqCvzYbmbXdKsUUlMt1at4twwvsPhJMGvF1sPUnpLYxTaz2ORPBuOObEQilv23DGm3N98PiMNPATzuSTCxW+eHTLx/ZoavxYu/seBjXLx+DgldJZqhiuVw8RUuJ7k4KYnKA7GyBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=wcE323tj; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="wcE323tj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=wcE323tjCg0o+l2pUqmE5+17J8YYZ4NMghjwfioX91O25udDh5X+ELqaauaZIv32qU2L0rn6Lm9aZ
	 DrTIu8MTgIJaOnRjOll5FpAPGLkc+/JkiP5qc2VwH3sTKNxWxwxuOqXHiz4Ta0RaTrYcLhQJQBoMJa
	 0D7k8m/j7cbCw4a4=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-16-12015 (RichMail) with SMTP id 2eef69e5bccfaa0-01ac1;
	Mon, 20 Apr 2026 13:42:43 +0800 (CST)
X-RM-TRANSID:2eef69e5bccfaa0-01ac1
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
Subject: [PATCH 6.12.y] ipv6: add NULL checks for idev in SRv6 paths
Date: Mon, 20 Apr 2026 13:42:41 +0800
Message-Id: <20260420054241.3043646-1-1468888505@139.com>
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
index 1a627c24e4c3..8a30dd83cf0b 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -379,6 +379,10 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 	hdr = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev) {
+		kfree_skb(skb);
+		return -1;
+	}
 
 	accept_seg6 = min(READ_ONCE(net->ipv6.devconf_all->seg6_enabled),
 			  READ_ONCE(idev->cnf.seg6_enabled));
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 5d21a74c1165..214d137d545e 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -245,6 +245,8 @@ bool seg6_hmac_validate_skb(struct sk_buff *skb)
 	int require_hmac;
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev)
+		return false;
 
 	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
-- 
2.34.1


