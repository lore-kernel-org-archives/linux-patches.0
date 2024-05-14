Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7545D54903;
	Tue, 14 May 2024 11:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684717; cv=none; b=D0D3umHdkMcjeLo2HpV4MCEdzfwcusnWpL/WEuBEFwX/fZCoFuZlC0WDrwyl7EIbVR2MxUyMsNnnp3Ht29gG1uww0ivi1iiBoE3ZvcP3zVbI+1PliTp6FfrXTiITLfdtOErUyMDQYYHoEFQzRBE5khm2C+V8z9N7eyVCtGQrjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684717; c=relaxed/simple;
	bh=GdoPmmuz/AIDNS9sa+CX6VDmSBOutGjyV4MiVkUUFUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ppap3cg7vapBgWf47bFYka3+lVIqBXaRWs9QbdwqRjMhLHaBuly9DB8kzO9eS1uouCJUy6YJTYk0TXKSAQg6PgCEUFls1F5GDCYzjDA0nFJoI1qVbyWbMaUMscK8PwCNF10KD3w32gnxnmJqQ9R8NrOHN+BOci1+Z/+VR2/kLaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YV7DmIQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YV7DmIQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1735DC2BD10;
	Tue, 14 May 2024 11:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684717;
	bh=GdoPmmuz/AIDNS9sa+CX6VDmSBOutGjyV4MiVkUUFUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YV7DmIQKkc/ZoKjImZ/AGawRK1jkV9InXnkSqqgmuJQRCKj3WyOA7Uf0b1K+njuWl
	 dh2LH2D54xXgz1v91YWuC2yEvt3c79CynDPjXCw3jsZ2NgxMBnJTDkGf2nZMJeTIDk
	 Vfp/mLytZi15po7ScAO0bGSNZoVhxHAzleuC2wBk=
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
Subject: [PATCH 6.6 080/301] vxlan: Pull inner IP header in vxlan_rcv().
Date: Tue, 14 May 2024 12:15:51 +0200
Message-ID: <20240514101035.268937527@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7e5e60318045a..f98069920e27f 100644
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



