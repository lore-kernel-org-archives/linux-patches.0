Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C972F44;
	Thu, 12 Dec 2024 17:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023268; cv=none; b=dsN2oIfDRebH3xFR1IgTZ24wjZfG4tGqpZvETjEjm+Ju4GTLCUGaN/y4rLM54kD6/8Wr3FhCMYv0SOfpUUjxfJthaweKzY7eRJ/gUJxjPgWPILCV0zb1PQwJoBO5fCYGlyS+GIUkHvkVAVTke+P7VcfLoDXfTsZPTxFIw0gzXso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023268; c=relaxed/simple;
	bh=Qr0Sn5LAJiNTUPV/T4Ba8VpSJ3yuz+Z3NG/5/q5lMzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juwR7xeWxjxvXLLSKhSpyH4cqGfwt5xdhTG+q/dh3uFScWP2nYgZOKDsUgSePic6MZgObHi46TKb15P/7UiYlXtmEhISUN5FvlOBBnpoD4apgvXxmmTwQ7kmL96/rjQalDxj7xzHKdgDG4BTeyw/4y60WhXAotCyR43q/Sl+rwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2PrWAG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2PrWAG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35298C4CECE;
	Thu, 12 Dec 2024 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023268;
	bh=Qr0Sn5LAJiNTUPV/T4Ba8VpSJ3yuz+Z3NG/5/q5lMzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2PrWAG+qADTnharIn/VreFdXf0ofN/oAc2WhuG2Pt6hLwpWh9LPas//5g/jv2tf1
	 t54sYJ0TQbiPK6bWgrr+dhm5ZnK74zsJuJJEG97/Lw3estCHO2hi9C+uxfkeoKOV5w
	 trhjHR927f6paOcwJknFwUDTkK0zNfPPcTBXR4gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/565] drm/vc4: hvs: Set AXI panic modes for the HVS
Date: Thu, 12 Dec 2024 16:01:12 +0100
Message-ID: <20241212144330.609516856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 014eccc9da7bfc76a3107fceea37dd60f1d63630 ]

The HVS can change AXI request mode based on how full the COB
FIFOs are.
Until now the vc4 driver has been relying on the firmware to
have set these to sensible values.

With HVS channel 2 now being used for live video, change the
panic mode for all channels to be explicitly set by the driver,
and the same for all channels.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-7-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 3856ac289d380..69b2936a5f4ad 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -729,6 +729,17 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC1);
 	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC2);
 
+	/* Set AXI panic mode.
+	 * VC4 panics when < 2 lines in FIFO.
+	 * VC5 panics when less than 1 line in the FIFO.
+	 */
+	dispctrl &= ~(SCALER_DISPCTRL_PANIC0_MASK |
+		      SCALER_DISPCTRL_PANIC1_MASK |
+		      SCALER_DISPCTRL_PANIC2_MASK);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC0);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC1);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC2);
+
 	HVS_WRITE(SCALER_DISPCTRL, dispctrl);
 
 	ret = devm_request_irq(dev, platform_get_irq(pdev, 0),
-- 
2.43.0



