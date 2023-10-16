Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816B61944F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSvX8F82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F205BC433C7;
	Mon, 16 Oct 2023 08:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445826;
	bh=2eDtaNxxYRqMqIs7pOObMtxwnlMTmNb+TjuI+C9tkyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSvX8F826KY/yr1zgoatHw21+COVym4zAhVt3OU/3EOLrCrdGrFsIgbgsZmsDOr/4
	 If+HIgFRrdHUkDm5p+uh+E5gAAvxLvRYYDG1NjQCXXbUgeO9cRSffvo6rortafWSmH
	 a6fEDNeZeCSSB82pQ4CL09/y+aYLxLuox7x0e9Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/102] drm/msm/dsi: skip the wait for video mode done if not applicable
Date: Mon, 16 Oct 2023 10:40:18 +0200
Message-ID: <20231016083954.200316285@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit ab483e3adcc178254eb1ce0fbdfbea65f86f1006 ]

dsi_wait4video_done() API waits for the DSI video mode engine to
become idle so that we can transmit the DCS commands in the
beginning of BLLP. However, with the current sequence, the MDP
timing engine is turned on after the panel's pre_enable() callback
which can send out the DCS commands needed to power up the panel.

During those cases, this API will always timeout and print out the
error spam leading to long bootup times and log flooding.

Fix this by checking if the DSI video engine was actually busy before
waiting for it to become idle otherwise this is a redundant wait.

changes in v2:
	- move the reg read below the video mode check
	- minor fixes in commit text

Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/34
Fixes: a689554ba6ed ("drm/msm: Initial add DSI connector support")
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/557853/
Link: https://lore.kernel.org/r/20230915204426.19011-1-quic_abhinavk@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index d3ec4d67a9a35..b577fed38c6d4 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1079,9 +1079,21 @@ static void dsi_wait4video_done(struct msm_dsi_host *msm_host)
 
 static void dsi_wait4video_eng_busy(struct msm_dsi_host *msm_host)
 {
+	u32 data;
+
 	if (!(msm_host->mode_flags & MIPI_DSI_MODE_VIDEO))
 		return;
 
+	data = dsi_read(msm_host, REG_DSI_STATUS0);
+
+	/* if video mode engine is not busy, its because
+	 * either timing engine was not turned on or the
+	 * DSI controller has finished transmitting the video
+	 * data already, so no need to wait in those cases
+	 */
+	if (!(data & DSI_STATUS0_VIDEO_MODE_ENGINE_BUSY))
+		return;
+
 	if (msm_host->power_on && msm_host->enabled) {
 		dsi_wait4video_done(msm_host);
 		/* delay 4 ms to skip BLLP */
-- 
2.40.1



