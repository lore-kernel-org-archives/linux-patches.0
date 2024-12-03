Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050F91F8935;
	Tue,  3 Dec 2024 15:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240616; cv=none; b=SZJDPH9Owzv0NmrGIrfqOlAtLCsohdT/+s+DjmjHy40AZypx42Cqs2AvZh9DZ/sJ4ohvDO/5+CNsTityCdZDei1jx2j8+7WV/Rmy+TM/iKjapjkRH08A8ld0NJMUQc3yNatp3MSwF4oy1FL5Uvu3wTOYiY22SFZKorzDz0+k8MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240616; c=relaxed/simple;
	bh=VmZ1bXk8DzCIWFReGhcYq4TWxdTNUVDl4ZIop+wy/dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtBecXkP1TxFW6T3zBK3iU8/jmatqVmXzc/MHQelU+a72IT068fosMrP2tC9xr+Z2cc3byZSwc9tyshrF07BOMpZoLnrMbQP+XBhGwSvAtVKiGWgrKv0cC5DVnwJvU/qs9JaxEtRLf2eqXWyPWorJPDh3zUOkiR56A/FIdgCz8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g437i7+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g437i7+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60158C4CECF;
	Tue,  3 Dec 2024 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240615;
	bh=VmZ1bXk8DzCIWFReGhcYq4TWxdTNUVDl4ZIop+wy/dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g437i7+v9VU1kU36UYnBnqe3612ZGrGbh5f/3KYR7C0l0ceajJnGqJoOvfKFQJR40
	 GDBG/kC2B6dl5Hq3k/jdDzkIVJ/wOGKIHoORX1v62gWmigdVURhy5uV7jO8p4GqTHY
	 y0OYGoOf3IQT5+UIcpvHLJ8yNr70hq58V38Oq0nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/826] drm/vc4: hvs: Correct logic on stopping an HVS channel
Date: Tue,  3 Dec 2024 15:38:35 +0100
Message-ID: <20241203144751.075633792@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 14415943a1157..1d011fa8a7eac 100644
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



