Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193EF239E73;
	Mon,  2 Jun 2025 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876364; cv=none; b=dGcyJegc0wjpuQEenm2i1Q2Js/RMvIp07NsLGLMc1b/awoexUyxjuFg2lY+QMBNI00XAVb/rN9kEAlsyQVOdZtbGc9J4jkUkPL7XRdQ66amPAM+iSTRs295QDwH00WTTuD7kbL4i19FU9MP7hAPeRTEkOQHmZp+Wyqt0pezqR4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876364; c=relaxed/simple;
	bh=u98jOjoZWWKznEfvWyN/LF1YnA2nWn3Ie9PnyZaBE+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0lqB0MIPZAxmyQgqYhBwEHN6j6RvojQvR9eqJyjI/GuF7t4tv99VNGCu1QXHVgK0KZUeS7hSY0FCLIonWec4L/KBibZUTA+RKuAED3JlBU8y3O7RP6ceAMZiXG8V++4YYKB8/ls7SNoW1xLmRWpKGJyOUSLulNqQpNOWRxl7QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZTf+rtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZTf+rtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88241C4CEEB;
	Mon,  2 Jun 2025 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876364;
	bh=u98jOjoZWWKznEfvWyN/LF1YnA2nWn3Ie9PnyZaBE+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZTf+rtgYHWvvNI60sx4yxn7eQAVOhgpmWWFevO4nPHAPp6SDCgT8dY6a5j1L0f/P
	 4lzUZSqfO5u9U+5780s0fCbBb+lg9c8g4Y4qLUq0aCKK6Mm4thzo78MmzfvJd+gB7V
	 b3oBkCpP9dPS0aKv6FRJr7sxduc3NEmILDTdO/io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/207] drm/amdgpu: reset psp->cmd to NULL after releasing the buffer
Date: Mon,  2 Jun 2025 15:48:15 +0200
Message-ID: <20250602134303.534274119@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <gerry@linux.alibaba.com>

[ Upstream commit e92f3f94cad24154fd3baae30c6dfb918492278d ]

Reset psp->cmd to NULL after releasing the buffer in function psp_sw_fini().

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index a8b7f0aeacf83..64bf24b64446b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -353,7 +353,6 @@ static int psp_sw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct psp_context *psp = &adev->psp;
-	struct psp_gfx_cmd_resp *cmd = psp->cmd;
 
 	psp_memory_training_fini(psp);
 	if (psp->sos_fw) {
@@ -373,8 +372,8 @@ static int psp_sw_fini(void *handle)
 	    adev->asic_type == CHIP_SIENNA_CICHLID)
 		psp_sysfs_fini(adev);
 
-	kfree(cmd);
-	cmd = NULL;
+	kfree(psp->cmd);
+	psp->cmd = NULL;
 
 	amdgpu_bo_free_kernel(&psp->fw_pri_bo,
 			      &psp->fw_pri_mc_addr, &psp->fw_pri_buf);
-- 
2.39.5



