Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FBE3AFB19;
	Sat, 12 Sep 2026 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238110; cv=none; b=hUqnoCF8UNsgztzVVKRA8R+f1W/GjNZ7VwHhWKA701740Osd6oernj0xYP5eWn4MQAISYgifd+5V2rAXud7yn4Rpdyc5o9PWPdUx4UbIUjt2WIyPDiVQuSqJE5J+B3yqUAbGANMnh4zNtuqeUsHTORn1FCVqYQcP8LAF1iNTIAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238110; c=relaxed/simple;
	bh=qXpHlLeOZMyEGYkSVDFUFesonk/xA0XPmpF7Ny2yC5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvKcegSOm9o6DK7vOKS3iBfntvLMd378+9mSeV/ypjRGRQ+uEpbr2Re8DTu5vnYTqjMOPMC9jxU8SxskEl9ZARwAHKJNYCArN3jv/TIXo0reIdRpLQA1bsmzvuzictE1btc6V5BlD4jlNMNnCA2XspFxlUTgZu0zayEhnNS6cGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugZZNOhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugZZNOhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E851F000FF;
	Sat, 12 Sep 2026 18:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238109;
	bh=Th3CFb3HeIeeG16gFVPrFzpJ1bcOTv2CJaAhPHtQBjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugZZNOhq+Se6n0XMeBSH2e6LyDfbBtmQoLAXXFOTuAl2dkjQIi7S3GcIu86DN5aIL
	 mPOaTmZJXL4NF8sHnGj0kn4qzm/ByWA6uar6QwoaCt0OqnoIf1RlUZ5XZlWsr9H3nM
	 dF4opyP6wfnmtbHwg2C23fZ3FUgk751CE0jqREIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/935] drm/bridge: cdns-mhdp8546: Return an error pointer on allocation failure
Date: Sat, 12 Sep 2026 08:57:03 +0200
Message-ID: <20260912065535.836153309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 30ac1d403438a6c6039f0af5bb2df3d021f96036 ]

The drm_bridge_funcs.atomic_reset documentation states that the hook
must return either a valid drm_bridge_state object or an ERR_PTR().

The cdns_mhdp_bridge_atomic_reset() callback returns NULL when the
allocation of its state fails, violating this contract.

Return ERR_PTR(-ENOMEM) instead.

Fixes: fb43aa0acdfd ("drm: bridge: Add support for Cadence MHDP8546 DPI/DP bridge")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # imx8mp + sn65dsi84 + bridge hotplug
Link: https://patch.msgid.link/20260619-drm-no-more-bridge-reset-v3-2-ff399263111b@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index 0d523812afd5a..86cd6ccee3171 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2143,7 +2143,7 @@ cdns_mhdp_bridge_atomic_reset(struct drm_bridge *bridge)
 
 	cdns_mhdp_state = kzalloc(sizeof(*cdns_mhdp_state), GFP_KERNEL);
 	if (!cdns_mhdp_state)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	__drm_atomic_helper_bridge_reset(bridge, &cdns_mhdp_state->base);
 
-- 
2.53.0



