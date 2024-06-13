Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D0D1877;
	Thu, 13 Jun 2024 12:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281930; cv=none; b=kbYvscHBk+r94HxNYY01WcIBjdM6MJD+Xn40KmX+5Gd2CYJJFdpjmbDYmflBIhfPw/lkbmr1mACaRurEB/QQvj3xU2apyzM9Kx8FKP12oHT9BigdfsL8dN0Za5Q0BE8wwi/iddWQ5SqT/qPY3NOvElIqql3UOjbWMorilc39Bkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281930; c=relaxed/simple;
	bh=J8khCB1E7+jBetBPixmeQzB5w1snn/6UhGESIpWkz3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilZvq3VDjtxkrTqbhugF0HtONmP/KF3E5dEvxLZHagmnK3k7nc1tmueVkBbInvyGxjtstaq8vz+sTh6iyFTE5hn0EGnVG6bpbm6Kt84qUnJDp7bGGeuFRheHAWV0tujJZQyBkd+za3FYqXeyUE8yqpkGWvYMWx4vnjnbAe7LkB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ut4qr2TT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ut4qr2TT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F6CC2BBFC;
	Thu, 13 Jun 2024 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281930;
	bh=J8khCB1E7+jBetBPixmeQzB5w1snn/6UhGESIpWkz3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ut4qr2TT9g1WsmbUVmk324EzFjG7AfE3+y9e3YdQ7mesXsuxtMNg9fyoY/mWszkKr
	 OI7RD5iIioPPdIAvG7JSzBRXVlRSPajwyKQvWbXFyaWTH7JIJhhFajvUl9mD1cjZ9z
	 uMuRdQKAPCRiPvPp8ELG7bxEqnmFlkIIffAWJ7ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/402] wifi: mwl8k: initialize cmd->addr[] properly
Date: Thu, 13 Jun 2024 13:31:01 +0200
Message-ID: <20240613113306.189782638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 529e325498cdb..ad9678186c583 100644
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



