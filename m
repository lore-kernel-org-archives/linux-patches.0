Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE00B47CC9E;
	Thu, 20 Aug 2026 16:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243282; cv=none; b=kF2Av4YKn9EyTM5HklZeD20pCuL4IcboTh+f/+/Sg/GkOfjjBvkCfkblP2+G5Yghwu/zktcs0Q34Ag1W1ddFdF9mKec3kTvhDF+9aBN/vo21tf6rgKHooDIjY6uF+GYwhtfy5N2vCb3fTU1zCfEot4e4mQXPARdabBuUB1GxuyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243282; c=relaxed/simple;
	bh=tl50s2HSt44SNxNpuf0QHniQNhHa8S9SGI+O+GKZaF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKdV7g7ov6WlVqYdjS+h6mf9AwYmEcxa9MWFXf1kv+V3ivkOlEBJKZdU4Y4nZ/+bQnD6O+SSQtlN211tHOdwu2qOnskM14tWqPWcjIPrUigkJJP6EOjQEQAQyXAD1n0t1KwLT6wT6zSQB4fL4KsdTmnKEF6FfR+4qYW1+MSF0qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWOqLnSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWOqLnSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB841F000E9;
	Thu, 20 Aug 2026 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243280;
	bh=7T9gh0JSvfTgcJS1jr5+UTo2vZNZcfESEWesL0IBtNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWOqLnScKiC042xucNd1KQqf1E5zWSoplExrLxeRgAYjgKJUxboEvyARfzbrwPc5n
	 PNDpyxNh3p+MThy7pezYrcKTCi0N/0thKCRvYQyGApqiSDr/bHzDNm/3hsXX5pORsO
	 kX3IKMKJjoGmwwekfFwkA4TeQh9KXDj92n4F9ZXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 041/272] drm/amdgpu: Reject UVD message with dimensions above 4096
Date: Thu, 20 Aug 2026 16:53:45 +0200
Message-ID: <20260820145232.456463311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit 8c9aebcdd9f46f7a14b98d6ab18574b7a48fbb08 upstream.

Fixes potential overflow in DPB size calculations.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 05e1387d151f71569fbe122d2c89f9db0c21dc10)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -578,8 +578,8 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	unsigned image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned min_ctx_size = ~0;
 
-	/* Reject invalid dimensions to prevent division by zero */
-	if (width < 16 || height < 16) {
+	/* Reject invalid dimensions */
+	if (width < 16 || height < 16 || width > 4096 || height > 4096) {
 		dev_WARN_ONCE(adev->dev, 1,
 			      "Invalid UVD decoding dimensions (%dx%d)!\n",
 			      width, height);


