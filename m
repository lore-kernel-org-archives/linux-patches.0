Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B36D3F58C4;
	Fri,  7 Aug 2026 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115566; cv=none; b=mpDnod3sKnkN4YDNbLLRDJHNIlD+N9zvwF7ysmb1UD42kWB3dHNFjuRNfqsDk01yhn/zXgzlpJ4/y1si3Hf/kuU65KgTlw4IjRRdLbOzCX9o9oIKT3NJcH1PCDQ7XwabhBLWFfJfEcNJa9UbefcV0ZywUt5EAGlBPNBKeUAaTX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115566; c=relaxed/simple;
	bh=iAWg0SWvQU9+hZ5yai26YzVIxaGVzcZxw4XiGhXnvo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eveSFwsPH3i4o5FARqE19cmMg4hwIqL3gCj2nNH6iMNR7S1wbKeWICc+gD2H6oX6F3Ip5lBLOFU2qft/nQqVqxnvMTDD8GzLUegChW4XLX1XhtsQpRk4og+p0CalGyX8yJ8BujAZngzDAg5dVZGj4zIMGDdBbi8QIlUkPVtI2zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUfhMCnY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUfhMCnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F394D1F00AC4;
	Fri,  7 Aug 2026 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115562;
	bh=YjR/ze/N03Ty8msmHzTlP99QyLIOhy3Uum43JaPzd+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUfhMCnYLoFLi8/D3xS90MFAsNiFmQ7hOxN7aFWQE1+7X5n4gzR5lsMs7ss+P23jw
	 deiBfLEweGJ1s+16PBqwObmGTED2BhjCS0NYtBfWQOcNY6fR/yubd+r3OAhB4Jg/ep
	 oVpDGPNzRTcmrjEXbB4UYgGxpRwrgeQor8oDbTvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 319/396] drm/amdgpu: move debug_vm handling to amdgpu_cs_parser_fini
Date: Fri,  7 Aug 2026 16:37:59 +0200
Message-ID: <20260807143431.146869156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

commit d8726ef11512754a68c0ab53c57634a569b8feff upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1187,19 +1187,6 @@ static int amdgpu_cs_vm_handling(struct
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
 
@@ -1389,6 +1376,8 @@ static int amdgpu_cs_submit(struct amdgp
 /* Cleanup the parser structure */
 static void amdgpu_cs_parser_fini(struct amdgpu_cs_parser *parser)
 {
+	struct amdgpu_device *adev = parser->adev;
+	struct amdgpu_bo_list_entry *e;
 	unsigned int i;
 
 	amdgpu_sync_free(&parser->sync);
@@ -1404,8 +1393,21 @@ static void amdgpu_cs_parser_fini(struct
 
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


