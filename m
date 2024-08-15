Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3FD1A01CB;
	Thu, 15 Aug 2024 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731766; cv=none; b=oUS+xZaiGqTJHFv4WeZ0EjTem9eF6m3DFc6aCL/2hIjDqwo1JWk+Wr2vdtrNR9O5QJL79pMKpeXKEsxcqmy35g6sOjzv1fPm0Vgch0YDfXWzOG4aqzWQVe/IN/OjDPWWPsNmNm01g/5IRy4NM4mz4AWUyX/hd7nul3khhjE9XzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731766; c=relaxed/simple;
	bh=epyLOYUDJysq0I8dbEIS2oRrsooT0Gyig/K81Hw2idA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGn/nYvSXl8PQpzrCnEzC1skyuuXO6OSW597cxNgvDjtLMyiuDKoPyBDsi7XGHPuhj5mBvc3hdPMw750mGTNmN0BzHsPqgbtRdT49SrNd0RAyKq+7+qTjioxsFBKmpIbApYb8XtAiSlDSrJJ3dU3Zwo7cKIVilK2PPM+pCQIoLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnYkRAiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnYkRAiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D349BC4AF0D;
	Thu, 15 Aug 2024 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731766;
	bh=epyLOYUDJysq0I8dbEIS2oRrsooT0Gyig/K81Hw2idA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnYkRAiS3aE2lx8qTuoKfiJkeMGwS/KqB2cuT++nM/kVehztcfyXok6dGshMO7pKQ
	 NpPWuPPAFF6OUkm5TIRIAO0upj13oV0V/0AIvWu46u9sWpG0/7GQ2JEPFPLxVlThDc
	 xcYqe70r/NphxksPsmI91LFyXWk+saAjTKYR3wAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 201/259] drm/amdgpu: Fix the null pointer dereference to ras_manager
Date: Thu, 15 Aug 2024 15:25:34 +0200
Message-ID: <20240815131910.536984113@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 4c11d30c95576937c6c35e6f29884761f2dddb43 ]

Check ras_manager before using it

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index b6fc191c353a7..96aad6cc83b1e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1053,12 +1053,15 @@ static void amdgpu_ras_interrupt_process_handler(struct work_struct *work)
 int amdgpu_ras_interrupt_dispatch(struct amdgpu_device *adev,
 		struct ras_dispatch_if *info)
 {
-	struct ras_manager *obj = amdgpu_ras_find_obj(adev, &info->head);
-	struct ras_ih_data *data = &obj->ih_data;
+	struct ras_manager *obj;
+	struct ras_ih_data *data;
 
+	obj = amdgpu_ras_find_obj(adev, &info->head);
 	if (!obj)
 		return -EINVAL;
 
+	data = &obj->ih_data;
+
 	if (data->inuse == 0)
 		return 0;
 
-- 
2.43.0



