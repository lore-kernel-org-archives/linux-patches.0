Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAD717B418;
	Sun,  7 Jun 2026 10:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827301; cv=none; b=XOWl6hLy0+vrN9uv5r47pwOwEbPEyeOjPo69wWNATEURWqG+FVi/8G5QyAUqxkGVLj163Y2fFB0HF3iyw/MazXPYSEbqBa3p6dCIdRzbdmEuwjLKuoyTErxYlsWZIr0cIYjDm4QxQXPWBZePTtuzun9PGEws5QdieD+/3vJCrAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827301; c=relaxed/simple;
	bh=WNhQqWvxJJGgs+wDlOyH/mdoI7vn9SZaEt46WedtQBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9bge/7xCajgC453wHxOVflfYISdA9HPnW4Kmymb0vmOrP2nMJJGdahQSB9+OB1ZCltG8F71OK5VTi7WYXlIRTyIiL+zgzwtTEg+iZUxI6Qsrvk5hlfnJ4Lx/4wd/QHHMIE3jtHZzHWUnoGMyRaG/VGARRWV/grd+Ey+BpvZR/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5bgQjNu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5bgQjNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BBF1F00893;
	Sun,  7 Jun 2026 10:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827300;
	bh=I7rIoXRgoHgyiWXvHd6UmcPyzBmj0qOnnZfs+0ztr2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5bgQjNuO59s/qpZhL7xF6DFNcgzf5L57TD+zHISRXYDLARd/APfqR+QuNOmbGeXq
	 zzpByUND8cJ62YBjigkiT/8U4yFFiSBMNzLO0HKzOh14wm8oVFSMf9lEwCKZxxhRub
	 ewdbfUmzwGGwzayCb0+mimdbFrfFjXMKz+/9q4a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/315] vxlan: do not reuse cached ip_hdr() value after skb_tunnel_check_pmtu()
Date: Sun,  7 Jun 2026 11:57:22 +0200
Message-ID: <20260607095729.624110156@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d2d0e0bd43716c..a4ff66e354f532 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2532,7 +2532,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto out_unlock;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, ip_hdr(skb), skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2606,7 +2606,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto out_unlock;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, ip_hdr(skb), skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
-- 
2.53.0



