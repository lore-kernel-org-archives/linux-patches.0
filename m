Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A161DDC2B;
	Wed, 19 Mar 2025 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394956; cv=none; b=jdL/c5NxXfd7TZg0HbGrjgV1QuKHp+60ClkLzcxKtMcStiqMDlKF5e679o6GIdFZk+lVJ+ZU85uNcPqB/mtqUWjbxySmF1YsADMFsUp6+FwmzmuT4u9UZomHdQe6QSqYFj0DWVaX2WAz0A6S0D3Y+DKPm678/vBbC0q26F/cdc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394956; c=relaxed/simple;
	bh=LYXLR3fnte8pXJoJ5tqKhQcy7sES/RQBh4mN1CBnLco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6CRn2exrBCXersdu16BXeJpkisczmmOe5x1Tj2bpvv3AcY6jNRBA7Lz3CikntaXUQsDqGSGOMXv5jq6K5FOfll4HRLj8pXAA5spCpC+nhrQGOq1nu5YRhe4xHyb/HFtEInle0YepzDW/ELxH4OiIufjDkeIy5VPleUlQaKko8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7LRMAIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7LRMAIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A48C4CEE4;
	Wed, 19 Mar 2025 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394956;
	bh=LYXLR3fnte8pXJoJ5tqKhQcy7sES/RQBh4mN1CBnLco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7LRMAISamphwoYvuBf0IjfheFAq8+Av8OyKPg/alVnoowKilK6f74QsNxDPpV6Cs
	 LyoJqUIk36JTZOZ/X3AODFWlAhSxv6QpmAIvjvib+20Ts2gfRM4J4/wHfbEzZFsAFo
	 rzWEExPutRGad2EESCjj7DA4TOguv8iP0QBoHMU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 182/241] drm/amdgpu/display: Allow DCC for video formats on GFX12
Date: Wed, 19 Mar 2025 07:30:52 -0700
Message-ID: <20250319143032.229863777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


