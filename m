Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD86A350D65;
	Wed,  3 Dec 2025 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780938; cv=none; b=qumGRECljhA+KrPr1OFyFGe+9jgVBaIJfELZ6Qze878k2yc0OEGeQxgTZHzcQMPwGYSfPGQ54QDDcjfSzICglF/a0ARyQFYzkVQVdbh/1BmvA90SFSiHa8U2xJu75ib9610Nb5WlJmYRTtWoaTu4LpJjrYNNKW8duMmnw4jA+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780938; c=relaxed/simple;
	bh=m4bvjCWEtBtYqcBtPGIIQCauS71eoX73uUOGUIggaPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PB7+l0tYz62aSXB3s1s3Xk9dOEQU3DiBM5XHCt+mYPIkKoqwGTPycTW3Lij6omzopzl2Go5tmP6z+VIunadKLayizT1T5ikmDWdNkS4dbenkWMZTmCLnBOUFu2QKIXA5hdmmrbV/cF7MzWOrXIc8Czt93zUko+zrgjkRBi23jYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfupR/K1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfupR/K1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28459C4CEF5;
	Wed,  3 Dec 2025 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780938;
	bh=m4bvjCWEtBtYqcBtPGIIQCauS71eoX73uUOGUIggaPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfupR/K1wZ6OhwFsu9DH4FDBhEcs3Ibzdw8jQlcAgOzEIYbyR6ztHAd1M1ptbTxQw
	 PHSgpGSTcFIxQomgHchg1wuZe/5lI/OSSjurpFX9nwzN9aDZ2cQkXxCMCw2q/RSUPB
	 tIDtPNheJODsl+SK/4utPN1fYMS8n/5hUTLaUDDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 104/132] drm/amdgpu: attach tlb fence to the PTs update
Date: Wed,  3 Dec 2025 16:29:43 +0100
Message-ID: <20251203152347.140534129@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

commit b4a7f4e7ad2b120a94f3111f92a11520052c762d upstream.

Ensure the userq TLB flush is emitted only after
the VM update finishes and the PT BOs have been
annotated with bookkeeping fences.

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f3854e04b708d73276c4488231a8bd66d30b4671)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -917,7 +917,7 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_upd
 	}
 
 	/* Prepare a TLB flush fence to be attached to PTs */
-	if (!params->unlocked && vm->is_compute_context) {
+	if (!params->unlocked) {
 		amdgpu_vm_tlb_fence_create(params->adev, vm, fence);
 
 		/* Makes sure no PD/PT is freed before the flush */


