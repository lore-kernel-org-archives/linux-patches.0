Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC22D7386;
	Wed, 20 May 2026 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296494; cv=none; b=p0uw+otKBaTk415nGfZ3A+k1pPZ697NwsszeWSZ59+XIBLWOtV1dctNI/zquuo7lZr9cgkjYJWv/Qr33WoOGfNqxCSqdHmg+/RTYetmcQbeKskUVQhbx1LHYqJducCnEf2lq5wZwr4ZcxGCjNeaHQ3hDXWCRHl+uPJwpRyLyPc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296494; c=relaxed/simple;
	bh=A0EORgsluRUog8yFNl/b3RrsrzkPswhZKNwTPNS1KdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hswAKY95ypvR+9nV/tiQKH0urUJi0upvYxtnG9q1S1+NbZHDbhHH0fU49C7RbrYIuF9G5UfqaKKrcQ+2DVmsPAeZh6cR6+cvwL+nBsH1zM+p5KfiCYt4uHt89Dip/J/UdJV7m5Sbi9TbMBUEDsuc0HBOqd3OV2TxdbzudUQH8Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15tzA3T4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15tzA3T4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3B31F00897;
	Wed, 20 May 2026 17:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296492;
	bh=npRxlEUFKTEiAQ0LwZCx4tmM24hkname1GrdxDlufvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15tzA3T4LiV6FXi0xwF4U787vAYITLiLz3KZnEqOvVjHj3PdpCb8swEwDtWhfPb0b
	 Hs4eBBGr+7NTZD1qq/In1rLzJunIbPtPe6Mv8moj2LnYbsVMf75OLogUapzqy6hyKL
	 e/LRCXSYzeBwhonBbPiJJil90vA0Wn583fLezOuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kito Xu (veritas501)" <hxzene@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0818/1146] netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check
Date: Wed, 20 May 2026 18:17:48 +0200
Message-ID: <20260520162206.739881038@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 711987ba281fd806322a7cd244e98e2a81903114 ]

The nf_osf_ttl() function accessed skb->dev to perform a local interface
address lookup without verifying that the device pointer was valid.

Additionally, the implementation utilized an in_dev_for_each_ifa_rcu
loop to match the packet source address against local interface
addresses. It assumed that packets from the same subnet should not see a
decrement on the initial TTL. A packet might appear it is from the same
subnet but it actually isn't especially in modern environments with
containers and virtual switching.

Remove the device dereference and interface loop. Replace the logic with
a switch statement that evaluates the TTL according to the ttl_check.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Kito Xu (veritas501) <hxzene@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/20260414074556.2512750-1-hxzene@gmail.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 3e0ccb6d9dc7e..426b85fca8f75 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -31,26 +31,18 @@ EXPORT_SYMBOL_GPL(nf_osf_fingers);
 static inline int nf_osf_ttl(const struct sk_buff *skb,
 			     int ttl_check, unsigned char f_ttl)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
 	const struct iphdr *ip = ip_hdr(skb);
-	const struct in_ifaddr *ifa;
-	int ret = 0;
 
-	if (ttl_check == NF_OSF_TTL_TRUE)
+	switch (ttl_check) {
+	case NF_OSF_TTL_TRUE:
 		return ip->ttl == f_ttl;
-	if (ttl_check == NF_OSF_TTL_NOCHECK)
-		return 1;
-	else if (ip->ttl <= f_ttl)
+		break;
+	case NF_OSF_TTL_NOCHECK:
 		return 1;
-
-	in_dev_for_each_ifa_rcu(ifa, in_dev) {
-		if (inet_ifa_match(ip->saddr, ifa)) {
-			ret = (ip->ttl == f_ttl);
-			break;
-		}
+	case NF_OSF_TTL_LESS:
+	default:
+		return ip->ttl <= f_ttl;
 	}
-
-	return ret;
 }
 
 struct nf_osf_hdr_ctx {
-- 
2.53.0



