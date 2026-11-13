Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591217;
	b=RJIud1fxUI8tomDXELMpa7n0KacsCjvS/bSjYfckVzoMfDwtSXdtZa4AZPYV2iy+yGO/
	 amlfruhuDzXrpMtWG8dlYyTU8+h/LS05p+L5cK8jAcXkAU3/UOCJG4bKYA6ZLe0mFdCIs
	 brQUIRyMrND6d8EOXYt0vx+lAeLoYiyWLQbK49XNuWOhU//EbkELgsqbMO7D2RX98nf4T
	 MRuFdCIfcwxciO7mw6CJ+fsW1QAo9dOxq26yh944bOzCjf1MQz2dLcqDZL83Tf9vfeHx/
	 X7WP+HOOFClSn7VDG0n7uDJs6GcjYVGCps03I93+8Ow1K2mXe0u9oZBDhu91/wjRiMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IYNSVDAp8fXFnFxe8N+zeAnYPpN63c9fSt3pwjn1lAM=;
	b=3Q9qFbIxiRHdV1dADnnyLxlEbfcW8QLXL23Fqz3GSODZoYl+uHZd1iWcXEPOq4ATFsCy
	 /OHrq2HdgO44Ma/ryV698Yjh31NGP78IYayYE6LDi2QW7ZhQdAJxckQOr+a+4yJzjd3XR
	 GjdEFvCeKXuGbN9x68kuD5kknkYgUgLCxXK8vUn/72vd2U0383QDN7vmNCxDcMQbU9c7Q
	 zXjuXKAL9GYukezUIl9vmpB1JNo3wEOLZImPWhoOuR5vThxqYhoHNeic39c9ehg6pwg/Q
	 BfkvDHg9asiVWviw2Ssp6bKX76I+c3LunS7diMb9cWmZiD+njR95LHF56yc9ADkf4KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XCOVFt7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B5F6075873;
	Fri, 13 Nov 2026 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XCOVFt7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DAD1F000C7;
	Fri, 13 Nov 2026 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591217;
	bh=IYNSVDAp8fXFnFxe8N+zeAnYPpN63c9fSt3pwjn1lAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2XCOVFt7zG7ijSkPrCWW/1zxibysHereksPxj5OdOX8pSuZ81olmM2cCFEtGUvAZj
	 X99GKRNUY5dVsB58cvEsvh7MkwJG06Egz0/twelg65Ofk414agZGCNpi8fFZy72Ib0
	 9XprfvVdbtt0dua8p4RMTYmzpYOB8CzG9rYteU2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Erhan Bilgili <erhan.bilgili@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 350/670] drm/amdgpu: Fix duplicate dependency fence releases
Date: Fri, 13 Nov 2026 10:48:34 -0500
Message-ID: <20261113153823.691729207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erhan Bilgili <erhan.bilgili@gmail.com>

[ Upstream commit ea47f84199241dd083d40a241beea665415d4f6c ]

drm_sched_job_add_dependency() consumes its fence reference on success
and failure. Do not release the fence again if
drm_sched_job_add_dependency() fails.

Fixes: 41cc108b2451 ("drm/amdgpu: fix missing dma_fence_put in error path")
Fixes: c1c4a8b21721 ("drm/amdgpu: grab extra fence reference for drm_sched_job_add_dependency")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Erhan Bilgili <erhan.bilgili@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e04f3dfb2071451633e6440a3911a9bb65df9144)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c    | 4 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index 86c17a8946f5d..8fe4974116011 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -423,10 +423,8 @@ int amdgpu_sync_push_to_job(struct amdgpu_sync *sync, struct amdgpu_job *job)
 
 		dma_fence_get(f);
 		r = drm_sched_job_add_dependency(&job->base, f);
-		if (r) {
-			dma_fence_put(f);
+		if (r)
 			return r;
-		}
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index 902d0a538e419..dd72891624ebb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -234,7 +234,6 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
 		dma_fence_get(fence);
 		r = drm_sched_job_add_dependency(&p->job->base, fence);
 		if (r) {
-			dma_fence_put(fence);
 			dma_resv_iter_end(&cursor);
 			return r;
 		}
-- 
2.53.0



