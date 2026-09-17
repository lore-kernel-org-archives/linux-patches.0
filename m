Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F04CDDE5;
	Thu, 17 Sep 2026 15:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658806; cv=none; b=njorsohlpsgfhip+gE13fM6o/6fY+zpZ85Sgm3cFrRI8QFh0Ha0I99X5sXao5Kgjstk/STfacvLrMwWpc6aTXULFZCzorKl9umlPnGRo+xWSJBE0nxJgXRo9KykCOHJwu7JMTxj4Tv0WVV356J2iU8hq4AR0loOHMZgzEWgdhQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658806; c=relaxed/simple;
	bh=V7leTAdBBjMHkF/Nq8jCIrql7zFQQK4H/vPfFdBQAx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qt39EoBsK0/cnMbZ8GjsDsenumjOCyHgpqCbjJIsk0U67+XbC1BuA4TfZ6T0U1TYYGzILzITfqCyyT1bIXLFc+8rFSHeN0470O30Vr8Xk9Ac1B3HlSDERZqWvXSvuO7lvUw89hPgN6zxpHq9lxslXvgihvYr8P/AKOyzWG1ojn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEueiRyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEueiRyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B22A1F00893;
	Thu, 17 Sep 2026 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658796;
	bh=o4ikCmuudoxY5Es4Y0Vp4mFX98TwCfC1am1h31r/sEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEueiRypWTPLnbrct6Kh/zi9H0SC2Ca2dSYqsjxzqwv4O6iizY3yhgH+cL2weTLxZ
	 nMncNK3sBRZ5v5L7+NbQrlBMPrLjU2GrWxUOTaOMPcIsAqLI25qV1Gia/BVhF3Qvh/
	 hIVdcqMkDeFzHVuFLarrT3cy9MH5yNFp2wINFpHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 012/733] drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()
Date: Thu, 17 Sep 2026 16:05:20 +0100
Message-ID: <20260917151350.957953267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 94579f24e2b526a04eb41050af0ba018c6f528e7 ]

Smatch complains that returning a NULL here will lead to a NULL pointer
dereference in drm_mode_addfb2().  Return an error pointer instead.

Fixes: dc5698e80cf7 ("Add virtio gpu driver.")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/an1tWfHIHwtXd9SO@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_display.c b/drivers/gpu/drm/virtio/virtgpu_display.c
index 44ffffec550fd..85ea252c658e3 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -344,7 +344,7 @@ virtio_gpu_user_framebuffer_create(struct drm_device *dev,
 	if (ret) {
 		kfree(virtio_gpu_fb);
 		drm_gem_object_put(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &virtio_gpu_fb->base;
-- 
2.53.0



