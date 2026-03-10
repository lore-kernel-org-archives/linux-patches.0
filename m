Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B722138945D;
	Tue, 10 Mar 2026 11:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142198; cv=none; b=ZgomOp30ZJCZSGzY6zpudzgitPb6+hI2zSlw5A2aOFHyJDX7lyjJzTlPC+HMtfny1lEcoTlZMIrp1ViyhJrdxps3Tr4xwnsV7z+pGyMp83ODqwoWXmVTbX/X2GMr386PFHzzdzOTEHimfnDxoOl6qfwyE4lpuBmLDbPqRjb9+D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142198; c=relaxed/simple;
	bh=InmajOgTM5YoLk5tdJRzfVtSZZOkNHe3zmSY4glK8W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFslg5uPsQS7EKGbwOOKEPN3/9SeY8m1yLYGdobhv1Et85nErZTQyTflJVPgXOqtPGUEQXCAyKDX5c36tHDJtxxTB2y3foA+USegTfL9qvWEzRcuF8ZRSIoXJ2+1TIKW0fNNbJVDhMmW82BGy2QmiJ/DnwPFq1uBY+gWW9UfBzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNM0q/5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNM0q/5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0DFC2BC86;
	Tue, 10 Mar 2026 11:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142198;
	bh=InmajOgTM5YoLk5tdJRzfVtSZZOkNHe3zmSY4glK8W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNM0q/5gzMbn4Ri/EL7iR5jt9ZAjtYPHvJz1yQJj5AcGoSgAS1WmjNdUiaEoSTpnT
	 T6pIn4WK24lrc38tIm0WFWJZXvZlaj0vq13wEaMYvbb0rps56GT63nw82o+o77aAl9
	 GSDcaUi1udwAhxFLG9j/Z5GyQR5kZX9lg6K5Wkl7IzKmXu0iQsxsrWZdse7E8t2rX2
	 hIk8wz3+BnDq++iax4R/XEirx95fkD9KJlIaJ4LncCyEhKENf3/4D/CSbsNku805Lt
	 wlAvSUiyc6np3Uz8Qiud+g++kjRwnIGro+cgfqr7czQ+DWY96VU/WuD1B1Wq7gZnr1
	 ST6V20e58r3+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/314] net: stmmac: Fix error handling in VLAN add and delete paths
Date: Tue, 10 Mar 2026 07:19:07 -0400
Message-ID: <d82af85a04499e33b70ff682c95876833e7762e1.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 754b36e733eb5..85f436dff4629 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6603,9 +6603,13 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 
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
 
@@ -6629,15 +6633,21 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
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

