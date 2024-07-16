Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437AA1DFF7;
	Tue, 16 Jul 2024 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144337; cv=none; b=Ka9h3ZXH+QHXBxTqWMLzC83InX0jUqlbw8y2gqThINOroDmyFrii+6Cgp5tFxeMFwmBQjadVPD+opnCZnsIZ6KGvk8rz/zf0f3B93yjjbPPJow48zINKLqP63qhB1dKF/HLc/jR/S35UCv6ODJvTMeH4CQNTFMu4CeFNnG1tuiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144337; c=relaxed/simple;
	bh=rRdzPznRmuau2UKUTdjCT/whoeyrV/8+2Vs/P5dlwSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdiOzCkqCgGEcHpi1BI3O72RJE7nsTbbI6I8SwIEkXfs7R9T5lK2af0qCHwV674O21LmYzDrvHH5lye4+zvoSnMQCxq6tuhwnnJzEAOXmYA/VSqtS2SdnW6e+TqOdXMcns1QefPfe+wh/zFiwjxgdoKmiajsbS4j0Ihv7r7ECEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RU9hwOvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RU9hwOvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60503C116B1;
	Tue, 16 Jul 2024 15:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144336;
	bh=rRdzPznRmuau2UKUTdjCT/whoeyrV/8+2Vs/P5dlwSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RU9hwOvhnnVleiE+QV+m/602vRJBvbXg8QUINfy9TDAXMMVp7lcosrwHyfnKY+xvE
	 b6ZbDhwi9ktbNivyWoRhxy0MOSTHBbLvGyJCH695HqsTgpMsot9OW4wu28Yuv2Vsw2
	 TfhQcm5vQkFurZdv48H6FFK2uOKT6iskCax+7fVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.4 38/78] drm/nouveau: fix null pointer dereference in nouveau_connector_get_modes
Date: Tue, 16 Jul 2024 17:31:10 +0200
Message-ID: <20240716152742.111709289@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 80bec6825b19d95ccdfd3393cf8ec15ff2a749b4 upstream.

In nouveau_connector_get_modes(), the return value of drm_mode_duplicate()
is assigned to mode, which will lead to a possible NULL pointer
dereference on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 6ee738610f41 ("drm/nouveau: Add DRM driver for NVIDIA GPUs")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240627074204.3023776-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -968,6 +968,9 @@ nouveau_connector_get_modes(struct drm_c
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(dev, nv_connector->native_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		ret = 1;
 	}


