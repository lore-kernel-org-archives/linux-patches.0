Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EB58801;
	Tue, 30 Apr 2024 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476037; cv=none; b=hVD6Bxn18lfxRgFCN41a5moHuT8M9hJUhEoUUvydZwjcD23dUA3WcdL4zBfIlKttMsOJu7FwCuzMQLXLgpLQB1f2g/U8lcQaMXoMZzLg3HhjwhGCPjUx2n9eGtSKZCqB3krPgvuxfiXcGhr+LgAbM8rhRUoQ0p7idJm1xJI3jG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476037; c=relaxed/simple;
	bh=kQHtj4+xmjX0cyc6cCJDcGhWCCiP5wKos6hEpQ8MOhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtFWkBSKRmvcOFWpU+OIf86opJMEFUTEUEYoOn8SnOEsqD7hLqO7EC93SxCD7AGmYVHIEEOBLHFe6kZoKVcIRHfu2SOzh3oRtIoTnKiKDG3vO6szyY3V9qdKCsFgEupF5NeyM41tZGcdxKu86wELzHdJQRrUI6gefENO+DLKykQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NU/CIGXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NU/CIGXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1197C2BBFC;
	Tue, 30 Apr 2024 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476037;
	bh=kQHtj4+xmjX0cyc6cCJDcGhWCCiP5wKos6hEpQ8MOhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NU/CIGXGKAR1VxodvTogcBw5b77KipBTsEQ/ksHkfaQ5TqJMvjEhDaPwNOa3ZUSvj
	 K59V0oHRaz5nwTrkOf38AisaHpXvAec9YNwarW49j2K13OL/bdsOW4b/W2jB1HpR4Q
	 Ild/iAd5Fp0jeHeZaVgmkb8k249F/Dot0WDL5YF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.4 015/107] drm/client: Fully protect modes[] with dev->mode_config.mutex
Date: Tue, 30 Apr 2024 12:39:35 +0200
Message-ID: <20240430103045.111905028@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 3eadd887dbac1df8f25f701e5d404d1b90fd0fea upstream.

The modes[] array contains pointers to modes on the connectors'
mode lists, which are protected by dev->mode_config.mutex.
Thus we need to extend modes[] the same protection or by the
time we use it the elements may already be pointing to
freed/reused memory.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10583
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404203336.10454-2-ville.syrjala@linux.intel.com
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_client_modeset.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -700,6 +700,7 @@ int drm_client_modeset_probe(struct drm_
 	unsigned int total_modes_count = 0;
 	struct drm_client_offset *offsets;
 	unsigned int connector_count = 0;
+	/* points to modes protected by mode_config.mutex */
 	struct drm_display_mode **modes;
 	struct drm_crtc **crtcs;
 	int i, ret = 0;
@@ -768,7 +769,6 @@ int drm_client_modeset_probe(struct drm_
 		drm_client_pick_crtcs(client, connectors, connector_count,
 				      crtcs, modes, 0, width, height);
 	}
-	mutex_unlock(&dev->mode_config.mutex);
 
 	drm_client_modeset_release(client);
 
@@ -798,6 +798,7 @@ int drm_client_modeset_probe(struct drm_
 			modeset->y = offset->y;
 		}
 	}
+	mutex_unlock(&dev->mode_config.mutex);
 
 	mutex_unlock(&client->modeset_mutex);
 out:


