Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1C62288F4;
	Mon,  2 Jun 2025 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877224; cv=none; b=BUNxrnxUZJ57RZf86t9Vz9KPF8BXfXZYZavmR4SE+kWP6egDaymFfizzC3tA5A5oROPxPpQvHYmqFTnwelt5uAar6yVw7ro7i1DKNId4KclNa5AJTvcGFSwggeeqeOtbpBlMUtyNNzfWXyJRwRZ73mYynKsiBv4acJi2o13/rWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877224; c=relaxed/simple;
	bh=qegTNn3LI3ZB5F5cCm0r/HIP/TlpJAu66DybyekzOwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kokdVlBzTphd/GWE+iy0PM9/CPaUs9GSPh+YfpcbC5mFpE/NlHmecd9E4uv3FfT8S5qVj+aYtodlVOeZB2NpOfAQz5NRSHu9fyxkX1FRWdDwTn7PGaljbkxGl77Z1JeZWcTfqnM8IKcWLiciDQGNKuUVUfpcbuGmt+Nuy3/ikZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaNd9c/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaNd9c/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6844FC4CEEB;
	Mon,  2 Jun 2025 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877222;
	bh=qegTNn3LI3ZB5F5cCm0r/HIP/TlpJAu66DybyekzOwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaNd9c/mzOF//6b1+wUp2HeEJG9FiWhFyH4/myFQv+bujtQxC7GQh//zCGqUt8Klu
	 5bFfZnELbHRWaA1rki737YTcko70/QK+jZZ5mXdbDOZv6pgTzqdZJNioniSL1kF34s
	 6H5x4Y8Aktlt7m8MTRRu/C0j50vH0cjkyg2h/L88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/325] drm/amdgpu: reset psp->cmd to NULL after releasing the buffer
Date: Mon,  2 Jun 2025 15:47:35 +0200
Message-ID: <20250602134327.090937261@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f8740ad08af41..a176b1da03bd3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -484,7 +484,6 @@ static int psp_sw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct psp_context *psp = &adev->psp;
-	struct psp_gfx_cmd_resp *cmd = psp->cmd;
 
 	psp_memory_training_fini(psp);
 	if (psp->sos_fw) {
@@ -511,8 +510,8 @@ static int psp_sw_fini(void *handle)
 	    adev->ip_versions[MP0_HWIP][0] == IP_VERSION(11, 0, 7))
 		psp_sysfs_fini(adev);
 
-	kfree(cmd);
-	cmd = NULL;
+	kfree(psp->cmd);
+	psp->cmd = NULL;
 
 	psp_free_shared_bufs(psp);
 
-- 
2.39.5



