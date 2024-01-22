Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1F864CEB;
	Tue, 23 Jan 2024 00:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971587; cv=none; b=RVUCEeDJwIf9XUFVY+meq+w6GD2/eMBuEgyaBAiJBz3gm8HxC8p1PHYfsr+ZcsGeydr9uBDuuDmExQ6t0DmMEKzpTk64uylAZ+s/d5UUnObqLV0S3LJYttyp1JaPTchQv+dq7WIq/E5S2Lnh5qUw1iWEfaHLjXMN4tPozo7kH8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971587; c=relaxed/simple;
	bh=eR2tHIPjvaRtkjGKkdG/jKVhDehp+9ZPQ2V67d3BOxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO42QgXDuPcavEBw0Svc71oDEzSkhkH34uzx2kgMdyy6v8CCOTFrRIJFbr7Z5ApBbfaVEUuOcq2YxIUadIVisLJJeaWUz1+TOBNNs1ZDnSSGH/irua/Z76sJdOjNBM3Ppq6f0gk5hi32glvnekQuawxdL3YnjXgxb751y6QtkbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNZIMROR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNZIMROR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C1AC433C7;
	Tue, 23 Jan 2024 00:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971586;
	bh=eR2tHIPjvaRtkjGKkdG/jKVhDehp+9ZPQ2V67d3BOxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNZIMRORB025tfkZkblI0XQOVBydjQgwMNeKBdZYu7veKni42kGFACvvAlzKbhC0H
	 gVuTu9iMfQGMyAqbKwJWziThWLzjGl5fPKKSHnQsL9+Ze1H0X8ho2L9K7clwD+/HiU
	 40wKHB0svm/Jua0OgTk+flgHGu2bVoT7qDzbtQnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/286] drivers/amd/pm: fix a use-after-free in kv_parse_power_table
Date: Mon, 22 Jan 2024 15:57:59 -0800
Message-ID: <20240122235738.836621834@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
index c8a5a5698edd..6eb6f05c1136 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
@@ -2733,10 +2733,8 @@ static int kv_parse_power_table(struct amdgpu_device *adev)
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



