Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C910D1E487;
	Mon, 23 Jun 2025 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686129; cv=none; b=PNq5l7LWossgjB/m/ThRf7Kc3sOb3XeEc+ykVtS22JnrFKAqQFoaaJ90Mb1uU65qAL3mwvx+lNKbJgErXUbtBqK4eE6ndpPo6ovg1le7OmVU8cE3semAOIWQ+zqpdekXdQosFkyZXDTGxSh3tGBP9Cfm22rXAM4l1omvlsFcKhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686129; c=relaxed/simple;
	bh=gMHFwdfkRif53xaCMkvTGo0Lao+GxteB1TsNYvBdOxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erZWiEyQVts35YhoLNOWcwx1NZxKMx45zemhkm7EDM8i0f3zJUYsS+pVS8csx24bHBT3lqxP2IHo0K0djAigOa7Huk5KAWTGTmlFilsUKWkeqh+FxLWuS00Tt9sI7ak3QIkRAh9qXbRn7NfanxfxiWK+zWd0wVpuXHyO+XNV7B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6sloK1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6sloK1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5F9C4CEEA;
	Mon, 23 Jun 2025 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686129;
	bh=gMHFwdfkRif53xaCMkvTGo0Lao+GxteB1TsNYvBdOxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6sloK1k5beDS25UMlrpJq1HxdgKN2z+2Avae6zL1QX812hu5T3hCyIWigqnJRayb
	 cy/Ugj0VbKA60u8RWxSf/moc5m7UomvkP0JnSFU1zhdkMDaGIrk8DDp5NVozj/WKwp
	 C5aKzxTXk/acZZlyDMRrS6tvWuquXxZ3xBDZhg2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Louis Chauvet <contact@louischauvet.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/508] drm/vkms: Adjust vkms_state->active_planes allocation type
Date: Mon, 23 Jun 2025 15:01:34 +0200
Message-ID: <20250623130646.453551913@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 57bbd32e9bebb..de8c2d5cc89c0 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -202,7 +202,7 @@ static int vkms_crtc_atomic_check(struct drm_crtc *crtc,
 		i++;
 	}
 
-	vkms_state->active_planes = kcalloc(i, sizeof(plane), GFP_KERNEL);
+	vkms_state->active_planes = kcalloc(i, sizeof(*vkms_state->active_planes), GFP_KERNEL);
 	if (!vkms_state->active_planes)
 		return -ENOMEM;
 	vkms_state->num_active_planes = i;
-- 
2.39.5



