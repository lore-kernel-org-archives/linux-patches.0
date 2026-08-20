Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4C9410D30;
	Thu, 20 Aug 2026 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247169; cv=none; b=ERcafz0ZDUA5Xj18EmJy5Swdc9jydWyC7JQYaAdfEPxmfYRJtyczzWHw8G+psB+x71X06vquuOMJHUDCWseinlb9sLuOa6BYwsQ/veiQ4+Jsz+t7WbArMO8f3FrXISjbtwGmfcp+ZqLNCBnKs35EgLK19HL25XXhSi2ekehP5Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247169; c=relaxed/simple;
	bh=eT/GWAaQNiWCXDDP1Bqjk0sV2AvbX4I2UZ0WhIBFdb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGyxSdXXR16bfv8FW48ss3VE8ZsfqWZS0zLQLDMYS38fhwMCewR9LeiyNkHfAX1zK70EAspl4C1B4+Mw5x8tvO43Og+JIaVV/+PslQyyl8Cte/YYrjdlU5phIRPeR7H/x8aSkGJeWmSa+uLsl7aRRmsSzHRgN7L4gMo7zl4fOVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oByl1lrn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oByl1lrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE3D1F000E9;
	Thu, 20 Aug 2026 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247168;
	bh=D/u+aFD9U2p5R1Kob+7+zUMU43BQj+EEHWLHVrN2GRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oByl1lrnnXfJQbMWz85TumObrlkIp2oP0gcqY0i86LsqIA+O78u7zjxWaOVKyqrGJ
	 uDKHTvprETlDQ8o+OUo0i+PuXtLsIYt0facQA5FImKHBA2hXGYJ1hSckHqg/E72vbP
	 8Q061p6xloQ7ZaCmllLp61//fQw8ST1w9/GUyAWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/220] drm/amdgpu: move debug_vm handling to amdgpu_cs_parser_fini
Date: Thu, 20 Aug 2026 16:56:02 +0200
Message-ID: <20260820145228.646798070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit d8726ef11512754a68c0ab53c57634a569b8feff ]

The commit referenced below restarts the CS if the validation is
still in progress. When debug_vm is enabled, all BOs from the CS
are invalidated so we will hit an infinite loop.

To avoid that, defer BO invalidation to amdgpu_cs_parser_fini.

Fixes: 59720bfd8c6d ("drm/amdgpu: restart the CS if some parts of the VM are still invalidated")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8c990ee9daa295462df24982ce6878db997a380a)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1213,19 +1213,6 @@ static int amdgpu_cs_vm_handling(struct
 		job->vm_pd_addr = amdgpu_gmc_pd_addr(vm->root.bo);
 	}
 
-	if (adev->debug_vm) {
-		/* Invalidate all BOs to test for userspace bugs */
-		amdgpu_bo_list_for_each_entry(e, p->bo_list) {
-			struct amdgpu_bo *bo = e->bo;
-
-			/* ignore duplicates */
-			if (!bo)
-				continue;
-
-			amdgpu_vm_bo_invalidate(bo, false);
-		}
-	}
-
 	return 0;
 }
 
@@ -1412,6 +1399,8 @@ static int amdgpu_cs_submit(struct amdgp
 /* Cleanup the parser structure */
 static void amdgpu_cs_parser_fini(struct amdgpu_cs_parser *parser)
 {
+	struct amdgpu_device *adev = parser->adev;
+	struct amdgpu_bo_list_entry *e;
 	unsigned int i;
 
 	amdgpu_sync_free(&parser->sync);
@@ -1427,8 +1416,21 @@ static void amdgpu_cs_parser_fini(struct
 
 	if (parser->ctx)
 		amdgpu_ctx_put(parser->ctx);
-	if (parser->bo_list)
+	if (parser->bo_list) {
+		if (adev->debug_vm) {
+			/* Invalidate all BOs to test for userspace bugs */
+			amdgpu_bo_list_for_each_entry(e, parser->bo_list) {
+				struct amdgpu_bo *bo = e->bo;
+
+				/* ignore duplicates */
+				if (!bo)
+					continue;
+
+				amdgpu_vm_bo_invalidate(bo, false);
+			}
+		}
 		amdgpu_bo_list_put(parser->bo_list);
+	}
 
 	for (i = 0; i < parser->nchunks; i++)
 		kvfree(parser->chunks[i].kdata);


