Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78996208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sv0a8nqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB117C433C8;
	Mon,  6 Nov 2023 13:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276751;
	bh=jgKj2kprXlTeP6SoeBfzj2pQbNl6ueV2POXkNn6JAJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv0a8nqsUO8LpGDRindV8iw/9fT0rBijEAH09ZWYjl2fe5Lcgz7V5f46hVAaUCKDK
	 MPGj0CBsn1nD2oOtukAqGuZaeilAxsbT5mJpv/B5WrL5FGEHETYAQl2M5Kxik1p3Il
	 O2hEqcx8zPqqa7SFWLFR1cAyHFevo5iYq+TVqV/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <Alexander.Deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 45/88] gpu/drm: Eliminate DRM_SCHED_PRIORITY_UNSET
Date: Mon,  6 Nov 2023 14:03:39 +0100
Message-ID: <20231106130307.503752025@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit fa8391ad68c16716e2c06ada397e99ceed2fb647 ]

Eliminate DRM_SCHED_PRIORITY_UNSET, value of -2, whose only user was
amdgpu. Furthermore, eliminate an index bug, in that when amdgpu boots, it
calls drm_sched_entity_init() with DRM_SCHED_PRIORITY_UNSET, which uses it to
index sched->sched_rq[].

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Acked-by: Alex Deucher <Alexander.Deucher@amd.com>
Link: https://lore.kernel.org/r/20231017035656.8211-2-luben.tuikov@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 3 ++-
 include/drm/gpu_scheduler.h             | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index 092962b93064f..aac52d9754e6d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -64,7 +64,8 @@ amdgpu_ctx_to_drm_sched_prio(int32_t ctx_prio)
 {
 	switch (ctx_prio) {
 	case AMDGPU_CTX_PRIORITY_UNSET:
-		return DRM_SCHED_PRIORITY_UNSET;
+		pr_warn_once("AMD-->DRM context priority value UNSET-->NORMAL");
+		return DRM_SCHED_PRIORITY_NORMAL;
 
 	case AMDGPU_CTX_PRIORITY_VERY_LOW:
 		return DRM_SCHED_PRIORITY_MIN;
diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
index f9544d9b670d3..ac65f0626cfc9 100644
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -68,8 +68,7 @@ enum drm_sched_priority {
 	DRM_SCHED_PRIORITY_HIGH,
 	DRM_SCHED_PRIORITY_KERNEL,
 
-	DRM_SCHED_PRIORITY_COUNT,
-	DRM_SCHED_PRIORITY_UNSET = -2
+	DRM_SCHED_PRIORITY_COUNT
 };
 
 /* Used to chose between FIFO and RR jobs scheduling */
-- 
2.42.0



