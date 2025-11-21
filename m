Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728BA34DB4B;
	Fri, 21 Nov 2025 13:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732550; cv=none; b=FrV3AOfJtBi9OnAjGYJYs/XoTOfSngEN2T4wCJMGv6w2Tj4gPnO8fkiR1XJAf9IjFu8ctHn9v0VTPYkg2VSt34Ao4mzgAs3yehezIkE+57aGoK3karz5Q9icgd675IWTRnwWLXgQKmxG05xoccy+tMrwRBSQyn5rJWUNHsFRgeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732550; c=relaxed/simple;
	bh=xZgN8RbGaxsS1GcvStDNyWaPNJuHjDIMuV0+V0ZhM0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax5fKLDQg83FDMX1oPP+Pv3kORvL4Z03h/66jSLc4QpQQNqI0vWFew9pU5oIM+sJwPmJyX2BAnLPUmsaC66ld59pvJkgNTIw46A+3TmPNcub8DRvUSrADWS7NJbmYN5ifpUT9IuOyuqWI78doUaU4oF4ZAQ7d/SshHLcl0+yHtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaULRCsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaULRCsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0351C4CEF1;
	Fri, 21 Nov 2025 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732550;
	bh=xZgN8RbGaxsS1GcvStDNyWaPNJuHjDIMuV0+V0ZhM0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaULRCsFc03K5dxUQC6fDcD86zC8Woo3A2C+rgdoQW95nl2RG2bSSEKVerTD4uDKL
	 U7tdHSCQI+/OgokgYwPHOdrlN+lYbxh//+TLA3+NEmElWceATlitZp4KUlEQM4cZKE
	 WHH8sXLPpYGypr6CsotW0n06ZWjzpehr3JfvmQ0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/529] drm/tidss: Set crtc modesetting parameters with adjusted mode
Date: Fri, 21 Nov 2025 14:07:12 +0100
Message-ID: <20251121130235.751252550@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df177881b9d32..356b7566013b1 100644
--- a/drivers/gpu/drm/tidss/tidss_crtc.c
+++ b/drivers/gpu/drm/tidss/tidss_crtc.c
@@ -91,7 +91,7 @@ static int tidss_crtc_atomic_check(struct drm_crtc *crtc,
 	struct dispc_device *dispc = tidss->dispc;
 	struct tidss_crtc *tcrtc = to_tidss_crtc(crtc);
 	u32 hw_videoport = tcrtc->hw_videoport;
-	const struct drm_display_mode *mode;
+	struct drm_display_mode *mode;
 	enum drm_mode_status ok;
 
 	dev_dbg(ddev->dev, "%s\n", __func__);
@@ -108,6 +108,9 @@ static int tidss_crtc_atomic_check(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
+	if (drm_atomic_crtc_needs_modeset(crtc_state))
+		drm_mode_set_crtcinfo(mode, 0);
+
 	return dispc_vp_bus_check(dispc, hw_videoport, crtc_state);
 }
 
-- 
2.51.0



