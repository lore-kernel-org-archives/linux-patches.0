Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9027144633;
	Tue, 23 Jan 2024 00:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969569; cv=none; b=NVIB59ipeMKBL38RLjMrAW19IjBEB5GxJZF4ELHCIMcfsG6bcXJs/C7Z03iIRu5S8742tNO2zvAXchbUYX2p9cdYmuFnEVBHNVmunJqH4A3SBkh05G4a+bZXa9kyOFsDBg6WeWmnIiWO80Nqk28rPdnkr48//ba55baj9AVrIcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969569; c=relaxed/simple;
	bh=a4NMzxga9L7G93uHVc/KyWOYW2r9LmdHMRQooSXKSaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CecC1MmpP/H0kFETFBNEx7sKEGz1R7qfkPcMZeOsCh4O5ffMT87UChaAoChXIrmSMzO2Rvq357PHfheGEVoR4TCLPjW3DH0+3229KJkFNq2rRzeRs1Bry/LYR2pLE5EtlGxRAsUy35uGSSaxhV0NdS59wuJaQWqXftLPtlquk4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZfwA/Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZfwA/Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C620C433F1;
	Tue, 23 Jan 2024 00:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969569;
	bh=a4NMzxga9L7G93uHVc/KyWOYW2r9LmdHMRQooSXKSaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZfwA/ZvVSOqIzAtV10cdnT4vtPZfrWyXtr9QZJOyyJzXCBwJmCu4sXP7W8UGdW5r
	 nPZSt3oJjvCxv4DHYVkwmdRuyFDjHH6Du93AHtvV5y9Xpgiz8WvjSAekU/sIXijbsd
	 DfA9N/sXY2KJxAlY9UyGlaUkxxvTb8XqellCN9WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 329/641] drivers/amd/pm: fix a use-after-free in kv_parse_power_table
Date: Mon, 22 Jan 2024 15:53:53 -0800
Message-ID: <20240122235828.192704037@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 5d28c951a319..5cb4725c773f 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
@@ -2735,10 +2735,8 @@ static int kv_parse_power_table(struct amdgpu_device *adev)
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



