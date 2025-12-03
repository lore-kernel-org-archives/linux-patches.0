Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2465A33893A;
	Wed,  3 Dec 2025 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779042; cv=none; b=UR8nNkSpdye2McOyegWKNl2J7cb7ZbUkfWfCcDiWAo3DRxkDBtgFRuiWP5vJdcBtzdgk0FFZSMUhhPQvzmSsC259qx+7v1uu58dwXsR0Zb7wPci2TI9RNwq8CjKS/bOwcAjc98eUvcqabkKw3J3sfUA96YMqaJtBimWAOa4UGhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779042; c=relaxed/simple;
	bh=Ncf4ej33ejgnSZVx87zUbZcURVoHo7T2gw6sTmxZGPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBS05aNxPAJJ+l+D/8F+0WhCgiqEz80bRfps63UH12Ax4gYpJOe6eDmeaIxrMxpETuupzzrmpGK4KNu6vL5jPcYRQm+/K5kzTDUWoK1R6rPnOjFpv6MsiTAMyw7hEzmGpMRIq9mXtMe+3gEAAOLrgGFOmQKVnZZZjn0fc3BxDV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrRDHHu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrRDHHu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB05C116B1;
	Wed,  3 Dec 2025 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779041;
	bh=Ncf4ej33ejgnSZVx87zUbZcURVoHo7T2gw6sTmxZGPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrRDHHu3LsnGC2Nk0N9GKgAX4BTeoYOuN0M66xPMjwkKxu9go6FJVA4DlfuFNgL81
	 toLrZ/Exs8mn5FG5FFbcZY52yNxh27uDt76b06eJUXPQ/2dqJowqLApWOda4pvNuG0
	 w0jJTNAXdmH/ZNi8hunquiNrMDQv1OUVYrfL1deU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/568] drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff
Date: Wed,  3 Dec 2025 16:22:18 +0100
Message-ID: <20251203152445.707672305@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

[ Upstream commit 0e7581eda8c76d1ca4cf519631a4d4eb9f82b94c ]

Acquire jpeg_pg_lock before changes to jpeg power state
and release it after power off from idle work handler.

Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
index 518eb0e40d32f..d5ae89876a061 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
@@ -85,10 +85,12 @@ static void amdgpu_jpeg_idle_work_handler(struct work_struct *work)
 		fences += amdgpu_fence_count_emitted(&adev->jpeg.inst[i].ring_dec);
 	}
 
-	if (!fences && !atomic_read(&adev->jpeg.total_submission_cnt))
+	if (!fences && !atomic_read(&adev->jpeg.total_submission_cnt)) {
+		mutex_lock(&adev->jpeg.jpeg_pg_lock);
 		amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_JPEG,
 						       AMD_PG_STATE_GATE);
-	else
+		mutex_unlock(&adev->jpeg.jpeg_pg_lock);
+	} else
 		schedule_delayed_work(&adev->jpeg.idle_work, JPEG_IDLE_TIMEOUT);
 }
 
-- 
2.51.0



