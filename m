Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF2647F77A;
	Thu, 20 Aug 2026 17:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248584; cv=none; b=alsiNB3I5uEgloN+i7S+LB+EGi1PYj/STCwx45eFT7vMiXzzreQxtKpPfoyiXxJuQiJm2kp5hO5jEdhfoSRHoKaL+WLw8VyHneVe8xo5sjgJHPxpV3dIi8kh1HghtOsXtntqmVHGIYuStpBwBz77boc5ShpCMY2bzxrImsIOudU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248584; c=relaxed/simple;
	bh=J7H7wmXdFliUN/Whhix8kZJR6ivzBvMQnTmrRQj6LZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvWvdi1Z6T+L2wDRqACAVqg0a0ZaNtCGwqgBzxhtuZwOgXoAx2GpVylKd6txGB246mtCl3vK+ngKnvdJ1tO6wDP2R5Kxa2emfrAvAcF1mIkXL6IgcABNPCoE1Yo8vGAK2R4HBgWLb5NHa7WfhJZF5BDvQaSjt9oHbMl8UtrweCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvkpvpIB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvkpvpIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9F31F00A3A;
	Thu, 20 Aug 2026 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248583;
	bh=R/IQHaZ8tBMT5GFJ1fHNnzgZaLfNdTNIDORX2M3oG9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvkpvpIBten0ZWO9H+Cz9MUPX3BuDMDv2lkoTXa++OsaHm2SqPrmZRR1ytcImqPON
	 5zkxt4bt254dK0YuH9tRLHXxIRnK6nqRmogA6pFYX2n/67je/2nRB1z5wsNBQgMbFo
	 STu1UfoFeQiQm5QBv8/3pL2n4AsZzor+V0S2Ha94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 271/303] openvswitch: use skb_ip_totlen in conntrack
Date: Thu, 20 Aug 2026 16:56:47 +0200
Message-ID: <20260820145301.605768545@linuxfoundation.org>
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

[ Upstream commit ec84c955a0d06cef31664bae328d94be7a3e2f03 ]

IPv4 GSO packets may get processed in ovs_skb_network_trim(),
and we need to use skb_ip_totlen() to get iph totlen.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8a7ed561671a ("net/sched: act_ct: fix sk_buff leak when the header checks reject a packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1282,7 +1282,7 @@ static int ovs_skb_network_trim(struct s
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		break;
 	case htons(ETH_P_IPV6):
 		len = sizeof(struct ipv6hdr)


