Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E4F272E53;
	Thu, 20 Aug 2026 16:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244064; cv=none; b=Emfozjur9Kh22Urhu4YIfLMt33cfTGr6XLJGFo1bwkpOvJTsi3Di9Y56BFZQ3H5PjKCdi9RTEPWk9wxp/5kW+DU8FyLV3Gtmn4vg1vE07rn1VT7+GfHSH5gT1k42jZYeBN/8/gGXu/dEO+CMhAPLB9MivRS6ffr1h7xW10Uh3Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244064; c=relaxed/simple;
	bh=KgEEfy+cJlh3Cy8osBeXDYbN2B4eXKpjqzbLsPvnd84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBicC/wxcJaNYBs+BhjZ6BFg3p8hJO2C1rHTjQQLNQEXxcXsVGpgQc6ROStdNNmVQJB/0k/wdOqBpHgGMKrJ6uLzGqqk6gL6E9nBSI0UYksLENMt7ck2DczFnbdvGYTLvJebBQkCOKG6DhIC/xDhSMjF41hcdsEY+MLHxgZ7TVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAGz30Kw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAGz30Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4441F000E9;
	Thu, 20 Aug 2026 16:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244063;
	bh=G2SWmlLgPKbk7Qtu6jBSAjBDnzxEvthU7uJFqrG7T64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAGz30KwWlkMZ8aszlBQ5m8K/5AFyiMz5ZcYrl9nOWX11ZlKLGes40Z9BkoeOFCtQ
	 adm0jqC+FUOILpwRn8FCWYk7VtKg23/TP779rLDkVsDAtLrVjiTX9eGzcEYah1Dl9b
	 f7RQNmt0YFLOho1QISsZc2PLVf/XknTnHATgeiFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 039/235] drm/amdgpu: Fix UVD decode image min size calculation
Date: Thu, 20 Aug 2026 16:54:35 +0200
Message-ID: <20260820145217.617377502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -728,7 +728,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		return -EINVAL;
 	}
 
-	if (width > pitch) {
+	if (width > pitch || pitch > 4096) {
 		DRM_ERROR("Invalid UVD decoding target pitch!\n");
 		return -EINVAL;
 	}
@@ -740,7 +740,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	}
 
 	buf_sizes[0x1] = dpb_size;
-	buf_sizes[0x2] = image_size;
+	buf_sizes[0x2] = (pitch * height) * 3 / 2;
 	buf_sizes[0x4] = min_ctx_size;
 	/* store image width to adjust nb memory pstate */
 	adev->uvd.decode_image_width = width;


