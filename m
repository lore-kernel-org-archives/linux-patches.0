Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02F3C13D;
	Thu, 30 Jan 2025 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245642; cv=none; b=Q6fFz4kuxC5E8FgO6ip85NflFgN+1Nuuz2tdLyI7hrCuAxh5IRccxEa8qwinXjU5IrkunJWW+5bcFplG8GgLgOOKjoPZ2Dh56Ch7hlp68Bu7+LrUdwItY5gq4fVTU34eY49Cq2vW1pLUXHtwUX2R2DnZJ8qP7hJG56IwNZjGgJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245642; c=relaxed/simple;
	bh=tE+RuztCcSnsQT/2+KrW64cfShqAoYbpkgdrV6khcmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+xGNRwzUWP20RGJNKWsYkWQ/WvxKI/g6tUFWoAFf7aJao7tWJUu2Mk75xxGlZcXxkA+O/7/eBVEumthTJHxYGUolPB6434VfV0kDeoekkViSTMgMpGcRdtL/pCSpZGaM3EUCz9bOhE+PvccywqQPhj3zphakuFiIF5o1ttzzsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWCvSzB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWCvSzB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB89C4CED2;
	Thu, 30 Jan 2025 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245641;
	bh=tE+RuztCcSnsQT/2+KrW64cfShqAoYbpkgdrV6khcmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWCvSzB6fvp+C+z3Gx2S9CwRovwJbx3aCY/zEc9gqcjQrfDdHJij6WDz52ud08cqZ
	 Qacs8hNtCNFe679GtFHr6njiBgdRHIm9eYcof1JEazR/k72Oy2JuYOO4ew2LBpNV2i
	 TKwYWy9xyvqyUyp/XVM+p2BRsAp0tHpnDiqsJPuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 11/40] drm/connector: hdmi: Validate supported_formats matches ycbcr_420_allowed
Date: Thu, 30 Jan 2025 14:59:11 +0100
Message-ID: <20250130133500.163136557@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit f2f96619590f944f74f3c2b0b57a6dcc5d13cd9f ]

Ensure HDMI connector initialization fails when the presence of
HDMI_COLORSPACE_YUV420 in the given supported_formats bitmask doesn't
match the value of drm_connector->ycbcr_420_allowed.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241224-bridge-conn-fmt-prio-v4-3-a9ceb5671379@collabora.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index fc35f47e2849e..ca7f43c8d6f1b 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -507,6 +507,9 @@ int drmm_connector_hdmi_init(struct drm_device *dev,
 	if (!supported_formats || !(supported_formats & BIT(HDMI_COLORSPACE_RGB)))
 		return -EINVAL;
 
+	if (connector->ycbcr_420_allowed != !!(supported_formats & BIT(HDMI_COLORSPACE_YUV420)))
+		return -EINVAL;
+
 	if (!(max_bpc == 8 || max_bpc == 10 || max_bpc == 12))
 		return -EINVAL;
 
-- 
2.39.5



