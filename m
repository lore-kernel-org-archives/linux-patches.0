Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF9A43F4BC;
	Thu, 30 Jul 2026 15:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424493; cv=none; b=HyFMOvp1dOXYqbeI5YHdDvp0IfBUXQS+qSwBcvKTlTeB1aV3M3DNj7EH8SHzxqzM+63WAJA/OoFReKuGIHLSucCj9IodtKmyGFhSAK0p7HX+FoTpNgHcLL0SQyHxmaTdhWwRCCGJwyoPUlVTwBmDKvc6Ku43pgkN6o/ungWJx90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424493; c=relaxed/simple;
	bh=YgdDvNRM09rdnG5TIbNVhpjOTQZAVHd8DRz22VBSLD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2unbaAa66K03lVFp3TJRArYQL8aKvziKoWp3O6CnrIsFCmi7SPHO9nuiB0Ty3rr4MS7SYOF5OMR5nondz4lEk6GFm0aUhA2AKSA/z8HjcX1O8/8r+DlyXRMy+ZX60e6QqXDVg4tz/vChSeHqn6c2rKjVdUmIrX9T0Ft89m9j+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpWhY3wL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpWhY3wL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B3C1F00A3A;
	Thu, 30 Jul 2026 15:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424492;
	bh=m/88je9mTuWdJqAbqOEijUfOf8B6wyTw4IPT12jM6wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpWhY3wLvF+oOSX0wll5ZAZ/F/M6UmQm75VX+Kd7TcKyh6ZzSYiZ06gdqAat5xBJp
	 g1r7kFoBdwwYumdLjHwIduOOIHu7poZKbdLKwKLpGeimUhOXL+6Xr7lM6gFarEfcT0
	 h0Cfk+pxMrK471sL3OQOdkBRDUzW3elE1yWM9Bh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahyan Soltani <shahyan.soltani@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 368/675] drm/amdgpu: fix lifetime issue of amdgpu_vm_get_task_info_pasid()
Date: Thu, 30 Jul 2026 16:11:38 +0200
Message-ID: <20260730141452.949720588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -2453,19 +2453,6 @@ static void amdgpu_vm_destroy_task_info(
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
@@ -2512,8 +2499,16 @@ amdgpu_vm_get_task_info_vm(struct amdgpu
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


