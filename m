Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9BA33438F;
	Thu, 30 Jul 2026 15:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426182; cv=none; b=TanNJGv/5ZGcM5MgvUf0MFvysNgzLMoxH8EDyh4Ifbsg2KgQ9rRW/RodJf22hUYx8LKdkygmP/hb6zW37NbU4jPTnjm0FnH12xTYmzSMjTe8kEvuqu/6+G33g4XmWhm+WX6ysbrdJQfQzQbchRYbIPKdrXmu9PUqGulmLSby1HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426182; c=relaxed/simple;
	bh=vpEbfrz2OEBXhqNyo/EtinyelXp5KZ+VLiPx+DG7F5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDT0DGePLhj1ty2Zmlst35Hs/t9WrTPmG5aHD3vjumqMtw7DaG2XTgGV7KiMwqr6mudgU/nd58HoRqjm9ydpq53CopNaw1IJDZyNj9ouw342kD0U1MZbKajAKRkYqYdV18OT3/y4IsWbqwIB2kvs85H8FPx1lm2vXnp6VUypBqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWG45o5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWG45o5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96AE1F000E9;
	Thu, 30 Jul 2026 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426181;
	bh=FpeDRsTJTU764JQrthf/KIdQ6Ga+MlwvCxrexAnaW1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWG45o5saFU6TLOg+evaH/YtLTtVt0FSqTwJcdcqu9OJcTdQXcEy1hiVk6j1uoXdx
	 7Rp542dkFsQwBM1ARX49Ze1yE66l52BJy5xok/Vq+IXVMxNsoWihKd/ba9+TgDpHAZ
	 5Qu/YtTPD8Ca9WoHXfcRgOQTaXyyF9QQx7vGt6Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahyan Soltani <shahyan.soltani@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 285/602] drm/amdgpu: fix lifetime issue of amdgpu_vm_get_task_info_pasid()
Date: Thu, 30 Jul 2026 16:11:17 +0200
Message-ID: <20260730141441.960350193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -2308,19 +2308,6 @@ static void amdgpu_vm_destroy_task_info(
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
@@ -2366,8 +2353,16 @@ amdgpu_vm_get_task_info_vm(struct amdgpu
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


