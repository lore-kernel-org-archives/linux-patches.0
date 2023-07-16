Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2931E8F75
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A089BC433C7;
	Sun, 16 Jul 2023 20:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537670;
	bh=HFRw48G4DtXnPqIuIC57uDqU175yi+0rBLI+YnZvbfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjIdCGaP1RsUUfNl0B4RXAj0ROHaBryenZsKtYuo7xQjI9aWRfR8ejAJnsp8Zn2oc
	 ugyTtYp6KySfGnH+J5KSLPwvIeE+qibkg20XMxOsXfIix9sEHByPubdrsqmdPNvxsB
	 Zu8U+g/UjYaN8xGgbOrm3V8GEeeBL41gi3Z66ZMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 151/800] wifi: rsi: Do not configure WoWlan in shutdown hook if not enabled
Date: Sun, 16 Jul 2023 21:40:04 +0200
Message-ID: <20230716194952.601228635@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit b241e260820b68c09586e8a0ae0fc23c0e3215bd ]

In case WoWlan was never configured during the operation of the system,
the hw->wiphy->wowlan_config will be NULL. rsi_config_wowlan() checks
whether wowlan_config is non-NULL and if it is not, then WARNs about it.
The warning is valid, as during normal operation the rsi_config_wowlan()
should only ever be called with non-NULL wowlan_config. In shutdown this
rsi_config_wowlan() should only ever be called if WoWlan was configured
before by the user.

Add checks for non-NULL wowlan_config into the shutdown hook. While at it,
check whether the wiphy is also non-NULL before accessing wowlan_config .
Drop the single-use wowlan_config variable, just inline it into function
call.

Fixes: 16bbc3eb8372 ("rsi: fix null pointer dereference during rsi_shutdown()")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230527222833.273741-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index d09998796ac08..6e33a2563fdbd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1463,10 +1463,8 @@ static void rsi_shutdown(struct device *dev)
 
 	rsi_dbg(ERR_ZONE, "SDIO Bus shutdown =====>\n");
 
-	if (hw) {
-		struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
-
-		if (rsi_config_wowlan(adapter, wowlan))
+	if (hw && hw->wiphy && hw->wiphy->wowlan_config) {
+		if (rsi_config_wowlan(adapter, hw->wiphy->wowlan_config))
 			rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
 	}
 
-- 
2.39.2



