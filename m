Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2F83932C8;
	Thu, 30 Jul 2026 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427560; cv=none; b=hK+k7Enk3xobg854CHC1TnCRXOKC9hxJT/hu25Ok1aNgyMx5YGkCxs1qpKbOmy4NpHfZk2qdIWsv7gkWcX0fXkL9mb5JXv0hjrYb6JCAZZZoMLp0yH1pHcLjdb8Lgerar1eujT8aiM8dV0ehG0TEqTlw6iFrivIl64XwicSwFDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427560; c=relaxed/simple;
	bh=oiyJL3TAmIdP9guSYBvyDIbFuw8P4MKzZtFulXcQDpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RxLTZdENC6mac42I4GlXqGjtGJu5kSVuTNlkEwUpR1ebqfwfYuNdPYukAQhcyc9N9+DwYYcZvC4QsmRzSzG3uQZBRmUWSUb+Q6NmJ8O6pRQM3GT/m0iI65Mim1Sx5VRNegf63Eg185iRnyeoWc59uX3PELfQk0f2YbF2Kl/2R0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWCjjaz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWCjjaz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B961F000E9;
	Thu, 30 Jul 2026 16:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427559;
	bh=iQcRHSJBNDkgP8Tvgdjch6sLiKcT9qa4jFbj3YtPmXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWCjjaz+eIcTJgMhCDg70uCxFouBDkEv5NCr/Z9eGxlLJ0HZEKwyzDobsyfTN0tMP
	 +CARuKPkOdUCGcHTq0XCjN61wls20B3rl9uw7/MwZoh36sk2CCtMIhg+zpy4woDJ0w
	 BvCHmIHNp3PV65zkcelCrKcR+D9b1UnwqjcC7Hp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 212/484] drm/amdgpu: Fix amdgpu_bo_move() when old_mem and new_mem are both GTT
Date: Thu, 30 Jul 2026 16:11:49 +0200
Message-ID: <20260730141428.077738750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit ee94a65f192c05c543b4d3ad7137cd696b5c18fc upstream.

The UVD code relies on GTT to GTT moves in order to ensure
that its BOs don't cross 256M segments.

Fixes: bfe5e585b44f ("drm/ttm: move last binding into the drivers.")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 21fd45e5e2628d00b478590bcc3d14d3de5d45b6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -479,6 +479,15 @@ static int amdgpu_bo_move(struct ttm_buf
 
 	if (new_mem->mem_type == TTM_PL_TT ||
 	    new_mem->mem_type == AMDGPU_PL_PREEMPT) {
+		if (old_mem && (old_mem->mem_type == TTM_PL_TT ||
+				old_mem->mem_type == AMDGPU_PL_PREEMPT)) {
+			r = ttm_bo_wait_ctx(bo, ctx);
+			if (r)
+				return r;
+
+			amdgpu_ttm_backend_unbind(bo->bdev, bo->ttm);
+		}
+
 		r = amdgpu_ttm_backend_bind(bo->bdev, bo->ttm, new_mem);
 		if (r)
 			return r;
@@ -511,6 +520,15 @@ static int amdgpu_bo_move(struct ttm_buf
 		amdgpu_bo_move_notify(bo, evict, new_mem);
 		ttm_resource_free(bo, &bo->resource);
 		ttm_bo_assign_mem(bo, new_mem);
+		return 0;
+	}
+	if ((old_mem->mem_type == TTM_PL_TT ||
+	     old_mem->mem_type == AMDGPU_PL_PREEMPT) &&
+	    (new_mem->mem_type == TTM_PL_TT ||
+	     new_mem->mem_type == AMDGPU_PL_PREEMPT)) {
+		amdgpu_bo_move_notify(bo, evict, new_mem);
+		ttm_resource_free(bo, &bo->resource);
+		ttm_bo_assign_mem(bo, new_mem);
 		return 0;
 	}
 


