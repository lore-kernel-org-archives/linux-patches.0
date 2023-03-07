Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0620BA50
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9E1C4339E;
	Tue,  7 Mar 2023 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215610;
	bh=ANdK5IJ9kk3EqkVoXOEZKwN6xWuAs/n5AGH+PEsKTJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhwBSXO2m+TFfFfuhiPlknfJWVqlXPWbyRcFKNqCfM/5DE2qrGmIo3PjvUU2DNB35
	 zdab4Iuq5Q61+rlbfgofjIMTknqR0G5pfdSelTLV8XMED16a/dCMjHJH+8I+2YK1up
	 7TBK0/QMJo07Y/OCnptSJS7lHfxv87cybfv81lzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/567] usb: musb: mediatek: dont unregister something that wasnt registered
Date: Tue,  7 Mar 2023 18:00:53 +0100
Message-Id: <20230307165919.604558768@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit ba883de971d1ad018f3083d9195b8abe54d87407 ]

This function only calls mtk_otg_switch_init() when the ->port_mode
is MUSB_OTG so the clean up code should only call mtk_otg_switch_exit()
for that mode.

Fixes: 0990366bab3c ("usb: musb: Add support for MediaTek musb controller")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/Y8/3TqpqiSr0RxFH@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/mediatek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/mediatek.c b/drivers/usb/musb/mediatek.c
index 6b92d037d8fc8..4f52b92c45974 100644
--- a/drivers/usb/musb/mediatek.c
+++ b/drivers/usb/musb/mediatek.c
@@ -346,7 +346,8 @@ static int mtk_musb_init(struct musb *musb)
 err_phy_power_on:
 	phy_exit(glue->phy);
 err_phy_init:
-	mtk_otg_switch_exit(glue);
+	if (musb->port_mode == MUSB_OTG)
+		mtk_otg_switch_exit(glue);
 	return ret;
 }
 
-- 
2.39.2



