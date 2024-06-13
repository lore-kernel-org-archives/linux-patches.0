Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4AD1448C4;
	Thu, 13 Jun 2024 11:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278833; cv=none; b=CjhXckakWEZJp74rwQeOrjZ0zLpoO5QRJaDzvfYnjsCjEXuq4ytEPvmPItrv8kdZptpSY/5sDQDWaos3rBS/vbKLE8iE4HDbHFx15/cAboOaj2c7YWxL8u4u7472cmbwqFxX6WaNoKThTfLVcPw3YCnwO1F5UZVIrkHd+vA4VT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278833; c=relaxed/simple;
	bh=mW53Vd+dlAo0ImV7kemJPJqlT2+9qrVVwsMId4psv80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smzM5n8qiGsNvNqsEBn6HIxPCrNmQj3QAIKaxZPAlr+9gy4AqCkpvP/kKJunJlfkPJ9sN/DvaTqNtbXHJBv7ST/SDQGXrTwH6EfvRdNw1yzXoEUBqb3RC5zzNtsTuzKe3bA+UWc4tIj5vye2OG+0Sc8jOwrS+rW6wT6KEGjJpbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pe9Gz0sV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pe9Gz0sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8330C2BBFC;
	Thu, 13 Jun 2024 11:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278831;
	bh=mW53Vd+dlAo0ImV7kemJPJqlT2+9qrVVwsMId4psv80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pe9Gz0sV68OKeOyhLVZ1cngrXVk2jr1+VJbmJeP/X0+LxU6khgOfKN4POHtod8Iak
	 fUqQY9kWgY4MQWE+72+tmdITqCwvrBTiCFbc1vBUHpI9mpdK7WgWbQ4N1BLisy58mS
	 MH/R9Gol42SQ/3m/gAm0Pfjsq4nrUQk0DrfLg/I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/213] wifi: mwl8k: initialize cmd->addr[] properly
Date: Thu, 13 Jun 2024 13:31:41 +0200
Message-ID: <20240613113230.055848323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ee842797570b7..55129bd36786f 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -2711,7 +2711,7 @@ __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
 		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
 		cmd->numaddr = cpu_to_le16(mc_count);
 		netdev_hw_addr_list_for_each(ha, mc_list) {
-			memcpy(cmd->addr[i], ha->addr, ETH_ALEN);
+			memcpy(cmd->addr[i++], ha->addr, ETH_ALEN);
 		}
 	}
 
-- 
2.43.0



