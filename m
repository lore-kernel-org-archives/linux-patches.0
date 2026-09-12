Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ED53176EE;
	Sat, 12 Sep 2026 19:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242196; cv=none; b=C7Q/lHcdTIxzE9za1KBAyP+X9wq9xEC4xbJfx8k/lwQl42POO36bjeBy1SwDkegeu/4xTSGRH/CGlv9TCS8bdLiDpOS+Sy9gfzrSBrvKgBL+CyldWC90IfjV02OEo4O4ylAEj3na4nxDcsA/EaZxBQHSJeLi8G3rqV9S2r+aWEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242196; c=relaxed/simple;
	bh=EtLHeWvGp83k8tWaJTNKHEk2X0QVGxGSyCMRIa1gJvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVh0HcKUn/3tKgVQhpEIUhcHhLGrZlTbFxgp+O+qxgvpAiAIK2ldYNbss6ZBLowSk0F/i+Vfgfww0fhsit5zEaXGj+Nb9SnYy8Q1cUr3a9LzOtpcUmJSYoeAFPry2Pu6Sm5v/7/TV6PFZTynEfqqyhXy1nRLQ4fjRnhm3DKross=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aL5VPqVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL5VPqVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8C61F000FF;
	Sat, 12 Sep 2026 19:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242195;
	bh=g3Z1cg0+ONxuzdft7U5/gNCUpOPb3UghWc43j/RhR34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aL5VPqVKuD9SXtpdvj19ll491UBpOikY1gHhgiJPyp2pKto9Sg5+O5Pewqh7r4GOO
	 U6R/yFMr9m+L7SJTuSkvpMPDvR5O51CKZbR0EVkWRmnqbaWEXQVYu1YwzhwqmRIsdf
	 9Y888By2dT+nBIVhKZLDj3s98BKbiTjn82dfm45U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Melissa Wen <mwen@igalia.com>
Subject: [PATCH 5.10 318/798] drm: Fix drm_crtc_commit leak if signaled when PAGE_FLIP_EVENT is used
Date: Sat, 12 Sep 2026 08:59:06 +0200
Message-ID: <20260912065524.449628567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 4d4be202165e832d74849b4a68e289a2a377039c upstream.

Commit 1c6ceeee6ebb ("drm/atomic: Fix memleak on ERESTARTSYS during
non-blocking commits") fixed a very similar issue when the event was
allocated by drm_atomic_helper_setup_commit() itself.

However, if the event is allocated in prepare_signaling(), it will also be
set to NULL in complete_signaling(), which prevents drm_crtc_commit from
being put in __drm_atomic_helper_crtc_destroy_state().

Dropping the reference when the event is set to NULL at
complete_signaling() fixes the leak.

The leak can be reproduced by sending a signal to the thread using
DRM_MODE_PAGE_FLIP_EVENT and using a sw_sync fence to cause the atomic
ioctl to block at drm_atomic_helper_wait_for_fences(). It happened both
with amdgpu and vkms.

Fixes: 24835e442f28 ("drm: reference count event->completion")
Cc: stable@vger.kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260727-drm_crtc_atomic_commit_leak-v1-1-23d9948a9d7c@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1263,6 +1263,8 @@ static void complete_signaling(struct dr
 		 * to prevent a double free in drm_atomic_state_clear.
 		 */
 		if (event && (event->base.fence || event->base.file_priv)) {
+			if (crtc_state->commit && crtc_state->commit->abort_completion)
+				drm_crtc_commit_put(crtc_state->commit);
 			drm_event_cancel_free(dev, &event->base);
 			crtc_state->event = NULL;
 		}


