Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7016D17555;
	Sat, 30 May 2026 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165477; cv=none; b=msrtUPrwvE6Y/LiCLLQCTjfFqeUrCXmf1T53YiN0lTZkiK1Kq7v4GTm5ln4Qmbcnv/qnb0x9vW4rBIDhYCcD0qSaSB1E/Niiph2icpPadZQJOPnF62GdMnynceybG7aLzUBYMEojUtAaA6ExM4gB6iFXX4OewdK+BP+7lpf+76A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165477; c=relaxed/simple;
	bh=SNgIyiLvDdLKa6blhu6T3WxnWH8XxqDs/8dbIDZNn04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKt4uHqD0nqLLrEXScQ8F+upcFpmOWZJapZasrTLHdO/UP8oqEzCF7giw03PqgIJIzP76uzcl0syF4lI63Itms9YWlIolqr0ZkM5/n9LWS9FULTyEgEzj0hkP4RVu99lpvgX47SuRdozixRhw0az0HzLTf2zlQuhd2lFa80IxJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8q/MCnu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8q/MCnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42641F00893;
	Sat, 30 May 2026 18:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165476;
	bh=hfxtN2CurQXz63Z5kEtpPLNpusuZG9nD/Mv++0h/uwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8q/MCnuOMhmQSxD6T8ZvKh7iJ+1jxxoMiw6/SRMQDI9KijckMHcewxq57AFxy/J3
	 f1z9VoqLQe8mZvnBxYbClMfTs/rpvtxdaMEV0g3Q4fOgZEccwuUedx7ezLPLJPEt7g
	 +gMsYPY+CmCb8pW4Xcz+AqQd/Q1WdGQX+kO8UT5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/589] ipv6: add NULL checks for idev in SRv6 paths
Date: Sat, 30 May 2026 17:59:30 +0200
Message-ID: <20260530160227.025783704@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c   | 4 ++++
 net/ipv6/seg6_hmac.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index cdad9019c77c4..dfa0fb3d6c35f 100644
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
index f82fcd8908e14..b52985c867c29 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -245,6 +245,8 @@ bool seg6_hmac_validate_skb(struct sk_buff *skb)
 	struct inet6_dev *idev;
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev)
+		return false;
 
 	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
-- 
2.53.0



