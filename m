Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CD735CB78;
	Wed,  3 Dec 2025 16:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779176; cv=none; b=IjOdVf/N5Jz6e2ye11yhaISIbIWlpaMJDBB+sPlNJAl10H02B2xM/Ae9rW47ESRZanW12HxfQShjPAprLk9Zhv+PAIlttrQgMXo6AQcJXnqhX0G6lTEH+qrwDw1/DTTjBnJ3jGalmXOnRBOC3hSv5DaaFTp1KCb7EwMmoKBW+oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779176; c=relaxed/simple;
	bh=6vJt1WUYt7OrbOrCPfXgfpETWJXU7jqxGg59TdFGMYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVZ+s8suvRAkJpfIBppk9EY4wIEnYlBFm/C6x6H8nsI37ueaHopPPNs83gEBDkHlLw+TIn2QID8RdPUC6ldv1IIE6XHfep1ULO73heSRXY58CENYHBpoaGUzuJrqoZUhDCDAZgXnwC75EZA6lzSJAY/P9Xx1p5rKFateNyIDNWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sf85Xypk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sf85Xypk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545E6C4CEF5;
	Wed,  3 Dec 2025 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779175;
	bh=6vJt1WUYt7OrbOrCPfXgfpETWJXU7jqxGg59TdFGMYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sf85XypkbGacO8Kj1BgPGpiBAlrd4iwaLmwo3hCTcY4U1lHL/rCR56iv9BgVRty+D
	 LNSPTtZZN/L44C6DftjwF4XFmy6np4Yjg0EhZF7MG7l6HRh2dcz9GZmqdQ1mp/1osM
	 PDEPc8gOp4F6bqYz2Givp2JQM6EVQRJumDQa0z/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/568] drm/tidss: Set crtc modesetting parameters with adjusted mode
Date: Wed,  3 Dec 2025 16:22:27 +0100
Message-ID: <20251203152446.040109044@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit cfb29225db20c56432a8525366321c0c09edfb2e ]

TIDSS uses crtc_* fields to propagate its registers and set the
clock rates. So set the CRTC modesetting timing parameters with
the adjusted mode when needed, to set correct values.

Cc: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Link: https://lore.kernel.org/r/20250624080402.302526-1-j-choudhary@ti.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tidss/tidss_crtc.c b/drivers/gpu/drm/tidss/tidss_crtc.c
index f33d2b7fc1b7e..b56d0d78edfd2 100644
--- a/drivers/gpu/drm/tidss/tidss_crtc.c
+++ b/drivers/gpu/drm/tidss/tidss_crtc.c
@@ -92,7 +92,7 @@ static int tidss_crtc_atomic_check(struct drm_crtc *crtc,
 	struct dispc_device *dispc = tidss->dispc;
 	struct tidss_crtc *tcrtc = to_tidss_crtc(crtc);
 	u32 hw_videoport = tcrtc->hw_videoport;
-	const struct drm_display_mode *mode;
+	struct drm_display_mode *mode;
 	enum drm_mode_status ok;
 
 	dev_dbg(ddev->dev, "%s\n", __func__);
@@ -109,6 +109,9 @@ static int tidss_crtc_atomic_check(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
+	if (drm_atomic_crtc_needs_modeset(crtc_state))
+		drm_mode_set_crtcinfo(mode, 0);
+
 	return dispc_vp_bus_check(dispc, hw_videoport, crtc_state);
 }
 
-- 
2.51.0



