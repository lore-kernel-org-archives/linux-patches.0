Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D2951CF59;
	Wed, 30 Sep 2026 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793255; cv=none; b=XKG4+zNr/k7I91Sp0Olu/i49QZysQrkG/Sv0I0RYRGroYiZQ4uABKf4c6LHUdhqDQUttt3Jc7C4psOHT8d5hZhpAyzW0NAeIlL+7+cz595FUnaXBVFTui9w8Cdgb8WdkFpNWU+Q2iHOMc+d35Jc8vmmw1oc7szWksgB/7lkJ3M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793255; c=relaxed/simple;
	bh=arbABNxUqLBOwp7b+AcjB7m9mQA+Ggm1Uz6hKYr+9ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pps8mnNyQ5yb7uLfxa4HJliDDmqFzeKnxtX4j0TG6QGkZNF76NLYBZ6WeuHpZVioEkp6JPag7R0KpWn+YljmXnXKyWlqzE0mceh/BXe8rl5H90Adj8NbVFU/+NKWdFNCK5m2cAhmtzdM9PcF9so/d8f/XAV1W+POIWWjz+RiDNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxjbF4ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxjbF4ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D568B1F000FF;
	Wed, 30 Sep 2026 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793254;
	bh=pClUhAWuAJha7dpBM2vSiQQpXGgYkucL43WBwa0HbCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OxjbF4ipVg5R8JfrNhUvyCQRswm2AIYyULbyl31rLL6hVchItoZG6AUPeDNRV8x6d
	 NMrblSHgOXbiM9iTszv/5+52ZSRu/qrbY/ns7vxPI9T1hFMWnfQhEVFZGsr5iv52sO
	 9CiG2nAqjwp8rvKYGaub31B0ZRo6kAvSTyXUroaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie Phillips <eddiephillips@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/395] gve: fix TX drop when GSO MSS is too small for hw
Date: Wed, 30 Sep 2026 17:27:32 +0200
Message-ID: <20260930152344.771811168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Eddie Phillips <eddiephillips@google.com>

[ Upstream commit 3b430ea6234087957b0d3cd181e3116722b59819 ]

The device has a strict requirement that the minimum MSS
(gso_size) for TSO/GSO packets must be at least 88 bytes. If a packet
below this threshold is pushed to the hardware, it can cause
hardware to silently drop the packet, leading to increased latency
and retransmissions.

Currently, this is validated too late in the transmit pipeline
(gve_prep_tso), leading to silent drops.

Fix this by moving the validation into the .ndo_features_check
callback (gve_features_check_dqo). If we detect a GSO packet with
a gso_size smaller than GVE_TX_MIN_TSO_MSS_DQO, we clear the GSO
feature flags for this packet.

Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Eddie Phillips <eddiephillips@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260924004252.1196328-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 49ed911957ec0..ba100f42fad93 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -582,17 +582,6 @@ static int gve_prep_tso(struct sk_buff *skb)
 	int header_len;
 	int err;
 
-	/* Note: HW requires MSS (gso_size) to be <= 9728 and the total length
-	 * of the TSO to be <= 262143.
-	 *
-	 * However, we don't validate these because:
-	 * - Hypervisor enforces a limit of 9K MTU
-	 * - Kernel will not produce a TSO larger than 64k
-	 */
-
-	if (unlikely(shinfo->gso_size < GVE_TX_MIN_TSO_MSS_DQO))
-		return -1;
-
 	/* Needed because we will modify header. */
 	err = skb_cow_head(skb, 0);
 	if (err < 0)
@@ -930,6 +919,9 @@ static bool gve_can_send_tso(const struct sk_buff *skb)
 	int header_len;
 	int i;
 
+	if (unlikely(gso_size < GVE_TX_MIN_TSO_MSS_DQO))
+		return false;
+
 	/* Must match the header length programmed by gve_prep_tso(). */
 	if (skb_is_gso_tcp(skb))
 		header_len = skb_tcp_all_headers(skb);
-- 
2.53.0



