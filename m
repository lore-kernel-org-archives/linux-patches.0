Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A80142903;
	Thu, 13 Jun 2024 12:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280906; cv=none; b=igxpMZ7tckg6DDvadRz9u6IqAJYVGzbAhyGoTEp5MdHOEn36sOQvXeP6EDOL4dMPpj3gCYd3WCK94J5UOqyZtuzRPR6pIt1sCSyqHF7ZpS16Jb+66iqy2BNyFVeh3/zZhwlLzkWeGgpzJ8U3jNFHTXG+XYTplyL8XDdGcMj6h/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280906; c=relaxed/simple;
	bh=4BcUyJcXxljmL5GQDf4hTxz8N7478euSbZibA/xHP8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQJrFH64yWHCTScCXw3i1mi6IXMLiNOceoddvVzq30cK/C4/3MrBqG6IXcwSaXtyVvY8oLtjEAkIKR3ypaNZ4WXiNNeARQbrRQqNukTcGJbuZ4rlQjJN7W3i1fG+PwwUVWO+9ThmEdCZyNDDw2hhPHYD0SlprjPpaIW5GZ+Q9AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkiFKOWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkiFKOWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA19C2BBFC;
	Thu, 13 Jun 2024 12:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280906;
	bh=4BcUyJcXxljmL5GQDf4hTxz8N7478euSbZibA/xHP8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkiFKOWiyYt+HqLJ34yBPQUxDUapEwYcSGnY8BsY8k2LGR1F9Z8lQ7V6tOUDv5+MY
	 rMMOl+N2WeAMZnzvvn7d3JGXTzvgTO61kffD4Q4socrTiBakIXh8RNCUcVKoZ3d2J9
	 +UEMWkeYeTyuHiRH7WE/CvR9MgYAj60/YhWhgnwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/317] wifi: mwl8k: initialize cmd->addr[] properly
Date: Thu, 13 Jun 2024 13:31:33 +0200
Message-ID: <20240613113250.449353840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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
index dc91ac8cbd48b..dd72e9f8b4079 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -2714,7 +2714,7 @@ __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
 		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
 		cmd->numaddr = cpu_to_le16(mc_count);
 		netdev_hw_addr_list_for_each(ha, mc_list) {
-			memcpy(cmd->addr[i], ha->addr, ETH_ALEN);
+			memcpy(cmd->addr[i++], ha->addr, ETH_ALEN);
 		}
 	}
 
-- 
2.43.0



