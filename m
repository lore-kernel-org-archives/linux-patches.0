Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A4A134AC;
	Mon, 12 Aug 2024 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480091; cv=none; b=lG9cbMg0EzDi/ZkP5honLLKaldyZk8QlZJb4wZCuhhMoAjeH5d1PxhbJ4mqrXntKGsLMqOpqFduO7piGd6gV9+kzRRQeOU3XeftAAMxywKB2v1ZUmET4HIeQIwTAq9jZm4kAN+SaeDIUjo/sWRlOhBTf2IwWvZO56YSiUPuTQD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480091; c=relaxed/simple;
	bh=bJckYEVAn9A9GtcfQaOwlH8NRjNDmYbrV+1FhEsA2LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeKjNmmRyQknHx+RoVhDUJVCeZZDOUShnIGqBd25FT80jSI4pSn7dvbEj36Ghwa2HEhdJe0nyuJ068EnvcE2lIEfRnzTmgRw8f3du3Ew5SHnKRkQvCuwNIcbq0q6ldOoEpPDadzoB0UgGBM9Ho9EE5yp7eIqMWnZVHdi/w5uhSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vclVXoPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vclVXoPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAA8C32782;
	Mon, 12 Aug 2024 16:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480090;
	bh=bJckYEVAn9A9GtcfQaOwlH8NRjNDmYbrV+1FhEsA2LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vclVXoPCjumwMy4uWaDiLpz/n9zYLWnn4Xja+yVCNEHB8nEDUmb907vER8EWuuk/r
	 TXUBiyHdLgr5pT29sktXBGGwPAWXsCtz+qzvMQOyEAcoowHvWArsRbKBMBp549T9hw
	 DxlVH6bI+tZWdK/Gh/J39HCaI93fbnL7afHV/o4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 094/263] drm/amdgpu: Fix the null pointer dereference to ras_manager
Date: Mon, 12 Aug 2024 18:01:35 +0200
Message-ID: <20240812160150.143445854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1adc81a55734d..0c4ee06451e9c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2172,12 +2172,15 @@ static void amdgpu_ras_interrupt_process_handler(struct work_struct *work)
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



