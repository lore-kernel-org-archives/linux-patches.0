Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C64346A09;
	Wed,  3 Dec 2025 16:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777619; cv=none; b=Jdez/kddUQsPtPU94IXD+jdD9J8Z7eH96bBMRLMT67XOWYK1wsJ8DSMwTKIXNXa4QGBF1aqpHhqDzNazn3tp7anTZdmL93sHw3pMVMBH3DVJKfDtw+0b8frfcxLDY09SNGQ7EFrv66BkwSr/msAxBIKGhxcl5SX4aB8VaksaqNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777619; c=relaxed/simple;
	bh=eC7iWINYk8ynF8TScypnfBZyvzFfOElfifgyCSTxxHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJzOmLJeM8Q422NBszbc/t1a2eouJ1InN8mOm89QmZQqqIfvfZck3WaumPu3yPiluKqjt/jW9y1dquEI6j84fI50CW2GmxwzizQjQLFVxQJ35t/KOjrXcDB2Ez4usW3KrrLFmDPPEF3spoLW2rZHUse01jVhhwmO+ukULrCjtko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXbCAoj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXbCAoj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEF6C116B1;
	Wed,  3 Dec 2025 16:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777618;
	bh=eC7iWINYk8ynF8TScypnfBZyvzFfOElfifgyCSTxxHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXbCAoj8i0UmnqHfDteNLxH2AFQcKPlB2duoUFRUB3OjqjLChLwYsFphiDUDzdp/n
	 +xiZ9mU3dvDuvvP8V2qtp4C+RrmHK1gaX9zrSacMCPwc/vLcP0Rmm1KQd9j4/nir/I
	 t4czl/r2KWQai1XXSL7x5fFRJZAzfTQmpIDuPT64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/392] drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff
Date: Wed,  3 Dec 2025 16:24:02 +0100
Message-ID: <20251203152417.488883330@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9342aa23ebd26..902523af9865a 100644
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



