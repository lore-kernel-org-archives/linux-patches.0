Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00211AED37;
	Thu,  6 Jun 2024 14:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683346; cv=none; b=ApZpdQcbb3puTctrRnYT741NByU7qtpWXHyHzvTrSSEhEIr8ZdOf9EnHHhKQZEjZ/RZZrFhAjIqPRMKld9D76OolorbNciKiA2t9/6sINEaL+8I7ZJONeBPNe4QzEkgnORThA0C6iit5Sm5InqJWIM5WnjLSOfo62Mjfwt7gRxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683346; c=relaxed/simple;
	bh=x/1KCcu43p2cG6nRII52x1ib/WSuhc73pIwV/6E+NnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GP4ONgnUHvQzay031aTXrTJaraqpIj9JOnzQZPD0ZmxzwcELxZAeC+/jCw9nflm4rXGdTffkoqGn2Al0cce2a9RrvTxGkQj40BJbeakKxzkfHyGv4S1yOlpYeePU1T+16cj65tmPBzYYmqVDal9AMtqc5MHvcrAFuE/795ng/Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7JgIjBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7JgIjBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED0BC4AF08;
	Thu,  6 Jun 2024 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683346;
	bh=x/1KCcu43p2cG6nRII52x1ib/WSuhc73pIwV/6E+NnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7JgIjBX4K1tGNTCRbkn9waqHuqiOK/Tm2W+4AL2UETIhjg4Q+IZnXVxa7bDS07RQ
	 UFgxAU8JOHvf7I8W+spremwfXfWQ9+0E9DJwomqk0qU0EXXOYKSGgdRivIQ0Plf5dX
	 nO62W0kVu88NLcbHg2BM1dWV9cSRd/TipkwI7V54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/744] drm/meson: vclk: fix calculation of 59.94 fractional rates
Date: Thu,  6 Jun 2024 15:59:19 +0200
Message-ID: <20240606131741.610967878@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit bfbc68e4d8695497f858a45a142665e22a512ea3 ]

Playing 4K media with 59.94 fractional rate (typically VP9) causes the screen to lose
sync with the following error reported in the system log:

[   89.610280] Fatal Error, invalid HDMI vclk freq 593406

Modetest shows the following:

3840x2160 59.94 3840 4016 4104 4400 2160 2168 2178 2250 593407 flags: xxxx, xxxx,
drm calculated value -------------------------------------^

Change the fractional rate calculation to stop DIV_ROUND_CLOSEST rounding down which
results in vclk freq failing to match correctly.

Fixes: e5fab2ec9ca4 ("drm/meson: vclk: add support for YUV420 setup")
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240109230704.4120561-1-christianshewitt@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240109230704.4120561-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_vclk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_vclk.c b/drivers/gpu/drm/meson/meson_vclk.c
index 2a82119eb58ed..2a942dc6a6dc2 100644
--- a/drivers/gpu/drm/meson/meson_vclk.c
+++ b/drivers/gpu/drm/meson/meson_vclk.c
@@ -790,13 +790,13 @@ meson_vclk_vic_supported_freq(struct meson_drm *priv, unsigned int phy_freq,
 				 FREQ_1000_1001(params[i].pixel_freq));
 		DRM_DEBUG_DRIVER("i = %d phy_freq = %d alt = %d\n",
 				 i, params[i].phy_freq,
-				 FREQ_1000_1001(params[i].phy_freq/10)*10);
+				 FREQ_1000_1001(params[i].phy_freq/1000)*1000);
 		/* Match strict frequency */
 		if (phy_freq == params[i].phy_freq &&
 		    vclk_freq == params[i].vclk_freq)
 			return MODE_OK;
 		/* Match 1000/1001 variant */
-		if (phy_freq == (FREQ_1000_1001(params[i].phy_freq/10)*10) &&
+		if (phy_freq == (FREQ_1000_1001(params[i].phy_freq/1000)*1000) &&
 		    vclk_freq == FREQ_1000_1001(params[i].vclk_freq))
 			return MODE_OK;
 	}
@@ -1070,7 +1070,7 @@ void meson_vclk_setup(struct meson_drm *priv, unsigned int target,
 
 	for (freq = 0 ; params[freq].pixel_freq ; ++freq) {
 		if ((phy_freq == params[freq].phy_freq ||
-		     phy_freq == FREQ_1000_1001(params[freq].phy_freq/10)*10) &&
+		     phy_freq == FREQ_1000_1001(params[freq].phy_freq/1000)*1000) &&
 		    (vclk_freq == params[freq].vclk_freq ||
 		     vclk_freq == FREQ_1000_1001(params[freq].vclk_freq))) {
 			if (vclk_freq != params[freq].vclk_freq)
-- 
2.43.0



