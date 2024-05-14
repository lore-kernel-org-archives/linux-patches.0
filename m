Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B784DA13;
	Tue, 14 May 2024 10:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682759; cv=none; b=NxWTiYUNYvKaGtolQE9aDleKSVv9rsqkiPSrmyyw+pnRaIqa5P99OImemR1m8bhzxEDoOqRdAnHU2wAopswAf9GmpPK636Bgryw+munqy+WJVEryxD1CNi4Yf7RH3B4APcFVKaY/LwimhX3bGszVBISlan0OTT1XLj1mpFn0Ujw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682759; c=relaxed/simple;
	bh=Fb0nz1vJp5wOEIFf2ny27g0hhB3Jc/wVditH0jknMWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKO179YkLqONHYox8V6sTUHWnq9xFVCWOOQSXHtQreyi25nxkQhYi8ZjM4w2n2pGNToB6plKLQAzwJP9Vy9k6EJe0C+Tj9avQlFceK3V0NVRX+PULc/Ixd/JrnXno7mCbV+dCkyuIpxjWtfexoz/6dL7h3GxIhWFekb1IgbjKTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URydVsNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URydVsNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7488CC2BD10;
	Tue, 14 May 2024 10:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682759;
	bh=Fb0nz1vJp5wOEIFf2ny27g0hhB3Jc/wVditH0jknMWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URydVsNxcEFrm8x/VIH9rmLZSx5PK74FDFj0zOBZe1kp9GqNUcR8KHoi4adMwm7CZ
	 2oI6gccaQvDu1Koe+IvOl97twOZSAeaRwAwUSUn3wnvUL9cVWmrJomJKEuoLOZSmt+
	 jhlFRlPaAUhD9uJQh9/h0IklvCrgreQzpUxLTLrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 078/336] vxlan: Pull inner IP header in vxlan_rcv().
Date: Tue, 14 May 2024 12:14:42 +0200
Message-ID: <20240514101041.550959308@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit f7789419137b18e3847d0cc41afd788c3c00663d ]

Ensure the inner IP header is part of skb's linear data before reading
its ECN bits. Otherwise we might read garbage.
One symptom is the system erroneously logging errors like
"vxlan: non-ECT from xxx.xxx.xxx.xxx with TOS=xxxx".

Similar bugs have been fixed in geneve, ip_tunnel and ip6_tunnel (see
commit 1ca1ba465e55 ("geneve: make sure to pull inner header in
geneve_rx()") for example). So let's reuse the same code structure for
consistency. Maybe we'll can add a common helper in the future.

Fixes: d342894c5d2f ("vxlan: virtual extensible lan")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/1239c8db54efec341dd6455c77e0380f58923a3c.1714495737.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 743fcde565b2f..0a0b4a9717cec 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1674,6 +1674,7 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	bool raw_proto = false;
 	void *oiph;
 	__be32 vni = 0;
+	int nh;
 
 	/* Need UDP and VXLAN header to be present */
 	if (!pskb_may_pull(skb, VXLAN_HLEN))
@@ -1762,9 +1763,25 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 		skb->pkt_type = PACKET_HOST;
 	}
 
-	oiph = skb_network_header(skb);
+	/* Save offset of outer header relative to skb->head,
+	 * because we are going to reset the network header to the inner header
+	 * and might change skb->head.
+	 */
+	nh = skb_network_header(skb) - skb->head;
+
 	skb_reset_network_header(skb);
 
+	if (!pskb_inet_may_pull(skb)) {
+		DEV_STATS_INC(vxlan->dev, rx_length_errors);
+		DEV_STATS_INC(vxlan->dev, rx_errors);
+		vxlan_vnifilter_count(vxlan, vni, vninode,
+				      VXLAN_VNI_STATS_RX_ERRORS, 0);
+		goto drop;
+	}
+
+	/* Get the outer header. */
+	oiph = skb->head + nh;
+
 	if (!vxlan_ecn_decapsulate(vs, oiph, skb)) {
 		DEV_STATS_INC(vxlan->dev, rx_frame_errors);
 		DEV_STATS_INC(vxlan->dev, rx_errors);
-- 
2.43.0



