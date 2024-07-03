Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D811799F;
	Wed,  3 Jul 2024 11:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005277; cv=none; b=Q/EMIsJbAz9abPfzuOSH0cbpX+A+qqS11MSq1eRtih3BOnrcxnCw7ok9o+k33Z49xEzlo+QvgWhJexN+aveOFIvSYCodcSU7XAIAiUu+KF1NzyhMvqhWQZgAUovX1BcxyBD4LzvnhazscDJehwjASF0ltVnLag994VKvb5WBLRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005277; c=relaxed/simple;
	bh=LrmmULH8uPZkKoqI5TtzB5OMBXIdabW9ApGcQIxDcyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNR3huAJUhOP3DubNoa1i8qrq3PLMNd5XJwrUWQaWVn1VhWvYpo6LrGeyGlGEPFoNp5EFd2h9KfcpITZJTv3Eb8USew4ylZzyIOq7rylXSrYLZFn0XsYfdVpKGGris9DOncSlCkQ12tTLTxn2uwDGKKcK3Vf0VQGAtGkmAARiL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qViAc6UL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qViAc6UL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF3CC2BD10;
	Wed,  3 Jul 2024 11:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005277;
	bh=LrmmULH8uPZkKoqI5TtzB5OMBXIdabW9ApGcQIxDcyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qViAc6ULqsQzVbPsftp7eedwGoav3uaZz1BksMCCmJxoubYjwcxK1D5A8fuhttgXA
	 NgDCLEyDvWvodDUo8OPZS1Ikq36DQ2S9N857r9JuyAFEhDPET+TXnMuzAO5Ji/h9jz
	 nzhlSt16mB1NfMXXWEOSMEpxrzK3OCal8Ni++yY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Delevoryas <peter@pjd.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/356] net/ncsi: Simplify Kconfig/dts control flow
Date: Wed,  3 Jul 2024 12:35:46 +0200
Message-ID: <20240703102913.490428039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index 7121ce2a47c0b..734feb2352fbc 100644
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
@@ -856,8 +850,6 @@ static int ncsi_gma_handler(struct ncsi_cmd_arg *nca, unsigned int mf_id)
 	return nch->handler(nca);
 }
 
-#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
-
 /* Determine if a given channel from the channel_queue should be used for Tx */
 static bool ncsi_channel_is_tx(struct ncsi_dev_priv *ndp,
 			       struct ncsi_channel *nc)
@@ -1039,20 +1031,18 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
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
 
@@ -1404,7 +1394,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		schedule_work(&ndp->work);
 		break;
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
 	case ncsi_dev_state_probe_mlx_gma:
 		ndp->pending_req_num = 1;
 
@@ -1429,7 +1418,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		nd->state = ncsi_dev_state_probe_cis;
 		break;
-#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
 	case ncsi_dev_state_probe_cis:
 		ndp->pending_req_num = NCSI_RESERVED_CHANNEL;
 
@@ -1447,7 +1435,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
 			nd->state = ncsi_dev_state_probe_keep_phy;
 		break;
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
 	case ncsi_dev_state_probe_keep_phy:
 		ndp->pending_req_num = 1;
 
@@ -1460,7 +1447,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		nd->state = ncsi_dev_state_probe_gvi;
 		break;
-#endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
 	case ncsi_dev_state_probe_gvi:
 	case ncsi_dev_state_probe_gc:
 	case ncsi_dev_state_probe_gls:
-- 
2.43.0



