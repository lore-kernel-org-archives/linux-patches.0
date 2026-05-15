Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EB13FF1A0;
	Fri, 15 May 2026 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860384; cv=none; b=ZTvfmsqzX2ADmTApqBtXWlZojUPOIeWn4AxOYoJOVjVBpJV9+b/eVTK6DvCgydlCm2v2skm1usTVrV5sPRxnTbJ5RFa2mz9qa9Z2j5ldCz3AglEpyte1pgyjCl83EVs2r3R50hhZVIV7/bZbVIm+XHnXDYoX1wedizbks9HuI+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860384; c=relaxed/simple;
	bh=0ax9uf/d93L8+1ktJmo6GdUvNKCnhmPTSjDe7ZJaEOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bh+6fsxdwuA8fo3vPp8VjIu9+QFVOZZX1oBgeyGEfZvSpEdgba/lr1KqhNv9/nhZIny9FrmkIY6Ddzi/TqUAgi5N3dAC5CPa1UoVlNUpKraZ2bqJVMKoJM2tZXerIZ46K1QGUFDma/Q0KTKlOQZvpkgasQkO9kKZZskSsowVTj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqGxQA44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqGxQA44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E288C2BCB0;
	Fri, 15 May 2026 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860384;
	bh=0ax9uf/d93L8+1ktJmo6GdUvNKCnhmPTSjDe7ZJaEOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqGxQA440Wn/q/xoctn8Kte40BQWpsi8K4qEAoJ616/Zg+7YnRQ14A6vW7zduWnqc
	 w/Qo4xX3TedNi0jaREsfJ7MwvUxzRYSv9t7ncWohpkqHdvYw8Z5jDb6G3zeg4XmNls
	 6LldfGTnO9heuhT3PWjt8s8p8hKWGbexZ0Tf/wTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenglei Xie <Chenglei.Xie@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 069/144] drm/amdgpu: gate VM CPU HDP flush on reset lock
Date: Fri, 15 May 2026 17:48:15 +0200
Message-ID: <20260515154655.142602933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Chenglei Xie <Chenglei.Xie@amd.com>

commit ddda81c4d7e71e41b1be91d921fd85747eddbd12 upstream.

During GPU reset, the application could still run CPU page table updates. Each commit called
amdgpu_device_flush_hdp(), which on SR-IOV sends work through the KIQ ring.
That can advance sync_seq while the GPU is being reset,
leaving fence writeback out of sync and causing amdgpu_fence_emit_polling()
to time out on later KIQ use.

Fix:
amdgpu_vm_cpu_commit():
  Reset will flush HDP anyway, the HDP flush in amdgpu_vm_cpu_commit() can be skipped
  when a reset is ongoging.
  Take reset_domain->sem with down_read_trylock() before amdgpu_device_flush_hdp().
  If the reset path holds the write lock, skip the HDP flush so no HDP-related HW
  access (including KIQ) runs during reset; state is re-established after reset.

Signed-off-by: Chenglei Xie <Chenglei.Xie@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_cpu.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_cpu.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_cpu.c
@@ -21,6 +21,8 @@
  */
 
 #include "amdgpu_vm.h"
+#include "amdgpu.h"
+#include "amdgpu_reset.h"
 #include "amdgpu_object.h"
 #include "amdgpu_trace.h"
 
@@ -106,11 +108,19 @@ static int amdgpu_vm_cpu_update(struct a
 static int amdgpu_vm_cpu_commit(struct amdgpu_vm_update_params *p,
 				struct dma_fence **fence)
 {
+	struct amdgpu_device *adev = p->adev;
+
 	if (p->needs_flush)
 		atomic64_inc(&p->vm->tlb_seq);
 
 	mb();
-	amdgpu_device_flush_hdp(p->adev, NULL);
+	/* A reset flushed the HDP anyway, so that here can be skipped when a reset is ongoing */
+	if (!down_read_trylock(&adev->reset_domain->sem))
+		return 0;
+
+	amdgpu_device_flush_hdp(adev, NULL);
+	up_read(&adev->reset_domain->sem);
+
 	return 0;
 }
 


