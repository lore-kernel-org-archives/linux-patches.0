Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210D536EA89;
	Tue, 10 Mar 2026 11:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141248; cv=none; b=Jal0LAt5ReRkaF0mectZ1y+LWFE1beVoVQc1bnuiRIzck+oKuHCAyhN/d2qMqsNcwoiPZLHy7mK2kfJosFMAJqhZo89ThnU9iuehB6O19UlNAtW0r9kc2huuI81s5Xnu72xFjuyHK2Q5VNy/6jSXuWqwRZ8k5Wihf80OKnZpqwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141248; c=relaxed/simple;
	bh=N7Wyh5ramUXGxgblyxj6McCO9h990p/XpTpfY9fEEbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmadFPyzDwG5SRf1EQVEa6oPr6bKLmDGALLmlAUjpTF1Le2N6yRFiXUl/JgaC8M4TCETdvMnNrkwkj2ydZXPiv+ew3iiVabDGzkydya9r/iVpW9UPX1/auLyFYQA9FIGKoQnr8kOZaiPiv10O838OeGqBqlJhH6HFax1xLJq3Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nphXLl8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nphXLl8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220D2C2BC86;
	Tue, 10 Mar 2026 11:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141248;
	bh=N7Wyh5ramUXGxgblyxj6McCO9h990p/XpTpfY9fEEbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nphXLl8ipFQiwCYl2gZ7fD9uzsrp1QUzvHTFPv3c8J4Ud564W5QVumCWGRHpXPied
	 L3CdpNU4EyM0Mk5JihVHRItdE7ufsK7rCJjSpYHRM2v0WT37fVboyTE5HNHJf8A0k+
	 KrnGVz78fu0A9nDyrnfUrhsAAMRk0mI5E+L1f0vL7oBja6Ut9sBni20IH05LBwwGIA
	 YRGKdI2C7lU53R3v9nVDT2t4cBBH6RXJC1SwZzV8osxWn91kvYSLxm7AIB/e9fmKmj
	 xnAHSRNgG/1ATE++g2WAvThzjiDRMrIAnaxbAAFAAhhQcms/SqFIwxztbJASP5fB4W
	 cg6ztoqN2905g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kohei Enju <kohei@enjuk.jp>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 250/311] iavf: fix netdev->max_mtu to respect actual hardware limit
Date: Tue, 10 Mar 2026 07:04:57 -0400
Message-ID: <1756f00bdbaecb933307cc5c2ba3d1f652b1b6cf.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit b84852170153671bb0fa6737a6e48370addd8e1a ]

iavf sets LIBIE_MAX_MTU as netdev->max_mtu, ignoring vf_res->max_mtu
from PF [1]. This allows setting an MTU beyond the actual hardware
limit, causing TX queue timeouts [2].

Set correct netdev->max_mtu using vf_res->max_mtu from the PF.

Note that currently PF drivers such as ice/i40e set the frame size in
vf_res->max_mtu, not MTU. Convert vf_res->max_mtu to MTU before setting
netdev->max_mtu.

[1]
 # ip -j -d link show $DEV | jq '.[0].max_mtu'
 16356

[2]
 iavf 0000:00:05.0 enp0s5: NETDEV WATCHDOG: CPU: 1: transmit queue 0 timed out 5692 ms
 iavf 0000:00:05.0 enp0s5: NIC Link is Up Speed is 10 Gbps Full Duplex
 iavf 0000:00:05.0 enp0s5: NETDEV WATCHDOG: CPU: 6: transmit queue 3 timed out 5312 ms
 iavf 0000:00:05.0 enp0s5: NIC Link is Up Speed is 10 Gbps Full Duplex
 ...

Fixes: 5fa4caff59f2 ("iavf: switch to Page Pool")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 4b0fc8f354bc9..53a0366fbf998 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2797,7 +2797,22 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 	netdev->watchdog_timeo = 5 * HZ;
 
 	netdev->min_mtu = ETH_MIN_MTU;
-	netdev->max_mtu = LIBIE_MAX_MTU;
+
+	/* PF/VF API: vf_res->max_mtu is max frame size (not MTU).
+	 * Convert to MTU.
+	 */
+	if (!adapter->vf_res->max_mtu) {
+		netdev->max_mtu = LIBIE_MAX_MTU;
+	} else if (adapter->vf_res->max_mtu < LIBETH_RX_LL_LEN + ETH_MIN_MTU ||
+		   adapter->vf_res->max_mtu >
+			   LIBETH_RX_LL_LEN + LIBIE_MAX_MTU) {
+		netdev_warn_once(adapter->netdev,
+				 "invalid max frame size %d from PF, using default MTU %d",
+				 adapter->vf_res->max_mtu, LIBIE_MAX_MTU);
+		netdev->max_mtu = LIBIE_MAX_MTU;
+	} else {
+		netdev->max_mtu = adapter->vf_res->max_mtu - LIBETH_RX_LL_LEN;
+	}
 
 	if (!is_valid_ether_addr(adapter->hw.mac.addr)) {
 		dev_info(&pdev->dev, "Invalid MAC address %pM, using random\n",
-- 
2.51.0

