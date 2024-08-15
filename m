Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501A23214;
	Thu, 15 Aug 2024 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732661; cv=none; b=Bkt/GtppAcJYxz+xY8sOLTIH1DwDn7B8Frk2+FxExj1r+Ye6JFPWqCnJEaoYmvSpF7JBsBBY4hiNXN18VLdsYP1WmX+EBkx2KOOA52vp4xalr0YP7r7CQlXSzADMsJfp7CTzYJDZEjl/L2hmb99Tl+8rY7ZPxweHXj22SRIQ3Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732661; c=relaxed/simple;
	bh=DAchrNRtEFCIinBwsLxj2ZeFcDTneXzf8r4YrLbTHGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zyh18JITBNVK1wJvCRkvZQ+sjKEPCMLffIUQQ5h0H6rUNmTQ0/3BN8O4x4gDVM0qiNrt0zwQ/b67CwJr4EbmyYnp0CofyqbIQIWJcdk4d6orN/wP925Qb36OEb7gtm0pquIkLUJY6/R01QGY47As+l5fDT/CJ3xbN4ejobU+EZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/39LAKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/39LAKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B96DC32786;
	Thu, 15 Aug 2024 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732660;
	bh=DAchrNRtEFCIinBwsLxj2ZeFcDTneXzf8r4YrLbTHGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/39LAKfLawejuqOEpjzXTuByx+hXnwREF1zvHpPW5TBpvhELk0hKIPNpQUv6KxsS
	 XaMokHRf58Uf75JNRlsaWzOp3l0ugHA/YZIkBB3bJ7U6U2DSIprt09MQcGzrXfHc7n
	 uXP0i4UvkaY/9wDtmGZw8Y3YSSk1Z+/MTE6l5glE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>
Subject: [PATCH 5.10 246/352] r8169: dont increment tx_dropped in case of NETDEV_TX_BUSY
Date: Thu, 15 Aug 2024 15:25:12 +0200
Message-ID: <20240815131928.946884010@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit d516b187a9cc2e842030dd005be2735db3e8f395 upstream.

The skb isn't consumed in case of NETDEV_TX_BUSY, therefore don't
increment the tx_dropped counter.

Fixes: 188f4af04618 ("r8169: use NETDEV_TX_{BUSY/OK}")
Cc: stable@vger.kernel.org
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/bbba9c48-8bac-4932-9aa1-d2ed63bc9433@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4288,7 +4288,8 @@ static netdev_tx_t rtl8169_start_xmit(st
 	if (unlikely(!rtl_tx_slots_avail(tp))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
-		goto err_stop_0;
+		netif_stop_queue(dev);
+		return NETDEV_TX_BUSY;
 	}
 
 	opts[1] = rtl8169_tx_vlan_tag(skb);
@@ -4361,11 +4362,6 @@ err_dma_0:
 	dev_kfree_skb_any(skb);
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
-
-err_stop_0:
-	netif_stop_queue(dev);
-	dev->stats.tx_dropped++;
-	return NETDEV_TX_BUSY;
 }
 
 static unsigned int rtl_last_frag_len(struct sk_buff *skb)


