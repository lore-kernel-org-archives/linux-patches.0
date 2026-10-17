Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4D03A7F4D;
	Sat, 17 Oct 2026 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260647; cv=none; b=mi3vpCbZ8XfHfgO+2mybvO8S0hXpssHdq9eZDP7rnHUins8IERCVLnGmHVfGcIakdELtOinxjjM/5bHPIlQO37Dqy8zosyY+V7CoUDmTUqHR00vfPklA03a4i9gV98yogWwVGZoc4kcebX+Y8K58SOZuiI47zFdEXWh3Qetfnfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260647; c=relaxed/simple;
	bh=3t+irYfsW64kJZfAGz/6SUJHiq/+gPR+S/Oc5RPVDY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K28bvPh9sMkDsHE6dXURVcEHGbnDSYWzkPbtU6+QyX3VUFLETrSg0J/8H1z/nn3qvXOyax8VolT4qFc/La+tNKtJ8zZyRoc/lKvQYfFPQvaooMoW9AfBRRjgb8zW7smvUF/fomepbovL63zPYKLPxAfjCeiygx9aQWHTSgDq164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYYw71ot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYYw71ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CF01F000C4;
	Sat, 17 Oct 2026 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260646;
	bh=SGizIoPANE1X+1qgRWCiRfw56eFHClUtVX/1k+KpLbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYYw71otWixeA0yWCCVg1NfU19S/i1nHjDT9O/snPuPuWP6W+2UGBw2QgeEdGWdxk
	 bTQ/KumnN5oyS5k6gJQen4dkuoBzabbWuiUZW5xFW7vVlCI6f5PBMxvVj+hFUJp8ZO
	 pJ5wuffOXzZYQENfURr1ekBaPEMM+iDFxS8IZ4gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1613/1674] vxlan: initialize _md in vxlan_xmit_one()
Date: Sat, 17 Oct 2026 18:04:45 +0200
Message-ID: <20261017160512.487395375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 93940ea5cf9c8..355337d428e52 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2487,7 +2487,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	const struct iphdr *old_iph = ip_hdr(skb);
 	union vxlan_addr *dst;
 	union vxlan_addr remote_ip, local_ip;
-	struct vxlan_metadata _md;
+	struct vxlan_metadata _md = {};
 	struct vxlan_metadata *md = &_md;
 	unsigned int pkt_len = skb->len;
 	__be16 src_port = 0, dst_port;
-- 
2.53.0



