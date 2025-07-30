Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA35426C383;
	Wed, 30 Jul 2025 09:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869142; cv=none; b=L05Kqg1qp8WsP/P2h2Bfh6KNEM8c4wkvjp8fnBqG+BiIwDBfSDOHZUEV1JurzSR83u3wjIdV4+duFT7oVCiM6hQCdBTUfUSI8AaiMexs00LOW3k56josm4og0jsojfqcoJMOR19YzHTDUFyxC1A6c0MZt53dGtwIu6F69/Qlv+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869142; c=relaxed/simple;
	bh=28JRe/aSp8pMhOfhB4vxf5UkFFTinC1MlfxrvqyPyL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WibygCvIXOY5yqIilJxEEi0byx/EEL7dcfzVNc8jXxycEhjkR9APJMzX8DYO1sgXKeum5m6lzw2gFz+nFnHo37CM++O5cToKdd1zqWwAYssmf8XWSEemewjHSarSSs7ViSAM2T7Xaq7TFkHLLXSAzegaER+s5NMfGR1SO3baATU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWGareJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWGareJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42840C4CEF5;
	Wed, 30 Jul 2025 09:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869142;
	bh=28JRe/aSp8pMhOfhB4vxf5UkFFTinC1MlfxrvqyPyL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWGareJN7f/iw6wMOHJapQtzN45RrpBvNjb108mu9vMitsXQkGfFKJXFM+YgAottE
	 ahq5/C1aH3HQ9BewPxQCeNyoKuhB8jfBamF9aBJr/Lv2uV+PzOtmLVrXRosGbkL2qy
	 bTneI+EAVo5qx0TIl1/IutE6TnoMYqcvDH+DckR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.15 47/92] Revert "drm/prime: Use dma_buf from GEM object instance"
Date: Wed, 30 Jul 2025 11:35:55 +0200
Message-ID: <20250730093232.576075630@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit fb4ef4a52b79a22ad382bfe77332642d02aef773 upstream.

This reverts commit f83a9b8c7fd0557b0c50784bfdc1bbe9140c9bf8.

The dma_buf field in struct drm_gem_object is not stable over the
object instance's lifetime. The field becomes NULL when user space
releases the final GEM handle on the buffer object. This resulted
in a NULL-pointer deref.

Workarounds in commit 5307dce878d4 ("drm/gem: Acquire references on
GEM handles for framebuffers") and commit f6bfc9afc751 ("drm/framebuffer:
Acquire internal references on GEM handles") only solved the problem
partially. They especially don't work for buffer objects without a DRM
framebuffer associated.

Hence, this revert to going back to using .import_attach->dmabuf.

v3:
- cc stable

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Zack Rusin <zack.rusin@broadcom.com>
Cc: <stable@vger.kernel.org> # v6.15+
Link: https://lore.kernel.org/r/20250715155934.150656-5-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_prime.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index d828502268b8..a0a5d725eab0 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -453,7 +453,13 @@ struct dma_buf *drm_gem_prime_handle_to_dmabuf(struct drm_device *dev,
 	}
 
 	mutex_lock(&dev->object_name_lock);
-	/* re-export the original imported/exported object */
+	/* re-export the original imported object */
+	if (obj->import_attach) {
+		dmabuf = obj->import_attach->dmabuf;
+		get_dma_buf(dmabuf);
+		goto out_have_obj;
+	}
+
 	if (obj->dma_buf) {
 		get_dma_buf(obj->dma_buf);
 		dmabuf = obj->dma_buf;
-- 
2.50.1



