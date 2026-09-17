Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1419B51A140;
	Thu, 17 Sep 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664748; cv=none; b=WZcHJT4n4Y2FEascxTmYa1jnhirJBxdBG4q01TjW+qsViWXLIEwG3AYAWd+gQ2kVfdcYmkW8fKZh9bhW/4qa8lVHI9kCTg7ejccK2SWx/ck/AJI4OvctNeuK3OjtwuVeAT8yW4TAot1H2X/eifbnjcV6M1W1AYax4iOwEIh+470=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664748; c=relaxed/simple;
	bh=PdMPF8+iSRhDFiofxLq52VksplKzarVnjIaHHe1l70I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=unfiPvha+bydo+O7f3HrNOSk07XyMoDxUP04siqTIegZug9axxd4G6nrNaZHh0UpRh6Sc8xJVogijxrmpBhIMMvHsSj8z3A4bXBg97RGox+f75VU7tkZHtcMQCYYu+pOuvzV7MOPef0d54YiGKzzE5nq1+U1gX6pbXk0JzELLDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/jHPyNM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/jHPyNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5351F000FF;
	Thu, 17 Sep 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664747;
	bh=xeMRyXEmO5WiOQxira7IAPaaNrR3ezFD/FBYSldxiZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/jHPyNMKLBBZqb68jHXLjndOIA+ugm53WHib/wWkTmdmMz1t1g17TIdrL3XVMl64
	 xN64DH3odXjX8r6iWv+Pbu2LRABTTLFycEMu9rNWtJYxZ4HADrD1JuMtEME7kt/lKr
	 sWkIH0w4K3X8Rot92Fvzy+ld4ew7M6yW8dmpjItU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0436/1250] drm/amdgpu: Use system unbound workqueue for soft IH ring
Date: Thu, 17 Sep 2026 16:03:51 +0100
Message-ID: <20260917151603.830590015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit ba2977dcce72127986fbad76c4c67f134e2f69ae ]

Allow the kernel to dispatch the soft IH work on other CPUs.

Otherwise it can happen that the soft IH ring fills up
before it actually starts processing anything, which
can easily happen with retry page faults, in which case
the CP repeatedly spams the CPU with a lot of interrupts.

This significantly improves retry page fault handling on
GPUs that don't have the filter CAM and must rely on
software based filtering.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3cdff3c8b93c2834977224d9c2b201fc334dd184)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index 8d7f97eed5a90..ccc378233bc5a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -512,7 +512,7 @@ void amdgpu_irq_delegate(struct amdgpu_device *adev,
 			 unsigned int num_dw)
 {
 	amdgpu_ih_ring_write(adev, &adev->irq.ih_soft, entry->iv_entry, num_dw);
-	schedule_work(&adev->irq.ih_soft_work);
+	queue_work(system_unbound_wq, &adev->irq.ih_soft_work);
 }
 
 /**
-- 
2.53.0



