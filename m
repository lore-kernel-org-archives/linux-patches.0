Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D3B143757;
	Wed, 19 Jun 2024 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803267; cv=none; b=m5LLTLsO6tIoU+tidQayrrHEPh9NRdpnV8csNvuItmTjfsKJlKkX+XyDZxKBVTtwhTl7n3hyyvIHWw+6142+hNOTckCfNlc3DSudq8rbAGAlKXZCVicIRb5XLv7Xdpay9bApwqA54zFznZh8fO79Eo9UAFFCuPh/8yQIWsCjlZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803267; c=relaxed/simple;
	bh=JI0dt6hwEv0HpOh5SHijoZeG16ZilRn4Fr6ohgUklmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeTyygVZKrl1exSSd1b5fTRnCDezEvxkEolUmXOV0TWHzRzhsQY0gD9flgJg/jhodDJLuCu7SFQwwFc4gGVGADtFR2Si0qjR8QhIozjErYW0ZPABdNyXzn92DRuATGwJ0yIgdZpgwSLbqpyEXOa+Y6g9El9EvhVrnfhNQXKqMUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F92fG+ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F92fG+ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A1AC2BBFC;
	Wed, 19 Jun 2024 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803266;
	bh=JI0dt6hwEv0HpOh5SHijoZeG16ZilRn4Fr6ohgUklmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F92fG+ce7AiKMGHUdh8xHzT8CKzpULu6ohUycrPFUiZXjU0fwTbAHbFcx/O878PU7
	 tQrpllciGwHoWpMTUbK5BDWLyWLjk4YtENzczjVHNFKHxNAdcvEq8JdlXfG00LPp2i
	 an1cfNe8UqLVfMWQaW4BUMnU2o9fzEDxfblB4UYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 6.9 208/281] drm/exynos/vidi: fix memory leak in .get_modes()
Date: Wed, 19 Jun 2024 14:56:07 +0200
Message-ID: <20240619125617.955574770@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 38e3825631b1f314b21e3ade00b5a4d737eb054e upstream.

The duplicated EDID is never freed. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -309,6 +309,7 @@ static int vidi_get_modes(struct drm_con
 	struct vidi_context *ctx = ctx_from_connector(connector);
 	struct edid *edid;
 	int edid_len;
+	int count;
 
 	/*
 	 * the edid data comes from user side and it would be set
@@ -328,7 +329,11 @@ static int vidi_get_modes(struct drm_con
 
 	drm_connector_update_edid_property(connector, edid);
 
-	return drm_add_edid_modes(connector, edid);
+	count = drm_add_edid_modes(connector, edid);
+
+	kfree(edid);
+
+	return count;
 }
 
 static const struct drm_connector_helper_funcs vidi_connector_helper_funcs = {


