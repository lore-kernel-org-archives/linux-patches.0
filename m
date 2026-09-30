Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE29553CA62;
	Wed, 30 Sep 2026 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790068; cv=none; b=MlBmP0OoEkEoOM+JDeH/iguqrrQ30l2a9mike1AHO1SV8RyYTnY49uaLN8Xyov8PXLpXWo3TQYBAylUEWQ6fYmT2lrlIJHBiGzCjT5KLGE8YLkFfk5IE0ufpE4Z3hT7enPoDxkyCebZ/tebJ6XaPd/sMhN+3LeHqwG2kkfk2Mx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790068; c=relaxed/simple;
	bh=U9DJdXwXZxPJHhJ3mTpcLvbOYujDcD4xERXSAJGX8Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUSDsBvK9MlIP04HyhH3pImaWuR5Oj4V7TsoYQqk53N3K136l3i9wuEjnaE3GzFLfQrjy8EIIWEI00GZhjHK7nEoqeDs53m337ymNpLD8twOWcEbm0gXtH3xbi/EeUSDnvr9ZbAHOf5dk75mH2SPuB0x1h3xlPMeIuHVuPg/b28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b14TIuiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b14TIuiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AB21F000FF;
	Wed, 30 Sep 2026 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790067;
	bh=RnZLLeu/1+uqNofOP/9b5rO6Q94KiHyBCmUmw84GtiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b14TIuiTArX1W+HyGwap/AOMlYchBg0PUHeHY5z1ozbmXTkszAIJ2te3vVQM0mnlp
	 s+pmyF4ONgUaXNI6ml0BQNWBuKhrvMe9Um7VU3ky+qSwYAJjZD4tKGFarEhkSf08JB
	 LFtmOStbWELR5ouutxOY5G1AF7lun0xZI5a1hsV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bobzhou2@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Frank Min <Frank.Min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 700/877] drm/amdgpu: avoid force-completing uninitialized UVD rings
Date: Wed, 30 Sep 2026 17:26:51 +0200
Message-ID: <20260930152429.786876978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


