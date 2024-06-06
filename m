Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6A41ABCBC;
	Thu,  6 Jun 2024 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683285; cv=none; b=DbBCdC7nZobXUhaOAgcynDYTWkLFIkG+7azkw9rBDBjMnh4SR1WjBU69/dglw5B6jC9D60xVINW36z902QO17GNTJbLDfeTlggIJTZHq0t/8BWoDw1xMoHOGpUV7udAOXhToDw53S38blEjg1HFqVZaIi+xwht0JDPlwi1ENSYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683285; c=relaxed/simple;
	bh=JEPUPxdpC+TdoMAj7kukCCq07jjZAZmRBvwIzswE5pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrEb7g9+2yAvlOVOCvOBoOV2C/DgXWy6pqBMoNC6N66w+5N1KpvWHKaQgsOk+OiIbd2prEspkdsM0baMXcOLPc3x0N1ZfMoS2otztRqSBJLZj8sRlg+vFEoWXpwVvE3FtomEvyP5baNCut6vHkHQKi7xJLI31VRts10QEecI+sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olKNKQpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olKNKQpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CFDC32782;
	Thu,  6 Jun 2024 14:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683285;
	bh=JEPUPxdpC+TdoMAj7kukCCq07jjZAZmRBvwIzswE5pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olKNKQpgDccDHVoNA0U17Q2xVI7QhL5ejfrkChMddKA2oNPjOLTzdn67e6h852S6D
	 Bb2HIkGy9KZqjNLxrEWiSZht2/UIUsdcqjy5Da6XRQ/a1lrbwzvJi7a+MU21y8su6C
	 IpoYzy91uQg3yqKBUwejqZatYuwlECWEU/FXDHPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/473] wifi: mwl8k: initialize cmd->addr[] properly
Date: Thu,  6 Jun 2024 16:01:31 +0200
Message-ID: <20240606131705.301190816@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1d60eabb82694e58543e2b6366dae3e7465892a5 ]

This loop is supposed to copy the mac address to cmd->addr but the
i++ increment is missing so it copies everything to cmd->addr[0] and
only the last address is recorded.

Fixes: 22bedad3ce11 ("net: convert multicast list to list_head")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/b788be9a-15f5-4cca-a3fe-79df4c8ce7b2@moroto.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwl8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 4dc7e2e53b81e..61697dad4ea61 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -2718,7 +2718,7 @@ __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
 		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
 		cmd->numaddr = cpu_to_le16(mc_count);
 		netdev_hw_addr_list_for_each(ha, mc_list) {
-			memcpy(cmd->addr[i], ha->addr, ETH_ALEN);
+			memcpy(cmd->addr[i++], ha->addr, ETH_ALEN);
 		}
 	}
 
-- 
2.43.0



