Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A6935C1A6;
	Thu, 20 Aug 2026 15:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238956; cv=none; b=N6Y0gRZLmXcNFsBclRoCafrXjdn9l6wqHixrXFp/rlpyZvJSvQPfTusQkzMTUtL+D2/cTrup393WGb4B9ggMv+ZIEuM1qIGBnQrr0TLynro1MxGe+vXdUPJPkmTlIdf1O4fyiV5UBPecZyh3M6jXTKYD3yWRuksJJu4K0SBhRdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238956; c=relaxed/simple;
	bh=FaVpQE9OjN0igEhvX4IJIgVzxjRtBntSwkLEmGNysfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ef9M0Y6Njt3GD10s6OXH+lROtbzDUxxq4DucEmLr0frIIewAyPIPmKoIiWlw1AfgKlUxk1CkTDajoprRD8DdMbyjy70mVBodQGUA08gJt8a2lX8EkD//UUUPmXpRd+ovVwP790qVWjm6+RADsC1F02rgOzCNxCDv+wEx9WRtL+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3KfXQMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3KfXQMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D961F000E9;
	Thu, 20 Aug 2026 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238954;
	bh=V4yfohJpmEgcQ5IMgKv0mzENkSVWkX6hska1IAU0WX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3KfXQMUhy0T1rUwY96c/P5vxRGYl3NBu3PkbNMfT/PeDGf29dWizV9e7qTRH/pre
	 AA0kSI05BFZexXDlVb2o6+QKeCQnnaBnRmEvdchF3rLtaFH4NGGBMR/6TkI13u+d3t
	 7bMkQ1mRy9kr3AfhaoVnR34UaXLu3i9E1PyJADAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 099/217] drm/amdgpu: Fix UVD min buffer sizes
Date: Thu, 20 Aug 2026 16:54:27 +0200
Message-ID: <20260820145240.725568712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit 18727670b44753865b81c56a9338c0d7bd102c54 upstream.

Use correct size for message buffer = sizeof(struct ruvd_msg).
Add ITSCALING_TABLE_BUFFER size.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 37519d007e4261febbcf35b3045f8344f3145497)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -974,15 +974,16 @@ static int amdgpu_uvd_cs_pass2(struct am
 				  ctx->buf_sizes[cmd]);
 			return -EINVAL;
 		}
+	} else if (cmd == 0x204 || cmd == 0x206) {
+		unsigned int min_size = ctx->buf_sizes[cmd == 0x204 ? 5 : 4];
 
-	} else if (cmd == 0x206) {
-		if ((end - start) < ctx->buf_sizes[4]) {
+		if ((end - start) < min_size) {
 			DRM_ERROR("buffer (%d) to small (%d / %d)!\n", cmd,
 					  (unsigned int)(end - start),
-					  ctx->buf_sizes[4]);
+					  min_size);
 			return -EINVAL;
 		}
-	} else if ((cmd != 0x100) && (cmd != 0x204)) {
+	} else if ((cmd != 0x100)) {
 		DRM_ERROR("invalid UVD command %X!\n", cmd);
 		return -EINVAL;
 	}
@@ -1112,11 +1113,12 @@ int amdgpu_uvd_ring_parse_cs(struct amdg
 {
 	struct amdgpu_uvd_cs_ctx ctx = {};
 	unsigned int buf_sizes[] = {
-		[0x00000000]	=	2048,
+		[0x00000000]	=	3556,
 		[0x00000001]	=	0xFFFFFFFF,
 		[0x00000002]	=	0xFFFFFFFF,
 		[0x00000003]	=	2048,
 		[0x00000004]	=	0xFFFFFFFF,
+		[0x00000005]	=	992,
 	};
 	int r;
 


