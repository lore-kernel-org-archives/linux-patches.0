Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF97CBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD8EC4339B;
	Tue,  7 Mar 2023 17:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210427;
	bh=PRPTphbTDeGzNC+HqY/fff9IX5Rp3zgmQxNjmjEB4NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gj2n0qh027V2tocGolE2tcZxNEuRofQYX80PmaNoVr+sqoEUCKXCmJ6MLltmALKOu
	 rdHt6sMBtnpNcu/sgWDjkwvN5R88ZP7Grswag0410bC7y9OU0HsHOQivxNXscZuyIp
	 uGTbZWg775XZARX+rGhz8gHlcdYU5Y5+zrgMEgeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0538/1001] usb: musb: mediatek: dont unregister something that wasnt registered
Date: Tue,  7 Mar 2023 17:55:10 +0100
Message-Id: <20230307170044.806221680@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index cad991380b0cf..27b9bd2583400 100644
--- a/drivers/usb/musb/mediatek.c
+++ b/drivers/usb/musb/mediatek.c
@@ -294,7 +294,8 @@ static int mtk_musb_init(struct musb *musb)
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



