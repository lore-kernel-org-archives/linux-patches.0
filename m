Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001D54C10DF;
	Thu, 17 Sep 2026 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659889; cv=none; b=rozxjQfelv4OkGPyc89HZZ3FFIsT57cgrFdo3aYtOE+rMcKjlqrd4X3r8aTYLDg1YylP6D7m4nSBJMWMYySjX13XeTOeqZFN1BxtMB8CBLHLD5FVDAY0+H7BmEzjHKfK+b1rXPTntExs4SIR+5LKGNqTqMvWKQ7pgzmD5CzZ5eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659889; c=relaxed/simple;
	bh=0BQFlhZ/nyTPYYqtfX8n+TWSfXmgM8bt47Wk6/BKCxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn5aiy8JTIu+t5jDcCl8+qpcZZjalrqGYFdxAwJYsC3dTIy/8kTda5gAK68+pyOr1N0T3ueAryCRDzylyw6nyxyEL3id2edVdLFD/eiGbIMQnxdvrjThslGh4XrTen/aU0PJTRHdTS3N57kXVt6uxkK1o5OTpVOPfqZ+o1RGwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG73+kZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG73+kZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569D21F000FF;
	Thu, 17 Sep 2026 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659884;
	bh=qUPvwDyps7U5e9hZmVx4htvHz3z5ZEHNxp4fR53G1Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RG73+kZXm5oikkbh6Ry0V/AQ1iSBPvvmDqmV2J4MP8Od0Vvg+RXSUq+Gvsp1YoQEQ
	 xkv+LOmsUS+yWKfpg2mSeHSAShTlFDnq6R8wPRYsjq4ndNu7SBUSNuJFBbQZN9NBji
	 CMXfRKY3cfL5v/BTsxQpwhcfCpTiRONUz2K7eqdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 405/733] vxlan: initialize _md in vxlan_xmit_one()
Date: Thu, 17 Sep 2026 16:11:53 +0100
Message-ID: <20260917151401.844730048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1d76e1dbc41f2..e045e1ee9e594 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2373,7 +2373,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
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



