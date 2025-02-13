Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF99A1422DD;
	Thu, 13 Feb 2025 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458647; cv=none; b=jh2n9tZETqQDNBh+zJdE8+hQIfy02hRyG6JqVkxz6YB5wzMXqvzqMLy4jNuaKIKyLRwHs0YLKHmdfYBe1jWW6xfAXPSUFpcdRrFUL0PQownSAUZL10cDq3L1P8I6A+gedRQjXt5hoByS6i+/BZLee+dVYd9hvoGScVyU9YswTM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458647; c=relaxed/simple;
	bh=STYhixLmwO27ci9w/e4ZRCHiufZy62V/Tfl8+BamFE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fuk20iN2HLpShSESNQTCIyHmyJFLbUiSWQejYRIktBiir807k800yCZ8Q8Kgns1lV83tCLM2H3qa9GeMrPk7mG8yWddhEJdAKqe+dbpd2lChdHm06iurAO120gLCqGH7ZXkbFa6wUlcOY/9E6AY9z0VROvFg4VdRpe5MLLQsNDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSz+ldua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSz+ldua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A16C4CED1;
	Thu, 13 Feb 2025 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458647;
	bh=STYhixLmwO27ci9w/e4ZRCHiufZy62V/Tfl8+BamFE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSz+lduaDlswA6m/ExccxHKybMptdrCHDXLklBOMsLa4Y7qA9qXQVjUpnEQsjXHej
	 52BqNcX8Lf9oP0vMBZSjwHQDIxgMtjUzz3Z+XGC14bUHBss5Nw0PxiCQw1pSeK9FIu
	 3HhfG8Ei4XLw/pnvoUfgGiVHjLcd1i1seX98zCVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Raphael Gallais-Pou <rgallaispou@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 039/443] drm/sti: hdmi: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:24 +0100
Message-ID: <20250213142442.133768564@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e99c0b517bcd53cf61f998a3c4291333401cb391 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Raphael Gallais-Pou <rgallaispou@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-9-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 21b46a6465f08..f8bbae6393ef8 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -1225,7 +1225,9 @@ static int hdmi_audio_get_eld(struct device *dev, void *data, uint8_t *buf, size
 	struct drm_connector *connector = hdmi->drm_connector;
 
 	DRM_DEBUG_DRIVER("\n");
+	mutex_lock(&connector->eld_mutex);
 	memcpy(buf, connector->eld, min(sizeof(connector->eld), len));
+	mutex_unlock(&connector->eld_mutex);
 
 	return 0;
 }
-- 
2.39.5



