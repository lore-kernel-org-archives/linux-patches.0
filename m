Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AC37BB15;
	Mon,  8 Apr 2024 13:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583183; cv=none; b=UbUXXXkxtKMMN5Olu6obIr8hgEAQuSBlkapfSuaH9VEumm4aEa9loZYFhivXPBpGmJsoZnm+Cf98EZkmKkDAR/N/ZCSb3jyI0CZatuOzmnYxVTzqmEDbIeB5BjedM/Kdx4ijGSpL7cv44as7aNKRWH3zb1ADp+aGku52QCMb3GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583183; c=relaxed/simple;
	bh=Eueu/bweULtXvbFJ6fge3m12UFv5OIQIjlKosWICp4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pG1N34x5vjmA0rIJOhmgzNzPS8IdZkYeawd4t39j9WjRhzvZXHYynDGG99YDSkBVnA3Oy4MeqQsF80FEQo0ewEUx4sZGGJ+1WPlgZjxznhi70rykG2BA4lmswfsiMALMoK+ugngXrAv4YsVMZZG61v/pWQCj5SE5SAj5tlQ3a+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9nKXJc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9nKXJc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4F3C433C7;
	Mon,  8 Apr 2024 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583183;
	bh=Eueu/bweULtXvbFJ6fge3m12UFv5OIQIjlKosWICp4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9nKXJc4HOAPxirt9yksRPZW/gAJczqWqQdmopBYBV4LV/Te8lGz5UZw3Ak/tU4e+
	 H8m3fgtRnvqpw3/PIa0y06V1VPYoHzVmeC4r6iju/tqg0GX4jEcTqRNg2KGkU/PcKi
	 6Tir4U+8eoKAUXsVd2v3KYghQa3RMb1DDakdZPas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Behr <dbehr@chromium.org>,
	Rob Clark <robdclark@chromium.org>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/252] drm/prime: Unbreak virtgpu dma-buf export
Date: Mon,  8 Apr 2024 14:57:46 +0200
Message-ID: <20240408125311.846284438@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit a4ec240f6b7c21cf846d10017c3ce423a0eae92c ]

virtgpu "vram" GEM objects do not implement obj->get_sg_table().  But
they also don't use drm_gem_map_dma_buf().  In fact they may not even
have guest visible pages.  But it is perfectly fine to export and share
with other virtual devices.

Reported-by: Dominik Behr <dbehr@chromium.org>
Fixes: 207395da5a97 ("drm/prime: reject DMA-BUF attach when get_sg_table is missing")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Simon Ser <contact@emersion.fr>
Signed-off-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20240322214801.319975-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_prime.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 7352bde299d54..03bd3c7bd0dc2 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -582,7 +582,12 @@ int drm_gem_map_attach(struct dma_buf *dma_buf,
 {
 	struct drm_gem_object *obj = dma_buf->priv;
 
-	if (!obj->funcs->get_sg_table)
+	/*
+	 * drm_gem_map_dma_buf() requires obj->get_sg_table(), but drivers
+	 * that implement their own ->map_dma_buf() do not.
+	 */
+	if (dma_buf->ops->map_dma_buf == drm_gem_map_dma_buf &&
+	    !obj->funcs->get_sg_table)
 		return -ENOSYS;
 
 	return drm_gem_pin(obj);
-- 
2.43.0



