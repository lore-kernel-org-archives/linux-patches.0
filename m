Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0FD1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFE5C433C8;
	Tue, 25 Jul 2023 11:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283729;
	bh=f0WgzdbQNiPceUgpK/AkLWb35i4eZa0k3xqdqEhFyCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTzXwna0jNjWeu+lfiAtI5DWe33eGkrmhcLGgqtaEsQBEv/RsrQH0cBqcLpEHwbi7
	 82ZXg1OilfA+HpVzETP8/1EeFdmQkReV4ENxa/k0tbAQI7vzkFThbePeydmPJBFmDy
	 1OZQovxuCa9KsUrC4LAcuhay23RbKu/VKM3SXQS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/509] drm/bridge: tc358768: fix THS_ZEROCNT computation
Date: Tue, 25 Jul 2023 12:40:41 +0200
Message-ID: <20230725104558.356692540@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

[ Upstream commit 77a089328da791118af9692543a5eedc79eb5fd4 ]

Correct computation of THS_ZEROCNT register.

This register must be set to a value that ensure that
THS_PREPARE + THS_ZERO > 145ns + 10*UI

with the actual value of (THS_PREPARE + THS_ZERO) being

((1 to 2) + 1 + (TCLK_ZEROCNT + 1) + (3 to 4)) x ByteClk cycle +
  + HSByteClk x (2 + (1 to 2)) + (PHY delay)

with PHY delay being about

(8 + (5 to 6)) x MIPIBitClk cycle in the BitClk conversion.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-7-francesco@dolcini.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index b7372c5b0b819..a35674b6ff244 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -744,9 +744,10 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	/* 40ns + 4*UI < THS_PREPARE < 85ns + 6*UI */
 	val = 50 + tc358768_to_ns(4 * ui_nsk);
 	val = tc358768_ns_to_cnt(val, dsibclk_nsk) - 1;
-	/* THS_ZERO > 145ns + 10*UI */
-	val2 = tc358768_ns_to_cnt(145 - tc358768_to_ns(ui_nsk), dsibclk_nsk);
-	val |= (val2 - tc358768_to_ns(phy_delay_nsk)) << 8;
+	/* THS_PREPARE + THS_ZERO > 145ns + 10*UI */
+	raw_val = tc358768_ns_to_cnt(145 - tc358768_to_ns(3 * ui_nsk), dsibclk_nsk) - 10;
+	val2 = clamp(raw_val, 0, 127);
+	val |= val2 << 8;
 	dev_dbg(priv->dev, "THS_HEADERCNT: 0x%x\n", val);
 	tc358768_write(priv, TC358768_THS_HEADERCNT, val);
 
-- 
2.39.2



