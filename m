Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E56315574C;
	Thu,  5 Sep 2024 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530317; cv=none; b=LOiPZRmPDc7cBw5ycacJMOdiomS50UyBKrZKMy070NInHpwfqK6taXQ6Cue2Nbgfp0zJX1NNSh0vSk68Ddgai3GWW4BI4PYgEGR99YHueiGPNNoVS4F+po2a+dy9UiCewTQ/HIahtSr1dwpsJ0Pv547BWMMWcBeH7wH7qLQgHI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530317; c=relaxed/simple;
	bh=9qq0Pq2x7xVc+NIk1yxebfi9K9hplTQ9i3SuxDx7ZKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iy/gcM+9Vv0DgFLpqqXC/eMHR6Kd+RBhpAkUDkkK78gSzGRxBYUt2uvXHcNvBwNeL8qu3HE4QrOOgQ7KIyfXu/FlqO3rgxCk+DSCy9kE7gN0e6GvVueqpGfy2Z9YWFPH6uhGOiJ/U9piSoAPV5W7Kj7TfdK3DYFD+zMYrWoiv4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSZydDS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSZydDS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D74DC4CEC3;
	Thu,  5 Sep 2024 09:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530317;
	bh=9qq0Pq2x7xVc+NIk1yxebfi9K9hplTQ9i3SuxDx7ZKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSZydDS3nvG0PdSL+lcCrGTlBKiKHU85H8o1IKlBHizUMD6i63nxEUSdz/QYPANyz
	 dwP2vBVeYoo7nJQ6LaXLhYhG5inQPpgD8pvaryrxH6W3/Qh998A3AJ7k5aKAFd/+81
	 nXnoGyIycCxwBuDYhkBNWn9XW9HJdX1G9VzqO8Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/132] drm/amdgpu: add skip_hw_access checks for sriov
Date: Thu,  5 Sep 2024 11:41:47 +0200
Message-ID: <20240905093726.886789509@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit b3948ad1ac582f560e1f3aeaecf384619921c48d ]

Accessing registers via host is missing the check for skip_hw_access and
the lockdep check that comes with it.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 7768c756fe88..d9dc675b46ae 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -998,6 +998,9 @@ static u32 amdgpu_virt_rlcg_reg_rw(struct amdgpu_device *adev, u32 offset, u32 v
 		return 0;
 	}
 
+	if (amdgpu_device_skip_hw_access(adev))
+		return 0;
+
 	reg_access_ctrl = &adev->gfx.rlc.reg_access_ctrl[xcc_id];
 	scratch_reg0 = (void __iomem *)adev->rmmio + 4 * reg_access_ctrl->scratch_reg0;
 	scratch_reg1 = (void __iomem *)adev->rmmio + 4 * reg_access_ctrl->scratch_reg1;
@@ -1073,6 +1076,9 @@ void amdgpu_sriov_wreg(struct amdgpu_device *adev,
 {
 	u32 rlcg_flag;
 
+	if (amdgpu_device_skip_hw_access(adev))
+		return;
+
 	if (!amdgpu_sriov_runtime(adev) &&
 		amdgpu_virt_get_rlcg_reg_access_flag(adev, acc_flags, hwip, true, &rlcg_flag)) {
 		amdgpu_virt_rlcg_reg_rw(adev, offset, value, rlcg_flag, xcc_id);
@@ -1090,6 +1096,9 @@ u32 amdgpu_sriov_rreg(struct amdgpu_device *adev,
 {
 	u32 rlcg_flag;
 
+	if (amdgpu_device_skip_hw_access(adev))
+		return 0;
+
 	if (!amdgpu_sriov_runtime(adev) &&
 		amdgpu_virt_get_rlcg_reg_access_flag(adev, acc_flags, hwip, false, &rlcg_flag))
 		return amdgpu_virt_rlcg_reg_rw(adev, offset, 0, rlcg_flag, xcc_id);
-- 
2.43.0



