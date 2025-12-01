Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF8B262FE4;
	Mon,  1 Dec 2025 11:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588794; cv=none; b=jI7v/XUnDX2xO2jZjysvBmGLAzqWhkDR3zx3iEF5bL7la52dvRnB9dvMdLu2ROs70IXq5Qk8neV7bfZBBHQGRXsiXrnF6NdXZK1utltMsSGtR7BLzJHAKl5VMrLb2PqjEpU0MpfcCeqXUu0yfbiegstXXaz2ck7v91NsrO4Xr44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588794; c=relaxed/simple;
	bh=TPFHb4JjIvVzrviAL0vfzWzf7giKDhL8hyvK/4Oa8TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCLXbxmymwmNSabumDzVoHUcJ1Oa2zV3jZyblCPIrADCGsF7+BH2D0CkmwCxvBRBJ53F5xdTxU7ov5wqJ8cgMIQHWoSiLwhV4ZIONoN4nYdH3/dmJmiEjJwcLC9cceDZ9SfBJpijHq8stw5gz18lH1iMpgCIwl+aXB3n9yRarEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmUdjUVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmUdjUVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A075C4CEF1;
	Mon,  1 Dec 2025 11:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588794;
	bh=TPFHb4JjIvVzrviAL0vfzWzf7giKDhL8hyvK/4Oa8TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmUdjUVCgL6Oa8OojQape0Cj7bRuSX8egJWtGgdjnw3vRGoMLwNg3lC+ZDLii1hbb
	 9kTlF/k0lgm4LHUClrAeyG+CfkcrQvQdqCrnotY0+fZhUdKB9ptheD1dHYOMm5b+No
	 34mE9v7bZJDPqLXGQqUCc/ed5xd5MjtS0TZyzafQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Nishanth Menon <nm@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/187] net: ethernet: ti: netcp: Standardize knav_dma_open_channel to return NULL on error
Date: Mon,  1 Dec 2025 12:24:41 +0100
Message-ID: <20251201112247.458268652@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 90a88306eb874fe4bbdd860e6c9787f5bbc588b5 ]

Make knav_dma_open_channel consistently return NULL on error instead
of ERR_PTR. Currently the header include/linux/soc/ti/knav_dma.h
returns NULL when the driver is disabled, but the driver
implementation does not even return NULL or ERR_PTR on failure,
causing inconsistency in the users. This results in a crash in
netcp_free_navigator_resources as followed (trimmed):

