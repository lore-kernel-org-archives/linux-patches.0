Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609918F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA67CC433C9;
	Sun, 16 Jul 2023 20:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537933;
	bh=NAYbEfyuOPdrUm5TmHEKkomggt4B6YXGxrVVThF92XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPcBJjAEUBDRu+HCksSxu4m6SDJknBrT7K8lRvzKsI/DerLivdWoIbb7IuAyTJIKm
	 LaJeid/TATKQzV354QY67fFjA5rsUGFs29HKuTBqur6vXpiF5jQbdFlmFJTFGj7Krv
	 YZOc/3L77/3wRUFhPpUXbofEGaP0X8lW/zP6Friw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 243/800] drm/bridge: tc358768: fix THS_TRAILCNT computation
Date: Sun, 16 Jul 2023 21:41:36 +0200
Message-ID: <20230716194954.745491234@linuxfoundation.org>
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

[ Upstream commit bac7842cd179572e8e0fc2d7b5254e40c6e9e057 ]

Correct computation of THS_TRAILCNT register.

This register must be set to a value that ensure that
THS_TRAIL > 60 ns + 4 x UI
 and
THS_TRAIL > 8 x UI
 and
THS_TRAIL < TEOT
 with
TEOT = 105 ns + (12 x UI)

with the actual value of THS_TRAIL being

(1 + THS_TRAILCNT) x ByteClk cycle + ((1 to 2) + 2) xHSBYTECLK cycle +
 - (PHY output delay)

with PHY output delay being about

(8 + (5 to 6)) x MIPIBitClk cycle in the BitClk conversion.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-9-francesco@dolcini.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index d8209433d5f43..966a25cb0b108 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -780,9 +780,10 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	dev_dbg(priv->dev, "TCLK_POSTCNT: 0x%x\n", val);
 	tc358768_write(priv, TC358768_TCLK_POSTCNT, val);
 
-	/* 60ns + 4*UI < THS_PREPARE < 105ns + 12*UI */
-	val = tc358768_ns_to_cnt(60 + tc358768_to_ns(15 * ui_nsk),
-				 dsibclk_nsk) - 5;
+	/* max(60ns + 4*UI, 8*UI) < THS_TRAILCNT < 105ns + 12*UI */
+	raw_val = tc358768_ns_to_cnt(60 + tc358768_to_ns(18 * ui_nsk),
+				     dsibclk_nsk) - 4;
+	val = clamp(raw_val, 0, 15);
 	dev_dbg(priv->dev, "THS_TRAILCNT: 0x%x\n", val);
 	tc358768_write(priv, TC358768_THS_TRAILCNT, val);
 
-- 
2.39.2



