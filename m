Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFAF37CD28;
	Thu, 20 Aug 2026 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238961; cv=none; b=k1SCL+ONloCHuuwgAlVORfly1lFATGK97Bn2vu8kM0dogWyif6XvjoL9LVtJTuuoMKjwmeMkqZcYg1YvtkedPKwv8hJXpd7787HlhjeyPj51Iqa+h16atBmlSgYTN8gx0OHHsbS3t0MHzArvzR64rcfuKnVQ3wSflgyjmfjP0Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238961; c=relaxed/simple;
	bh=qlmpHDtB2UsaLmIFvzyJDdR/u1KdRu8Ysl6x0kuS2s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h67oyjJ5ON74vateQkdnyp2xY02Z/CdaEIADgNdkfuO1gei7vS9/AuZA7Oe7jwZUjIq/+c5tRVmlwJyU5AKSBdw5ABWYrQFQb2dVXlrNBF5sdfmpOola8Gz175WGM1nI6rep4Ij7ypID2ppxammdT0YL+oVnFTEi6PkgOXnHkbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N45NWZ3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N45NWZ3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BB71F000E9;
	Thu, 20 Aug 2026 15:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238960;
	bh=gMBv3j2+5pOTpvQWf6d1kVWrxA1m8lqhJgREyntZvW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N45NWZ3PhEpezcJtLE3numpkzvgBWiY8cTPgx1605dkIhjdgOTvPb++Q2yKYPnX6p
	 TypU7CRCa4GenjE3gCKRb8akbIaDX6lOEkPW6l3DbgO9dHnPgBs37S33TrXB7wH6Yy
	 pNKv8lKVcl3Hep7d6xeXwf1ZAnrk3z+5kmvoOZ7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 101/217] drm/amdgpu: Fix UVD decode image min size calculation
Date: Thu, 20 Aug 2026 16:54:29 +0200
Message-ID: <20260820145240.784016751@linuxfoundation.org>
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
@@ -761,7 +761,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		return -EINVAL;
 	}
 
-	if (width > pitch) {
+	if (width > pitch || pitch > 4096) {
 		DRM_ERROR("Invalid UVD decoding target pitch!\n");
 		return -EINVAL;
 	}
@@ -773,7 +773,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	}
 
 	buf_sizes[0x1] = dpb_size;
-	buf_sizes[0x2] = image_size;
+	buf_sizes[0x2] = (pitch * height) * 3 / 2;
 	buf_sizes[0x4] = min_ctx_size;
 	/* store image width to adjust nb memory pstate */
 	adev->uvd.decode_image_width = width;


