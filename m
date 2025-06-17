Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6661D2F237C;
	Tue, 17 Jun 2025 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175082; cv=none; b=lLwURZ5MdptX2R5LE+AWyPhHSOn/tey6sWbbeenl7LS1TZ/e+MTzL+VyvvrZZ59vzgbclpS7d00wCIMKM5lb8F+DCksUFJuUjig0zZLYBWovImefu/2CfQ5QfmWi/bj56XWCF38+njjnmGk+wpKTepEUv8j7fgDi5oXojBJz6lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175082; c=relaxed/simple;
	bh=MCJFO2i7b8mSPavwsQ/5gzJTfaCRdUu1UV7/UFX01Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwARDrgfWL+WKmLfHMUciTzO2qanuM52woDMRRf1HyAop7Xe0ePiBoXtJSDVcpwYNQVE/MN3yNGl/R+Ocdu7vCRnxGK0C5kYdGz6uRFRgRvsCHEH9uyW3De8pbajGLc/CrFkReMAeg2hbYd/L4VD2Sx0GdW7KyR7ASuLUSgY6us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykFjaYWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykFjaYWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570BEC4CEE7;
	Tue, 17 Jun 2025 15:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175082;
	bh=MCJFO2i7b8mSPavwsQ/5gzJTfaCRdUu1UV7/UFX01Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykFjaYWZvFYdeVbzfDWqpJSaewCvWq/t6awFdv0ehVLU2uAmMt4v8VGeyVqHCgOhH
	 05A7t8dgVH5ZqGM4Tinty7Zbko+9pqr0rS0sLPPK1ZtUT06uzV5pWxQpc4gkiI8dSL
	 /hwNN+ynaAixmyNASQtgsnGrJ8S+t84E/E0YZ7Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Louis Chauvet <contact@louischauvet.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/512] drm/vkms: Adjust vkms_state->active_planes allocation type
Date: Tue, 17 Jun 2025 17:20:56 +0200
Message-ID: <20250617152423.227234760@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 258aebf100540d36aba910f545d4d5ddf4ecaf0b ]

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct vkms_plane_state **", but the returned type
will be "struct drm_plane **". These are the same size (pointer size), but
the types don't match. Adjust the allocation type to match the assignment.

Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Fixes: 8b1865873651 ("drm/vkms: totally reworked crc data tracking")
Link: https://lore.kernel.org/r/20250426061431.work.304-kees@kernel.org
Signed-off-by: Louis Chauvet <contact@louischauvet.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_crtc.c b/drivers/gpu/drm/vkms/vkms_crtc.c
index 40b4d084e3cee..91b589a497d02 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -198,7 +198,7 @@ static int vkms_crtc_atomic_check(struct drm_crtc *crtc,
 		i++;
 	}
 
-	vkms_state->active_planes = kcalloc(i, sizeof(plane), GFP_KERNEL);
+	vkms_state->active_planes = kcalloc(i, sizeof(*vkms_state->active_planes), GFP_KERNEL);
 	if (!vkms_state->active_planes)
 		return -ENOMEM;
 	vkms_state->num_active_planes = i;
-- 
2.39.5



