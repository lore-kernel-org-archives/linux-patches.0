Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989C518C332;
	Wed, 30 Sep 2026 16:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787406; cv=none; b=j8BfilTJ6JkjlUuEL6SNwKmyzu9SthFS3KrQBPs1OEmYIMqsiTu+7vr/NuX73B4c4ieiLJ/9MGQSIzkzj7fiKVMolob3EqMXP8T9pgBfwv8NVimhyFJR8LgyJ2etn59Y0yW5QZhY/7ONHeAtgpZaStpRprJm0hj5+CBxmV7ModA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787406; c=relaxed/simple;
	bh=kGF75vCdb6YGy3UN6Ie6PxPxbtXsUtzAj4ccll6C9tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgYo7qtQReMldE3f34qr7fbNdj4HUeWCC+GUU+0Qm7AvAlPJdCjYKVuw7J8Xf3VRRlYZlLdJcm4lxpVkqbLPqc/k8hHj1mwRBGt1CxEnPMNdvk87zUlG7XL44ZlMmDl3yjXnkquK9wajNbdxKGduYlTt/TYXWNiqaSyip+cmOY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cV+6jLbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cV+6jLbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56331F000FF;
	Wed, 30 Sep 2026 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787405;
	bh=EiZsIDEULG1XJcXmPZGC8PNqrlYSYSSm91K+FMv6VYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cV+6jLbR7983EHypwnUY5otoKsnc+mA2KfXarQ9D/siVrmxjQzBda79EH6cHCRhjM
	 ntuKGWw2xjPJzdM2uFk4VqRTWXEBnrDJ2aByxTdIXAapwuYGRtpjJPwI6D8DqFseu2
	 w2pxGAzfBc+OlEUWaN8bX6Rh3qDp+Nbe+RZTZVXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie Phillips <eddiephillips@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 220/457] gve: fix TX drop when GSO MSS is too small for hw
Date: Wed, 30 Sep 2026 17:25:25 +0200
Message-ID: <20260930152350.797944782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index 0f6f7c5dbb2e0..e5fe17b047981 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -577,17 +577,6 @@ static int gve_prep_tso(struct sk_buff *skb)
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
@@ -925,6 +914,9 @@ static bool gve_can_send_tso(const struct sk_buff *skb)
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



