Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E82F46C82A;
	Thu, 20 Aug 2026 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248553; cv=none; b=EnrEnpi6OcLw48dQoX1Chjjk8NQqbCTVEf5fN6m/v1e6MonIPgbRmGdRBzsaqvAaSxP4T0J23q55rgqAur4tdPBU1BDpXPPURUZHBSd0zW19N3A6KlThlLRJongw9FKJzhFgjhlA0pdNU0ILSCIvqXoEgg2/AG3xr4G/emfQQLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248553; c=relaxed/simple;
	bh=oZ8loFM3rc9NApotBlVO+XXDD0Fgp+6tdBXvK5CbI/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sr7T0Fh4LDLL2BGCck4lSCIPGUU/UnkOsfCa8W1764lq7JyrRaj51RYX8aalDG3wFNWvKMVNLe9UQlwJdBl1wQHnka4wrbRxTaU3B/oXAt+EY7ttTu0Klq2kp82xo0QCggHKSoU6J9V56VsayXeFYeuCwneexsDF6b59BDMEFns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxjN3Fzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxjN3Fzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2DC1F000E9;
	Thu, 20 Aug 2026 17:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248552;
	bh=W6554/SKob95gTa8X/x3Xay6Pmg7ikMagvZuy1yLTZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxjN3FzdYhCeRMM+3hdbPnB/jIRinxYjTdAKMQ/xO8fNYYxzDrkvKv6qPtky8tOoY
	 Y2e1pXriTT6Tvl5xRKNtr+mBHfZc2XVMq4BcclMJQyuLA3BDyheWK+tqk9m1OWM8Fn
	 bKEuxLK2v5JIc013BieSvioTwjDEGN7Bi3NmeB+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 266/303] drm/amdgpu: move debug_vm handling to amdgpu_cs_parser_fini
Date: Thu, 20 Aug 2026 16:56:42 +0200
Message-ID: <20260820145301.447171544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1153,19 +1153,6 @@ static int amdgpu_cs_vm_handling(struct
 		job->vm_pd_addr = amdgpu_gmc_pd_addr(vm->root.bo);
 	}
 
-	if (amdgpu_vm_debug) {
-		/* Invalidate all BOs to test for userspace bugs */
-		amdgpu_bo_list_for_each_entry(e, p->bo_list) {
-			struct amdgpu_bo *bo = ttm_to_amdgpu_bo(e->tv.bo);
-
-			/* ignore duplicates */
-			if (!bo)
-				continue;
-
-			amdgpu_vm_bo_invalidate(adev, bo, false);
-		}
-	}
-
 	return 0;
 }
 
@@ -1325,6 +1312,8 @@ static int amdgpu_cs_submit(struct amdgp
 /* Cleanup the parser structure */
 static void amdgpu_cs_parser_fini(struct amdgpu_cs_parser *parser)
 {
+	struct amdgpu_device *adev = parser->adev;
+	struct amdgpu_bo_list_entry *e;
 	unsigned i;
 
 	for (i = 0; i < parser->num_post_deps; i++) {
@@ -1337,8 +1326,21 @@ static void amdgpu_cs_parser_fini(struct
 
 	if (parser->ctx)
 		amdgpu_ctx_put(parser->ctx);
-	if (parser->bo_list)
+	if (parser->bo_list) {
+		if (amdgpu_vm_debug) {
+			/* Invalidate all BOs to test for userspace bugs */
+			amdgpu_bo_list_for_each_entry(e, parser->bo_list) {
+				struct amdgpu_bo *bo = ttm_to_amdgpu_bo(e->tv.bo);
+
+				/* ignore duplicates */
+				if (!bo)
+					continue;
+
+				amdgpu_vm_bo_invalidate(adev, bo, false);
+			}
+		}
 		amdgpu_bo_list_put(parser->bo_list);
+	}
 
 	for (i = 0; i < parser->nchunks; i++)
 		kvfree(parser->chunks[i].kdata);


