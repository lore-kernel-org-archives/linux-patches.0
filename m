Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891912110E;
	Tue, 27 May 2025 17:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365486; cv=none; b=sMIP5Jisl7DiKuSbiDk5WEN3LvWuVpxnwgmMrI3IbUvCmxGzRKE2ggGs25nFlk87eYCpOoXt8/D308LwHwKz+j4E1StRFxLYZL9KV88MyYVN7kJqvfS8pAr9B8+q9CxPC6ZhMsZ96dn7EHnOrrzNMNXeQiZPaEa6xpk1KJrMB0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365486; c=relaxed/simple;
	bh=QgtzTRGVTEyfypDrTtZaqKZmbwOsVakKKm7fpXmnFac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/kMiO9jUtBW8V56m8qZARyARCIXc9D0keXHLp8tpwBJngUIiwTGAepxZdJ4Gspga5tcnLMyDPrgDJRdum3iu84f/2fNt5vycxhYay+M8uZ8wfM+HyG1k/SW+xeXyJwgYgAHzxohdrmF4P68Qs/eQbBgykcXwsS4gKWR+ZiwSGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwXhsbop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwXhsbop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA643C4CEE9;
	Tue, 27 May 2025 17:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365486;
	bh=QgtzTRGVTEyfypDrTtZaqKZmbwOsVakKKm7fpXmnFac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwXhsbop6gQqkcLbsMK4tbmx87myRQn7juYqbVTKm+yLnBpe+SiWXBI5LDDlWNnQn
	 fp/JeADxiON2A3CDIf0WCP5pQXGGuYmMKoRsLGkGy2j6f87oI6Rknq9//XqUcJEw9I
	 UgXQTcoj7a7Fp4WgBZYaLwJNNddbE7TCcgqj553U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/626] drm/amdgpu: reset psp->cmd to NULL after releasing the buffer
Date: Tue, 27 May 2025 18:24:45 +0200
Message-ID: <20250527162500.947884351@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d70855d7c61c1..31a376f2742a2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -531,7 +531,6 @@ static int psp_sw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct psp_context *psp = &adev->psp;
-	struct psp_gfx_cmd_resp *cmd = psp->cmd;
 
 	psp_memory_training_fini(psp);
 
@@ -541,8 +540,8 @@ static int psp_sw_fini(void *handle)
 	amdgpu_ucode_release(&psp->cap_fw);
 	amdgpu_ucode_release(&psp->toc_fw);
 
-	kfree(cmd);
-	cmd = NULL;
+	kfree(psp->cmd);
+	psp->cmd = NULL;
 
 	psp_free_shared_bufs(psp);
 
-- 
2.39.5



