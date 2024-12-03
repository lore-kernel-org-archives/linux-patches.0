Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA8A1F6696;
	Tue,  3 Dec 2024 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238269; cv=none; b=E0vLhU4yTtoAA4lfCY1gw0W1OdyRckw2R9bv7swZGOWfb0fA+DLzp2RPspXbj0/RkrleB1QO5Eg4+5joEXcYffeq9wedB0K7/CN7ppkoA+brKbC/gZ81HGtOA/NgymfpF+aVp1gWPx+rInQxqMv78BfupB2W6IKkJBNxX5mHdDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238269; c=relaxed/simple;
	bh=Wx06nkl92CPnKM/yH3J/c/Zg7TytkGd7kcx36PNJS08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2G3+Om5ebWoaa/BfGrPHBPNV5/1sBbDRi39S20lfSmGuLx+XvunzVvlPT6AO2f1cEYDVJJpBzQ8J5L5p/vo+1Qqn5SJKsMido2F31Fq9A2FjYmRn9fxFu/sCmZwi4hwkz2DBtO8PRRE5KpWuAqIfri+kmcIwVQVsqf/P3A2pEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlCIVhN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlCIVhN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C0BC4CECF;
	Tue,  3 Dec 2024 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238269;
	bh=Wx06nkl92CPnKM/yH3J/c/Zg7TytkGd7kcx36PNJS08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlCIVhN8UZFzTQtM6qbBoYP9yTIUllxr+/yTuXuAQniEuePcNMY0SfX9atI7UlpaA
	 joBBBTVn6oSIAQFqTPxv9gkN2NqYCHxqaarl3nJj46DlEk0sunI9wCFr7TGTZypzbr
	 tKcfW7TR6VAW3umTgmv7TdiqAGhzkRZf969s4kMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 221/817] drm/vc4: hvs: Correct logic on stopping an HVS channel
Date: Tue,  3 Dec 2024 15:36:33 +0100
Message-ID: <20241203144004.376558869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 7ab6512e7942889c0962588355cb92424a690be6 ]

When factoring out __vc4_hvs_stop_channel, the logic got inverted from
	if (condition)
	  // stop channel
to
	if (condition)
	  goto out
	//stop channel
	out:
and also changed the exact register writes used to stop the channel.

Correct the logic so that the channel is actually stopped, and revert
to the original register writes.

Fixes: 6d01a106b4c8 ("drm/vc4: crtc: Move HVS init and close to a function")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-32-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 3e72219a6a75f..27c8fb9efa854 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -420,13 +420,11 @@ void vc4_hvs_stop_channel(struct vc4_hvs *hvs, unsigned int chan)
 	if (!drm_dev_enter(drm, &idx))
 		return;
 
-	if (HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_ENABLE)
+	if (!(HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_ENABLE))
 		goto out;
 
-	HVS_WRITE(SCALER_DISPCTRLX(chan),
-		  HVS_READ(SCALER_DISPCTRLX(chan)) | SCALER_DISPCTRLX_RESET);
-	HVS_WRITE(SCALER_DISPCTRLX(chan),
-		  HVS_READ(SCALER_DISPCTRLX(chan)) & ~SCALER_DISPCTRLX_ENABLE);
+	HVS_WRITE(SCALER_DISPCTRLX(chan), SCALER_DISPCTRLX_RESET);
+	HVS_WRITE(SCALER_DISPCTRLX(chan), 0);
 
 	/* Once we leave, the scaler should be disabled and its fifo empty. */
 	WARN_ON_ONCE(HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_RESET);
-- 
2.43.0



