Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B792622A80D;
	Wed, 21 Jan 2026 18:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020100; cv=none; b=i0u1FIjU5uJTJOaCdAbqOHlajnfjWku7V4RK3l7h24tELNQDuLSxO/HB5dHPC04c0oiP3hr/d44qkXuOV+8Rp1VEg5fC4PhdBGXaGnTHkg1S2Y5F0xEP3XCdlGwrM0yYUE2Ip/ZQEFUIhTYp4pes/W5T/tUw7eBVBYR2Z8a+a2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020100; c=relaxed/simple;
	bh=9pkNINbbE5wYYHaYEuYHSzj3qixwifadPctJ4/q9Kds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fi5O71K5DLMSZXc+fwJJRG3dQxb6OlqgKFvE0hQgHRWcUD51qcGLR7LoevhUk+IlF80aT7t68s/eT6mBlsPoVcLAQs3RmSmTZGw/I49RWpZmECFK1MG6qTgShpEgp3TdNrHoDDO9IZ9vFIrWf4n3FbYoC4FyT/w9yc7VjLHRzds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJz9egsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJz9egsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1FBC16AAE;
	Wed, 21 Jan 2026 18:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020100;
	bh=9pkNINbbE5wYYHaYEuYHSzj3qixwifadPctJ4/q9Kds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJz9egsTJW84F4SrmdW52tu176eDZPoCpiVrU/HU34xosaUDw8ZuccoMCWkgl5/8d
	 Nly6q+ZEFlc0+xznducwAGBxrulAD6LxYZ0yHWLWubKKdHfsm4jSBCKHHf2jDvjUYV
	 PlP0tuNlj7AZTqf0hmLQmw4oWbtLHCygR9OWIQeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/198] drm/amdgpu: fix drm panic null pointer when driver not support atomic
Date: Wed, 21 Jan 2026 19:14:46 +0100
Message-ID: <20260121181420.642326438@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 9cb6278b44c38899961b36d303d7b18b38be2a6e ]

When driver not support atomic, fb using plane->fb rather than
plane->state->fb.

Fixes: fe151ed7af54 ("drm/amdgpu: add generic display panic helper code")
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2f2a72de673513247cd6fae14e53f6c40c5841ef)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 51bab32fd8c6f..2f416d12e2e7e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -1824,7 +1824,12 @@ int amdgpu_display_get_scanout_buffer(struct drm_plane *plane,
 				      struct drm_scanout_buffer *sb)
 {
 	struct amdgpu_bo *abo;
-	struct drm_framebuffer *fb = plane->state->fb;
+	struct drm_framebuffer *fb;
+
+	if (drm_drv_uses_atomic_modeset(plane->dev))
+		fb = plane->state->fb;
+	else
+		fb = plane->fb;
 
 	if (!fb)
 		return -EINVAL;
-- 
2.51.0



