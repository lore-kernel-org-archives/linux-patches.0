Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112F234320C;
	Tue, 11 Nov 2025 01:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823184; cv=none; b=pZrLinrN+4ieemPozeS17p3LUeinjQ0AqOAinCfE9uvlc1NrDAIDfG06WF3F+uESyzn+xNmiUNAeZC78k/P1tZAIn8uPMeoGhCJOa0pWfHKjV4gJ7n3hIu1/XSni34tC9ARznT76edTZWirhdMi+ggTtayfmu003a4z+kPIPD+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823184; c=relaxed/simple;
	bh=fQL6fdO2OW8LngKpGGyLiPJiP212czGUDU8m6TuJtbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRyIK6/pEePhiRppk+3QhQ3yWE9hLtPlDh0BdbP3Rfta5EFq1A5QwyCz+PbdZ5FTYoTUW0fpxzdlWJqDzaVj9/sJYTnjjMfIvkp195mXGih+OCUUZUHif4gh5xdfNRg6yJAOqQVqkSeveq9Omwua3DfLKogdhiGqZB/bL6iKgb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1sQztRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1sQztRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D85C19421;
	Tue, 11 Nov 2025 01:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823183;
	bh=fQL6fdO2OW8LngKpGGyLiPJiP212czGUDU8m6TuJtbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1sQztRPsOGi/SUBa8DJFvT7KbvH7FYLqeD1+mOsMYFnbpCGgXrsJn66woNgf3x4b
	 J2lHSdApnC4rqbDgM356ptPpdhotJtiSTmjBzaVX95XQVQL/lhdsxVy1V3EJrtytBY
	 /yJFEKEBEJIIoIIsjOth2fjj7NLp4GdDSeF/kYEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/565] drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff
Date: Tue, 11 Nov 2025 09:40:43 +0900
Message-ID: <20251111004531.139272247@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6df99cb00d9a5..f96a79a4d5397 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
@@ -117,10 +117,12 @@ static void amdgpu_jpeg_idle_work_handler(struct work_struct *work)
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



