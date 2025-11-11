Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44CB346E58;
	Tue, 11 Nov 2025 01:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823212; cv=none; b=OwFffBDpzrjz8nYQYsvV6Sjg7ePuD6DKAIiVktXLTMsdJT5BzJ0jV2tCtz6mjTzfcuRr9QY7+79Oo+uKqoYyovTioV94+6SnzZ9J41E488aa3m6eaw4If+wOizW28zKXdV1TYVHphui1a+RAOO+G5xRVAR9c4+72CRRShDKCyNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823212; c=relaxed/simple;
	bh=FMNQxagkNx4aAsnD5Y9YqHBwncNUcji6/lX6wjdRmYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPYQ9sz4zyU2tbXsIM7M5fmxOiutktPdjIthoueP2vgtIoOa7hqZ9kfnhqYyP68+r3RyuX5O0cob6M4lMMHOiyGmYFOxqID8gkJoP/Gjtub2hqv9OFBXZHD8xIX/Szw8iyQWt4TmvrZ8Jt1SEIzVbzVyJ4XP+f6ngRt0CYvEEP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auaqCw6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auaqCw6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0A1C116B1;
	Tue, 11 Nov 2025 01:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823212;
	bh=FMNQxagkNx4aAsnD5Y9YqHBwncNUcji6/lX6wjdRmYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auaqCw6y3EOOQv1EMzWdTsdghaG5Atq+PK13zYfVj9ag2Ao9WBtWYxERfcVvk2HWW
	 ZYkaWZML2ieEi01co9Bng3MIGwakDc/e7HzVMuAg7ZN/z0025OzOz3xcaVr+sTcmB5
	 X2u3z5k5hA5zu/7QcbvFcXNH4NyOI+bFQLBTGTcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 254/849] drm/amdgpu: skip mgpu fan boost for multi-vf
Date: Tue, 11 Nov 2025 09:37:04 +0900
Message-ID: <20251111004542.569086454@linuxfoundation.org>
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

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit ba5e322b2617157edb757055252a33587b6729e0 ]

On multi-vf setup if the VM have two vf assigned, perhaps from two
different gpus, mgpu fan boost will fail.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index dfa68cb411966..097ceee79ece6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3389,7 +3389,7 @@ static int amdgpu_device_enable_mgpu_fan_boost(void)
 	for (i = 0; i < mgpu_info.num_dgpu; i++) {
 		gpu_ins = &(mgpu_info.gpu_ins[i]);
 		adev = gpu_ins->adev;
-		if (!(adev->flags & AMD_IS_APU) &&
+		if (!(adev->flags & AMD_IS_APU || amdgpu_sriov_multi_vf_mode(adev)) &&
 		    !gpu_ins->mgpu_fan_enabled) {
 			ret = amdgpu_dpm_enable_mgpu_fan_boost(adev);
 			if (ret)
-- 
2.51.0



