Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459612FB08C;
	Wed, 25 Feb 2026 06:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002757; cv=none; b=pyD9Ed/8E+VQ8E7hfcB9mvrG8hFpc7yFK9UrlEGhiLATDF9twguLEpsZwKGUmBSBJRQyDHCvbUedAaP4D83ZLrU/idOlGFo1h4DdFpluf3B+K715Old5j+wmwWBaflMOYYWAmQkym7Gmwj+C5mhhdRt5c8FKe6aBBy1cOLOTXso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002757; c=relaxed/simple;
	bh=u5X+C1g3xRrrwFjIGq7xA800WZpfHB5u2E4wKlnJCtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEJbGpschN28v0ZEEXGlNCxoDFy5Dh0RdZRiashKU3CX+MbMy1ynF96vVK3dPyqbWw8tHLM391p383UErwu19qJPF10TifONHwkx1bsUZIKJlBFf7cDJWGie7onjQDzFB9vGBnM1e2VAyE5xzCzM5g6WE6dXmO4W1P1kvO0ZqF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMzU4xbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMzU4xbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA67C116D0;
	Wed, 25 Feb 2026 06:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002757;
	bh=u5X+C1g3xRrrwFjIGq7xA800WZpfHB5u2E4wKlnJCtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMzU4xbIfTb/ooBK/ugcU9UK9OmR0MIKTGDd+juAlg4jJK2GjQ6Fe/NENz3aCwrkf
	 IkGvhV5S7QKDU8eIRZmy65mTeUHzMJxnNKB5ZcxDQljB+NP6jw0aqlU226DgYrsejs
	 0/K2YL0AdNE8ncgcO8B84Y4V9OfQ8uzZYlM8fWFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	"Jesse.Zhang" <Jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 584/641] drm/amdgpu/sdma6: enable queue resets unconditionally
Date: Tue, 24 Feb 2026 17:25:10 -0800
Message-ID: <20260225012402.662040564@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



