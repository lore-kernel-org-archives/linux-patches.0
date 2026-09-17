Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33264C10C4;
	Thu, 17 Sep 2026 17:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665270; cv=none; b=f5QWOkbzpYM08rLSgmgDA3sITh83ne80D3Xo5VYNhS/KgBXX7fngi0pvxZwpaZzP7tJqpwDXK000Sioj+R0awDtYJEiSRCTvS9TKfd/bv+atBBtCzsQwJxb+Vr9YKGMiBeAx0w1cD5oi+atFKtmcmOQM87aziQNzmc6Kfid12Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665270; c=relaxed/simple;
	bh=wqnlD8FSqQCx21vSIvEBBygcjURMsHQ/z/dS2wwG5iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POfcY+oohWfEc2JjCyTozDzDHLY0ZaA03mcJg3dxm43uLXZBd7ni3Uy+B7IXp7iy8CZ8gxcv3ONpeko9pepMmVWhiQIY3kAFamNuVHSWeh0KV3AeVLO64I2RyAlgxYz9rjc25hA/YlEHun5m4W/0F8N60g0G/bpVHwMzN12fMV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vb1G5/yr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vb1G5/yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB771F000FF;
	Thu, 17 Sep 2026 17:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665269;
	bh=3yw7bdxOYQcPBV6vogeGj2ImaGfDb4GPPwoORX7TATg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vb1G5/yrOHcfKrseDYF6s1saYEZBz6vjPPa83Xp75YaEq3IwszgaR5yzw7VdfX2Cz
	 klKu3Grpc5UL8acs+HaWQDIv8J19Rzx2Q1Qof4lqJOrZemY+FvVr7GdL75JTktWzkF
	 AIgdMvSoMyltOqxP5mqycmexjMO9v9E3bTcY7CB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0606/1250] drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()
Date: Thu, 17 Sep 2026 16:06:41 +0100
Message-ID: <20260917151608.301020153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c3315935d8bc4..e265a06f2c06a 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -319,7 +319,7 @@ virtio_gpu_user_framebuffer_create(struct drm_device *dev,
 	if (ret) {
 		kfree(virtio_gpu_fb);
 		drm_gem_object_put(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &virtio_gpu_fb->base;
-- 
2.53.0



