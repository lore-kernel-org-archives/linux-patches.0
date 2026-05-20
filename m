Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B226A369D4C;
	Wed, 20 May 2026 16:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295509; cv=none; b=kIjT/WOkyzrzshGXNM9RG4DmVTtzZnf6GrzRkxAAQEDr5y01GbwBMLZgHjaNN5KJedB78z9J9xjy44sqZ93xIlrcCb/YpnWMCipNtj9/W9QlrAj43A4Tyu50YRAghatSvii71ZT+F3W0SjGg1AVRLxMmLbxeHFf2+lwjf8g3bcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295509; c=relaxed/simple;
	bh=Wl4llWjACVR2WMC6BcVC8h9Evee8mdVyKlvdv2wMUEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntNZHddtcnt+7S/mk/NgiA1RNxeYSWcDX4zsMX/4zGHBYFe4Fc0m82KEujs9WAjAC3159pKgbcaD4V4vAbfMGswtcDkebFgqhRl/F4amvZ/BpohDThb5JiqOmhN08QaSAM3mQRKqYgrK4mFA06Is+nyPF+n4fKmIfndCLiuhhHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwoXKFFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwoXKFFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCC41F000E9;
	Wed, 20 May 2026 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295508;
	bh=G8UQkiU0k+LK78dOgHrENAjXEpB/VAT5WFh62JFJsGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwoXKFFaces6vIFcq+cMjbRAoeqCwDFzo8CChSG2wr8h/8wKXz0hMQHKlhF0SxQCg
	 SeFgfsIhLtvrYzLPuP/xZEpZ45+lgnesJpzWYC8oDIPJGU4dqlWUvWh5eyy19k7h9A
	 qjxfEsnC62Oj6lCqfngzomS/sHPz6bGd7zQ+Zudk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 7.0 0429/1146] drm/fb-helper: Fix a locking bug in an error path
Date: Wed, 20 May 2026 18:11:19 +0200
Message-ID: <20260520162157.898362793@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit bd64240dc88caaf7b96dd869f36f165f51b52039 ]

The name of the function __drm_fb_helper_initial_config_and_unlock() and
also the comment above that function make it clear that all code paths
in this function should unlock fb_helper->lock before returning. Add a
mutex_unlock() call in the only code path where it is missing. This has
been detected by the Clang thread-safety analyzer.

Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Christian König <christian.koenig@amd.com> # radeon
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com> # msm
Cc: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 63c971af4036 ("drm/fb-helper: Allocate and release fb_info in single place")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260403205355.1181984-1-bvanassche@acm.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 05803169bed57..16bfbfb0af161 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1641,8 +1641,10 @@ __drm_fb_helper_initial_config_and_unlock(struct drm_fb_helper *fb_helper)
 	drm_client_modeset_probe(&fb_helper->client, width, height);
 
 	info = drm_fb_helper_alloc_info(fb_helper);
-	if (IS_ERR(info))
+	if (IS_ERR(info)) {
+		mutex_unlock(&fb_helper->lock);
 		return PTR_ERR(info);
+	}
 
 	ret = drm_fb_helper_single_fb_probe(fb_helper);
 	if (ret < 0) {
-- 
2.53.0



