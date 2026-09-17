Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63754973B9;
	Thu, 17 Sep 2026 18:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670888; cv=none; b=LI3YlxhjtccMgraDmIoAptHubyilhri76luE6olq9n7cosnyhiVxx/iDr3r5xvwls/wNkZXIvuKZegX7Ioys5GMpSZ46h0fYnB+NIFQfalLS/oAh7+zFIQJy/wn16tgU2Xl9KCFufdnt4FHdJ0sl34VfVGf8r3DkjV2iYrj47Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670888; c=relaxed/simple;
	bh=2/iogWFp5LABcG14RFPzz5Mol08YImszMyBqNcRwdeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pfu9wMJ97v5HkVI9IpcqIle1nMcifp86inwM0MhfcqKQgiAu/H/La7Gv1pjCKozpjPrRbcC4Riliio6oUbVEeR6D/6oRsjNLfGg2acaBdYu28sRlG3mrxGfw0V4XVQ6maRmqse11UH1KqAAIdsRzODQ5UHccUGkfPwe2ySAdBGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7wOPyRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7wOPyRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06F21F000FF;
	Thu, 17 Sep 2026 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670887;
	bh=1dtmN90sXBqcas5sht7AkTd6YH1v/+cPzf6A6mLRBT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7wOPyRtUrx8ARXbOE2ImXZJ0eyNR/tIdmfSRgVT1AteFAsVSDge7Wjhyx2/JfGiK
	 2X9Gtkz79+Fw/BZ0SKkt8L27PNYM3PycfectCbfDfQrpJf2KCeOlu8oJLFO+xcmCFL
	 erc20JabnL/0VLMFs04+UXhGwfCM3fXU47uR0RjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0765/1102] vxlan: initialize _md in vxlan_xmit_one()
Date: Thu, 17 Sep 2026 16:11:48 +0100
Message-ID: <20260917151559.644287148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index bf50dc239b1d0..b14dbc6892078 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2392,7 +2392,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
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



