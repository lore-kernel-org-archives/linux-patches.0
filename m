Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5D122F765;
	Mon,  2 Jun 2025 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873855; cv=none; b=fgggyt5/ugV8U7sNWsq0sWhXDWdYTgkcEXKnK5SES8u2zhk/poi0ME8pU5KWeUOvB6I/m67i0Fdh0d2cR2a2lQRPQk3upnNwTU4pA3xVTKX5OqVvjNcfWBcwiLeGc6BNT2pCKJa6aJgzCJxTa3JyPZnzCanqStnrBfgmtu+/dHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873855; c=relaxed/simple;
	bh=txAxfDs81Vgzf7A412zoYF4ReMuY7ArovEdo++45HrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBPQqk/oZH07KHvkZqd4ypL45kqEhRVJa5v1Kkc26Jbozg+MrO/5T3Tu0MXA/5x5EcPi1BVNztbpi0bY2S0z2gDBBcDBZOIhmgflD1raW0o8B1Q3+kysPJnsNBmJ3yGAoriscrfj+k8LnvBhMn3PCZkos3c3ZgF2FrI4/CJVZPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZfdbHwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZfdbHwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A57CC4CEEB;
	Mon,  2 Jun 2025 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873855;
	bh=txAxfDs81Vgzf7A412zoYF4ReMuY7ArovEdo++45HrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZfdbHwzLFsKdVoGc4PLPiTBwialjChW90gMszvzSadS2HcrIK1em/VTklBycOoF3
	 lYQ1AHfxpLfpOnr+4+HxIBcMkQHovh8537s/jlbjHRHYdm9L6xTDwtsryLA0i37SzI
	 YdL/1CR0Jty9SJX90oSdM7RthKfvyE2SUe0YD0eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/444] drm/amdgpu: reset psp->cmd to NULL after releasing the buffer
Date: Mon,  2 Jun 2025 15:45:09 +0200
Message-ID: <20250602134350.863283220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6a24e8ceb9449..a4ab02c85f65b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -506,7 +506,6 @@ static int psp_sw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct psp_context *psp = &adev->psp;
-	struct psp_gfx_cmd_resp *cmd = psp->cmd;
 
 	psp_memory_training_fini(psp);
 
@@ -516,8 +515,8 @@ static int psp_sw_fini(void *handle)
 	amdgpu_ucode_release(&psp->cap_fw);
 	amdgpu_ucode_release(&psp->toc_fw);
 
-	kfree(cmd);
-	cmd = NULL;
+	kfree(psp->cmd);
+	psp->cmd = NULL;
 
 	psp_free_shared_bufs(psp);
 
-- 
2.39.5



