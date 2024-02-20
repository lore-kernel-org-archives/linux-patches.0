Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9100151CCC;
	Tue, 20 Feb 2024 21:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465031; cv=none; b=YJNYfMKu6ls4SnID3fUDF9wivwEXVfw9lFPqp3rN826S0K3HRgFJryhEE2THPn6Ik/PHhqg6arUcQI0g6QN5fNtN2Laa/qH0gsqPmhL6vfaEgvBHQ4lPnaMolmtX0AOXFELj4o3bbxg8eoVJ3CbCp3uO5hGZngZkuQ5OPUKLk2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465031; c=relaxed/simple;
	bh=8fz9PzWYZSBklPQD4ncFTgkXvLCgrEFqHLoNNAK98NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiwCwlOJmsriY/dr5MRrpAirKCaScOkTemxI9tT/j96MTBfKqPSa2J6sv2h9yOatiKBV4ypL3mC3TG1YfWLLthwbV6wxs3ylTrBCWd3jJCk3LLHzqlpEarvrZ+WSxC1nEjKlVwgRONe1d02UHKaW6eL5XRPpx8WMkBzcqpNiz4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYN4MZ7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYN4MZ7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF73C433F1;
	Tue, 20 Feb 2024 21:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465031;
	bh=8fz9PzWYZSBklPQD4ncFTgkXvLCgrEFqHLoNNAK98NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYN4MZ7eYPR5lz6/QsRo3Mn1Vxe+sHOye7OyAFch6WopHxZw2wn34r9gyhcwFjKiF
	 fZvw53PnzaggwwEIcpGYwL8wX04Uf6rDOOyfxeSrtWAVsEF1t3F9mv8/qdvKh74HrF
	 ZSVKm3rG3DyqE5QW/jw08cxrfrcAmHlxuMRf2eNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 214/309] drm/amdgpu: Avoid fetching VRAM vendor info
Date: Tue, 20 Feb 2024 21:56:13 +0100
Message-ID: <20240220205639.869178227@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 55173942a63668bdc1d61812c7c9e0406aefb5bf upstream.

The present way to fetch VRAM vendor information turns out to be not
reliable on GFX 9.4.3 dGPUs as well. Avoid using the data.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1947,14 +1947,6 @@ static int gmc_v9_0_init_mem_ranges(stru
 
 static void gmc_v9_4_3_init_vram_info(struct amdgpu_device *adev)
 {
-	static const u32 regBIF_BIOS_SCRATCH_4 = 0x50;
-	u32 vram_info;
-
-	/* Only for dGPU, vendor informaton is reliable */
-	if (!amdgpu_sriov_vf(adev) && !(adev->flags & AMD_IS_APU)) {
-		vram_info = RREG32(regBIF_BIOS_SCRATCH_4);
-		adev->gmc.vram_vendor = vram_info & 0xF;
-	}
 	adev->gmc.vram_type = AMDGPU_VRAM_TYPE_HBM;
 	adev->gmc.vram_width = 128 * 64;
 }


