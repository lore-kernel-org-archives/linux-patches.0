Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BF576F17;
	Mon, 15 Apr 2024 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191398; cv=none; b=tUOPx57CGUjBzB6RDC0b9+xM+6Ez0GC3PBKcHRecd+szD05ZwsKCANKp6Rni1MLPcsee9ypGxbRkVLztL+HP1zDOLL0HeLwqDVwb3w2me5zsBsWktGexd/+G26Iw6f5PmZ3tcZUWMZOTrTf74vmTCcOE7qNEjOFD2UtgmT7n7wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191398; c=relaxed/simple;
	bh=1clrBa0pM35up35uO1AL3aYpjXMK8AL8DABVP87BoEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBjrQGCq3/5rl3Jq6nZaVpYA3TxDsxIzVECwcUZSHQ6UBl2vV4nEWQDoo/lhE0dHiZcUeUd6u6PhEopHFryWNEoSlXueLhut6Ac0QcKz5kjMAsWKBOSN/h4yqTY7b1/bQ0gyBVebFnIj+A7PrM7Zjc9380Ns++Tfvwqp0/u/qoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivtzzWDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivtzzWDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1E9C113CC;
	Mon, 15 Apr 2024 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191398;
	bh=1clrBa0pM35up35uO1AL3aYpjXMK8AL8DABVP87BoEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivtzzWDptJv1q9CUI7w6v7MzBcFEFxeF0K63QLmkoldkXg2HxJ2cgpWx7ITDHnKvL
	 ++2nhn9PVA8Wg6LfUGR4dJe/iyebC/xMVpojF1x4WOYDH9DfFq2MJVSQ6fRvtbLjdB
	 XOj2CzhpNMy15l5Y9/Hzz1Uyp/OUSRk7HTaMVzLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.8 128/172] drm/client: Fully protect modes[] with dev->mode_config.mutex
Date: Mon, 15 Apr 2024 16:20:27 +0200
Message-ID: <20240415142004.272102048@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -777,6 +777,7 @@ int drm_client_modeset_probe(struct drm_
 	unsigned int total_modes_count = 0;
 	struct drm_client_offset *offsets;
 	unsigned int connector_count = 0;
+	/* points to modes protected by mode_config.mutex */
 	struct drm_display_mode **modes;
 	struct drm_crtc **crtcs;
 	int i, ret = 0;
@@ -845,7 +846,6 @@ int drm_client_modeset_probe(struct drm_
 		drm_client_pick_crtcs(client, connectors, connector_count,
 				      crtcs, modes, 0, width, height);
 	}
-	mutex_unlock(&dev->mode_config.mutex);
 
 	drm_client_modeset_release(client);
 
@@ -875,6 +875,7 @@ int drm_client_modeset_probe(struct drm_
 			modeset->y = offset->y;
 		}
 	}
+	mutex_unlock(&dev->mode_config.mutex);
 
 	mutex_unlock(&client->modeset_mutex);
 out:


