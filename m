Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF5837F008;
	Tue, 17 Mar 2026 16:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765903; cv=none; b=Mg02q1TwvaxKkA83oCx/NDSHVrJWdBzUF0HBOvoI2TlGUQ/08hgkLH+tQl/7/24J8dQ0DKwszGiYI+Oq+d1vFlJ0I4iJyzuL0Ba9lc7lgmqbVkqT6igf2dCVKPyipqMK8nuX5FssWn72bwNk/YHED8/VGKKX2t2rCOTFQ+9caSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765903; c=relaxed/simple;
	bh=iHVaz+EtLwBwyfCzrkRyP1V9ZmDHU09dUtyUWgKVQwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVWOFz5gneg20VkkLEnLSgLsPMCEG7yX9I2tXzwPYJgHSH41oPJnVFWMt5tN9XFb5psMwm2AYdgaRQv/cXXHdlIkFSfFxON5BSyx545axjNaUt05MqXzSPLCOkTEHY/Eebidd/lm8fgZjb72LoMOLmYyhC3xOQWvW/twHgqsSl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBgQ3FnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBgQ3FnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5B2C4CEF7;
	Tue, 17 Mar 2026 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765902;
	bh=iHVaz+EtLwBwyfCzrkRyP1V9ZmDHU09dUtyUWgKVQwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBgQ3FnCO3yCWA+e6zpJ5fhPiWLKzJyfrKpdMlmxUsTMaOjRy9HnEyO2O2zUMSZvH
	 4eC1636HBYpvJtDs1/dqHf3sPQI7umy2E6YON121PugHDZ7cf6W5/B2b9EIJPzTflR
	 ibbn76UbCiS4HSdCD9X+Yrk0fJKhwrNJMnVFey14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 094/378] e1000/e1000e: Fix leak in DMA error cleanup
Date: Tue, 17 Mar 2026 17:30:51 +0100
Message-ID: <20260317163010.475980710@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Vollrath <tactii@gmail.com>

[ Upstream commit e94eaef11142b01f77bf8ba4d0b59720b7858109 ]

If an error is encountered while mapping TX buffers, the driver should
unmap any buffers already mapped for that skb.

Because count is incremented after a successful mapping, it will always
match the correct number of unmappings needed when dma_error is reached.
Decrementing count before the while loop in dma_error causes an
off-by-one error. If any mapping was successful before an unsuccessful
mapping, exactly one DMA mapping would leak.

In these commits, a faulty while condition caused an infinite loop in
dma_error:
Commit 03b1320dfcee ("e1000e: remove use of skb_dma_map from e1000e
driver")
Commit 602c0554d7b0 ("e1000: remove use of skb_dma_map from e1000 driver")

Commit c1fa347f20f1 ("e1000/e1000e/igb/igbvf/ixgb/ixgbe: Fix tests of
unsigned in *_tx_map()") fixed the infinite loop, but introduced the
off-by-one error.

This issue may still exist in the igbvf driver, but I did not address it
in this patch.

Fixes: c1fa347f20f1 ("e1000/e1000e/igb/igbvf/ixgb/ixgbe: Fix tests of unsigned in *_tx_map()")
Assisted-by: Claude:claude-4.6-opus
Signed-off-by: Matt Vollrath <tactii@gmail.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 2 --
 drivers/net/ethernet/intel/e1000e/netdev.c    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 7f078ec9c14c5..15160427c8b30 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -2952,8 +2952,6 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 dma_error:
 	dev_err(&pdev->dev, "TX DMA map failed\n");
 	buffer_info->dma = 0;
-	if (count)
-		count--;
 
 	while (count--) {
 		if (i == 0)
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index ddbe2f7d81121..6bcb57609d16a 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5654,8 +5654,6 @@ static int e1000_tx_map(struct e1000_ring *tx_ring, struct sk_buff *skb,
 dma_error:
 	dev_err(&pdev->dev, "Tx DMA map failed\n");
 	buffer_info->dma = 0;
-	if (count)
-		count--;
 
 	while (count--) {
 		if (i == 0)
-- 
2.51.0



