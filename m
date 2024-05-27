Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63DE262BE;
	Mon, 27 May 2024 19:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838167; cv=none; b=DUiw7GJGSTGfAAQWY5K9ULtqK+H/e3BeC5xueOqfICh8ZAUeEXro+e3mnVbo9dv1WBPlHsyjyz+lsfxFC/nBJV8FW01qgDHWnIR387L0tPnfUXzsSpCJcLJctguGXpzD/kCvCqkBK7cpSlxws5NU37ihJgPVyfHu6fcY9emt9z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838167; c=relaxed/simple;
	bh=dG4Of5iXkjIBhC/sipDeqIngb1kp0EoHNTcQbS/+1gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uw2SIYLGHdmOUAnX3wJxfNpMXCor5AnPfJu5rYSFGwmanDMRSBas5JcyZElwo0U9IgsV7322xAyl1NJYdS3U6PRfn2XUR7/yJyL7qnG8pNy8y6VlOeikpImuKf7S/+4o198MJXCzNVDEHiHOlmO5Q08STZPCW6jUpzpFlumk/GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CL+ynlHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CL+ynlHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4EAC2BBFC;
	Mon, 27 May 2024 19:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838167;
	bh=dG4Of5iXkjIBhC/sipDeqIngb1kp0EoHNTcQbS/+1gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CL+ynlHGMm0hcQzYJMKIc81jKzCv/6LSmItioa7Ltq6Eh/Rh2K+FHNKgNB7BA8dSF
	 EMP6Xl0uF/CeZCKP9dP7Fa+mhBeGW4AoaDG49wZLfAZisQNGEunILdDZuzeTbRZgCo
	 v+wCWHu8gddLtPS/gLf3J6T327+HCx06MFU6wuYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 291/493] wifi: mwl8k: initialize cmd->addr[] properly
Date: Mon, 27 May 2024 20:54:53 +0200
Message-ID: <20240527185639.827080490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 13bcb123d1223..c0ecd769ada76 100644
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



