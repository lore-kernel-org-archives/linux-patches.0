Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A0730569E;
	Fri, 15 May 2026 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862235; cv=none; b=JknyaNmc7suPh4AU6PXMk4t94ETj9Xt2OQFx55bpylAimnXgYTdZHTg4ESUHHtXCaYPqBDJTC28KF5+4cG75YBzB4BZgCKGxvHAE2G/9ZVvPbKq1zF8IvK+QnEVBiBO+azyGmsEYn4YLHJpBidSJ0U0fqyWj2UlnxhnXeMVk7+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862235; c=relaxed/simple;
	bh=fPkyslUUmlX4Qre7yZ/VHmcBlzbx5ZBNq3yL6LguPwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gFP9+THoAW2AAiD9Ecqz6ajHJLWney/PhzPzA/NTFeNCgC0quT/oYPUbvfano4lmu25GE5Z2czivXGs/ZeY8R5Wg/xNmOmRzGaHab5BfJxDi5V2846aHt8iQGEZ6grFEuxgV6GeW6AJNmnja2BYBieZ0IHfRsEBNC/fdS5Gg3Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYwWWuTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYwWWuTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFF3C2BCB0;
	Fri, 15 May 2026 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862235;
	bh=fPkyslUUmlX4Qre7yZ/VHmcBlzbx5ZBNq3yL6LguPwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYwWWuTl0RK8q0ZmcfYy9STI5i8bdhG1n2wqrlQtHB5YYlRXyAhf33uK2NEZKFfDg
	 U/9hGVZa3yR9EEzoVF7Z8yNltcsUcT2YyUuFE7qxLi1puQYYHbesEqmS2u3uCSVh9V
	 u7phQRfYgOXp5YmoOKZ8Scb2uHiHBhfuWg0LRXM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 153/188] drm/amdgpu: Fix validating flush_gpu_tlb_pasid()
Date: Fri, 15 May 2026 17:49:30 +0200
Message-ID: <20260515154700.643522594@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Timur Kristóf <timur.kristof@gmail.com>

commit e3a6eff92bbd960b471966d9afccb4d584546d17 upstream.

When a function holds a lock and we return without unlocking it,
it deadlocks the kernel. We should always unlock before returning.

This commit fixes suspend/resume on SI.
Tested on two Tahiti GPUs: FirePro W9000 and R9 280X.

Fixes: f4db9913e4d3 ("drm/amdgpu: validate the flush_gpu_tlb_pasid()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601190121.z9C0uml5-lkp@intel.com/
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -738,8 +738,10 @@ int amdgpu_gmc_flush_gpu_tlb_pasid(struc
 
 	if (!adev->gmc.flush_pasid_uses_kiq || !ring->sched.ready) {
 
-		if (!adev->gmc.gmc_funcs->flush_gpu_tlb_pasid)
-			return 0;
+		if (!adev->gmc.gmc_funcs->flush_gpu_tlb_pasid) {
+			r = 0;
+			goto error_unlock_reset;
+		}
 
 		if (adev->gmc.flush_tlb_needs_extra_type_2)
 			adev->gmc.gmc_funcs->flush_gpu_tlb_pasid(adev, pasid,


