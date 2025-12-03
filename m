Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D60B34886B;
	Wed,  3 Dec 2025 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778344; cv=none; b=enRlJXNW/RIGDxQFH6v6DdZBOA5tD49UFk791QfFONBBkOfchmTzEj2yEn2eDZ278uJSCwCpBQajj3CF5c8AXqXraevELN6SmwGTpm3uYFslugfw4O+jPRZ/cIkNnIzLgo8mHmXsfFRm1r9Pahr3wxgAeohci7R8gT93oqjElII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778344; c=relaxed/simple;
	bh=TEEZHnokrUlQ521NaY21TpF7iF+wH5rih/zP2flAgFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/DKhoCrXbftAQihmfGsDTntyu3Cu5FqVIHdjB2Eridw5JITmXsnWDt3t+A5giWiRXghdAKk6oJQ1NB+9gs2d86J1xHcWhT0rR07d7gE0BPgGOdvU0M1pu5ExwrjDIpc/2eFOdeh9UTI4gEpv/Gl7T3H6HfPddtTM4WKVH9r0QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PArWnL6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PArWnL6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A83C4CEF5;
	Wed,  3 Dec 2025 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778344;
	bh=TEEZHnokrUlQ521NaY21TpF7iF+wH5rih/zP2flAgFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PArWnL6D/xlAN9/RQuWggx2xy8Ej6GQZrjggY+yL7wrN4hdfkR7ZLdI3YJiHHqVH2
	 Xj+9ZUPISvmULmlpvZ62xHakQ7FocNu8zQMCbrtbgNxIFmDN3mQI7WXMbEyRPCmEIc
	 nOHS6H51kAgYsxD51Jj0SvaoO/7Y2fbDe+pjQoGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Nishanth Menon <nm@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 310/392] net: ethernet: ti: netcp: Standardize knav_dma_open_channel to return NULL on error
Date: Wed,  3 Dec 2025 16:27:40 +0100
Message-ID: <20251203152425.568962413@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2f00be789a8a9..08c6cb16532e5 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1338,10 +1338,10 @@ int netcp_txpipe_open(struct netcp_tx_pipe *tx_pipe)
 
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
 
@@ -1359,7 +1359,7 @@ int netcp_txpipe_open(struct netcp_tx_pipe *tx_pipe)
 	return 0;
 
 err:
-	if (!IS_ERR_OR_NULL(tx_pipe->dma_channel))
+	if (tx_pipe->dma_channel)
 		knav_dma_close_channel(tx_pipe->dma_channel);
 	tx_pipe->dma_channel = NULL;
 	return ret;
@@ -1678,10 +1678,10 @@ static int netcp_setup_navigator_resources(struct net_device *ndev)
 
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
index 591d14ebcb112..bbde54b2ce62d 100644
--- a/drivers/soc/ti/knav_dma.c
+++ b/drivers/soc/ti/knav_dma.c
@@ -410,7 +410,7 @@ static int of_channel_match_helper(struct device_node *np, const char *name,
  * @name:	slave channel name
  * @config:	dma configuration parameters
  *
- * Returns pointer to appropriate DMA channel on success or error.
+ * Return: Pointer to appropriate DMA channel on success or NULL on error.
  */
 void *knav_dma_open_channel(struct device *dev, const char *name,
 					struct knav_dma_cfg *config)
@@ -423,13 +423,13 @@ void *knav_dma_open_channel(struct device *dev, const char *name,
 
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
@@ -440,7 +440,7 @@ void *knav_dma_open_channel(struct device *dev, const char *name,
 	if (config->direction != DMA_MEM_TO_DEV &&
 	    config->direction != DMA_DEV_TO_MEM) {
 		dev_err(kdev->dev, "bad direction\n");
-		return (void *)-EINVAL;
+		return NULL;
 	}
 
 	/* Look for correct dma instance */
@@ -452,7 +452,7 @@ void *knav_dma_open_channel(struct device *dev, const char *name,
 	}
 	if (!found) {
 		dev_err(kdev->dev, "No DMA instance with name %s\n", instance);
-		return (void *)-EINVAL;
+		return NULL;
 	}
 
 	/* Look for correct dma channel from dma instance */
@@ -473,14 +473,14 @@ void *knav_dma_open_channel(struct device *dev, const char *name,
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



