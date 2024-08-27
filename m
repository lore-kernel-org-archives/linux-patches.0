Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735171BC097;
	Tue, 27 Aug 2024 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770396; cv=none; b=UH/N8bvyw4sNvQiTQxNHrn7SuK1zDHRQIfyk/5OWI9X9g+5SkXZ/vNUSPX9Vjmq0kV06GceRS3IWF8/bxOHgUOlOWyqM6EgH7BCeT16CXDKmgBu/6jGmArpb9uEguDd4QucjO9/mCN1QqCpWRae/cW9fMV8MW/EOScVnQY5MSSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770396; c=relaxed/simple;
	bh=QQTIBRJtemn34QAnXkZK2w3/MaTiMrbNkiShI7skNjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHNXLqWyxr9agziqVLYcSUlSFD3QQYrP+lWn5J0H7/Z/KOGBpqaZ4S++impsRLsKD79Ag5JEW0KJfAQfl+ow81/jDLzhNxmABf3Pe/rVGJHye7pugzZJtFADBFaaAIrNX3KofDaZN27dII0nRplu191qFbITs9P/GkgkCns6SQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Krc4rheu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Krc4rheu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B1BC61042;
	Tue, 27 Aug 2024 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770396;
	bh=QQTIBRJtemn34QAnXkZK2w3/MaTiMrbNkiShI7skNjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Krc4rheuiV2UixW/Df1kIJNirvWn98RnrT/BzS47MbPN5Cr4A3LMSVRSM0KgCv/uv
	 bYLN4waLxEycI9/mihIId2Ib2q/Kl3gr9Hn/KtxM6jrpllH4RzLSAmdTb9vskuHgDL
	 I4Icx86WqqZAvE8iGm2jfRLJz7gYf0VoE9a2B2/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/341] drm/amdgpu: fix dereference null return value for the function amdgpu_vm_pt_parent
Date: Tue, 27 Aug 2024 16:37:26 +0200
Message-ID: <20240827143851.591718503@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0d51222f6f8eb..026a3db947298 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -766,11 +766,15 @@ int amdgpu_vm_pde_update(struct amdgpu_vm_update_params *params,
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



