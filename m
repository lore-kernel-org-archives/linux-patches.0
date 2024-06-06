Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48ED196D93;
	Thu,  6 Jun 2024 14:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683290; cv=none; b=NvCB2jA+aBcFJMSotUchWRhWhSxN4MJUhmscE58HOrF5IZQiemG2QI8PyBMFTqP50W/H+Hjp+IR3m7UJS0gkF8Jvt2k9k22bgW/fdYzqbgK5gV7pPvJ6cPtKevbi27s2iy6TK7X1wYehXQLq4i4zgIj0ZN/fhJDPL8Cg9B3UUU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683290; c=relaxed/simple;
	bh=E306Ea8HqQcJNsmFnjEXz5YvzL28kvFAREMmHt7dVEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+JyHCag+SSn5MftsKEE4vBXTMQIbZiP8Oi+lyM4zp6idysQr0kR2LVfmo2FaQqoe7T6VpVY+POQukN5l5FimaCsHMpJVUJRq/V8/NHDweO1aug7bPkylFs9D+bt83xLHOietFUP9zHyFYi1AJjG+LVg8M8zQxe0XvulMJkopqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjTkX5p8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjTkX5p8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D52CC2BD10;
	Thu,  6 Jun 2024 14:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683290;
	bh=E306Ea8HqQcJNsmFnjEXz5YvzL28kvFAREMmHt7dVEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjTkX5p8EtnEMCPbSGmtJX/NBwOO4v5IlabqFSH9WF9CjWMEJppftIemkef1QFyxF
	 meKdUV1IUcRaF6pDsE5SxGxHoafNF9zqjQpUEJ9tXu2Y3thYRySqr62JiYUf+oHVdz
	 w1zyOCzThoAuuXdswvKg9AnGIgoPevll/5SKbBHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/744] wifi: mwl8k: initialize cmd->addr[] properly
Date: Thu,  6 Jun 2024 15:58:23 +0200
Message-ID: <20240606131739.800045149@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



