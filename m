Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911333264C2;
	Wed, 30 Sep 2026 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791256; cv=none; b=RRvQr7uoSP3pQsrWBsc88e2wg0nq6EWecKgu+aU0VRootqXniJnqhW8XQR8gJFXTybGsY0hBvMNkTC3XjYtYjauuFLCO8amVzF2gHIP/rm1MjhphMtIpE1+g68duwRSUhpjAFM2RFMmrvThkElUakQZ/STtfXbw0hdqbtXFX/7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791256; c=relaxed/simple;
	bh=iHXvUZjxSWWsDfY19QTHFSsU0KqmuM5RQ5RSnPQLjA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b63sztWiAolEopV0gNIGEw9EQqiuLuElAhy27gjWDqv2qLVt0McBCNn+I3QnQwsn0vZIpWUfQfo74o46LnxGGk/YGZkS8ig//dO9Eqa+pgNy4ZimmYd9uRahc6q9FNzh3y9gUCiFgyp52glpnhGEuZ6XVPhsFeB1iqf4B991Rhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff9x08X2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff9x08X2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6CF1F000FF;
	Wed, 30 Sep 2026 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791255;
	bh=gl0IXrtmFk5DaG5ohpx7pbDavJYOQEXsHgJd2LMUYyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ff9x08X2EYV6LxzOLsOBVy804T59SFmnMr0KtYWGRc3ORyVgyFBZCgrDwJJ3mo3Sf
	 QJbR2kMwzcPKVPpwS47RnGKK92bJzQQA2IU9fHYStwlqEjuDEORcxmcvif/FT79HTk
	 l0LGIPllYB6FXrPZGPHk4STtH8iru2Spj6o8EZ38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/752] drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()
Date: Wed, 30 Sep 2026 17:21:49 +0200
Message-ID: <20260930152403.439420014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ef1f19083cd31..438c3fab0e147 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -317,7 +317,7 @@ virtio_gpu_user_framebuffer_create(struct drm_device *dev,
 	if (ret) {
 		kfree(virtio_gpu_fb);
 		drm_gem_object_put(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &virtio_gpu_fb->base;
-- 
2.53.0



