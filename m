Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BC9273D77;
	Wed,  4 Feb 2026 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219024; cv=none; b=LL7sIUgo7xi5SYpLfPeWdrW0cvsOvKOPqrUlC08i2mkYWnkOC7nyGKoYVR6UOK8cG7b+N61zGYRmBnvbTwSngomwaCEgbajtezfryG4VUkCS6zlhiAalKlmWa9WCbvK4go5SN2T9FDr4uOQCqOHKISFkWtVjSIgsaUEww5tAL8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219024; c=relaxed/simple;
	bh=+5UhERIv2JRpCJV3K0CRepvp8IgnZGaSnxdcQkkfNag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHIKfyUY+IfHPjy1o/xfVE7y+zfe4MuITCLK7IBTY/cdCtIHgh7I6XSRNPW+ghqRIIcPYSI8o6t84XPJWIwkPM8AwMnpFhl/i9oOm73iFqSI1i4N+n22WmG3AmlS08r7PokPOwb9LC0NqxSOQvjsU+KUQEWq8aAFHFb+c/++yzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNIVX6Gx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNIVX6Gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DD5C4CEF7;
	Wed,  4 Feb 2026 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219024;
	bh=+5UhERIv2JRpCJV3K0CRepvp8IgnZGaSnxdcQkkfNag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNIVX6GxqSoK+kRv9uobbNdpV6FahLBHuSS/9dHIUNuaLQtc29AsHSlxikL6n9QWm
	 8Q4Pf9g4a2rqPtw/12RJLCE+E4p+tKSbi3IQVfTK6GXI7jAllDZ7M7PTwAeYdTMO6r
	 YR42+CU/v+RC4CrK19HASsNJG5NFF9DTONub7jig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/122] drm/amd/pm: fix race in power state check before mutex lock
Date: Wed,  4 Feb 2026 15:40:26 +0100
Message-ID: <20260204143853.443947825@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit ee8d07cd5730038e33bf5e551448190bbd480eb8 ]

The power state check in amdgpu_dpm_set_powergating_by_smu() is done
before acquiring the pm mutex, leading to a race condition where:
1. Thread A checks state and thinks no change is needed
2. Thread B acquires mutex and modifies the state
3. Thread A returns without updating state, causing inconsistency

Fix this by moving the mutex lock before the power state check,
ensuring atomicity of the state check and modification.

Fixes: 6ee27ee27ba8 ("drm/amd/pm: avoid duplicate powergate/ungate setting")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7a3fbdfd19ec5992c0fc2d0bd83888644f5f2f38)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index bc29a923fa6e5..8253d2977408d 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -80,15 +80,15 @@ int amdgpu_dpm_set_powergating_by_smu(struct amdgpu_device *adev,
 	enum ip_power_state pwr_state = gate ? POWER_STATE_OFF : POWER_STATE_ON;
 	bool is_vcn = block_type == AMD_IP_BLOCK_TYPE_VCN;
 
+	mutex_lock(&adev->pm.mutex);
+
 	if (atomic_read(&adev->pm.pwr_state[block_type]) == pwr_state &&
 			(!is_vcn || adev->vcn.num_vcn_inst == 1)) {
 		dev_dbg(adev->dev, "IP block%d already in the target %s state!",
 				block_type, gate ? "gate" : "ungate");
-		return 0;
+		goto out_unlock;
 	}
 
-	mutex_lock(&adev->pm.mutex);
-
 	switch (block_type) {
 	case AMD_IP_BLOCK_TYPE_UVD:
 	case AMD_IP_BLOCK_TYPE_VCE:
@@ -115,6 +115,7 @@ int amdgpu_dpm_set_powergating_by_smu(struct amdgpu_device *adev,
 	if (!ret)
 		atomic_set(&adev->pm.pwr_state[block_type], pwr_state);
 
+out_unlock:
 	mutex_unlock(&adev->pm.mutex);
 
 	return ret;
-- 
2.51.0



