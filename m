Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8457F2E7182;
	Tue, 11 Nov 2025 01:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823243; cv=none; b=Hb4oA6bVgK+JZWeuvB4Ocr+W+4s6QNJgWlPAtdCPHC4c5UTtudStNsmifcYdi//x0NI4Qt61aC3nqSkalGqIXZXku1ABXYSPUbRkVZ1abWrO5qfPgRgThaRIW09a7NLLOnOL4FkRO4F1KLNKiAO/O8xQHaASdw35HoMN/DHfwtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823243; c=relaxed/simple;
	bh=jtnz8ZFyIL0fJMZP7FCwnBbB6nWUDtCeaJ3i9zrVMsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXeqO98GFUYopo/L3hDKaYmDaf2UYyzE+xafOfVzg4nAj57NOpGv28Wu6E2VvPSykckNDlPfUthU8a/M9QMFuMRWUSCmoxtJeF/5NRqS3zmtdxU9dfnnFCFeRtgaXQsb0FOEqkLjO6kOWXQXsRhmqINauT3kILP9ao9zjtjqDrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUAIBryc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUAIBryc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3949C4CEF5;
	Tue, 11 Nov 2025 01:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823243;
	bh=jtnz8ZFyIL0fJMZP7FCwnBbB6nWUDtCeaJ3i9zrVMsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUAIBrycDiCUeWNdwEIG3Imr30BRtHiOoyJ86O/BzXQUsqP7zzwRNU7qA3YEUG/Xg
	 /S/a5cgPqKcpHAGsXKnX/O3IlbAswzW5Vj+XBu9p0+LkWNY0qlVNmisvYaWRDqSXTw
	 VoW5lPJKGthxKrA0p0pdkTVJj2PnKfAhtFAT6kCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 260/849] drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff
Date: Tue, 11 Nov 2025 09:37:10 +0900
Message-ID: <20251111004542.718512645@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 82d58ac7afb01..5d5e9ee83a5d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
@@ -121,10 +121,12 @@ static void amdgpu_jpeg_idle_work_handler(struct work_struct *work)
 			fences += amdgpu_fence_count_emitted(&adev->jpeg.inst[i].ring_dec[j]);
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



