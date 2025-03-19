Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFB71A841C;
	Wed, 19 Mar 2025 14:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395145; cv=none; b=oHNeG0+yGbEflUKqLQnSoFIbu7rX7smeUZ4i6k6hCJJHaJdO5QH09e2bOc6uA05Yfb89s1NNtJbbTzoT5UvovoG3yBFIhE22hYhH7PVZOfbGKNKfRVLNwfwOC/c7nmB9RFyeTbwh/15ADf2Z5d0aldEjM58SMQoYRkJ2eZLATWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395145; c=relaxed/simple;
	bh=A2OB4nHZkYqnDk9cpW/OArTeGzm+6cBKl0n6XTAzvO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL01Glp2DcBqHhr9SCi5nWG/PInzmES6Ldp107zXrI6V8iuQkLgeGEOp9bFadPiYLPzg0KIi2PgVwv1sCfaoGGJ82JV4bRwgrbqQ8ZFJXG1MT+mkYSZ7ZAmqVK9yPODaFW2/808lxYpVEfVWHRM7M/FsdEA3dvXbDfTEHlMv4sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEpJOF/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEpJOF/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BB0C4CEE4;
	Wed, 19 Mar 2025 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395145;
	bh=A2OB4nHZkYqnDk9cpW/OArTeGzm+6cBKl0n6XTAzvO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEpJOF/C0mnJs0FsJFNEoS2PxRTtSJK82a1aZmw6voUXLg1jUD0WCCqBEMW4TGREt
	 e8MLzM7ADoPurqLw+Uy+4oVRx1v6dr/G/AAey+mto7Azm1xs+hK4byHSPfWdT2nsYY
	 Bbx3F3B6xvosKcxCqvT3M5HyIoxHVSl7YoijB2sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 176/231] drm/amdgpu/display: Allow DCC for video formats on GFX12
Date: Wed, 19 Mar 2025 07:31:09 -0700
Message-ID: <20250319143031.187905483@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit df1e82e7acd3c50b65ca0e2e09089b78382d14ab upstream.

We advertise DCC as supported for NV12/P010 formats on GFX12,
but it would fail on this check on atomic commit.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ba795235a2b99ba9bbef647ab003b2f3145d9bbb)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -275,8 +275,11 @@ static int amdgpu_dm_plane_validate_dcc(
 	if (!dcc->enable)
 		return 0;
 
-	if (format >= SURFACE_PIXEL_FORMAT_VIDEO_BEGIN ||
-	    !dc->cap_funcs.get_dcc_compression_cap)
+	if (adev->family < AMDGPU_FAMILY_GC_12_0_0 &&
+	    format >= SURFACE_PIXEL_FORMAT_VIDEO_BEGIN)
+		return -EINVAL;
+
+	if (!dc->cap_funcs.get_dcc_compression_cap)
 		return -EINVAL;
 
 	input.format = format;


