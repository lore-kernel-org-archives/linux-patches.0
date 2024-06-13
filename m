Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9D7144D1D;
	Thu, 13 Jun 2024 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279938; cv=none; b=f0OxdJClLiwE2hUYV0QlyeedWoISK+yStocR02ZtYRZvHRALm49HokIRKrHfRHSCYCx05s6j6r8kDVsvQx44n3JZA8hs20FUT3PQDCSVI5X7ko4i6ftErbjGfbrqPQvFhhv2qA+VDA1y1OWCcSgebXK7RIz/GBu4nZKwIs99vqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279938; c=relaxed/simple;
	bh=G5JRnDo4c5C6jpv4uoSKetJku5sc7ZykxUD/LCZk4VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TACtIN2u/8r75V1mkGQCdSHKjMpWD+mtPYHvu8YHwOOWCKkr1eARjR9RR+sj0KbnxgPJDvFVIMYHgFCC6nXbbM0EkycjjytfO/VkFJVy7KKjzhdPdXy1xpkDrcqlOuQpkOIJJ9F4IRF+YzXFmMJZdMuqfRQx5IW1o0nUuDoKRTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiFdImoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiFdImoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2583DC2BBFC;
	Thu, 13 Jun 2024 11:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279938;
	bh=G5JRnDo4c5C6jpv4uoSKetJku5sc7ZykxUD/LCZk4VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiFdImoBvnbIjaLUbboJTbtyRHZHG8ed2nl0Q1Jjff8C9k4AGCl+Iqb5UNqGSEHD8
	 VlxHSQi43ou05jmRh8gkU6dgPALh6e/ZHCIG5wuJ5ZfAw5sqtoSKq8lSvuBWDZTZ1k
	 z6tn4HKA+pIoUexxXKncmgeqPxEz5IlEWSDydLK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/202] wifi: mwl8k: initialize cmd->addr[] properly
Date: Thu, 13 Jun 2024 13:32:34 +0200
Message-ID: <20240613113229.940192950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 14ac2384218df..abd5c8670bc44 100644
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



