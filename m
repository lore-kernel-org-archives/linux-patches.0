Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61339186E5A;
	Wed,  3 Jul 2024 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004345; cv=none; b=KAxPDDO/cbHcZCpQcFZt+mPdrS8ZBJ/6qUG2VpybDrWHw0Te1EvJPJt9blPxFNN/zhCKqfGLKfD3VuhbtLF3fh6G5Ig1ZEDq1SRxH45JHCGnzrP97uIxuoIgbbQq5TLOMDwsrXNez9nYZrsiD8nbciyUwaTsPiu7zy67DX7Sq64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004345; c=relaxed/simple;
	bh=uQZFbXnVRoiE9784+L/+4pbXqQCm0hz6LYPqaC/xuUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeaG2Afq0Os0Sa/UVI+NOjxVWHQ4ZTbQWyYyTTfEOw9Vvz2Z2wp6ARHPCLznMzWRAUrING8rjQKSru2PNB53r2AVhB1Eh+D0DUtRwyxKmLksYoqzTm/JqM+3zwd1HIldNXWN9cUDQ6R+ryso5wzOKg75AF7DKySCm/Tz6FxunnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnK+28kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnK+28kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8EEC2BD10;
	Wed,  3 Jul 2024 10:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004345;
	bh=uQZFbXnVRoiE9784+L/+4pbXqQCm0hz6LYPqaC/xuUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnK+28kvdNn8l/W7CLt9aSaPZ8F2DA/rxm1gRzMRRWu81b78voTIiwzHyRNeo3QRj
	 6EncdOGh1zXzT5umk2a6neJUmz8deToouHONm+/ylqyvgGCMTY2kQF12Or2ESc7prt
	 X4hByeGqO8HijEB/AweDpuXsdYdN67et36EeYKo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Delevoryas <peter@pjd.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/290] net/ncsi: Simplify Kconfig/dts control flow
Date: Wed,  3 Jul 2024 12:36:33 +0200
Message-ID: <20240703102904.650994469@linuxfoundation.org>
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

From: Peter Delevoryas <peter@pjd.dev>

[ Upstream commit c797ce168930ce3d62a9b7fc4d7040963ee6a01e ]

Background:

1. CONFIG_NCSI_OEM_CMD_KEEP_PHY

If this is enabled, we send an extra OEM Intel command in the probe
sequence immediately after discovering a channel (e.g. after "Clear
Initial State").

2. CONFIG_NCSI_OEM_CMD_GET_MAC

If this is enabled, we send one of 3 OEM "Get MAC Address" commands from
Broadcom, Mellanox (Nvidida), and Intel in the *configuration* sequence
for a channel.

3. mellanox,multi-host (or mlx,multi-host)

Introduced by this patch:

https://lore.kernel.org/all/20200108234341.2590674-1-vijaykhemka@fb.com/

Which was actually originally from cosmo.chou@quantatw.com:

https://github.com/facebook/openbmc-linux/commit/9f132a10ec48db84613519258cd8a317fb9c8f1b

Cosmo claimed that the Nvidia ConnectX-4 and ConnectX-6 NIC's don't
respond to Get Version ID, et. al in the probe sequence unless you send
the Set MC Affinity command first.

Problem Statement:

We've been using a combination of #ifdef code blocks and IS_ENABLED()
conditions to conditionally send these OEM commands.

It makes adding any new code around these commands hard to understand.

Solution:

In this patch, I just want to remove the conditionally compiled blocks
of code, and always use IS_ENABLED(...) to do dynamic control flow.

I don't think the small amount of code this adds to non-users of the OEM
Kconfigs is a big deal.

Signed-off-by: Peter Delevoryas <peter@pjd.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e85e271dec02 ("net/ncsi: Fix the multi thread manner of NCSI driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-manage.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 06ad7db553fb5..d2f8155af53e3 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -689,8 +689,6 @@ static int set_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
-
 static int ncsi_oem_keep_phy_intel(struct ncsi_cmd_arg *nca)
 {
 	unsigned char data[NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN];
@@ -716,10 +714,6 @@ static int ncsi_oem_keep_phy_intel(struct ncsi_cmd_arg *nca)
 	return ret;
 }
 
-#endif
-
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
-
 /* NCSI OEM Command APIs */
 static int ncsi_oem_gma_handler_bcm(struct ncsi_cmd_arg *nca)
 {
@@ -833,8 +827,6 @@ static int ncsi_gma_handler(struct ncsi_cmd_arg *nca, unsigned int mf_id)
 	return nch->handler(nca);
 }
 
-#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
-
 /* Determine if a given channel from the channel_queue should be used for Tx */
 static bool ncsi_channel_is_tx(struct ncsi_dev_priv *ndp,
 			       struct ncsi_channel *nc)
@@ -1016,20 +1008,18 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 			goto error;
 		}
 
-		nd->state = ncsi_dev_state_config_oem_gma;
+		nd->state = IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
+			  ? ncsi_dev_state_config_oem_gma
+			  : ncsi_dev_state_config_clear_vids;
 		break;
 	case ncsi_dev_state_config_oem_gma:
 		nd->state = ncsi_dev_state_config_clear_vids;
-		ret = -1;
 
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
 		nca.type = NCSI_PKT_CMD_OEM;
 		nca.package = np->id;
 		nca.channel = nc->id;
 		ndp->pending_req_num = 1;
 		ret = ncsi_gma_handler(&nca, nc->version.mf_id);
-#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
-
 		if (ret < 0)
 			schedule_work(&ndp->work);
 
@@ -1381,7 +1371,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		schedule_work(&ndp->work);
 		break;
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
 	case ncsi_dev_state_probe_mlx_gma:
 		ndp->pending_req_num = 1;
 
@@ -1406,7 +1395,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		nd->state = ncsi_dev_state_probe_cis;
 		break;
-#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
 	case ncsi_dev_state_probe_cis:
 		ndp->pending_req_num = NCSI_RESERVED_CHANNEL;
 
@@ -1424,7 +1412,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
 			nd->state = ncsi_dev_state_probe_keep_phy;
 		break;
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
 	case ncsi_dev_state_probe_keep_phy:
 		ndp->pending_req_num = 1;
 
@@ -1437,7 +1424,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		nd->state = ncsi_dev_state_probe_gvi;
 		break;
-#endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
 	case ncsi_dev_state_probe_gvi:
 	case ncsi_dev_state_probe_gc:
 	case ncsi_dev_state_probe_gls:
-- 
2.43.0



