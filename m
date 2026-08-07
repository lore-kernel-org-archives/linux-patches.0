Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E64F4746B7;
	Fri,  7 Aug 2026 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117784; cv=none; b=E6Rxi8ZrL3Z7e87zyAsEEQjsBSgo2QR9QHWT7y3vmLNQl2RpArTY0lEEWI7P5nR7uCvb+AsoX/mUMk6K2tYcd7EqgW15CcGwE1gfM/Ssdyqv1Nc5lR6mIT44D0FEvGJjVPptH2EwcEISZ0+oByS229b5XTey7oG6XR1dgTx4fZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117784; c=relaxed/simple;
	bh=DnKvAp2a+Ay1OUHAQPp9ZpGiWdRjPz3UnmUmOumtlMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQpHZ7AGrIHe6kIbdTy06Z3YwExJELLCA9QUJrKdydvJ9yMu6qb/chrpfBJ4VMOkq9VfLDxRulAicd7SVjNuVv4aKFz3AMjNPTLqU3UfSIns+AhRgvAgI6EEc11dzJEGGUgeqCJLaz35RzN2Efy02rzLb58h+HNGM81DL3lylXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmC/9Ia1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmC/9Ia1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2331F000E9;
	Fri,  7 Aug 2026 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117783;
	bh=iY3I2Dr8S2ro/KtVWkh858X2DyYCuFRw6VYxVbrC/Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmC/9Ia1SJuk5ZjblzdK+0IS3bJfnh0K11G0WBcXtKs+LHRfF2HCnqOBPT7f7k3Ed
	 VeEWnIXKcdXOz3OaS2rmxR7uJI2PYppbnVeGRxXinpynfMmLasR+l32h4tLOGLtk9L
	 Ec4szVkAqfhfapmAzYJLNhCqO04MSPdqHtqaELqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Deucher, Alexander" <alexander.deucher@amd.com>,
	Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>,
	Kent Russell <kent.russell@amd.com>
Subject: [PATCH 7.1 403/438] drm/amdkfd: fix QID bit leak in pqm_create_queue()
Date: Fri,  7 Aug 2026 16:39:59 +0200
Message-ID: <20260807143436.553888307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>

commit 38b73293f38658a4685ffcea666462024f858ad9 upstream.

When MES is enabled and amdgpu_amdkfd_alloc_kernel_mem() fails during
the first queue creation for a process, pqm_create_queue() returns
early via 'return retval' without going through the err_create_queue
cleanup label.

This means clear_bit(*qid, pqm->queue_slot_bitmap) is never called,
leaving the reserved QID bit permanently set in queue_slot_bitmap.
Over time this leaks QID slots, potentially exhausting all available
queue slots.

Fix this by replacing 'return retval' with 'goto err_allocate_pqn'
so that clear_bit() is always called on the error path without
touching the uninitialized pqn pointer.

AILIKFD-813

Reported-by: Deucher, Alexander <alexander.deucher@amd.com>
Signed-off-by: Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a107f74c38edbb80d6ab64dcaeeb292c14e9779f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -378,7 +378,7 @@ int pqm_create_queue(struct process_queu
 						     false);
 		if (retval) {
 			dev_err(dev->adev->dev, "failed to allocate process context bo\n");
-			return retval;
+			goto err_allocate_pqn;
 		}
 		memset(pdd->proc_ctx_cpu_ptr, 0, AMDGPU_MES_PROC_CTX_SIZE);
 	}


