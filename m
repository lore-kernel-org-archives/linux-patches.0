Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8F631DDB8;
	Tue,  2 Sep 2025 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820213; cv=none; b=l0nyxCI+ZCGYYSYklPaRH1LR8RuhE8vcrcGbx6GmTZQHpMjxzWfjpK6NatIEBTU8NYGq4rdQBgn6VGTYAXFNH3LTXNU5rIWwtUaf9VGELGOSxoIScQGIFFpVnqL6AHaCqSY3JliEEjVTbH2Qv5Y1RW2SJKIJfoonzBC2OkkmQcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820213; c=relaxed/simple;
	bh=IYAxXPJ/ursIyaUnsNeZvZ9/ErlTWPCGb+0phNTuqTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9xQ/B4w4h//r2KniMp0xsdH26rbJvcjRoL5zGO+eo5+RSerk53xBpT0Nq0nv+qFxokP40d8Mmo77TrVZ9Vk8kpzVueNoSs3xpS3RlvYRV1dtS3s/U6GdYsjXcBq9Q6hJqhDGIQyWGpWE7fhDI3LT2LoH8JjiibpjQ2/AVQOo4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyl8iOm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyl8iOm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E18C4CEED;
	Tue,  2 Sep 2025 13:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820213;
	bh=IYAxXPJ/ursIyaUnsNeZvZ9/ErlTWPCGb+0phNTuqTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyl8iOm0qNMiDeJOAt+BF/TAgtoqndu1feWSgUctFlpG+OMHh3j5e9v7t4dPaipsf
	 al8evaG0avQNAXU1myUlgXihSLcNrqL33YOboxmH8faWVuU6DZWuSEKLQafRIbGJYs
	 iQ9va5i/a5xjDnUsESobRv7zPowKmbpB8vgTzr4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Priya Singh <priyax.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 32/75] ice: fix incorrect counter for buffer allocation failures
Date: Tue,  2 Sep 2025 15:20:44 +0200
Message-ID: <20250902131936.383850831@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michal Kubiak <michal.kubiak@intel.com>

[ Upstream commit b1a0c977c6f1130f7dd125ee3db8c2435d7e3d41 ]

Currently, the driver increments `alloc_page_failed` when buffer allocation fails
in `ice_clean_rx_irq()`. However, this counter is intended for page allocation
failures, not buffer allocation issues.

This patch corrects the counter by incrementing `alloc_buf_failed` instead,
ensuring accurate statistics reporting for buffer allocation failures.

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Reported-by: Jacob Keller <jacob.e.keller@intel.com>
Suggested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Priya Singh <priyax.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e7084c6aab6da..eae4376c68595 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1297,7 +1297,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			skb = ice_construct_skb(rx_ring, xdp);
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
-			rx_ring->ring_stats->rx_stats.alloc_page_failed++;
+			rx_ring->ring_stats->rx_stats.alloc_buf_failed++;
 			xdp_verdict = ICE_XDP_CONSUMED;
 		}
 		ice_put_rx_mbuf(rx_ring, xdp, &xdp_xmit, ntc, xdp_verdict);
-- 
2.50.1



