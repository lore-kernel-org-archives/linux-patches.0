Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3B4248881;
	Wed, 25 Feb 2026 01:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983617; cv=none; b=ax9EQSpxqu/rf+84+MjJ8b9gCv+GvSzsvKe7lZd5cHfFN0cTEf7TkebOsEeEf17DDr/YNWQgdvOLX/qu2FZMzpFIKkeM11GmmLKapDEVPgORIj49N+rIoX94rgMXIeV8NGFEdlD9FnjoKjMNlzS0O7tw0QPPT8XBPBd8b6Rqr4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983617; c=relaxed/simple;
	bh=A9SJQyncR59m/mxUbnSap5pd5HH8wtCOoJXI8wFKkUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+NvH8xcp4t62dAbiWnPw8fGV5wprA9ETl6dSxNO9UaEAJkIxW7ZFhcOzD8EFrGBvN67a7YdAMTiUI+u77c1rX19JDBUcIgkZW89AjKhXVsa7FN1hcZ6vpSf0V/PAUpWHIYIY8JkA//agAVxbhDIK7wcIvDz/0uHrY6EbWZKP5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXLjD80r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXLjD80r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89712C116D0;
	Wed, 25 Feb 2026 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983617;
	bh=A9SJQyncR59m/mxUbnSap5pd5HH8wtCOoJXI8wFKkUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXLjD80reVP47c3bXjUBN4Jdg2IXKQsH9RWAaLM+Ro7W+WDkiEbY5DumlukGTR/Ta
	 sTMPrrfGnMtLFBpva68rtFa/ob3zJj4SqJJEUNKhJqIsL08YqONFr6uxxGkhHr9fGY
	 u8F/hjbXbQA6nDt8t5bnVU4rVvtKHL0FhtUXzins=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	"Jesse.Zhang" <Jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 711/781] drm/amdgpu/sdma6: enable queue resets unconditionally
Date: Tue, 24 Feb 2026 17:23:40 -0800
Message-ID: <20260225012417.186774193@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 56423871e9eef1dd069bddef895207fa5ce275fe ]

There is no firmware version dependency.  This also
enables sdma queue resets on all SDMA 6.x based
chips.

Fixes: 59fd50b8663b ("drm/amdgpu: Add sysfs interface for sdma reset mask")
Cc: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Jesse.Zhang <Jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
index 2170400449872..6809c6d4be5b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -1351,18 +1351,9 @@ static int sdma_v6_0_sw_init(struct amdgpu_ip_block *ip_block)
 
 	adev->sdma.supported_reset =
 		amdgpu_get_soft_full_reset_mask(&adev->sdma.instance[0].ring);
-	switch (amdgpu_ip_version(adev, SDMA0_HWIP, 0)) {
-	case IP_VERSION(6, 0, 0):
-	case IP_VERSION(6, 0, 2):
-	case IP_VERSION(6, 0, 3):
-		if ((adev->sdma.instance[0].fw_version >= 21) &&
-		    !amdgpu_sriov_vf(adev) &&
-		    !adev->debug_disable_gpu_ring_reset)
-			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
-		break;
-	default:
-		break;
-	}
+	if (!amdgpu_sriov_vf(adev) &&
+	    !adev->debug_disable_gpu_ring_reset)
+		adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 
 	if (amdgpu_sdma_ras_sw_init(adev)) {
 		dev_err(adev->dev, "Failed to initialize sdma ras block!\n");
-- 
2.51.0



