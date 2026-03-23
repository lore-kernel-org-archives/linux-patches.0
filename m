Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EAD241C8C;
	Mon, 23 Mar 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278013; cv=none; b=tzBBeW4SPueb2cRk/XXt1pzDzUTCd3nqxXvSMYD8MciEQp2++pRjgj158uKQ7ae6DHzL8IfIheJ3TkoseOp37bNs30yqiWMiaR58qrkqOMx0Q+92wVud88G1HnJgrVRFEI/eW4bmsgCX1p20UP1gtiRxwzEmwevUxyuDUXvJCKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278013; c=relaxed/simple;
	bh=+uDTEb8dh4AxPYSWLRlbRCZlV2G/ZlBtJCB0woJOOMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2ChvvwajwPgfLfRVc6lbO1bTJBkSahFjSR3JwhQlUHyRDkKKTZgbBbO3yGHlexDEIIGMoMtwof0KK08gucUuNqPUqTeXpYFxl8lnDyXOmbW5lJf9WK0whH6E6ocN8l62wct/V5OaKzYL1sUZxOjusCGbHh//WOJPehZ9ukDpc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGjAlhVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGjAlhVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B409DC4CEF7;
	Mon, 23 Mar 2026 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278013;
	bh=+uDTEb8dh4AxPYSWLRlbRCZlV2G/ZlBtJCB0woJOOMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGjAlhVaTnZTlh6Q1ljZtaMhnKz3Mb1DWLgTBXth9zXBkJcEE4//MB5yDBKDD8kZo
	 yYUN8SRaxFzAl5f43DnuhBQyWGf0VfkeGn61eIX5YAyC1kUYbf2Ua0WdAqK0emgFgX
	 1UpkZlYyW5gj/yx1DYVrazRatkTKkuJoweBnXWHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/567] net: stmmac: Fix error handling in VLAN add and delete paths
Date: Mon, 23 Mar 2026 14:41:32 +0100
Message-ID: <20260323134538.088827409@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a8861d77e047..42df435c4d838 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6549,9 +6549,13 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 
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
 
@@ -6572,15 +6576,21 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
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



