Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9FE7464;
	Tue, 30 Apr 2024 10:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474751; cv=none; b=DJ7HPg4FlW7N5d/SKwSJ5Yjjf3ZucOhSf8k75LWecUVF26cR6ieHrci8L7jujMS4V/jVYRiU/wt2fDAUuku6QrCdFpzU+yoyMQ+VSokm7EvUDHHn0yd8b6gExFHJD7fzm7XXkwf9ls41/SfdvBr900Cxmobg2XYcgPPWpS+zyrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474751; c=relaxed/simple;
	bh=VQwxaojVVd/bazEu8DoxVssDDCghBUuMOXY/mugBkiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IECYugRZMI5bmyp1O2IE5eDE/xCkWn/8J1RNMEhKbnas3PT5IGdfamSh6AvYGKxP1OpcqcZWQCTKb9hf0OOuW+fnoYpNXTC2DPHGpZX+HIPRjenK4PV1pBYrrTbOovZoyPLnEtlDO4k/H/3fg3+lKpzxtat7kXrBl32eZYVfWyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+1HHmC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+1HHmC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031CFC4AF19;
	Tue, 30 Apr 2024 10:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474751;
	bh=VQwxaojVVd/bazEu8DoxVssDDCghBUuMOXY/mugBkiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+1HHmC8833sL4E3EagOKGEwMFfcB8VBVOrFVDfcsQ55quS7gjKfWqD40aGFTRL4k
	 YvidHBsWZUtyOTLhsJt/oFCY62t8BsU72e1sf6RVlBRETjFvJdMLjsuX0kU2lAIYei
	 Kdo34sUvZqBkTn9AU9O0yYCuboZF2J4jCzvFK35Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.10 024/138] drm/client: Fully protect modes[] with dev->mode_config.mutex
Date: Tue, 30 Apr 2024 12:38:29 +0200
Message-ID: <20240430103050.140206923@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -774,6 +774,7 @@ int drm_client_modeset_probe(struct drm_
 	unsigned int total_modes_count = 0;
 	struct drm_client_offset *offsets;
 	unsigned int connector_count = 0;
+	/* points to modes protected by mode_config.mutex */
 	struct drm_display_mode **modes;
 	struct drm_crtc **crtcs;
 	int i, ret = 0;
@@ -842,7 +843,6 @@ int drm_client_modeset_probe(struct drm_
 		drm_client_pick_crtcs(client, connectors, connector_count,
 				      crtcs, modes, 0, width, height);
 	}
-	mutex_unlock(&dev->mode_config.mutex);
 
 	drm_client_modeset_release(client);
 
@@ -872,6 +872,7 @@ int drm_client_modeset_probe(struct drm_
 			modeset->y = offset->y;
 		}
 	}
+	mutex_unlock(&dev->mode_config.mutex);
 
 	mutex_unlock(&client->modeset_mutex);
 out:


