Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3564B5381A;
	Tue, 10 Sep 2024 10:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963732; cv=none; b=W4iA4aVQS7r1YIH9U1+aqqRQwyiMvOz0aeVjm/0jdsBKK9mZn9MDitD+BArB7W3EK+R/crKcTyZG4hTOk4+hJK/li7aqugZpUe52hQGcwPx5MGLaMPf8pzhAC5I2c9U39ZvTvnYFi82cO4IpqyiZfdJb1JtWpWouRh5GE5oKhE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963732; c=relaxed/simple;
	bh=1HQDiKvdedAeB7zXWL/uYWdmGOjwfp4FaOe4VHsbe28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkwV+Y+4d6dc6mNH4n3tizummVQU//tcsGawsoEoeiLY+E+SwsOMOLe+QCxFdg7zDWEJiEhf+c+1DDYcUND1XvnJBnFmykeapjhAszZyqNsVmAWoMQO0geArK+qvM93XihRHVyYOoEduBvpFgMSPPfV06cjk913kkfi2yPExnjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuSFnC3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuSFnC3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE869C4CEC3;
	Tue, 10 Sep 2024 10:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963732;
	bh=1HQDiKvdedAeB7zXWL/uYWdmGOjwfp4FaOe4VHsbe28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuSFnC3Gf/T5SJXI9ixIKPXbORDZK9Ac3TvAIy8kzt53lChEYqwzWy5MNAuCdzpEs
	 g3Et0BrxY4KjPJQOyYWaYGgYwiT9NaF5+P3a96H2+Jh32E+XTwqyLthzJ7/oFDHUmm
	 jBqCEGkb1UiwWkW8oXaPG9XOiUEC9kCWQ9Xeq86g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Breno Leitao <leitao@debian.org>,
	Madalin Bucur <madalin.bucur@oss.nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/214] net: dpaa: avoid on-stack arrays of NR_CPUS elements
Date: Tue, 10 Sep 2024 11:33:00 +0200
Message-ID: <20240910092605.175785435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 555a05d84ca2c587e2d4777006e2c2fb3dfbd91d ]

The dpaa-eth driver is written for PowerPC and Arm SoCs which have 1-24
CPUs. It depends on CONFIG_NR_CPUS having a reasonably small value in
Kconfig. Otherwise, there are 2 functions which allocate on-stack arrays
of NR_CPUS elements, and these can quickly explode in size, leading to
warnings such as:

  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:3280:12: warning:
  stack frame size (16664) exceeds limit (2048) in 'dpaa_eth_probe' [-Wframe-larger-than]

The problem is twofold:
- Reducing the array size to the boot-time num_possible_cpus() (rather
  than the compile-time NR_CPUS) creates a variable-length array,
  which should be avoided in the Linux kernel.
- Using NR_CPUS as an array size makes the driver blow up in stack
  consumption with generic, as opposed to hand-crafted, .config files.

A simple solution is to use dynamic allocation for num_possible_cpus()
elements (aka a small number determined at runtime).

Link: https://lore.kernel.org/all/202406261920.l5pzM1rj-lkp@intel.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Link: https://patch.msgid.link/20240713225336.1746343-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 20 ++++++++++++++-----
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    | 10 +++++++++-
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 1766b7d94ffa..119f560b2e65 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -910,14 +910,18 @@ static inline void dpaa_setup_egress(const struct dpaa_priv *priv,
 	}
 }
 
-static void dpaa_fq_setup(struct dpaa_priv *priv,
-			  const struct dpaa_fq_cbs *fq_cbs,
-			  struct fman_port *tx_port)
+static int dpaa_fq_setup(struct dpaa_priv *priv,
+			 const struct dpaa_fq_cbs *fq_cbs,
+			 struct fman_port *tx_port)
 {
 	int egress_cnt = 0, conf_cnt = 0, num_portals = 0, portal_cnt = 0, cpu;
 	const cpumask_t *affine_cpus = qman_affine_cpus();
-	u16 channels[NR_CPUS];
 	struct dpaa_fq *fq;
+	u16 *channels;
+
+	channels = kcalloc(num_possible_cpus(), sizeof(u16), GFP_KERNEL);
+	if (!channels)
+		return -ENOMEM;
 
 	for_each_cpu_and(cpu, affine_cpus, cpu_online_mask)
 		channels[num_portals++] = qman_affine_channel(cpu);
@@ -976,6 +980,10 @@ static void dpaa_fq_setup(struct dpaa_priv *priv,
 				break;
 		}
 	}
+
+	kfree(channels);
+
+	return 0;
 }
 
 static inline int dpaa_tx_fq_to_id(const struct dpaa_priv *priv,
@@ -3444,7 +3452,9 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	 */
 	dpaa_eth_add_channel(priv->channel, &pdev->dev);
 
-	dpaa_fq_setup(priv, &dpaa_fq_cbs, priv->mac_dev->port[TX]);
+	err = dpaa_fq_setup(priv, &dpaa_fq_cbs, priv->mac_dev->port[TX]);
+	if (err)
+		goto free_dpaa_bps;
 
 	/* Create a congestion group for this netdev, with
 	 * dynamically-allocated CGR ID.
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 5750f9a56393..df6af1097dd2 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -541,12 +541,16 @@ static int dpaa_set_coalesce(struct net_device *dev,
 			     struct netlink_ext_ack *extack)
 {
 	const cpumask_t *cpus = qman_affine_cpus();
-	bool needs_revert[NR_CPUS] = {false};
 	struct qman_portal *portal;
 	u32 period, prev_period;
 	u8 thresh, prev_thresh;
+	bool *needs_revert;
 	int cpu, res;
 
+	needs_revert = kcalloc(num_possible_cpus(), sizeof(bool), GFP_KERNEL);
+	if (!needs_revert)
+		return -ENOMEM;
+
 	period = c->rx_coalesce_usecs;
 	thresh = c->rx_max_coalesced_frames;
 
@@ -569,6 +573,8 @@ static int dpaa_set_coalesce(struct net_device *dev,
 		needs_revert[cpu] = true;
 	}
 
+	kfree(needs_revert);
+
 	return 0;
 
 revert_values:
@@ -582,6 +588,8 @@ static int dpaa_set_coalesce(struct net_device *dev,
 		qman_dqrr_set_ithresh(portal, prev_thresh);
 	}
 
+	kfree(needs_revert);
+
 	return res;
 }
 
-- 
2.43.0



