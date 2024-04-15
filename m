Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44CF1EEE3;
	Mon, 15 Apr 2024 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192072; cv=none; b=ipaQERdlyF//+zVhc1H0t5ZC/XQBEHNv58oE719Su2QcpTzEwqNPkTuGNVkg1ZumG98tU7k4wGIok7X0dnwS/mp0+tXAtLRUfrdBgiJU5SbmGJ87z+RoNqHYChXoaLCwf+b4DpUwr8DO4A4vvZrHenw22l7WhPytY/WntcY1WwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192072; c=relaxed/simple;
	bh=n1UQAQ1zOENItXC+6ZfRtbg4OXsKXR3+TdyFObjj2vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H9ElOqgY9nOkFP9MTVjGZ6mSEFtoKkTWUWy0xyDo5cqNK/GkygeepqIFew0HY39NKo66nUhSr3he6fA0KntmMXibi0+BF68slY0BxJvSuX6stUtMknJ6X1HX+xxkipENiPc+kMDRbZGSGarLmKwyTDkfqrODtY8QBZS+xoThMWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9nCOXyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9nCOXyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F42CC113CC;
	Mon, 15 Apr 2024 14:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192071;
	bh=n1UQAQ1zOENItXC+6ZfRtbg4OXsKXR3+TdyFObjj2vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9nCOXyZZKXbZG9dsYAnomGSkIgs6Xy0E9+ls/WOhT0Hn8BIzaetCk9DY7tGsGAXr
	 V5sx8tMsYJXYk9sFStuaekL1BJ1Ao8zks8nMf01q2DrHlGWmc+K93i4A5NJdspa9Ch
	 I84Z5V8Di+/OmBs6kmW7/mooRiZeOoCiP4SEdacc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.1 49/69] drm/client: Fully protect modes[] with dev->mode_config.mutex
Date: Mon, 15 Apr 2024 16:21:20 +0200
Message-ID: <20240415141947.644741671@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -781,6 +781,7 @@ int drm_client_modeset_probe(struct drm_
 	unsigned int total_modes_count = 0;
 	struct drm_client_offset *offsets;
 	unsigned int connector_count = 0;
+	/* points to modes protected by mode_config.mutex */
 	struct drm_display_mode **modes;
 	struct drm_crtc **crtcs;
 	int i, ret = 0;
@@ -849,7 +850,6 @@ int drm_client_modeset_probe(struct drm_
 		drm_client_pick_crtcs(client, connectors, connector_count,
 				      crtcs, modes, 0, width, height);
 	}
-	mutex_unlock(&dev->mode_config.mutex);
 
 	drm_client_modeset_release(client);
 
@@ -879,6 +879,7 @@ int drm_client_modeset_probe(struct drm_
 			modeset->y = offset->y;
 		}
 	}
+	mutex_unlock(&dev->mode_config.mutex);
 
 	mutex_unlock(&client->modeset_mutex);
 out:


