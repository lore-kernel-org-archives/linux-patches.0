Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C02A1386CB;
	Tue, 27 Feb 2024 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043351; cv=none; b=ai4NG6TFxwW1ADuit7AA1W8x8IOWLbF9bCfFA1BKSXZluuLRv5JTxdVwX3mi7dCLVkLyRup9nncvMq6cbEJnYhV23Yd6XEItu5r9308TBj3snb1BXtQO9tK554eXtCq+fWSfxS7hSQJQxIVn9NGrGdcj/GoWUA06+Qmz4PZZm6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043351; c=relaxed/simple;
	bh=ouiQvd3hpx29Dwat0NJXjmFpBFng7c1y+M+y68oRZyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6EqnBvly2j0VQofJuS6M9AfL4n5jI0obtufLa5ryszEfKcIJ/9g9lxxkQENSACVdnyKXMbwlrKiUBK6/geFWA/JgwA2UfO/HZaiTQCTmEEzIXNf0TMs32uyyx66bzzmCsq9i3QH1rjM4PoIbzbGpHYGKlBmRkOE+gKK0pTjAvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04bmZen3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04bmZen3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BDFC433C7;
	Tue, 27 Feb 2024 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043351;
	bh=ouiQvd3hpx29Dwat0NJXjmFpBFng7c1y+M+y68oRZyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04bmZen3lJjs7wkpl2oW++f4pVgafOiYTR0mqeIbzHX+gNssbenRFMj7I9yiKKPLB
	 TfxiyYbRlGgEa6xT/nYBtfnP8H98pPwLi6AstJ6EsZ1nu50Lv7DlNQECCdDU56z40q
	 6HxA4jszDPkL9lT7MY2Q6h84xJxJzakpsrSh7z34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/195] drm/amdgpu: reset gpu for s3 suspend abort case
Date: Tue, 27 Feb 2024 14:25:38 +0100
Message-ID: <20240227131613.037227564@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 6ef82ac664bb9568ca3956e0d9c9c478e25077ff ]

In the s3 suspend abort case some type of gfx9 power
rail not turn off from FCH side and this will put the
GPU in an unknown power status, so let's reset the gpu
to a known good power state before reinitialize gpu
device.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 811dd3ea63620..489c89465c78b 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1285,10 +1285,32 @@ static int soc15_common_suspend(void *handle)
 	return soc15_common_hw_fini(adev);
 }
 
+static bool soc15_need_reset_on_resume(struct amdgpu_device *adev)
+{
+	u32 sol_reg;
+
+	sol_reg = RREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_81);
+
+	/* Will reset for the following suspend abort cases.
+	 * 1) Only reset limit on APU side, dGPU hasn't checked yet.
+	 * 2) S3 suspend abort and TOS already launched.
+	 */
+	if (adev->flags & AMD_IS_APU && adev->in_s3 &&
+			!adev->suspend_complete &&
+			sol_reg)
+		return true;
+
+	return false;
+}
+
 static int soc15_common_resume(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	if (soc15_need_reset_on_resume(adev)) {
+		dev_info(adev->dev, "S3 suspend abort case, let's reset ASIC.\n");
+		soc15_asic_reset(adev);
+	}
 	return soc15_common_hw_init(adev);
 }
 
-- 
2.43.0



