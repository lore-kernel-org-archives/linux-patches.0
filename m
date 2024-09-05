Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D955194A45;
	Thu,  5 Sep 2024 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529889; cv=none; b=g7zvIQIX1lMQNkcx8NqmrEx56rd0F4cBetkhcj8ZbG43ljStyG3i4C4WrZ0D9vMikQFpi3xAEA7+MCCkNXgqSHAqqAOUV8NNoBiyPCPs1vdF9INOxkuui0HY6ePcP+yA5R3V5bejLJsEvncVe+NZXbxH1w/8XDH8suRjIjUPF8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529889; c=relaxed/simple;
	bh=IyROwFsI6KPFb2hG+YKz/p3FTv0+mAHldZTbZRHDhGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTO4Ld/BGpNQ7uVyhp9c8rEjuUVkCkRYJCwOq7T2muSehHKswSq1bLS3nhp0WtnAQVuxa5PU5ZcqYh8XwWYoPgW/qqSaM2pmEJ+OJghNUCZhwpB3Q5WIfvu658LGqh9+slZewCvjXZCcgMzMhqnvk8V4v9BvTDkobBfEe/1bt9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3QOn/hX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3QOn/hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F838C4CEC6;
	Thu,  5 Sep 2024 09:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529889;
	bh=IyROwFsI6KPFb2hG+YKz/p3FTv0+mAHldZTbZRHDhGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3QOn/hX5+xLKJ/EeoFB3L49mBhBPhnsTq+7s1T5YgiqyRq9ivUAhBfBAxt2l7/Vc
	 uX3DtwhKe1WpfF+YsHb0cVvY50zCjQD/ZLJgCoYKsHfLW759poFBA1ZG1MiUVKu6H6
	 yFQ93VAatLKfuRhj6fV/aBOC4hXzmKmH6UU53hyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 174/184] drm/amdgpu: set RAS fed status for more cases
Date: Thu,  5 Sep 2024 11:41:27 +0200
Message-ID: <20240905093739.128857304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit 09a3d8202df1e9fa1eb5f5f63524c8948275ff4c ]

Indicate fatal error for each RAS block and NBIO.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 1 +
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 57fdc4ab9c54..7ba90c5974ed 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2112,6 +2112,7 @@ static void amdgpu_ras_interrupt_umc_handler(struct ras_manager *obj,
 	/* Let IP handle its data, maybe we need get the output
 	 * from the callback to update the error type/count, etc
 	 */
+	amdgpu_ras_set_fed(obj->adev, true);
 	ret = data->cb(obj->adev, &err_data, entry);
 	/* ue will trigger an interrupt, and in that case
 	 * we need do a reset to recovery the whole system.
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index 750ce281b97b..e326d6f06ca9 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -418,6 +418,7 @@ static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 		/* ras_controller_int is dedicated for nbif ras error,
 		 * not the global interrupt for sync flood
 		 */
+		amdgpu_ras_set_fed(adev, true);
 		amdgpu_ras_reset_gpu(adev);
 	}
 
-- 
2.43.0



