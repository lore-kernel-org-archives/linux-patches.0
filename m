Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6F11171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08960C433C8;
	Mon, 21 Aug 2023 20:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648077;
	bh=gqyS9+Et9HrnTElIM4gGIzXrxOxAu0t880LTgOoSUSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0pTiJqJ0ZKw/dPiePRN3ve315w9dsYqJuwsDPjLXK4Ii0XRRlvUEs2valE+JC3Wq
	 ZR5dNf4vjpAtx9R7MfFfNb53XjxrT7hXt20e+ssGLbabNAfVV42mdhD/9CXPHmZBny
	 UTutslgAMcGIKk3KQFIaqgybSx3GpeStAKAzw5no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Hongfei <luhongfei@vivo.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 047/234] led: qcom-lpg: Fix resource leaks in for_each_available_child_of_node() loops
Date: Mon, 21 Aug 2023 21:40:10 +0200
Message-ID: <20230821194130.815216471@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lu Hongfei <luhongfei@vivo.com>

[ Upstream commit 8f38f8fa7261819eb7d4fb369dc3bfab72259033 ]

Ensure child node references are decremented properly in the error path.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Link: https://lore.kernel.org/r/20230525111705.3055-1-luhongfei@vivo.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-qcom-lpg.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/rgb/leds-qcom-lpg.c b/drivers/leds/rgb/leds-qcom-lpg.c
index 1c849814a4917..212df2e3d3502 100644
--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -1173,8 +1173,10 @@ static int lpg_add_led(struct lpg *lpg, struct device_node *np)
 		i = 0;
 		for_each_available_child_of_node(np, child) {
 			ret = lpg_parse_channel(lpg, child, &led->channels[i]);
-			if (ret < 0)
+			if (ret < 0) {
+				of_node_put(child);
 				return ret;
+			}
 
 			info[i].color_index = led->channels[i]->color;
 			info[i].intensity = 0;
@@ -1352,8 +1354,10 @@ static int lpg_probe(struct platform_device *pdev)
 
 	for_each_available_child_of_node(pdev->dev.of_node, np) {
 		ret = lpg_add_led(lpg, np);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			return ret;
+		}
 	}
 
 	for (i = 0; i < lpg->num_channels; i++)
-- 
2.40.1



