Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49947518150;
	Thu, 17 Sep 2026 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666995; cv=none; b=jC5vxOlglDQ6R7eJQT4UoBd2imD8leAJ7W3ehEwRdbhNDvRvxDy0vK61FeKz2Kr7hNe89tFWvtgrLG+twMwWBcILFIsMALSAaWrCBH1T0YPEiPZliTaq8hfeohmqswg5mkifFdvt/6eHFv1Pfb5o3HOXuQ/Ls31G0GmysQpenmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666995; c=relaxed/simple;
	bh=AB0Z6TSAnoCVQGUZ1yGRfDH4KNyuN2FS7TDPkzDYSOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ8Z7/zqHGaw2FO2qwvuoVf3hUb58IRU2aAwZPA/S3DUxElQIuXOjROqcoLqKwfYKhULw/wLhNAhtrRgo7M52vtx4O7d5Nb+DCA21Qj7SNwZWMJ1tB84JrkPNUT89FkIjoYoA400fV1xzWoWFZVq4cSTvSEi35UzJJnkG2ZFSIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlq3vE04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlq3vE04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909011F000FF;
	Thu, 17 Sep 2026 17:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666994;
	bh=1ElsXecSUx5LYPpvZGLDofLFLWrwNrD2zoQ7PSmsmzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlq3vE04gZqj1JneA+McBnKJEn0OCFaTxGjBniIQ3J5XCHXHpL1D/xqUtQfu5mlHM
	 wkMS1Up1Q65vfCktK5ESOJ3plvGuuB6IhiigFSoosFcIJKSbU3ZYy4lQOuLwlfSyaU
	 fOl9TOTWSh99sxIqmIMYm7gIibgceh5X98G/RPSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bobzhou2@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Frank Min <Frank.Min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1186/1250] drm/amdgpu: avoid force-completing uninitialized UVD rings
Date: Thu, 17 Sep 2026 16:16:21 +0100
Message-ID: <20260917151624.430342530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Bob Zhou <bobzhou2@amd.com>

[ Upstream commit 6760f5cb12d2366ddd58a2d8637f7583d73f596b ]

uvd_v7_0_sw_init() does not initialize the UVD decode ring for an
SR-IOV VF. However, amdgpu_uvd_resume() unconditionally force-completes
the decode ring when restoring its fence sequence.

Skip fence completion when the fence driver is not initialized.

Fixes: 0a33b11d26c6 ("drm/amdgpu: mark force completed fences with -ECANCELED")
Cc: stable@vger.kernel.org
Signed-off-by: Bob Zhou <bobzhou2@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Acked-by: Frank Min <Frank.Min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -516,7 +516,8 @@ int amdgpu_uvd_resume(struct amdgpu_devi
 			}
 			memset_io(ptr, 0, size);
 			/* to restore uvd fence seq */
-			amdgpu_fence_driver_force_completion(&adev->uvd.inst[i].ring, NULL);
+			if (adev->uvd.inst[i].ring.fence_drv.initialized)
+				amdgpu_fence_driver_force_completion(&adev->uvd.inst[i].ring, NULL);
 		}
 	}
 	return 0;


