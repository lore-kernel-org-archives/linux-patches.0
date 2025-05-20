Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199DC24E008;
	Tue, 20 May 2025 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750762; cv=none; b=O0EIwEibseghWIoxKAUzBMZ0NaIUbF5om9yCuJy3LwqIZlKz/xHnydAWC2yASJ+azG/S3LUot2+ofJCh1a+fP9vJmmhU5qKDBBESTIauTXO1WFT65pNKrrCykFvdeiAn3ycs/KRlYYJoWqncPq3psfCYvWkQOkiIeHjgLRU83gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750762; c=relaxed/simple;
	bh=HhHa6YgYbGj5YiJPd7zQH0dk04LsnAqcQraPZD1b33k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+OsOQpve4cGZ6v5Okd9DTde5ceELycoQ42T4dE+lcNMNgvbWgOUEi+WKhfLZFKUb9yjWdPZq/1Nf6CrGuvy0uTGsadh3rwhyNoVGqPMGY/1s5Ith2xCsweNnOElX6ujyZQVRGa7mT6ifs2YQqHAOVt0xl7ddLicchSA9vgsb/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yez3XRP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yez3XRP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39FBC4CEE9;
	Tue, 20 May 2025 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750758;
	bh=HhHa6YgYbGj5YiJPd7zQH0dk04LsnAqcQraPZD1b33k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yez3XRP0NIiSM+OXBcAJL6gdLA0Mz1UwwIRwtlMOEs0Dui8UldgA64I1f4vNxjyhV
	 nb9Aib6SepcujiF5dRdNXuOULta6et74qdIcYjMv3Se8DNJxU4cvzVuHIrsKKpNfb2
	 JMc5rCBC9OTxErNVuavnoZ7uULiO1ucKTAewprbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>
Subject: [PATCH 6.14 081/145] drm/amdgpu: fix incorrect MALL size for GFX1151
Date: Tue, 20 May 2025 15:50:51 +0200
Message-ID: <20250520125813.753103189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <tim.huang@amd.com>

commit 2d73b0845ab3963856e857b810600e5594bc29f4 upstream.

On GFX1151, the reported MALL cache size reflects only
half of its actual size; this adjustment corrects the discrepancy.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0a5c060b593ad152318f89e5564bfdfcff8a6ac0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -750,6 +750,18 @@ static int gmc_v11_0_sw_init(struct amdg
 	adev->gmc.vram_type = vram_type;
 	adev->gmc.vram_vendor = vram_vendor;
 
+	/* The mall_size is already calculated as mall_size_per_umc * num_umc.
+	 * However, for gfx1151, which features a 2-to-1 UMC mapping,
+	 * the result must be multiplied by 2 to determine the actual mall size.
+	 */
+	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
+	case IP_VERSION(11, 5, 1):
+		adev->gmc.mall_size *= 2;
+		break;
+	default:
+		break;
+	}
+
 	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
 	case IP_VERSION(11, 0, 0):
 	case IP_VERSION(11, 0, 1):


