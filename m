Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68648248F73;
	Tue, 10 Mar 2026 11:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141279; cv=none; b=oyxxIgIoGC+kWw9YImwPfvmjGlWhLKohSD0rnh0A1ROhgzHYGVLMtyYGd7k8PUhX2afgwQdqUf9jKtm51Jo0h6taNqm4etXoJchexm5BeF79jnenF1M7rGOrnmM5OKdjpZUCv3mSLzzr3lbAJuimQ30FNGCm6/12j5k3hjXEVMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141279; c=relaxed/simple;
	bh=L3FVxrXpuSXPInUiAQsvyhIc2Mg7aOKJ5KzTjPDoing=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghItjPXKaFgdjpd7a/mKG7ycvOXPxgQu2NdBXYv+J9YLwBTwgpvomPt7N0qGEJOP2P++B0R+2WQ7hs/JoBiwzGBEA+bsgTe0f5a6QuyNJpBkJgVCxUJPtBGsx9HeuWajcx+rjqEXY78tBt0/fL6eQ10cWb0yEwNL3oGl0e4OkOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjmf+B6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjmf+B6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3060C2BC86;
	Tue, 10 Mar 2026 11:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141279;
	bh=L3FVxrXpuSXPInUiAQsvyhIc2Mg7aOKJ5KzTjPDoing=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjmf+B6zgnj3oSDocRceQjS4hCar9eiJGAPKH5S/KJ/bTlppxJ07347dEBQSEJzZR
	 ubaCRdjChSg/B3KEhHDMzlSb6v8wjFT+1gg3VfvdF/Id+ES/qetN8Neushh1YYVfwm
	 ijmqdZoXGewXiE6UAuKHsDnE96ZJjKbWrKa05GJNvPC/yyQ3K8wFqpU4dzZSe/vCAd
	 T6Vdbv8nWc5B0Yksxt7QaEuCC5zv55rGUlY83B73VnupEUjmEALIQxT3bQ+DMDa5Ki
	 8zfFMKK3YkrjZF7wfWWooNTfkXAOGOsoQcJjJ6cp3YjUUgigYRIyWuHbntnGdlxnTj
	 mnxodG6aBRv6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 282/311] net: stmmac: Fix error handling in VLAN add and delete paths
Date: Tue, 10 Mar 2026 07:05:29 -0400
Message-ID: <a4406c417e5da3bf26b133a55597c217ad8df796.1773140655.git.sashal@kernel.org>
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
index e9493c0c27b87..f8e4d436f2967 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6746,9 +6746,13 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 
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
 
@@ -6772,15 +6776,21 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
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