Unhandled fault: alignment exception (0x221) at 0xfffffff2
[fffffff2] *pgd=80000800207003, *pmd=82ffda003, *pte=00000000
Internal error: : 221 [#1] SMP ARM
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-rc7 #1 NONE
Hardware name: Keystone
PC is at knav_dma_close_channel+0x30/0x19c
LR is at netcp_free_navigator_resources+0x2c/0x28c

[... TRIM...]

Call trace:
 knav_dma_close_channel from netcp_free_navigator_resources+0x2c/0x28c
 netcp_free_navigator_resources from netcp_ndo_open+0x430/0x46c
 netcp_ndo_open from __dev_open+0x114/0x29c
 __dev_open from __dev_change_flags+0x190/0x208
 __dev_change_flags from netif_change_flags+0x1c/0x58
 netif_change_flags from dev_change_flags+0x38/0xa0
 dev_change_flags from ip_auto_config+0x2c4/0x11f0
 ip_auto_config from do_one_initcall+0x58/0x200
 do_one_initcall from kernel_init_freeable+0x1cc/0x238
 kernel_init_freeable from kernel_init+0x1c/0x12c
 kernel_init from ret_from_fork+0x14/0x38
[... TRIM...]

Standardize the error handling by making the function return NULL on
all error conditions. The API is used in just the netcp_core.c so the
impact is limited.

Note, this change, in effect reverts commit 5b6cb43b4d62 ("net:
ethernet: ti: netcp_core: return error while dma channel open issue"),
but provides a less error prone implementation.

Suggested-by: Simon Horman <horms@kernel.org>
Suggested-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251103162811.3730055-1-nm@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/netcp_core.c | 10 +++++-----
 drivers/soc/ti/knav_dma.c            | 14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 5dbb4ed1b1328..5c850cc3fae41 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1339,10 +1339,10 @@ int netcp_txpipe_open(struct netcp_tx_pipe *tx_pipe)
 
 	tx_pipe->dma_channel = knav_dma_open_channel(dev,
 				tx_pipe->dma_chan_name, &config);
-	if (IS_ERR(tx_pipe->dma_channel)) {
+	if (!tx_pipe->dma_channel) {
 		dev_err(dev, "failed opening tx chan(%s)\n",
 			tx_pipe->dma_chan_name);
-		ret = PTR_ERR(tx_pipe->dma_channel);
+		ret = -EINVAL;
 		goto err;
 	}
 
@@ -1360,7 +1360,7 @@ int netcp_txpipe_open(struct netcp_tx_pipe *tx_pipe)
 	return 0;
 
 err:
-	if (!IS_ERR_OR_NULL(tx_pipe->dma_channel))
+	if (tx_pipe->dma_channel)
 		knav_dma_close_channel(tx_pipe->dma_channel);
 	tx_pipe->dma_channel = NULL;
 	return ret;
@@ -1679,10 +1679,10 @@ static int netcp_setup_navigator_resources(struct net_device *ndev)
 
 	netcp->rx_channel = knav_dma_open_channel(netcp->netcp_device->device,
 					netcp->dma_chan_name, &config);
-	if (IS_ERR(netcp->rx_channel)) {
+	if (!netcp->rx_channel) {
 		dev_err(netcp->ndev_dev, "failed opening rx chan(%s\n",
 			netcp->dma_chan_name);
-		ret = PTR_ERR(netcp->rx_channel);
+		ret = -EINVAL;
 		goto fail;
 	}
 
diff --git a/drivers/soc/ti/knav_dma.c b/drivers/soc/ti/knav_dma.c
index 981a9014c9c4e..f238ce3d32fbe 100644
--- a/drivers/soc/ti/knav_dma.c
+++ b/drivers/soc/ti/knav_dma.c
@@ -420,7 +420,7 @@ static int of_channel_match_helper(struct device_node *np, const char *name,
  * @name:	slave channel name
  * @config:	dma configuration parameters
  *
- * Returns pointer to appropriate DMA channel on success or error.
+ * Return: Pointer to appropriate DMA channel on success or NULL on error.
  */
 void *knav_dma_open_channel(struct device *dev, const char *name,
 					struct knav_dma_cfg *config)
@@ -433,13 +433,13 @@ void *knav_dma_open_channel(struct device *dev, const char *name,
 
 	if (!kdev) {
 		pr_err("keystone-navigator-dma driver not registered\n");
-		return (void *)-EINVAL;
+		return NULL;
 	}
 
 	chan_num = of_channel_match_helper(dev->of_node, name, &instance);
 	if (chan_num < 0) {
 		dev_err(kdev->dev, "No DMA instance with name %s\n", name);
-		return (void *)-EINVAL;
+		return NULL;
 	}
 
 	dev_dbg(kdev->dev, "initializing %s channel %d from DMA %s\n",
@@ -450,7 +450,7 @@ void *knav_dma_open_channel(struct device *dev, const char *name,
 	if (config->direction != DMA_MEM_TO_DEV &&
 	    config->direction != DMA_DEV_TO_MEM) {
 		dev_err(kdev->dev, "bad direction\n");
-		return (void *)-EINVAL;
+		return NULL;
 	}
 
 	/* Look for correct dma instance */
@@ -462,7 +462,7 @@ void *knav_dma_open_channel(struct device *dev, const char *name,
 	}
 	if (!found) {
 		dev_err(kdev->dev, "No DMA instance with name %s\n", instance);
-		return (void *)-EINVAL;
+		return NULL;
 	}
 
 	/* Look for correct dma channel from dma instance */
@@ -483,14 +483,14 @@ void *knav_dma_open_channel(struct device *dev, const char *name,
 	if (!found) {
 		dev_err(kdev->dev, "channel %d is not in DMA %s\n",
 				chan_num, instance);
-		return (void *)-EINVAL;
+		return NULL;
 	}
 
 	if (atomic_read(&chan->ref_count) >= 1) {
 		if (!check_config(chan, config)) {
 			dev_err(kdev->dev, "channel %d config miss-match\n",
 				chan_num);
-			return (void *)-EINVAL;
+			return NULL;
 		}
 	}
 
-- 
2.51.0



