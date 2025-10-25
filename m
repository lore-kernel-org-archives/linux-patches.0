Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001DB303A1E;
	Sat, 25 Oct 2025 16:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409223; cv=none; b=f50r9OJauunPe02aiB+WfOt2TIYfG0QEVtO2RlyBKsDbS5KuAbaloO082dxXapECfu/yGqdm8XqwqDkJwSSYx1bGeE5ht4UhRzFvbrGhDbE4tFHdgPVfVjjVXpXdoPv8cc+r4geho0UGqkLva/FcfAbsrhVDTEIED6gkEzV73tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409223; c=relaxed/simple;
	bh=cxOFZm6VnbsnkY2qI+t1K+yEmFfKosTkeskzB4b2b98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KRzp/e1WWK3W1bdVW8WXdxYFPWXCnFgsri3VJii83WsNrP6hYpuZ9npM0978/1hazkB5zumJ57BH9hMSdCBPvjkhGWd0XnBPsua2eX/JXiHdxmrHd5FcWL+nGaLTYzIceLs6/Rx04DsMMzUq9JPJZtPSwyZQJzYHFrz4RbgCVgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrqV4laj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrqV4laj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A803EC116B1;
	Sat, 25 Oct 2025 16:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409222;
	bh=cxOFZm6VnbsnkY2qI+t1K+yEmFfKosTkeskzB4b2b98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrqV4lajR8Ourbt5toLjRHa7AdZI/2qUllLf3TdjrK/wEex7sJBKT9tZS3NcjpJP2
	 /XzAweIBKV2RWApFcw2tKQ/QfMa+Zv8j3emBPx6q71UKEjUqXIHWEBIppN2HPzgCGf
	 V88Vd1LlpM8gjVna7CR8My9/pJEr6Gc0QSrpOIsR5yKY1gLKJ56XVjjLOaSN6hDoET
	 rnKX13L3+iaynfaHG0nLd4VyTLEamxmClfmQm6ebDkpTSR7H/wlT5CNcpokcetkWNV
	 E2/JOCPSDvEEjXhWwUdZKmFthImqsGOLZnIw3XUDgl6WLN/VhbbOVK6JHBsxhhHINp
	 9RiX+IyupbZtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	srinivasan.shanmugam@amd.com,
	sunil.khatri@amd.com,
	tvrtko.ursulin@igalia.com,
	Tong.Liu01@amd.com,
	alexandre.f.demers@gmail.com,
	mario.limonciello@amd.com
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amdgpu: reject gang submissions under SRIOV
Date: Sat, 25 Oct 2025 11:57:59 -0400
Message-ID: <20251025160905.3857885-248-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

[ Upstream commit d7ddcf921e7d0d8ebe82e89635bc9dc26ba9540d ]

Gang submission means that the kernel driver guarantees that multiple
submissions are executed on the HW at the same time on different engines.

Background is that those submissions then depend on each other and each
can't finish stand alone.

SRIOV now uses world switch to preempt submissions on the engines to allow
sharing the HW resources between multiple VFs.

The problem is now that the SRIOV world switch can't know about such inter
dependencies and will cause a timeout if it waits for a partially running
gang submission.

To conclude SRIOV and gang submissions are fundamentally incompatible at
the moment. For now just disable them.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – Rejecting gang submissions on SR-IOV VFs prevents real GPU
hangs/timeouts without touching any other paths.

**Why Backport**
- SR-IOV world switching can preempt only part of a gang submission, so
  one engine waits forever on the others and the VF times out; the new
  guard rejects those multi-entity submissions up front. The fix is a
  single check added to `amdgpu_cs_pass1()` that returns `-EINVAL` when
  `p->gang_size > 1` on a VF
  (`drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c:273`).
- `amdgpu_sriov_vf()` already exists and is widely used; the change is
  contained and triggered only in the broken configuration.

**Risk**
- Behavioural change is limited to SR-IOV VFs; bare-metal and PF paths
  stay identical.
- Users that attempted gang submit on a VF now get a clean `-EINVAL`
  instead of a GPU hang. That feature never functioned correctly in this
  mode, so the regression risk is minimal compared to the current
  failure mode.

**Next Steps**
- Backport the guard; no additional prerequisites are needed. Consider
  also backporting the accompanying IDS flag patch so user space can
  detect gang-submit availability.

 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index d541e214a18c8..1ce1fd0c87a57 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -286,7 +286,7 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 		}
 	}
 
-	if (!p->gang_size) {
+	if (!p->gang_size || (amdgpu_sriov_vf(p->adev) && p->gang_size > 1)) {
 		ret = -EINVAL;
 		goto free_all_kdata;
 	}
-- 
2.51.0

