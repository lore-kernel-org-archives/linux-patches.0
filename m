Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208A817A5A4;
	Mon, 23 Dec 2024 16:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969904; cv=none; b=AcpzsARoYLC7+zrZ00t+dzy2GgfSyqFF6soz3u6xmk+SN12rzkG3bRUjxazk5mU1sPPAU90cbxBcKCdVJCPUWSd8nk59ejx6USzT5sCpPX4fdPBlA8P9WqwGgdgw27be1YCsFXSfvclVBG1jZ5CJemUJmb0QVMvTqTK6KHhufZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969904; c=relaxed/simple;
	bh=c99J2B/in0b3FaynEb+6527N2b6SCzIxFOYUCopkYTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJ8q6pQdcjpc06xDO/lXuS7bHc+JRIi++kD+0CsUxHBxIfDrPGMQ59BQLrvpD4eVjIUDoyYqqT0r8sGw6SW8lX3vIdG5Jqk3MWCFxh63XoDNL5IUTEUJEeRsijK6CPGieloTztUUadmlwAtg0XLGfh86xGra9suvTqoqJ0yUU6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFoUHmae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFoUHmae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2ECC4CED3;
	Mon, 23 Dec 2024 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969904;
	bh=c99J2B/in0b3FaynEb+6527N2b6SCzIxFOYUCopkYTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFoUHmaeYZwrGKTfSUlSe0qAumG1qNKHmi3Wiq1Vyct104Wys6MW3fNO75puG2aEb
	 FZREaVu/nIW6ti4m8VivzMuFDH+9rLsRqpJ7xXoUzYSj1QDdBpdNQMSGwG0NdLOqKn
	 CLlNgvdciTapqf1k9GCmwxbbyRCa9z468IsP9Uh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 088/160] drm/amdgpu: fix amdgpu_coredump
Date: Mon, 23 Dec 2024 16:58:19 +0100
Message-ID: <20241223155412.095792901@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian König <christian.koenig@amd.com>

commit 8d1a13816e59254bd3b18f5ae0895230922bd120 upstream.

The VM pointer might already be outdated when that function is called.
Use the PASID instead to gather the information instead.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 57f812d171af4ba233d3ed7c94dfa5b8e92dcc04)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
@@ -345,11 +345,10 @@ void amdgpu_coredump(struct amdgpu_devic
 	coredump->skip_vram_check = skip_vram_check;
 	coredump->reset_vram_lost = vram_lost;
 
-	if (job && job->vm) {
-		struct amdgpu_vm *vm = job->vm;
+	if (job && job->pasid) {
 		struct amdgpu_task_info *ti;
 
-		ti = amdgpu_vm_get_task_info_vm(vm);
+		ti = amdgpu_vm_get_task_info_pasid(adev, job->pasid);
 		if (ti) {
 			coredump->reset_task_info = *ti;
 			amdgpu_vm_put_task_info(ti);


