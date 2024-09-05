Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCE314A08E;
	Thu,  5 Sep 2024 09:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529645; cv=none; b=g9jlDUHLSUHyK6iQGSbNs8mErEc7CvS49RLFmXpacuYg9zfS1PCn9OWdJHG2XTUKxQ0+mwWsfU2tSSRmBHNYU1kyNoE0O+JEPJXuxnq0Zdrw3zH1h54hJagUlV1+Q1mhvx2oKbdTKBaQxDJvChzw9tUeZrac0MibGsaNFBhddXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529645; c=relaxed/simple;
	bh=zaTbc0o1knnnA0JpQiHbXO/z/5tyaMxa0sJW8EP5UlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cd9WT53PJZ9GMDDLc635p19E4+UDxB0+z51J/7Tnrmu0yYVJXdT4x9qKlPhHGEgBwgBJtR0B93zuFNfsuNbGkNRAtQf7tZyjKLiidAxZGug3Tfj7839Bl+QZlcNHXMEphLEdCKjD55pgRczC7QGpuIWwcrCCKkPOi6sRQ/pz3l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVkrG5of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVkrG5of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68DBC4CEC3;
	Thu,  5 Sep 2024 09:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529645;
	bh=zaTbc0o1knnnA0JpQiHbXO/z/5tyaMxa0sJW8EP5UlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVkrG5ofHX39PWPkWT4RkhejyuhiZL49C9yRAJekTCPu30oDsBvlvaezbG0wszdaA
	 RbhQyXLGC9H1Ja1j/9hiFXHt3BLDcGJlcvj2hM4Q5cWXNclgJCP1/jvityhS+e0Uju
	 QbEfSReNsC8FTElO52uo0ovxQJW/e7nMlkwSxPEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 091/184] drm/amdgpu: Fix uninitialized variable warning in amdgpu_info_ioctl
Date: Thu,  5 Sep 2024 11:40:04 +0200
Message-ID: <20240905093735.794531827@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 0991e49d2b73bb4189f83a49eb41cdf16976bbf6 ]

Check the return value of amdgpu_xcp_get_inst_details, otherwise we
may use an uninitialized variable inst_mask

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index a0ea6fe8d060..977cde6d1362 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -623,25 +623,32 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 			switch (type) {
 			case AMD_IP_BLOCK_TYPE_GFX:
 				ret = amdgpu_xcp_get_inst_details(xcp, AMDGPU_XCP_GFX, &inst_mask);
+				if (ret)
+					return ret;
 				count = hweight32(inst_mask);
 				break;
 			case AMD_IP_BLOCK_TYPE_SDMA:
 				ret = amdgpu_xcp_get_inst_details(xcp, AMDGPU_XCP_SDMA, &inst_mask);
+				if (ret)
+					return ret;
 				count = hweight32(inst_mask);
 				break;
 			case AMD_IP_BLOCK_TYPE_JPEG:
 				ret = amdgpu_xcp_get_inst_details(xcp, AMDGPU_XCP_VCN, &inst_mask);
+				if (ret)
+					return ret;
 				count = hweight32(inst_mask) * adev->jpeg.num_jpeg_rings;
 				break;
 			case AMD_IP_BLOCK_TYPE_VCN:
 				ret = amdgpu_xcp_get_inst_details(xcp, AMDGPU_XCP_VCN, &inst_mask);
+				if (ret)
+					return ret;
 				count = hweight32(inst_mask);
 				break;
 			default:
 				return -EINVAL;
 			}
-			if (ret)
-				return ret;
+
 			return copy_to_user(out, &count, min(size, 4u)) ? -EFAULT : 0;
 		}
 
-- 
2.43.0



