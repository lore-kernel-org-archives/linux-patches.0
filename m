Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74F129B78F;
	Fri, 21 Nov 2025 13:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732438; cv=none; b=foDfmb5fJ0hcheRX78URoLRJHaDTfopHD8xdGG4gQ5oiEZXm1YKeC6v5EDbml4xX7D36JRNeCMUyCkFgi7/eChP6IVbtpkvZBqQiup1L0gi8pkBlJDKDc8nvXDNsvVCrYfY0/+qCCKNmUotN6WOLHMsrlVUqW6IFWZIHzrX1TFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732438; c=relaxed/simple;
	bh=JyRT3oWd7G4jBnnGGb78UZ7O270YsHkO59wgUgNbd8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+4q7SeVUCQqkPPGOeiirNBlKS2W7nEC40O6ZsqmPKBrfQCcLOr57TbTEMUyUTfLNmQ4CguofSCu5OkPGNf0WJ8tnZqfCn51UNn70PRa4dQoqL/3KtetsTwpSW5Bn+HRDHV9dDXeE/kgsjQsaDSPpwqkEBpy3zRqPppVL7GpYhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhQ0wdSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhQ0wdSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DD5C4CEF1;
	Fri, 21 Nov 2025 13:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732438;
	bh=JyRT3oWd7G4jBnnGGb78UZ7O270YsHkO59wgUgNbd8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhQ0wdSBQ4rVLESH7wGtgaayQKEjbheeFqY9R7uyPK9olMrD8wuMy/mKSg+2NiXMW
	 DpB0kdvLdDiU6riXEf1jeb1HT/E8XqmAB73gON1DVYELolWuweI3yRWglVtq7CxtuH
	 L5T5LGGbBdEQznQrTzxS6Ju1YvPZN6/CnGhY9Mvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/529] drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff
Date: Fri, 21 Nov 2025 14:07:00 +0100
Message-ID: <20251121130235.329223366@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2ff2897fd1db6..cd8fa1164d540 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
@@ -87,10 +87,12 @@ static void amdgpu_jpeg_idle_work_handler(struct work_struct *work)
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



