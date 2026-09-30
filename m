Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575555038FE;
	Wed, 30 Sep 2026 15:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782856; cv=none; b=Yzxvi3QOGDQgBigjsT7lYrgvxcdJS/+brxx0AekGEI71G8GK6OAMs4q76Yej68Jv4RfnylpmDP3q0foXliCJSlesZe734Qo02yThSVUnNseilhxyPoVAdAC9kY6whCllXnfxAAPYwL6yEbxFgQm6sJOU1QuEu662ctktvTu99lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782856; c=relaxed/simple;
	bh=cQ17TLIN/XYB530SXGGe9PjAai02PQH/d9Pvmk0XMSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afODu3B+PmyetUyEbSGsKGwnRs6rz57SVIW/qaHns+PM64xlF/GUBrrrjnRDzMBzJOsjzKXJo7w/PwJUjKjn402B0ZkGdc2rbEEdqp1No6IsBeLvIWFKo49SdsbSJX22mYs6q9LQI+KzJ4sbybwmhKXPI4BAtWsXESoTZ+yQMJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zg6DdZLp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zg6DdZLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058251F00893;
	Wed, 30 Sep 2026 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782851;
	bh=ntaklDuWBbE7CwAA7oEtW1HVqD88ZdW0Ek4ihN9vwCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zg6DdZLpz6jbvozrJXsfCvfM0NkT8/TJwqjJmH6sbwMRmXf42y6rdwUOR9lpB0dNs
	 gX6WrPsYG1jk5vmCYyjB+LtRVsroepQmKOxkVuQP6dDGaiG7KdYp1DdtECtZlPHJuE
	 0yfXX8JRNsUu3UjjHl+9a0o4quvc3avjcwbhLjvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/595] drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()
Date: Wed, 30 Sep 2026 17:21:24 +0200
Message-ID: <20260930152351.849369552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9b2b99e853422..64025fd694dd0 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -315,7 +315,7 @@ virtio_gpu_user_framebuffer_create(struct drm_device *dev,
 	if (ret) {
 		kfree(virtio_gpu_fb);
 		drm_gem_object_put(obj);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	return &virtio_gpu_fb->base;
-- 
2.53.0



