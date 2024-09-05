Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A944A154BFF;
	Thu,  5 Sep 2024 09:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530088; cv=none; b=JaBrbTQlBFfmn2P8D45xPN5tSbFYi4pbsk/Y0qbQ5K1aNETaFqJK5cbChXLZaBeRcvXjC5eivJLF+7imMnbiUqBanSyJz1xHclx6BVMRpF+HfDDVI/vOEUI5B5k/154ohNk8LHWuzAde2PxgOVwhPfzr+9YI8dw0nkf1ZQwZmps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530088; c=relaxed/simple;
	bh=gXgSJZvymUGswu72My0Cfft8XN895K2+0EwznoZozCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo0irP8cV2pRpS6gBvrrfb7rKuMPfy3kQNUrpHcGpWlcjHIEiV9WyuRi/mSvAUNYzcB7GQWIkazC5IGBCSm4LQaSLPuJ/S0rgGFA/9qa62vkuT3apXl3KKosAX77RiNdVwDzebpc/vLOzLv0PNq5obSljDjm8SfZ5Y+/+cL5RWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ze1HsKG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ze1HsKG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC77C4CEC3;
	Thu,  5 Sep 2024 09:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530088;
	bh=gXgSJZvymUGswu72My0Cfft8XN895K2+0EwznoZozCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ze1HsKG1H/uxzPWicXk6vJdJ78wLeuxDhmmXEhpgrpv8iyTyfivKsNQ8KwywoXefy
	 80dAkVLg+ctg6bLwAvRAIzTE5JCIbvDg6fyjbki6pNxuOFhqe0NfYchM8xlcz4+KbI
	 vKIRvOVJBWupHmLor9085QeQtNY+tRCyXG33Xie4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhigang Luo <Zhigang.Luo@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/132] drm/amdgpu: avoid reading vf2pf info size from FB
Date: Thu,  5 Sep 2024 11:40:37 +0200
Message-ID: <20240905093724.205110892@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhigang Luo <Zhigang.Luo@amd.com>

[ Upstream commit 3bcc0ee14768d886cedff65da72d83d375a31a56 ]

VF can't access FB when host is doing mode1 reset. Using sizeof to get
vf2pf info size, instead of reading it from vf2pf header stored in FB.

Signed-off-by: Zhigang Luo <Zhigang.Luo@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index ff4f52e07cc0..7768c756fe88 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -615,7 +615,7 @@ static int amdgpu_virt_write_vf2pf_data(struct amdgpu_device *adev)
 	vf2pf_info->dummy_page_addr = (uint64_t)adev->dummy_page_addr;
 	vf2pf_info->checksum =
 		amd_sriov_msg_checksum(
-		vf2pf_info, vf2pf_info->header.size, 0, 0);
+		vf2pf_info, sizeof(*vf2pf_info), 0, 0);
 
 	return 0;
 }
-- 
2.43.0



