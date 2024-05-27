Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550F717E90E;
	Mon, 27 May 2024 19:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837063; cv=none; b=FWjQcOhHjJ9a2eMAPb9wOb/HmvsppvIzIJGBPmlci+OgGIjz7tcLMQIn63I9+KQd7+/4vuzSesjw9Vjj10CvZja2b66aBtyBQwWyu3wQqF7rInu3zEurc+ha2uzcDTJtpeikSyI1PfG9JXCCsos0eMgMOKG2gIALDaMQ6jSAAxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837063; c=relaxed/simple;
	bh=SsLuUx2HuUB10vhI4fVEga4p5s7FdyDQIuTlnX0Y66U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWGspJzfAH0Fd244nXZy9XWlcROx3pJCNL464b42a8Zaxw2L4VsNQC2sCG1bPV1nF/Q+1tTu6HQrCRihhHI5GY3xNthA4BBdveT2LHw9WpRlju5OXPELXZKvZ3WMr2V945KIjh+qvP7E7t8LAiqhN6CUr29fm1zn3S7gwKvCLKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8z3GAyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8z3GAyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE541C2BBFC;
	Mon, 27 May 2024 19:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837063;
	bh=SsLuUx2HuUB10vhI4fVEga4p5s7FdyDQIuTlnX0Y66U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8z3GAyPOwZmeP47Xld5xl4e+JTwqCzNboLI4accLQZ4xSCslBMyNbH/j5Pe7ZqOL
	 +//dHNbRpzA4ZP5eMl+kiRMmjijsP3gt02RDbBH3rRNnVpEMboXCbsfDkvowTtVD4l
	 oBbppk4QisQYT42so3MncFscuo4mIC4iMJ/QJHSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 296/427] drm/meson: vclk: fix calculation of 59.94 fractional rates
Date: Mon, 27 May 2024 20:55:43 +0200
Message-ID: <20240527185629.928196200@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



