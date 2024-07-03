Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6996F194A6F;
	Wed,  3 Jul 2024 10:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004342; cv=none; b=On2dRKHsZCJyRLCiVrT3y1cUuq7A87avibw2lmlXs2NibZOOV7wA7RRopJZf3OAyXyQ60hzCKqiTzxfDLjEKw1t6J3ZhYwPxd0fg8jtWe0P6q7h/EZOXoEYr3agNz3am748iGQ+tec1/hV8oj5VgqkMZzPO8VWBjuNMxyQONt1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004342; c=relaxed/simple;
	bh=n76BBZwRAF9+6EarIUOx0T58/fy0g68xH0F68EQRlVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ap6tW1tV7muTI8ISW1OQBVJUeFNI/PfI6QRCB+x9sBf3r4FcuULmHe9x1Zj94gIyLgWt34FomoI4tL1lkz5oEZosjkV8gDft4gqgT8mrEupxnJ6cAMKn9DXDmzjhIvjCYN2iKGGdFdNhB0FFeNmlsivjB8EBJUc0OlLrKJI2130=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itFK/98N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itFK/98N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3809C32781;
	Wed,  3 Jul 2024 10:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004342;
	bh=n76BBZwRAF9+6EarIUOx0T58/fy0g68xH0F68EQRlVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itFK/98NZNN3rqzKPDC6xIJYVFUwSIwAgjw9BzjcjOodc2c+cDihTbGKghuAtDBEM
	 LS1zL4UQAzklVA8t6pyu3HXFnnff8JDM1PGhXzRZYVTISXUP/vJreQkBJp2lBnjURC
	 AQmtu3xwbUxipxmIXWZ1XiLAhSUu/y/1t2MRnpl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Mikhaylov <i.mikhaylov@yadro.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/290] net/ncsi: add NCSI Intel OEM command to keep PHY up
Date: Wed,  3 Jul 2024 12:36:32 +0200
Message-ID: <20240703102904.613394176@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Ivan Mikhaylov <i.mikhaylov@yadro.com>

[ Upstream commit abd2fddc94a619b96bf41c60429d4c32bd118e17 ]

This allows to keep PHY link up and prevents any channel resets during
the host load.

It is KEEP_PHY_LINK_UP option(Veto bit) in i210 datasheet which
block PHY reset and power state changes.

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e85e271dec02 ("net/ncsi: Fix the multi thread manner of NCSI driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/Kconfig       |  6 ++++++
 net/ncsi/internal.h    |  5 +++++
 net/ncsi/ncsi-manage.c | 45 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/net/ncsi/Kconfig b/net/ncsi/Kconfig
index 93309081f5a40..ea1dd32b6b1f6 100644
--- a/net/ncsi/Kconfig
+++ b/net/ncsi/Kconfig
@@ -17,3 +17,9 @@ config NCSI_OEM_CMD_GET_MAC
 	help
 	  This allows to get MAC address from NCSI firmware and set them back to
 		controller.
+config NCSI_OEM_CMD_KEEP_PHY
+	bool "Keep PHY Link up"
+	depends on NET_NCSI
+	help
+	  This allows to keep PHY link up and prevents any channel resets during
+	  the host load.
diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index ec765f2a75691..1e3e587d04d39 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -78,6 +78,9 @@ enum {
 /* OEM Vendor Manufacture ID */
 #define NCSI_OEM_MFR_MLX_ID             0x8119
 #define NCSI_OEM_MFR_BCM_ID             0x113d
+#define NCSI_OEM_MFR_INTEL_ID           0x157
+/* Intel specific OEM command */
+#define NCSI_OEM_INTEL_CMD_KEEP_PHY     0x20   /* CMD ID for Keep PHY up */
 /* Broadcom specific OEM Command */
 #define NCSI_OEM_BCM_CMD_GMA            0x01   /* CMD ID for Get MAC */
 /* Mellanox specific OEM Command */
@@ -86,6 +89,7 @@ enum {
 #define NCSI_OEM_MLX_CMD_SMAF           0x01   /* CMD ID for Set MC Affinity */
 #define NCSI_OEM_MLX_CMD_SMAF_PARAM     0x07   /* Parameter for SMAF         */
 /* OEM Command payload lengths*/
+#define NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN 7
 #define NCSI_OEM_BCM_CMD_GMA_LEN        12
 #define NCSI_OEM_MLX_CMD_GMA_LEN        8
 #define NCSI_OEM_MLX_CMD_SMAF_LEN        60
@@ -274,6 +278,7 @@ enum {
 	ncsi_dev_state_probe_mlx_gma,
 	ncsi_dev_state_probe_mlx_smaf,
 	ncsi_dev_state_probe_cis,
+	ncsi_dev_state_probe_keep_phy,
 	ncsi_dev_state_probe_gvi,
 	ncsi_dev_state_probe_gc,
 	ncsi_dev_state_probe_gls,
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index ffff8da707b8c..06ad7db553fb5 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -689,6 +689,35 @@ static int set_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
+
+static int ncsi_oem_keep_phy_intel(struct ncsi_cmd_arg *nca)
+{
+	unsigned char data[NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN];
+	int ret = 0;
+
+	nca->payload = NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN;
+
+	memset(data, 0, NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN);
+	*(unsigned int *)data = ntohl((__force __be32)NCSI_OEM_MFR_INTEL_ID);
+
+	data[4] = NCSI_OEM_INTEL_CMD_KEEP_PHY;
+
+	/* PHY Link up attribute */
+	data[6] = 0x1;
+
+	nca->data = data;
+
+	ret = ncsi_xmit_cmd(nca);
+	if (ret)
+		netdev_err(nca->ndp->ndev.dev,
+			   "NCSI: Failed to transmit cmd 0x%x during configure\n",
+			   nca->type);
+	return ret;
+}
+
+#endif
+
 #if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
 
 /* NCSI OEM Command APIs */
@@ -1391,8 +1420,24 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 				goto error;
 		}
 
+		nd->state = ncsi_dev_state_probe_gvi;
+		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
+			nd->state = ncsi_dev_state_probe_keep_phy;
+		break;
+#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
+	case ncsi_dev_state_probe_keep_phy:
+		ndp->pending_req_num = 1;
+
+		nca.type = NCSI_PKT_CMD_OEM;
+		nca.package = ndp->active_package->id;
+		nca.channel = 0;
+		ret = ncsi_oem_keep_phy_intel(&nca);
+		if (ret)
+			goto error;
+
 		nd->state = ncsi_dev_state_probe_gvi;
 		break;
+#endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
 	case ncsi_dev_state_probe_gvi:
 	case ncsi_dev_state_probe_gc:
 	case ncsi_dev_state_probe_gls:
-- 
2.43.0



