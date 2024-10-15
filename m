Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0631C07C2;
	Tue, 15 Oct 2024 12:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997075; cv=none; b=TbKwNLf3Seg85mVFbjAOMS7Tu11JzZFxTlk1aIKdqPRYZM1jRL2bhy3/Pi/Itq7eb7KqwxL2jrJyPJkwhCxoLBz1eTPT9/rHfEe+JUH5ULDtDuJanyXcDhtmLAJf5/xqxJbHkYNzIC+Rb+sKFdfuF9as/A+M7AEI9fvDu0VT/k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997075; c=relaxed/simple;
	bh=8IbpOM3sGGNFMhGYSgrnKCQaHAhy7789edX/RErN98Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj1kGD2D6TjDhCmiumWTacGEKN4HVL9tvPI9KwRfFwWm3MJj+Aak7z/4pXlHF21TRKm1bWWGndhSOzkQaD3GNRd+cAMKEyZf2G8sAV50qQS6wjvRXTrvd/cE+QqW1KAuAIqGyyEU+gGFE1k9hJ2wBoARxtw+23Mn3JhBSgFXsbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqsPT6Gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqsPT6Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76C1C4CEC6;
	Tue, 15 Oct 2024 12:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997075;
	bh=8IbpOM3sGGNFMhGYSgrnKCQaHAhy7789edX/RErN98Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqsPT6Ggx4l0RZLvchIfBuk9U2kojhKbPoffaE3ij8p0WJOLnPsAlG14Xznk5VsEr
	 WyryQkAlHkKFv+nz+ovG8ja3qvAtAzWqHgt6jheaLN1gjSlymheHWHV95dZEAAEzbz
	 mkpraHHoN5xMuOtKle8pOTI+uFm/R7kqRlIXBEzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/518] bareudp: allow redirecting bareudp packets to eth devices
Date: Tue, 15 Oct 2024 14:39:45 +0200
Message-ID: <20241015123920.129276127@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 99c8719b79814cab3fd43519591dcc41c978a48c ]

Even though bareudp transports L3 data (typically IP or MPLS), it needs
to reset the mac_header pointer, so that other parts of the stack don't
mistakenly access the outer header after the packet has been
decapsulated.

This allows to push an Ethernet header to bareudp packets and redirect
them to an Ethernet device:

  $ tc filter add dev bareudp0 ingress matchall      \
      action vlan push_eth dst_mac 00:00:5e:00:53:01 \
                           src_mac 00:00:5e:00:53:00 \
      action mirred egress redirect dev eth0

Without this patch, push_eth refuses to add an ethernet header because
the skb appears to already have a MAC header.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 45fa29c85117 ("bareudp: Pull inner IP header in bareudp_udp_encap_recv().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index d9917120b8fac..1b774232b0df0 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -139,6 +139,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	skb->dev = bareudp->dev;
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 
 	if (!ipv6_mod_enabled() || family == AF_INET)
 		err = IP_ECN_decapsulate(oiph, skb);
-- 
2.43.0



