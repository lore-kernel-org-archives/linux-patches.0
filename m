Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6651247F77A;
	Thu, 20 Aug 2026 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248615; cv=none; b=E7+Zv892WA1hzzilhWmCRjiCgDC+jHfWOpxIg1eEbZ8BqCyO8BU8o0WN2ePnroIHoOLzvVkUDh/ZMwGG0seN1YI5O9aZTBhcF+DyvtbJNhpSz6w0vYgMuVpDkttWDggQ9CjLbEjL1TNDz2IpP7KllOZxKR4P+CNtaIiyt1hfsxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248615; c=relaxed/simple;
	bh=RUFaWcpUItrY/mImYJjNC15skunkEjUN39CbPRSfQXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk4MhSUPlQ0MxRkOZxvAJOs3JktldUVUwrLXCKPyy4L4k2eDsTNp6JtJ42Hj0Zc8tJ6B97V4fphmRzdcTKZH/gJ0mflTl4c8z8Xrzq7QVMZQ2xnztk7Hyo8mpUh9H66m0j/lQVRE7yOGqnj41e0UK6dLQgahfCWpGAvWCelBGCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1fH3dpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1fH3dpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54BC1F000E9;
	Thu, 20 Aug 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248614;
	bh=xLQwGQWYhmzmQZAfKiHllPDo2oTMgnwETVgsLeJxoMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1fH3dpvk6/rpTIujKTBKNb/PzIp7zH96odbmDkVo+cQfys8m+rmse/BTiNQnsdTd
	 hR5OQSA2rrpnga74ODDMsRXkbS2WYjbqhkPbrFfzCTmi65/o44EE8prRQsrux10OL4
	 t6h4tESBKMPXj+W9DYZ8Hhdu60x80g9GoWksRWDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 272/303] net: sched: use skb_ip_totlen and iph_totlen
Date: Thu, 20 Aug 2026 16:56:48 +0200
Message-ID: <20260820145301.638659423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 043e397e48c58b4442ea5124dc1bdc95367a0a33 ]

There are 1 action and 1 qdisc that may process IPv4 TCP GSO packets
and access iph->tot_len, replace them with skb_ip_totlen() and
iph_totlen() accordingly.

Note that we don't need to replace the one in tcf_csum_ipv4(), as it
will return for TCP GSO packets in tcf_csum_ipv4_tcp().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8a7ed561671a ("net/sched: act_ct: fix sk_buff leak when the header checks reject a packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c   |    2 +-
 net/sched/sch_cake.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -789,7 +789,7 @@ static int tcf_ct_skb_network_trim(struc
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		break;
 	case NFPROTO_IPV6:
 		len = sizeof(struct ipv6hdr)
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1269,7 +1269,7 @@ static struct sk_buff *cake_ack_filter(s
 			    iph_check->daddr != iph->daddr)
 				continue;
 
-			seglen = ntohs(iph_check->tot_len) -
+			seglen = iph_totlen(skb, iph_check) -
 				       (4 * iph_check->ihl);
 		} else if (iph_check->version == 6) {
 			ipv6h = (struct ipv6hdr *)iph;


