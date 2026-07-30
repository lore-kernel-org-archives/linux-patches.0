Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B005439343;
	Thu, 30 Jul 2026 14:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422435; cv=none; b=Vp8rfz+cINKN+W/fRKZjlKhnMuJm69y7w54FaiN+gwsXKghQF7uZfsL6DXjPPdReBtJ+MY8cwlCYp9SmzInJ+0vJ66i9RonrsI5sCA8Vsoj8PXbD+5ZL6rSRkTi8nbMMcul39v3B3e+s4tfiKSyutW8rOmCWJ/sghc/eywAEkcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422435; c=relaxed/simple;
	bh=oM8aC3zppHxArpjrRwVIhnCJmzlE/RgTyEA2/DfvZNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ho832SQKXwdFX+ysyFx+VJgJCusn779VyWt5ZrNYAauWFXQ4nxHV03USrRLgt0HjZUKGh4G9/B+zsAhsxgDhJStBP50dfg7cCNIPXcKJR73gwjcKDEandryxT6hu1Pl9DebAwFEHRPNeOlnsGih5gXNxBM+NFQ8epnhmMCzwGls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15rLutDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15rLutDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C416D1F000E9;
	Thu, 30 Jul 2026 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422434;
	bh=yLGRXmMD7fTZ13qV7zafRkQTmTGiHHPYQJGapjsQL9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15rLutDfBlr732GC1Vrp8G3kb2OgiuMuRRl6CKpCNuSz5Xal03jb2pcMXfZvts+ff
	 TiBJ3L0Daa7Et2tJr8R7RU+gp/FTQdyLsRAy47e/R7b2kWU10wLQed4Dk/bn7yokfF
	 pLsbXW+7vABjHBFZPsM0Vih96rXu8YkMlQ4CI1+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahyan Soltani <shahyan.soltani@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 437/744] drm/amdgpu: fix lifetime issue of amdgpu_vm_get_task_info_pasid()
Date: Thu, 30 Jul 2026 16:11:50 +0200
Message-ID: <20260730141453.586607102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahyan Soltani <shahyan.soltani@amd.com>

commit 04cc4aa3617b0ed67e859f91f09de5d896a46f3a upstream.

The vm pointer returned from amdgpu_vm_get_vm_from_pasid() is only
valid while the lock is still being held. Once xa_unlock_irqrestore is
called and returned, the pointer is no longer under lock and is subject
to modification. Since, the caller still dereferences vm->task_info in
amdgpu_vm_get_task_info_vm() after the lock is removed, this causes a
use after unlock problem.

Remove the lifetime issue present in amdgpu_vm_get_task_info_pasid()
through removing the amdgpu_vm_get_vm_from_pasid() function from
amdgpu_vm.c and making the relevant code inline to hold the lock while
it is still in use.

Signed-off-by: Shahyan Soltani <shahyan.soltani@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9d01579f3f868b333acc901815972685989092c7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2487,19 +2487,6 @@ static void amdgpu_vm_destroy_task_info(
 	kfree(ti);
 }
 
-static inline struct amdgpu_vm *
-amdgpu_vm_get_vm_from_pasid(struct amdgpu_device *adev, u32 pasid)
-{
-	struct amdgpu_vm *vm;
-	unsigned long flags;
-
-	xa_lock_irqsave(&adev->vm_manager.pasids, flags);
-	vm = xa_load(&adev->vm_manager.pasids, pasid);
-	xa_unlock_irqrestore(&adev->vm_manager.pasids, flags);
-
-	return vm;
-}
-
 /**
  * amdgpu_vm_put_task_info - reference down the vm task_info ptr
  *
@@ -2546,8 +2533,16 @@ amdgpu_vm_get_task_info_vm(struct amdgpu
 struct amdgpu_task_info *
 amdgpu_vm_get_task_info_pasid(struct amdgpu_device *adev, u32 pasid)
 {
-	return amdgpu_vm_get_task_info_vm(
-			amdgpu_vm_get_vm_from_pasid(adev, pasid));
+	struct amdgpu_task_info *ti;
+	struct amdgpu_vm *vm;
+	unsigned long flags;
+
+	xa_lock_irqsave(&adev->vm_manager.pasids, flags);
+	vm = xa_load(&adev->vm_manager.pasids, pasid);
+	ti = amdgpu_vm_get_task_info_vm(vm);
+	xa_unlock_irqrestore(&adev->vm_manager.pasids, flags);
+
+	return ti;
 }
 
 static int amdgpu_vm_create_task_info(struct amdgpu_vm *vm)


