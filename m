Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6B414B092;
	Tue,  9 Jul 2024 11:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523701; cv=none; b=OJ3yNl/SCMrV/dhxGY/TaA7hgFxhYLiuDMTkjU/qw11K2XUqZ+2ycNL8frwZCqzMFsPpiK/ja8ORD84M7o5soh4radFltZSsMVwTQvzM7aUJodHAQwXT2BmH/BeRAk96kTTdqRpFAJF0sQucReOc8p7gDWpt26KX/0qYqVKADHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523701; c=relaxed/simple;
	bh=AlPROd7WWiyf+KwUGDm2xE1MxFq+4tpaWrtIANQolfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nLTYWbA6CwpRBtYk5bgF0axDaD4yWPYho50olumWunIDhcYmyIBCbrormgkQ+bCo3UmJmL8Log7qhvsvFCvZPV33eDfKbS8EpYILqxxpls98vrmcWL0ZCJEIa3UsLiZd46pCSg2KVPRF2TT/zrBmKBf6P4/CNriQBavBuhNKBvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXG2Tp6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXG2Tp6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74A2C3277B;
	Tue,  9 Jul 2024 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523701;
	bh=AlPROd7WWiyf+KwUGDm2xE1MxFq+4tpaWrtIANQolfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXG2Tp6KL4WBMtUG/Uj8G1mbrAEBvuH5iW4hdJxMlNdslRWOlCKF8RtXk5OEKVgxc
	 iMb0Dlc8KYro37pD5XnVHkcM5KH/ySG/v5k5LePml56sXaDjx+3I20BAF7OvW3bood
	 ShQEcUkYhKa2Jy0mGowht1tHuOxxRvk1IiYbhuOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozef Hopko <jozef.hopko@altana.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/139] wifi: wilc1000: fix ies_len type in connect path
Date: Tue,  9 Jul 2024 13:09:38 +0200
Message-ID: <20240709110701.191994720@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozef Hopko <jozef.hopko@altana.com>

[ Upstream commit 39ab8fff623053a50951b659e5f6b72343d7d78c ]

Commit 205c50306acf ("wifi: wilc1000: fix RCU usage in connect path")
made sure that the IEs data was manipulated under the relevant RCU section.
Unfortunately, while doing so, the commit brought a faulty implicit cast
from int to u8 on the ies_len variable, making the parsing fail to be
performed correctly if the IEs block is larger than 255 bytes. This failure
can be observed with Access Points appending a lot of IEs TLVs in their
beacon frames (reproduced with a Pixel phone acting as an Access Point,
which brough 273 bytes of IE data in my testing environment).

Fix IEs parsing by removing this undesired implicit cast.

Fixes: 205c50306acf ("wifi: wilc1000: fix RCU usage in connect path")
Signed-off-by: Jozef Hopko <jozef.hopko@altana.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Acked-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240701-wilc_fix_ies_data-v1-1-7486cbacf98a@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/hif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index e202013e6f2fe..e4bb3ea6e2267 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -379,7 +379,8 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 	struct ieee80211_p2p_noa_attr noa_attr;
 	const struct cfg80211_bss_ies *ies;
 	struct wilc_join_bss_param *param;
-	u8 rates_len = 0, ies_len;
+	u8 rates_len = 0;
+	int ies_len;
 	int ret;
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
-- 
2.43.0



