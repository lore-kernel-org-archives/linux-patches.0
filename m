Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBC33D75C7;
	Wed, 20 May 2026 17:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296710; cv=none; b=W+s8/knZjQ4a/+uq7AUzLGKnOZod7ELrjYUOOIu0xnlZPfjlQD/7ZwhOh41JSbPl/q9QPyhSX6AEfy5ZLEl76A4m9FR2Qa2hkOGX3tc/dc3rUMn+0cQupvxN8naHUlE12jeX0uYZZL30dGHJftr524aRd4uNG3FNMW1749Jin/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296710; c=relaxed/simple;
	bh=JveKBoI5TKLq6Bp73h6TJT9uRMv+3zZiSUAUO25ModU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VsyNLAm9C1ehsvMqoVdc2s0HX4o0q9KB9eR1ckMxS1zGc8cTgz+bcPRXQnZKZH+JgJXf+UOUIf4AXsq9MysNsKLH+GpqZ027IuiXsgk/atC6uuOXPEneK8Dyuu9mie1iUVXhQGIHkEtzJEZQajfbPfEYqMbHbS9guY3OwhVQc4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+mIfYw/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+mIfYw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AA41F000E9;
	Wed, 20 May 2026 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296709;
	bh=NeqXPKD/0UUEcBADTI1EgSI6P3ZlCQji436YhQyZHPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+mIfYw/XeLV+o7IUjZ+iwpZymtHvYUO2ZtuHuUEFvz63AiofbN/r1v7C0QXqevFm
	 acvtYYuIZJEZx0jBNc3Xh/R/K3DgGYwQIgLFCmUXxh5+zoTR97NYrkQys4sTAMxYpE
	 9Spy3u2kUpFuXfaTzgOpGuKEUzWTb+Fj5ECYGs+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Slavin Liu <220245772@seu.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0901/1146] drm/amdgpu: avoid double drm_exec_fini() in userq validate
Date: Wed, 20 May 2026 18:19:11 +0200
Message-ID: <20260520162208.625953587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 508babf310365f1107a2e8831c267c292a286818 ]

When new_addition is true, amdgpu_userq_vm_validate() calls
drm_exec_fini(&exec) before iterating over the collected HMM ranges and
calling amdgpu_ttm_tt_get_user_pages().

If amdgpu_ttm_tt_get_user_pages() fails in that path, the code jumps to
unlock_all and calls drm_exec_fini(&exec) a second time on the same
exec object. drm_exec_fini() is not idempotent: it frees exec->objects
and may also drop exec->contended and finalize the ww acquire context.

Route that error path directly to the range cleanup once exec has
already been finalized.

Fixes: 42f148788469 ("drm/amdgpu/userqueue: validate userptrs for userqueues")
Issue found using a prototype static analysis tool
and confirmed by code review.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Signed-off-by: Slavin Liu <220245772@seu.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2802952e4a07306da6ebe813ff1acacc5691851a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index caca0c4aeefe7..0e015741ab24e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -1231,7 +1231,7 @@ amdgpu_userq_vm_validate(struct amdgpu_userq_mgr *uq_mgr)
 			bo = range->bo;
 			ret = amdgpu_ttm_tt_get_user_pages(bo, range);
 			if (ret)
-				goto unlock_all;
+				goto free_ranges;
 		}
 
 		invalidated = true;
@@ -1258,6 +1258,7 @@ amdgpu_userq_vm_validate(struct amdgpu_userq_mgr *uq_mgr)
 
 unlock_all:
 	drm_exec_fini(&exec);
+free_ranges:
 	xa_for_each(&xa, tmp_key, range) {
 		if (!range)
 			continue;
-- 
2.53.0



