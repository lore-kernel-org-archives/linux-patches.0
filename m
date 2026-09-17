Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF33E4FD7B1;
	Thu, 17 Sep 2026 18:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668686; cv=none; b=V7VVPSnhUMTJYV0PWJmMalL+yFBOoh92y5cGBVLhPpZjDAbj4fIPMG/pmUxp40BFVKR7a8CE7sSOW1zWiebE2mrQTx0Hf6scQ+du2QDY6hAlx0nYCQNtCtNkfpS0PPjD+ZUdag21iPF6H1JDAsDRY5KAKK6gokr/jV7+0Hu1kYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668686; c=relaxed/simple;
	bh=9k+z8Z8UZ3xyyT+OuEdRvprzk4ugpkTA6obmitz8fzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSwm44TkZ9Q+3H284poblefTpmXW8RGdh4XTFYZaYoXnoXYyEgPtxBEnJnkNKwdUUTc8MQqHPG03NuhfL8rzLzWiX4xyuYOeTL89H9spcnXWREDqD3eLtb3Y1Ws1gVFUyho+//0HMf/xhWT/ARTOV8agX8nAbrphHN3kUiFaU5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9YknXN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9YknXN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88D11F000FF;
	Thu, 17 Sep 2026 18:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668684;
	bh=OSIqgDeHeYK/eLRzzNr3VoIaJ2YvlLXqn/Qqp7PE7nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9YknXN1akuzNS+X/ClIP0fXNmYtE4pEgqjimGss1KplYQ8Fp5qO1QIfJ9LcjrhLt
	 eW10qVGsrZlX22OiTCHkBeBcH7+ZiZcrNxSPFMStGhNovmsd2u8OZnrZQWaK5EQCfD
	 +pCIg8T3X93mGIGgBx3l0nyqvxuUmWHvPJMYbfcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0505/1102] drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()
Date: Thu, 17 Sep 2026 16:07:28 +0100
Message-ID: <20260917151552.415850968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 64baf2f22d9f0..9d4fcf2b6e878 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -318,7 +318,7 @@ virtio_gpu_user_framebuffer_create(struct drm_device *dev,
 	if (ret) {
 		kfree(virtio_gpu_fb);
 		drm_gem_object_put(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &virtio_gpu_fb->base;
-- 
2.53.0



