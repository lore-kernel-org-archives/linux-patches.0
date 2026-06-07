Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAFC4CB5B;
	Sun,  7 Jun 2026 10:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827511; cv=none; b=e/QW0JWDrEfGVdy1iKVDZPNaWPM7lOgwZLUNohFS3sYHtDeE5fShR0B+CwxQgRELfMYVTlyTF4a0rsuFJf/PMzVPmMOoil7YUqgN1PVWl57ydryNQqRJ5xsCPzqm5Uc6DFiE6rVF2EZtI8VIulsXkAkuuupMBNoo1BmDNiytelY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827511; c=relaxed/simple;
	bh=vYap0u9PfOf1t0x2DO4SuwOVh7PBWCRsvy+d9aS+xhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZ9WyX4b9AWGozbFMrUr3zgihKQULdOu02XMButCG32u68Op6GkRbF7gsVlPqTtvieuYjQn2/rSNQnkrqJu04tVJaToAlZBHxmf8DHuH1w2dE9NHqnN2iMDM8vCJ2Ic5aq00MCwsJN78CQAdRWxp3Tt2vZQ9KAkScEP032n2FSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13Wfe+eR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13Wfe+eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9754E1F00893;
	Sun,  7 Jun 2026 10:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827510;
	bh=Sbk1VMxM5HGBaUzofXvtNwpSclPb6S2Ue4kY3WyDRRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13Wfe+eR3S4Jvhn/krtjDdkQSkW2H8dWTtZsbI5y3RuTNno4ni/T/yFXs7nRi09Tl
	 EsOJ7+HSLbYN8vADh7obO77vcyf/e0sI3JDK3Go2/GQiyG9FHs6nqKjJXHo5lIA6qR
	 jbFUeZP7WLS4CDUUcnIChMPigZ9xydQ8pqVrgzjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/307] vxlan: do not reuse cached ip_hdr() value after skb_tunnel_check_pmtu()
Date: Sun,  7 Jun 2026 11:57:38 +0200
Message-ID: <20260607095729.985141307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7d9ef0cb271555d8cf39fefe6c981e1493b25ecf ]

skb_tunnel_check_pmtu() can change skb->head.

Reusing old_iph afer skb_tunnel_check_pmtu() can cause an UAF.

Use instead ip_hdr(skb) as done in drivers/net/bareudp.c
and drivers/net/geneve.c.

Found by Sashiko.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Link: https://patch.msgid.link/20260525203642.2389723-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index ed428293b0e579..765d25eee2fe48 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2541,7 +2541,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto out_unlock;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, ip_hdr(skb), skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2601,7 +2601,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto out_unlock;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, ip_hdr(skb), skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
-- 
2.53.0



