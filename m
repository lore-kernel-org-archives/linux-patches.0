Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA218F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871C5C433C8;
	Sun, 16 Jul 2023 20:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537924;
	bh=K4cFRuLE+MyvbssmghWVqUZv1XOr+FVrs8SFrxcOrEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dw4fD+0J0tf2ZXF5kIdqYg7onXT1fy7jtLAzQd8nj3rpp+tXBefJLEjOoqlod+rAA
	 iMjnuxGWNyTUVlcySOUagfGmuMHL4q9wyxJmKrJfEZzyqdLl0eicpBZGPuvRTWFA0t
	 uJ2qLK4SEHUsYRNDOiYMGiDhYiUxYCL+P6UFTw5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 242/800] drm/bridge: tc358768: fix TXTAGOCNT computation
Date: Sun, 16 Jul 2023 21:41:35 +0200
Message-ID: <20230716194954.722828787@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 3666aad8185af8d0ce164fd3c4974235417d6d0b ]

Correct computation of TXTAGOCNT register.

This register must be set to a value that ensure that the
TTA-GO period = (4 x TLPX)

with the actual value of TTA-GO being

4 x (TXTAGOCNT + 1) x (HSByteClk cycle)

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-8-francesco@dolcini.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index e3f456bfb90c1..d8209433d5f43 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -796,7 +796,7 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 
 	/* TXTAGOCNT[26:16] RXTASURECNT[10:0] */
 	val = tc358768_to_ns((lptxcnt + 1) * dsibclk_nsk * 4);
-	val = tc358768_ns_to_cnt(val, dsibclk_nsk) - 1;
+	val = tc358768_ns_to_cnt(val, dsibclk_nsk) / 4 - 1;
 	val2 = tc358768_ns_to_cnt(tc358768_to_ns((lptxcnt + 1) * dsibclk_nsk),
 				  dsibclk_nsk) - 2;
 	val = val << 16 | val2;
-- 
2.39.2



