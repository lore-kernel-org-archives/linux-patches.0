Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082B34C7F;
	Mon, 23 Jun 2025 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685163; cv=none; b=IRNrNow8w9tF0ghU2dRWpbpV1wXXSrLa7UgYXqGlt1PniIVymYqNNWf3C5kmfuBnbp+Xgn9BHK9osIxRf9+JtGLqemyC+ei/9DV4WaF/GlqMgp5kQsOw1aRiBL+JGnB8FzKMuVySqcPwAdpOMxaYw7/84aH9XqCEE0BcwJmxBvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685163; c=relaxed/simple;
	bh=DT6xVSaY+PgXwGKH4Vl5MX4QM7P3QMkau7bKJq9s3ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEYlUIZhg1/yOqZQpR+8SIzEfAOAm1KD/muleZCMfPLYyFCN2H/DvuZEFCpJnkXZ08JigyIufe4sjiHP8R3MrcJMZmnDE29qPf1BL9HoNaj8dM6ZqW3Bn2dR3EW+copliFo7PYJct/Y0fuUYXwnVHxphwqTRk/A7qc1cAt7+FWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kpu87nUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kpu87nUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891A1C4CEEA;
	Mon, 23 Jun 2025 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685162;
	bh=DT6xVSaY+PgXwGKH4Vl5MX4QM7P3QMkau7bKJq9s3ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kpu87nUD1PlUJYGRmz0/ntsvQDvT4URLmM8nqnc4gBXNsIc+Ev5fP0kbXMHtmimjD
	 GTqWJFPq9j5tw1Vc5kjPhZMhocg/WzUNQCI6VYdCCkiDiXT9EcKW894f0HW9GJTD+K
	 DqfAiofWO4kBQ44ppZfCYcML3hS8jZumA7TTXy0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Louis Chauvet <contact@louischauvet.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/355] drm/vkms: Adjust vkms_state->active_planes allocation type
Date: Mon, 23 Jun 2025 15:03:52 +0200
Message-ID: <20250623130627.746378374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1ae5cd47d9546..2225e764e709f 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -194,7 +194,7 @@ static int vkms_crtc_atomic_check(struct drm_crtc *crtc,
 		i++;
 	}
 
-	vkms_state->active_planes = kcalloc(i, sizeof(plane), GFP_KERNEL);
+	vkms_state->active_planes = kcalloc(i, sizeof(*vkms_state->active_planes), GFP_KERNEL);
 	if (!vkms_state->active_planes)
 		return -ENOMEM;
 	vkms_state->num_active_planes = i;
-- 
2.39.5



