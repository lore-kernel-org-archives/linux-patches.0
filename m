Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C91356742;
	Thu, 20 Aug 2026 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247930; cv=none; b=fVShOas0qoKZpR9IhAo+lQt2PuMFtVsoTZ2T90/pe+GDydgxOxjp+FkSjbJnHZpdu/+nl93cpFHSLabDTyIQSnPmZfN6GXXYixlU7Khj5MQ38azQ1pa9KJ1UrVKwmNpOElvXjUIhfvS8IulA9Y/Ge6qTZxWSk4eV2j9Ml6Skgfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247930; c=relaxed/simple;
	bh=5EWgVLIoeBmM4dfBO3Jgj6pZ9QhHw8GKJNPrq0yIDhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ2NSsCB97uaCWainjVvcOt9D2N9o3J4cZgX3rCWY6EJhV0SBmf/HiN0mWy9Vhap71qPUl8KYmWcHAZ/OJT8joj1NV4ljZCLD0JdG8+o9fqErTqj7v6zK/4FveUdAV/4J88U5X2LLZxezpC586+Fy795nfkIX9KkloGwra6YwRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ib6SBqpU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ib6SBqpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2BD1F000E9;
	Thu, 20 Aug 2026 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247928;
	bh=nFMmvoU6bGR8IrUztEr7A4YGm0WGtpLXg/IIYAGJW4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ib6SBqpU4fz/Fbg2YLrO8xW9COYV2tE/MtkS9Uv7icGiRadx4wx3mVphGq3YMvAw9
	 ghtZTksu6VWBRgCwbKOtvTlCvIVrah5+/RY/oA3b/pZ0AvuSN7TW/4q9q4rEwrzwND
	 Rmp6sO3pj/pB8RAWbsUblF9zEcQgZWsCvWtqYNNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 050/303] drm/amdgpu: Fix UVD decode image min size calculation
Date: Thu, 20 Aug 2026 16:53:06 +0200
Message-ID: <20260820145254.677334247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit b8bb9ba3f101a1b0011f785a577a4a0a38371174 upstream.

This needs to use pitch instead of width. Also reject pitch
over 4096 to avoid overflow.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b41c8cb12e202b220353332ab87dc01a11f69304)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -791,7 +791,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		return -EINVAL;
 	}
 
-	if (width > pitch) {
+	if (width > pitch || pitch > 4096) {
 		DRM_ERROR("Invalid UVD decoding target pitch!\n");
 		return -EINVAL;
 	}
@@ -803,7 +803,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	}
 
 	buf_sizes[0x1] = dpb_size;
-	buf_sizes[0x2] = image_size;
+	buf_sizes[0x2] = (pitch * height) * 3 / 2;
 	buf_sizes[0x4] = min_ctx_size;
 	/* store image width to adjust nb memory pstate */
 	adev->uvd.decode_image_width = width;


