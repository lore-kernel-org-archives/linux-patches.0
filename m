Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C984EA39C;
	Wed, 30 Sep 2026 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784925; cv=none; b=m0VpYFrONw3gz5EJLA4SLsRPoCuiDM2Qr4BOP0ERuThHRYzHM3Z7FpDzICYgAaWK0MdLZpFWXh1TDf2ZPazd7ZAYejOxZncesGjV7luJTTckq7F6Fui3/Lv08Lt+d2UGItiztE3b1JlHnFB4EF7ivLrBJ/w1D/c5oE2xY542ybc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784925; c=relaxed/simple;
	bh=qMnZXOsOyNkVOWcoN0wSPa7m/jjSpZZElNf9wYpGD1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/dFihDT7IDav5oqexJ3QWLBkf8cV6xwJCg50LiDUN1kawD0mXnIRrWY8k43nJQvcGe1OfdU6VBAuAtepR3qRyslV63ZGqhDr4/frAe4rqqYCl5otVMe7IeYDA+EZYsE8sf8DAnZuYMgXzuy8Ttst+x5tD2i5hqcXjj4FaJsGFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qi3xgB64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qi3xgB64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31D51F000FF;
	Wed, 30 Sep 2026 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784915;
	bh=zjIyIU85C73Fh40V6jYTVUgHjJVdjw1AhEmievV0K3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qi3xgB643wU4pAtMQEwUg2U9HI4YPNUvf2GtH953zaZh+Z79zXEftpZIMfjWK6vGw
	 5mHQhXynGukyTlEuXJuTlxPGYzKmZK4dqWmDm2kTRjD75EEHry4cMPOJjQ7/n+Dkqm
	 hxUADTFO9gO2peixTHSngA/gawj4+DBHTEs+FRr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 324/982] drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()
Date: Wed, 30 Sep 2026 17:17:40 +0200
Message-ID: <20260930152423.778488792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9ea7611a9e0fc..77d52d7e3a39c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -320,7 +320,7 @@ virtio_gpu_user_framebuffer_create(struct drm_device *dev,
 	if (ret) {
 		kfree(virtio_gpu_fb);
 		drm_gem_object_put(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &virtio_gpu_fb->base;
-- 
2.53.0



