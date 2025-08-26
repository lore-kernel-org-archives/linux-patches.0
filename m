Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B736F1A00F0;
	Tue, 26 Aug 2025 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213092; cv=none; b=aR7XedY6FK3d601bqntK2js1GXY43/svVhyv0MtfNe6xW2010dQJTA31kx4o4Gi7j9Mqzrq9Rnw/4H84BBvW7U+P/JB3H8jbKsyYX5Dizt8KG6ofAC+0uZ7O1MfxZ3dk+y7mY0/x/KExNHs2ju1Ukc7IVNXJx2i36FQnivjBsiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213092; c=relaxed/simple;
	bh=ZTwYLTuIitjcUzGMRoThauQJC2skZwhrmq0DIxd8EtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mH2+bx12f9J6m5zUHU+bfPbBZ5v7uJsdlGjgPIJ0ID+eVo1XuUZOY7NRcv65PZUiijAvkl6EYJPjtPvFD0yP1YGNLBxE6EXPKoPqWJlofaWf6Z5jdLI3+zkOR/RduPCXdoYrUUor9PwxWVxaTvbJaVqAZbqZJF5n4HYlyAJgzJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqyTICeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqyTICeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B74FC4CEF4;
	Tue, 26 Aug 2025 12:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213092;
	bh=ZTwYLTuIitjcUzGMRoThauQJC2skZwhrmq0DIxd8EtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqyTICeuwr7oOaBDameDKji4nqUHP5PIo1uCIBLdH0x0z3Pr1P24ybWBn+vn6g5vw
	 nOILLGjiaVqMxWMoDaA0wXZuo/5ya9gTn9u97cM+9LxPDPWbxdCMTqHflfhwxZ34PK
	 8mwwTXq5sbKUDY8MpPTU6e48QD5BzFrygT/QDMFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/587] drm/amd/display: Only finalize atomic_obj if it was initialized
Date: Tue, 26 Aug 2025 13:06:06 +0200
Message-ID: <20250826110958.456237179@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b174084b3fe15ad1acc69530e673c1535d2e4f85 ]

[Why]
If amdgpu_dm failed to initalize before amdgpu_dm_initialize_drm_device()
completed then freeing atomic_obj will lead to list corruption.

[How]
Check if atomic_obj state is initialized before trying to free.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d4edddaa23dd..10c607d84b43 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4620,7 +4620,8 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
 static void amdgpu_dm_destroy_drm_device(struct amdgpu_display_manager *dm)
 {
-	drm_atomic_private_obj_fini(&dm->atomic_obj);
+	if (dm->atomic_obj.state)
+		drm_atomic_private_obj_fini(&dm->atomic_obj);
 }
 
 /******************************************************************************
-- 
2.39.5



