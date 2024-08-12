Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E6218732B;
	Mon, 12 Aug 2024 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478961; cv=none; b=G1QM+LA/IgQl6oZWyLKn0uoZje5ZEYv/SLju2Av62Nl4O6QRdeCjQ29U5A0I5Nhso77cbr9S8mRDRnTJTVX+M+yhguKxaecM07oAGk0G1pZkkCQ42nLXC5yysHYLyPKJYPZqcdegBKUvaZsf4DZORA7SEEvaeC26ZLraK4P99Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478961; c=relaxed/simple;
	bh=J0RfmL7SeI9+Q5W7j8XxSHwQsKNddhFBMZADt+Qyz3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiRAKUbWyUsOMhc/4sUEGuSJqhJbNN+1TZd4n0zMHovkNfSVIbBSA+EzU4lIL6B+F3QLNwvnGfiKw5vgUubjJuLOt6FDvL2xxUSI53Yq3Q6gEth61pDbzv2WGl32wobILcs3sReW6lq6xWP3nTe/WJPyQxCmxwM4OxwboeUau8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVikIrHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVikIrHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7669BC32782;
	Mon, 12 Aug 2024 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478960;
	bh=J0RfmL7SeI9+Q5W7j8XxSHwQsKNddhFBMZADt+Qyz3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVikIrHlV1kN3uCDgzGVaBZSFvxtFjZEV7bjTTVyH5wTKHf3KHVJ7ZNW+6arecScP
	 dsPaL2JPmXm3Y9P+Fl8lDC54zs+kpJMsdUWJww7fG9ODE0k8lqaTW2sIjBCaZI9pg0
	 lrzhPuOl20GJLuFi6BPFbK188jPyCgse92QRoLtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.1 088/150] drm/client: fix null pointer dereference in drm_client_modeset_probe
Date: Mon, 12 Aug 2024 18:02:49 +0200
Message-ID: <20240812160128.564123328@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 113fd6372a5bb3689aba8ef5b8a265ed1529a78f upstream.

In drm_client_modeset_probe(), the return value of drm_mode_duplicate() is
assigned to modeset->mode, which will lead to a possible NULL pointer
dereference on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: cf13909aee05 ("drm/fb-helper: Move out modeset config code")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240802044736.1570345-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_client_modeset.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -873,6 +873,11 @@ int drm_client_modeset_probe(struct drm_
 
 			kfree(modeset->mode);
 			modeset->mode = drm_mode_duplicate(dev, mode);
+			if (!modeset->mode) {
+				ret = -ENOMEM;
+				break;
+			}
+
 			drm_connector_get(connector);
 			modeset->connectors[modeset->num_connectors++] = connector;
 			modeset->x = offset->x;


