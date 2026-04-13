Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B3A31DD97;
	Mon, 13 Apr 2026 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099119; cv=none; b=ip1HaBii7tCuSgrfjGbx80f6xY8vhzzrZF+CdT8Ll0N9Rphqd4xQdaOIAeveJLlij3gl90yuOeByYzSiR6OIa31HO/dOZDCgg+ADWPPrVqSSxjfeaIX1JrSWmjY8wZNy26DCiModCQke0gCixG6UUa9kEQkOQu3HcEkgl/49omY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099119; c=relaxed/simple;
	bh=5eGSW9KUHvwFhuPlTMj1EhBOOeElYv80co4VZC3cj3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGoD4z/QE3/f4U+JHY2T+lPjlTTuoDsen/oDZTzGWH6YFum4IpEHM8aA83xc2koT6aMJ2s2QyCmnRDtngFjYw+Ev8XbvwCx/ndKPC6BHeByHB/u5W/CyYqWvndHFevSKmh//hFBvQPcj8kocshKg1KOO/OIjr8EKBsaxYRHpz/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX86SfBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX86SfBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20035C2BCB0;
	Mon, 13 Apr 2026 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099119;
	bh=5eGSW9KUHvwFhuPlTMj1EhBOOeElYv80co4VZC3cj3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RX86SfBTLQIfMo6akAk2N+HUcZ/SyY9b3bp7A1ZONm2P6/s+e102f16Pe8D/d/4Pi
	 LnNGxjXwXQHEf9KOpG72ESt+nFGi5Duuf2TV5o5mP7PedP264PBkLQJRienw2aU+08
	 ysTYa3wL856DtrC1w6cvi0oxtPXB8vy7Xo3fbrXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/491] igc: fix missing update of skb->tail in igc_xmit_frame()
Date: Mon, 13 Apr 2026 17:57:43 +0200
Message-ID: <20260413155827.226775105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit 0ffba246652faf4a36aedc66059c2f94e4c83ea5 ]

igc_xmit_frame() misses updating skb->tail when the packet size is
shorter than the minimum one.
Use skb_put_padto() in alignment with other Intel Ethernet drivers.

Fixes: 0507ef8a0372 ("igc: Add transmit and receive fastpath and interrupt handlers")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7593e8b7469c5..e59de43704b51 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1522,11 +1522,8 @@ static netdev_tx_t igc_xmit_frame(struct sk_buff *skb,
 	/* The minimum packet size with TCTL.PSP set is 17 so pad the skb
 	 * in order to meet this minimum size requirement.
 	 */
-	if (skb->len < 17) {
-		if (skb_padto(skb, 17))
-			return NETDEV_TX_OK;
-		skb->len = 17;
-	}
+	if (skb_put_padto(skb, 17))
+		return NETDEV_TX_OK;
 
 	return igc_xmit_frame_ring(skb, igc_tx_queue_mapping(adapter, skb));
 }
-- 
2.51.0



