Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9679196C7C;
	Tue, 26 Aug 2025 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214532; cv=none; b=IvK2VTskurH+bodKD+BAjMbu8D3aHOya/VKOacID5RVfVvjmeCLX5raP9GzWH6phXB1PQeCyGWdWK9PPZZnwH6BuvcBOeqs3lZRivRMhW9WRW29jKxxdR+yrXC6k9pa2kM1ZiEcOKc8fGIgEbPXkzDE+gHE4qiosxY41WhITuzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214532; c=relaxed/simple;
	bh=5Vl7G6eRLx1ljua6UIS6vcjR3bI9jXXvYaDD/CzLPgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giexBLpCeVXAmKbRFGe/Wv3Z/4MHTDwufo/qw9LMxG2yL1cLT7W3qB3nNTvyA12Jcxhwn7mW7h3TNDzCOjl1KZ2rkbYPSgzFnnyYF1oEv5UHt2X/BKDRlMCReZkOeV5WH2K1uLEqP/0lSUEgXcelZd6JMAN+o5N44oTtRLXMBM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBVxPY2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBVxPY2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C28CC113CF;
	Tue, 26 Aug 2025 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214532;
	bh=5Vl7G6eRLx1ljua6UIS6vcjR3bI9jXXvYaDD/CzLPgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBVxPY2uCPLqj6ALCnLpu+ZYFELLqLiNU/iZvkI4aHCmXbMgG2uf+ijv/WY5cGa2A
	 Fxwd8BIuQ58fFCmpaN+sXfn+QuT+nEC5RjS5VFrkf/uevXojnoxpzFmzVA8Ev/mhpK
	 ogcN8852tdV4H/OF4rW4B8sYGWSYz+hL0LOb030w=
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
Subject: [PATCH 6.1 173/482] drm/amd/display: Only finalize atomic_obj if it was initialized
Date: Tue, 26 Aug 2025 13:07:06 +0200
Message-ID: <20250826110935.083106012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64f626cc7913..8cd88b2aa54c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4638,7 +4638,8 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
 static void amdgpu_dm_destroy_drm_device(struct amdgpu_display_manager *dm)
 {
-	drm_atomic_private_obj_fini(&dm->atomic_obj);
+	if (dm->atomic_obj.state)
+		drm_atomic_private_obj_fini(&dm->atomic_obj);
 }
 
 /******************************************************************************
-- 
2.39.5



