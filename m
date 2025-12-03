Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC36434CFD8;
	Wed,  3 Dec 2025 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777741; cv=none; b=AH2xPvRuSzbR1IEXplxQhfdLgX29Zz3AZ6mm2ln0IJMGd9QDdwiHb/fK7LdmA2kM/WZovGhFYjdJj2Zf+eog5MbVPjYY1nSP8xwkcGukgW6g2HttN2boC7lKKgtKROcm5rYW+kD7zKz66kgnINgb1vyOLQqZ09wgic3iy3hVOw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777741; c=relaxed/simple;
	bh=R98UVH9RRYvMoRXn7p3v4Y4eftVujSENtlMIqqWrhg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbSJj3fsVJuQ+1LHWfv7m672Mo5Z8b7A8eUvD//Us5Q29zwaIhqZUqdTR1A2icwN09Rgl+tcTsqIWL04Uq8/2EWcsji+p8dZT+97dJpUS1fG8VzzmZER15cs5xmSQqP9L03ine+DDB2lp6FFlQNVNVsoJbUDWSofupktfY4X9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCN49O6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCN49O6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CA0C4CEF5;
	Wed,  3 Dec 2025 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777741;
	bh=R98UVH9RRYvMoRXn7p3v4Y4eftVujSENtlMIqqWrhg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCN49O6Bu9t2R9SBwaF3mrBXWyoamG6kWKqOtXMRU6VXwz/Bf2VpUcuXh0D/m6O+y
	 g56Sg4a45xS/4DMDpj4qDNA4xnpcDPHFsuU0uia8SxPp75QO9lrXzKldmvUgHVR5YX
	 3AI4Z+xFdS2Rr+SfTqDIdDtGhZl+bEfxlufoN/3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/392] drm/tidss: Set crtc modesetting parameters with adjusted mode
Date: Wed,  3 Dec 2025 16:24:10 +0100
Message-ID: <20251203152417.778807830@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3de103c673576..123060f682e68 100644
--- a/drivers/gpu/drm/tidss/tidss_crtc.c
+++ b/drivers/gpu/drm/tidss/tidss_crtc.c
@@ -94,7 +94,7 @@ static int tidss_crtc_atomic_check(struct drm_crtc *crtc,
 	struct dispc_device *dispc = tidss->dispc;
 	struct tidss_crtc *tcrtc = to_tidss_crtc(crtc);
 	u32 hw_videoport = tcrtc->hw_videoport;
-	const struct drm_display_mode *mode;
+	struct drm_display_mode *mode;
 	enum drm_mode_status ok;
 
 	dev_dbg(ddev->dev, "%s\n", __func__);
@@ -111,6 +111,9 @@ static int tidss_crtc_atomic_check(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
+	if (drm_atomic_crtc_needs_modeset(crtc_state))
+		drm_mode_set_crtcinfo(mode, 0);
+
 	return dispc_vp_bus_check(dispc, hw_videoport, crtc_state);
 }
 
-- 
2.51.0



