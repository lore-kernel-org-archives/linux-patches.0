Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD07A1F12F7;
	Tue,  3 Dec 2024 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242142; cv=none; b=eIR79XEvGxsLSY42eS+O/npOPYlqXWgsNEnvRd/TEub8WaFOaGwkhuqwfWEZ8od4Sk1ARaJ2KJQHUpCFk74SBl80u6Y1dfUjRlclyUWAYyAvdshyWJFoxTpqUyj7Hin+mbkPfxI9QLoLvW2ugwV1Da26vFW97JEiz5hKogqgSTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242142; c=relaxed/simple;
	bh=Eo/kUvmhHG7DeT4kh/PRIfA4pasyiCzsFyTx6qWfwWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBBqDvvHOHaqw3H+loLM1/RKX8wMMRGDFu9VwE0abBPmJArFWYdcJh2ZJlN2d4QbauTJwgCHLHkBpU2uXjKoPaFT3RCZpDLmP7qYOdm5q5ZzWIavSoXr8bnonNkvk4HRPlgbUZOD6uBizG2KxYfXLy5V1b5kZ7oG6tZ1vwti4WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrNrwsBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrNrwsBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6E2C4CECF;
	Tue,  3 Dec 2024 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242142;
	bh=Eo/kUvmhHG7DeT4kh/PRIfA4pasyiCzsFyTx6qWfwWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrNrwsBp7d3qVIl+edAgivEDwe9bLB2a84m8oa7LwArh/Vf+SOEozpqHeUqY3izP7
	 ocsP/YS563B13KyRa4bCtRsW4gBnM2S479GhUD3HJZED/RrS7dwibNkmM/Lmtp4h9E
	 NnKSHWe6AEYhQMdWR5dqi4nlDt4xS1miVHYRX/Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 578/826] bnxt_en: Set backplane link modes correctly for ethtool
Date: Tue,  3 Dec 2024 15:45:05 +0100
Message-ID: <20241203144806.298033972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravya KN <shravya.k-n@broadcom.com>

[ Upstream commit 5007991670941c132fb3bc0484c009cf4bcea30f ]

Use the return value from bnxt_get_media() to determine the port and
link modes.  bnxt_get_media() returns the proper BNXT_MEDIA_KR when
the PHY is backplane.  This will correct the ethtool settings for
backplane devices.

Fixes: 5d4e1bf60664 ("bnxt_en: extend media types to supported and autoneg modes")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index f71cc8188b4e5..20ba14eb87e00 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2838,19 +2838,24 @@ static int bnxt_get_link_ksettings(struct net_device *dev,
 	}
 
 	base->port = PORT_NONE;
-	if (link_info->media_type == PORT_PHY_QCFG_RESP_MEDIA_TYPE_TP) {
+	if (media == BNXT_MEDIA_TP) {
 		base->port = PORT_TP;
 		linkmode_set_bit(ETHTOOL_LINK_MODE_TP_BIT,
 				 lk_ksettings->link_modes.supported);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_TP_BIT,
 				 lk_ksettings->link_modes.advertising);
+	} else if (media == BNXT_MEDIA_KR) {
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Backplane_BIT,
+				 lk_ksettings->link_modes.supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Backplane_BIT,
+				 lk_ksettings->link_modes.advertising);
 	} else {
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 				 lk_ksettings->link_modes.supported);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 				 lk_ksettings->link_modes.advertising);
 
-		if (link_info->media_type == PORT_PHY_QCFG_RESP_MEDIA_TYPE_DAC)
+		if (media == BNXT_MEDIA_CR)
 			base->port = PORT_DA;
 		else
 			base->port = PORT_FIBRE;
-- 
2.43.0



