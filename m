Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E40C110A;
	Tue, 23 Jan 2024 02:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975768; cv=none; b=tIKc4wKLrL7FsTVr4+ldQJ83MLmkafAI5K7zaaNJlSTeXv+tx2RM6VdRrh8mG3JbMrntQ3gjyKU6PiwmlmTrhn4VOh9bSthqZJmBSNukZr7BlpGfF2FNuwIFmY2YW41HKdSEdm+Qz2Ulgxv1oDChPFxHXbTsQNC++JeEC5iv2Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975768; c=relaxed/simple;
	bh=bKnbIOexUhN6L6inpDUZGw6dIQlpDheyLwTrqGXWL7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPXgafXJ3pmQFgxHYQ7wICiHBeM5EvMe/+biKUaA4AjN4GF/hNB2gp+1e2zr+MM/0Kv78cZKOAnyTBFuyTve8fccKMkJZCJsYfG4E4w2Nuy3fkzg+1FlxlPrclYbnnMo4T9yLLK7lFDBxkclPfdAK5L0uLCrV3I7b96NsDhG2u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TdItdwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TdItdwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE248C43390;
	Tue, 23 Jan 2024 02:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975768;
	bh=bKnbIOexUhN6L6inpDUZGw6dIQlpDheyLwTrqGXWL7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TdItdwclTsrxpQiaGSNOLzMhkmEB1oC3g9iGyhRwnCyFWk9R6zrlQ2PrIXTaGix9
	 n7msZszE00CIxammTxvXsDdLp5581xekyieefWzj2+gdsK6po7K5eWyOVwY6beOg8d
	 UtnyG0deB2nUNWtCmRhn6KzWr+6+yz/RP5xm4fd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 552/583] drm/amdgpu: fall back to INPUT power for AVG power via INFO IOCTL
Date: Mon, 22 Jan 2024 16:00:03 -0800
Message-ID: <20240122235829.037301426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit d02069850fc102b07ae923535d5e212f2c8a34e9 ]

For backwards compatibility with userspace.

Fixes: 47f1724db4fe ("drm/amd: Introduce `AMDGPU_PP_SENSOR_GPU_INPUT_POWER`")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2897
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index d30dc0b718c7..58dab4f73a9a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -1026,7 +1026,12 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 			if (amdgpu_dpm_read_sensor(adev,
 						   AMDGPU_PP_SENSOR_GPU_AVG_POWER,
 						   (void *)&ui32, &ui32_size)) {
-				return -EINVAL;
+				/* fall back to input power for backwards compat */
+				if (amdgpu_dpm_read_sensor(adev,
+							   AMDGPU_PP_SENSOR_GPU_INPUT_POWER,
+							   (void *)&ui32, &ui32_size)) {
+					return -EINVAL;
+				}
 			}
 			ui32 >>= 8;
 			break;
-- 
2.43.0



