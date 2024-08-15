Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0921A00F8;
	Thu, 15 Aug 2024 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732292; cv=none; b=YWSEBZoHwy5dVneyb9vkjAaf1v2J46vK10g5/BxeQsDznglmr2thHwQW1+ApzyGDOFLP8I9IRBI1uKRk5A/Ann7bu6RQV2cXB9aWFzUXlaBJAjLFbLyvmx3nZrJpox7ioPV3gOUTiEktosy8obRzauOys24BGHMcFMNCbXE9Uw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732292; c=relaxed/simple;
	bh=hN9x6aaxPNzLfqhPQtNjAfQ1kCglcKFipMKmdS8vTmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXhW4Aa7MJOmUvwoWEWXliOnaaC35CJ4M8RQLvzeRokykSfHIf56jSL9NEd9CiPFSSRmIOOcR+TUtJOa6UETCjXaCWr7Kl0iG+BVvCvgd9CnaNun+9jurlcJS+RqOUQtB35V8Vpm3ENHG6ZtpyO2h94hq3CepaktiZ0bpoMwAUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxSE14MY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxSE14MY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC3DC32786;
	Thu, 15 Aug 2024 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732292;
	bh=hN9x6aaxPNzLfqhPQtNjAfQ1kCglcKFipMKmdS8vTmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxSE14MYui7LlHwPquCyFApKEvDYZ0veaZLuD9SfmA1peXKEb4YCwTqp5w32DTgOb
	 VNsxckmDZVJTo0XaIuQ6fiMifnWRAo5zWlqVuD+3WpXDSD7sd3sHpib+eZCnTtJIrH
	 S4ugKgXwAQIcEwJBnrV7k5OZk71v3ig65Kdr0lPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.10 134/352] drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes
Date: Thu, 15 Aug 2024 15:23:20 +0200
Message-ID: <20240815131924.434070330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit cb520c3f366c77e8d69e4e2e2781a8ce48d98e79 upstream.

In cdv_intel_lvds_get_modes(), the return value of drm_mode_duplicate()
is assigned to mode, which will lead to a NULL pointer dereference on
failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 6a227d5fd6c4 ("gma500: Add support for Cedarview")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709113311.37168-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/cdv_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/cdv_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_lvds.c
@@ -310,6 +310,9 @@ static int cdv_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


