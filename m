Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5D318EE1;
	Thu, 12 Mar 2026 20:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347206; cv=none; b=THnzUipVQnBblRRYfcTBSG9sYS+avcaIPDhNvV/WB1/CuvBAqOIOQUKge3tNHPFDjV+OyFSz7voHLsiNkC/HQxZGrIwy7MBEyZtbOx7iZ1KR8s2t23MoXE+bRclbCRxb/6M7cnfn90vL4KV7LcWItRCD+MNngrqwBtj6qtRxPvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347206; c=relaxed/simple;
	bh=ZYXJmERd6s/xglaU3h9rTUTc6BjJoaOr/lLNoaMeLgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBA4YDSkabo8AnD9kiCPjD/HEQp/IQZeNThARqVto7Ts16R/J9gm9WeZPMS7WesmOXQqk0NeTqgGfH5kTN6fed8rJriKekPyo8egHSz7HxiUrgWcza208g0yaljXhaEycni8+Zay5MomZ2q83jzo2O0F8Gw42AlH3LsIfb0kUP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URekbYC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URekbYC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136CAC4CEF7;
	Thu, 12 Mar 2026 20:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347206;
	bh=ZYXJmERd6s/xglaU3h9rTUTc6BjJoaOr/lLNoaMeLgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URekbYC5MQGjKpfoiVjOHD8ZkAwmx3kXPnUPA5mqZjxUcq8i872Wup87qpQSVFI0+
	 EsojfTldUacCFJ4gWJOcBLSJjVd9TYuA1zSkmc+Zhztx3tS3R7ExGn8YtYGDdHk9T5
	 kcecbOz/nVNpXjw7f0c4qxopDWcwSC/h/Wk9Q6js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/265] net: stmmac: Fix error handling in VLAN add and delete paths
Date: Thu, 12 Mar 2026 21:10:20 +0100
Message-ID: <20260312201026.746241120@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 35dfedce442c4060cfe5b98368bc9643fb995716 ]

stmmac_vlan_rx_add_vid() updates active_vlans and the VLAN hash
register before writing the HW filter entry. If the filter write
fails, it leaves a stale VID in active_vlans and the hash register.

stmmac_vlan_rx_kill_vid() has the reverse problem: it clears
active_vlans before removing the HW filter. On failure, the VID is
gone from active_vlans but still present in the HW filter table.

To fix this, reorder the operations to update the hash table first,
then attempt the HW filter operation. If the HW filter fails, roll
back both the active_vlans bitmap and the hash table by calling
stmmac_vlan_update() again.

Fixes: ed64639bc1e0 ("net: stmmac: Add support for VLAN Rx filtering")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Link: https://patch.msgid.link/20260303145828.7845-2-ovidiu.panait.rb@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c  | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 112287a6e9ab9..396216633149d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6679,9 +6679,13 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 
 	if (priv->hw->num_vlan) {
 		ret = stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
-		if (ret)
+		if (ret) {
+			clear_bit(vid, priv->active_vlans);
+			stmmac_vlan_update(priv, is_double);
 			goto err_pm_put;
+		}
 	}
+
 err_pm_put:
 	pm_runtime_put(priv->device);
 
@@ -6702,15 +6706,21 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 		is_double = true;
 
 	clear_bit(vid, priv->active_vlans);
+	ret = stmmac_vlan_update(priv, is_double);
+	if (ret) {
+		set_bit(vid, priv->active_vlans);
+		goto del_vlan_error;
+	}
 
 	if (priv->hw->num_vlan) {
 		ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
-		if (ret)
+		if (ret) {
+			set_bit(vid, priv->active_vlans);
+			stmmac_vlan_update(priv, is_double);
 			goto del_vlan_error;
+		}
 	}
 
-	ret = stmmac_vlan_update(priv, is_double);
-
 del_vlan_error:
 	pm_runtime_put(priv->device);
 
-- 
2.51.0



