Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E951E18A6C3;
	Fri, 27 Sep 2024 12:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440173; cv=none; b=TzkXfVKcz9MlsTxrECPQ8AS5H3RySX3KB469lQ4GD75rw4l7PZz97eGfDzwK2t37Dce0tALUeocO+86biBBWOb9IpITJLlFtpxAheqEUWUKmTOxvSZ2s0tfmJvLXelFkCW1ECdIJHvKpbemFoLZH00RKyJKaTVgZDiudvD/Cv0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440173; c=relaxed/simple;
	bh=tZH+YV2Xm5FdPECf5iCsxCIdjlLFpQ2ca6UzutXHa/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDr5936V/QA5iRQ4vQHD280UTnY/kNo/kMPUg6qwJ4JjD4K3WiC4A/QLiQ18cXAmYYhVJUEjEkuvDgizAs9A0+oINdDHIIUr1JLaxUimc0bnQbHHqIoBluILN1zVrkxuhN1vD8Y72UH7AwyASOP0I3ZMS8b/lwPj1NT4AoRIX9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIyeCb2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIyeCb2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DDAC4CEC4;
	Fri, 27 Sep 2024 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440172;
	bh=tZH+YV2Xm5FdPECf5iCsxCIdjlLFpQ2ca6UzutXHa/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIyeCb2tlODY/09tUjDGlpNMSaXfCx+twFt1Nu1y6iGs6uvepx9X/5zO8/qime4Sk
	 6nqThZwTIRCP5LUDjImKnCDrJ/lGE83WMgo1pdLwckNNgC3T6psep3lOonXadMFlcc
	 1uTSv0QX3JSfd/Bcya+l4kRFlmk5Bi9iN5786n1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	James Zhu <James.Zhu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 48/58] drm: Expand max DRM device number to full MINORBITS
Date: Fri, 27 Sep 2024 14:23:50 +0200
Message-ID: <20240927121720.750640543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Winiarski <michal.winiarski@intel.com>

[ Upstream commit 071d583e01c88272f6ff216d4f867f8f35e94d7d ]

Having a limit of 64 DRM devices is not good enough for modern world
where we have multi-GPU servers, SR-IOV virtual functions and virtual
devices used for testing.
Let's utilize full minor range for DRM devices.
To avoid regressing the existing userspace, we're still maintaining the
numbering scheme where 0-63 is used for primary, 64-127 is reserved
(formerly for control) and 128-191 is used for render.
For minors >= 192, we're allocating minors dynamically on a first-come,
first-served basis.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240823163048.2676257-4-michal.winiarski@intel.com
Acked-by: James Zhu <James.Zhu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_drv.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index a5f7b24324e30..928824b919456 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -121,10 +121,19 @@ static void drm_minor_alloc_release(struct drm_device *dev, void *data)
 	xa_erase(drm_minor_get_xa(minor->type), minor->index);
 }
 
+/*
+ * DRM used to support 64 devices, for backwards compatibility we need to maintain the
+ * minor allocation scheme where minors 0-63 are primary nodes, 64-127 are control nodes,
+ * and 128-191 are render nodes.
+ * After reaching the limit, we're allocating minors dynamically - first-come, first-serve.
+ * Accel nodes are using a distinct major, so the minors are allocated in continuous 0-MAX
+ * range.
+ */
 #define DRM_MINOR_LIMIT(t) ({ \
 	typeof(t) _t = (t); \
 	_t == DRM_MINOR_ACCEL ? XA_LIMIT(0, ACCEL_MAX_MINORS) : XA_LIMIT(64 * _t, 64 * _t + 63); \
 })
+#define DRM_EXTENDED_MINOR_LIMIT XA_LIMIT(192, (1 << MINORBITS) - 1)
 
 static int drm_minor_alloc(struct drm_device *dev, enum drm_minor_type type)
 {
@@ -140,6 +149,9 @@ static int drm_minor_alloc(struct drm_device *dev, enum drm_minor_type type)
 
 	r = xa_alloc(drm_minor_get_xa(type), &minor->index,
 		     NULL, DRM_MINOR_LIMIT(type), GFP_KERNEL);
+	if (r == -EBUSY && (type == DRM_MINOR_PRIMARY || type == DRM_MINOR_RENDER))
+		r = xa_alloc(&drm_minors_xa, &minor->index,
+			     NULL, DRM_EXTENDED_MINOR_LIMIT, GFP_KERNEL);
 	if (r < 0)
 		return r;
 
-- 
2.43.0



