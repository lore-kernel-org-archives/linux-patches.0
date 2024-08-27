Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C61D0493;
	Tue, 27 Aug 2024 15:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772513; cv=none; b=QKogOhZqG91jP4bQZqRVLLfD0pJ0yEhGHW4xjX9TdP7rZV+Fl8G5ivhDqRr4xDWnJH6/lNntScbOW+3NMGKSY/NkKoeTTF2e/IDs8yfHdV/n1xdduEoQbqO25Y4Xu/y7kXnWfNhUkMq3z3Hszz3pWeFlm1VOghrThJ3aj8TZCb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772513; c=relaxed/simple;
	bh=GjVgfnSslwzAfoHYFQ4Q4vbKcmN4031ZHE7z3AFSyEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k94hyAuU7bfmv6iyWmNueQz8KMhPfMh+klPWTJDwEWUSirnbkE4RFCve2N7mo0K0i6Ao5wS9XTZR9WWFEdI5E+F3EpRTJvWL0Oe1pekXaIas6rMr+wn/ncs7YlEae7gJsFl3W05aPuHd1JwkZsqnqKRuyTHcI+mIOmUo25BJ35A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZ0dLtiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZ0dLtiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE027C6107B;
	Tue, 27 Aug 2024 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772513;
	bh=GjVgfnSslwzAfoHYFQ4Q4vbKcmN4031ZHE7z3AFSyEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZ0dLtiIkEheYCc9V1195OjHUJRAWOpG1F48CnLzqZa8b1q18xLD9zk+1udoYi0WL
	 E2QDuyI3LT4a9nL9URJeoPZY/EbnxjkLJI0Bv5AE+2UAALYYwk3RjVK+Cd1JVlNRNI
	 8YMWQvniBxqGnRJ02zF/8HhUdQ8p+aBYsG+Tig/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/321] drm/amdgpu: fix dereference null return value for the function amdgpu_vm_pt_parent
Date: Tue, 27 Aug 2024 16:38:34 +0200
Message-ID: <20240827143846.075307838@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 511a623fb46a6cf578c61d4f2755783c48807c77 ]

The pointer parent may be NULLed by the function amdgpu_vm_pt_parent.
To make the code more robust, check the pointer parent.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
index 69b3829bbe53f..370d02bdde862 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -754,11 +754,15 @@ int amdgpu_vm_pde_update(struct amdgpu_vm_update_params *params,
 			 struct amdgpu_vm_bo_base *entry)
 {
 	struct amdgpu_vm_bo_base *parent = amdgpu_vm_pt_parent(entry);
-	struct amdgpu_bo *bo = parent->bo, *pbo;
+	struct amdgpu_bo *bo, *pbo;
 	struct amdgpu_vm *vm = params->vm;
 	uint64_t pde, pt, flags;
 	unsigned int level;
 
+	if (WARN_ON(!parent))
+		return -EINVAL;
+
+	bo = parent->bo;
 	for (level = 0, pbo = bo->parent; pbo; ++level)
 		pbo = pbo->parent;
 
-- 
2.43.0



