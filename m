Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3B53502A8;
	Wed, 30 Sep 2026 19:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795041; cv=none; b=DqO+4fypHTdbHImCh1MzjFZ7JJpJhM/QsIFvyZ+sG3sQGWWxwiNrLjcju+495DKevUbzpkjdRoMcw8vFQy34ClCW1H0hI0SfUy0WXhIASWEw8Tl5i3+tfqS3juIg6In+ChzdfVjPucW8u6PqF5/4ufB32uMFNpdeAVfaO04W1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795041; c=relaxed/simple;
	bh=xaxUUxxOovd4aLn6LSsvM/0g0CqifF0gqoGWiJfdLZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmBQ6cU572znsLqo3vI2ZGCFQKV9hbZ49cexer+msbq8/0DwhRJSVz9bhm4Cz3LH79ToJi257HZGbjf8B9bc2t5SknUxTUSzHd/paxpHl3I3B5pCzZ2eKDg0LOHoo33uBG+Qu9cB7sjYdAeWJrvcgdRL1AzuiorNzAH6sP1BYVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfRneyGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfRneyGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983611F000FF;
	Wed, 30 Sep 2026 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795040;
	bh=o4N7b/PXFQRUUukXvQaAoKJR4pCUT9NG9YMvTC1tQbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfRneyGU1Xhu7e8SI/hKv+I8XmkmBb4IHtc0vG/I4UOCYFRJktCypstzfff0MPOtv
	 Zuf9xwTCSCQFc1+W2uNU9CnoLdGRNKi35VxsOm24eydB6fu2ZSjNlfjUWa2a6lwvQn
	 rPPfd1xcRdEh48gSJ0u0RtQV4faKSNzSdIMT6ZD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0377/1193] drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()
Date: Wed, 30 Sep 2026 17:17:41 +0200
Message-ID: <20260930152442.554161122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ad924a8502e90..d5cc5e89dbc1e 100644
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



