Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EE06350A;
	Tue, 23 Jan 2024 00:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971255; cv=none; b=jBCgZOaxO2QzG6w4Zwy+6lSiMry6Qlbdv3Es/HOWYIC212kv3X8fSd6HC0hhP7n/s34lx2R8BicsD9sZt9xmB4Nb0VaMiioCKYHkjIedWRj4oGjcR2Kz1pHkGU01YhHxk/8yCdhjpREIX2Pk9Mqkm1WmAARI/1UfNx3obLSV+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971255; c=relaxed/simple;
	bh=+58vjNGq8i6PvO1YQewNGgie8AJQjWo/d6YKAiZtvec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaSIxd/gv/FSSlXly+1YzxPm7yEwFCl1a6g9T0ybN/DkNAprMOLMd6GhI4y9AD8GJR3Z1Ibe6N6vUALZZ6tYpc+yIs2YV3QkR1PTTQnCPo1WwDc08twjZ5vaa4hblCKSSbMt40tIKL5P8sKl5h3oySNX3GkA9q66/nC7tuthCTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kb0KTVuN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kb0KTVuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02436C433C7;
	Tue, 23 Jan 2024 00:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971255;
	bh=+58vjNGq8i6PvO1YQewNGgie8AJQjWo/d6YKAiZtvec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kb0KTVuNmtiocYHSOgW1MlN0NqAaeGEdOTtVdvlno3jHTCRKOxS+t0cyoiGFU1h6W
	 +5ikJ6R9txTzPZzM3ArWXlAwmjVwJTz5OhwDIpiHziOS3r9gPnIk+2qThALkRILoW4
	 XeVByp1nRPqjSosPo3XJcXPJZb7dFEglf9SShwm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/417] drivers/amd/pm: fix a use-after-free in kv_parse_power_table
Date: Mon, 22 Jan 2024 15:56:19 -0800
Message-ID: <20240122235759.230407843@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 28dd788382c43b330480f57cd34cde0840896743 ]

When ps allocated by kzalloc equals to NULL, kv_parse_power_table
frees adev->pm.dpm.ps that allocated before. However, after the control
flow goes through the following call chains:

kv_parse_power_table
  |-> kv_dpm_init
        |-> kv_dpm_sw_init
	      |-> kv_dpm_fini

The adev->pm.dpm.ps is used in the for loop of kv_dpm_fini after its
first free in kv_parse_power_table and causes a use-after-free bug.

Fixes: a2e73f56fa62 ("drm/amdgpu: Add support for CIK parts")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
index f5e08b60f66e..d17bfa111aa7 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
@@ -2748,10 +2748,8 @@ static int kv_parse_power_table(struct amdgpu_device *adev)
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
 		ps = kzalloc(sizeof(struct kv_ps), GFP_KERNEL);
-		if (ps == NULL) {
-			kfree(adev->pm.dpm.ps);
+		if (ps == NULL)
 			return -ENOMEM;
-		}
 		adev->pm.dpm.ps[i].ps_priv = ps;
 		k = 0;
 		idx = (u8 *)&power_state->v2.clockInfoIndex[0];
-- 
2.43.0



