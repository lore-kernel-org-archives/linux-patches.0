Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24532F3605;
	Fri, 10 Oct 2025 13:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102330; cv=none; b=o4ar4Ouq2QNFMw8hU2VNzvsq9fno7OuG05lFwG0fRVVFYwgPHg4iIrVhfnV4KTE+rX/asZLdmDUFGvZb6Gyb9a46zSSL39/c2kkLKPydVFK/DQs5PvYkpdqpp9s72PHuxH8Dg4rpO3emKNrL1jRjV1ZS9ffahqoZnueLbwiTaSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102330; c=relaxed/simple;
	bh=5hCpYKng3divR1V4azgqk6TIDa83yoRj5sjv7o5j7Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7ocG/wn0RwLFA/Ldr83Cf2MvcvfKX8xBo+EdHShGY3220LY2Kw+7ndl/nzJ1//IEevysaDfqL9qdiEi77wXHIXp5anPW4m3sIKDW2YFvN7TX1HNrWYEp7QHaAYne4xBqYCg1i4nq3JRjV1ybUuTNbLmDCfzPNKPCBqclSgG6cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8CDHy+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8CDHy+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06345C4AF0D;
	Fri, 10 Oct 2025 13:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102330;
	bh=5hCpYKng3divR1V4azgqk6TIDa83yoRj5sjv7o5j7Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8CDHy+WqZL1oMeo0yVl6wp/ATLxIvytGacn0Z3ARLQez5tDDnCISGC0Wsj5RznGR
	 jndfWDlUP/egS6ziK2Wo46VgRbytSNO0VOJ8EfCWRJ21e72xFbPQilPlKPmvny9Syu
	 xz8kBHjnKPYrmp8Nde5HUFVSrzj0HxRMU7F9tcVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wasee Alam <wasee.alam@amd.com>,
	Mario Sopena-Novales <mario.novales@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 19/41] drm/amdgpu/gfx11: Add Cleaner Shader Support for GFX11.0.1/11.0.4 GPUs
Date: Fri, 10 Oct 2025 15:16:07 +0200
Message-ID: <20251010131334.117737752@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit c1b6b8c7706354b73196649c46b5e6d4d61c2f5c ]

Enable the cleaner shader for additional GFX11.0.1/11.0.4 series GPUs to
ensure data isolation among GPU tasks. The cleaner shader is tasked with
clearing the Local Data Store (LDS), Vector General Purpose Registers
(VGPRs), and Scalar General Purpose Registers (SGPRs), which helps avoid
data leakage and guarantees the accuracy of computational results.

This update extends cleaner shader support to GFX11.0.1/11.0.4 GPUs,
previously available for GFX11.0.3. It enhances security by clearing GPU
memory between processes and maintains a consistent GPU state across KGD
and KFD workloads.

Cc: Wasee Alam <wasee.alam@amd.com>
Cc: Mario Sopena-Novales <mario.novales@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0a71ceb27f88a944c2de2808b67b2f46ac75076b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 96566870f079b..199bd9340b3bf 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1654,6 +1654,21 @@ static int gfx_v11_0_sw_init(struct amdgpu_ip_block *ip_block)
 			}
 		}
 		break;
+	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
+		adev->gfx.cleaner_shader_ptr = gfx_11_0_3_cleaner_shader_hex;
+		adev->gfx.cleaner_shader_size = sizeof(gfx_11_0_3_cleaner_shader_hex);
+		if (adev->gfx.pfp_fw_version >= 102 &&
+		    adev->gfx.mec_fw_version >= 66 &&
+		    adev->mes.fw_version[0] >= 128) {
+			adev->gfx.enable_cleaner_shader = true;
+			r = amdgpu_gfx_cleaner_shader_sw_init(adev, adev->gfx.cleaner_shader_size);
+			if (r) {
+				adev->gfx.enable_cleaner_shader = false;
+				dev_err(adev->dev, "Failed to initialize cleaner shader\n");
+			}
+		}
+		break;
 	case IP_VERSION(11, 5, 0):
 	case IP_VERSION(11, 5, 1):
 		adev->gfx.cleaner_shader_ptr = gfx_11_0_3_cleaner_shader_hex;
-- 
2.51.0



