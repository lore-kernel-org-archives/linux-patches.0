Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358E136921B;
	Wed, 30 Sep 2026 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785354; cv=none; b=NfsMUY+yz8viyIDW2I15m2HHAglVeVfIEomW3y9MTUgdwT/t2XJV/nTjQQ2qaMo7Mw2Yrkomvbc9IOJARhPEdjOhV6gn9C5w00DsyvwId1bV58ll5tN4IV4K58kyBzTci3K9f7Oj13r2k6fHVyRR5FGjNj5GDbJ+f1XXUyXrE8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785354; c=relaxed/simple;
	bh=c07YMjkuuX5gX8WCnXLdOTxr59VUTe5nWNRKhoXlYB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIpghFFWHdimp48ZJUzuJq6wH0ZsZyXzPUuFWeMuuZINVjO6N8Uypr7edTXGpKQ5UoVSvfAcN8oN9D8S49xa3frTx+/YdK/GAsdwviryaNIiGgCMHOz+XyvITWPYAX08KPlYRjY6M/EhobLQDbuFiT1ZaTj315WvVVnTK/1ZHVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLIU86SH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLIU86SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054AB1F00893;
	Wed, 30 Sep 2026 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785350;
	bh=AbR4eZKGc4B3l5itfMLyROtZGDeAQMMkKQ7RNcaj0zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLIU86SHDN5HVmCGI/s93Gm6qzyd/yOkYzYHISkKAJIaHvWaVRJC83XZ6Vs63PHj5
	 C69F+SVYhpt7HculMA7wSz1yXqxHmFbzTH/N3dx0FbePjpjN32cfNWPERdHqW5FT5h
	 6aPcdu0fL7sLYDMzdY+w6lDrgchU9MyKBa4ujhY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 477/982] vxlan: initialize _md in vxlan_xmit_one()
Date: Wed, 30 Sep 2026 17:20:13 +0200
Message-ID: <20260930152427.027492357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit be83178bfc44588f6e3adb827ed874c683193466 ]

If a VXLAN device is configured with both VXLAN_F_COLLECT_METADATA and
VXLAN_F_GBP, and a packet is transmitted through it using an external
ip_tunnel_info that lacks the IP_TUNNEL_VXLAN_OPT_BIT flag, md is left
pointing to the uninitialized _md stack variable:

                if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT, info->key.tun_flags)) {
                        if (info->options_len < sizeof(*md))
                                goto drop;
                        md = ip_tunnel_info_opts(info);
                }

Because IP_TUNNEL_VXLAN_OPT_BIT is not set, md is not updated and remains
pointing to _md. Later, vxlan_build_skb() is called with md, which
eventually calls vxlan_build_gbp_hdr():

        if (vxflags & VXLAN_F_GBP)
                vxlan_build_gbp_hdr(vxh, md);

Inside vxlan_build_gbp_hdr(), md->gbp is read:

        if (!md->gbp)
                return;
        gbp = (struct vxlanhdr_gbp *)vxh;
        ...
        if (md->gbp & VXLAN_GBP_DONT_LEARN)
                gbp->dont_learn = 1;

If the stack contains garbage, this causes:
1) VXLAN_HF_GBP flag to be spuriously set in the VXLAN header.
2) gbp->dont_learn and gbp->policy_applied to be set from stack bits.
3) gbp->policy_id to receive 16 bits of uninitialized kernel stack data,
   leaking it onto the wire.

Fix this by zero-initializing _md. If IP_TUNNEL_VXLAN_OPT_BIT is not
present, md->gbp remains 0, and vxlan_build_gbp_hdr() returns early
without modifying the VXLAN header.

Fixes: ee122c79d422 ("vxlan: Flow based tunneling")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260906180111.1973188-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 6659a7df23a17..9327b38fb6fde 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2440,7 +2440,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	struct ip_tunnel_key key;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	const struct iphdr *old_iph;
-	struct vxlan_metadata _md;
+	struct vxlan_metadata _md = {};
 	struct vxlan_metadata *md = &_md;
 	unsigned int pkt_len = skb->len;
 	__be16 src_port = 0, dst_port;
-- 
2.53.0



