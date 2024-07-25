Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F9519A29C;
	Thu, 25 Jul 2024 14:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918304; cv=none; b=S6eKzZr2k5wnU6AhjukDyjmuOIpniY4Cbm1dBFpb2hcl2zRok7Je7P7Yb+iOv+fFgiLEnoPK9Xq1LypEh5mp+k2rV8y35ts+OgH1YmZGsxMfoqxQVEcf7/kLG3nW5Dop+c6GIkOF+4z14LGT1NYxaqp2qqvQ6jRWEkaBB/bcwKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918304; c=relaxed/simple;
	bh=Yv1Tfp7MXPkUw+uwkCOsovb+cETVRXYcXCfUxnhp77w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kO8/Is3mmwkKZ9N4YSNCElEEYUjVNlJwdo/+KRTCYwl1SQ3f0ArNr1WpuGhQ1/L4K/XV61yiiDGxGU2cyhsHeGPD13BVT1HIoCH6ll/uq3TAFVDf1upMPpgDd526oSCMyIoRhNcpYsNjufcjp1haVWqpyY+eZ5CoXpY0xlzC68s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQbG1Hcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQbG1Hcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3612C116B1;
	Thu, 25 Jul 2024 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918304;
	bh=Yv1Tfp7MXPkUw+uwkCOsovb+cETVRXYcXCfUxnhp77w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQbG1Hcf7cpH7p3K5JaUNtVPnwdOI6ocYP94bNdZFSqg85W2SUEqwFMEzoCGaGxu9
	 7OVAPLAVtKA1JiIjec4ISFj8PROGj/B3HXLv+fPFtO5ub5pFsso7zh8+nGsxXT/dz8
	 QBvFNGSkuKriMw2tnI5cVGNuQn2ep82hBb/AB+50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 6.10 01/29] drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()
Date: Thu, 25 Jul 2024 16:36:17 +0200
Message-ID: <20240725142731.873778629@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 6769a23697f17f9bf9365ca8ed62fe37e361a05a upstream.

The "instance" variable needs to be signed for the error handling to work.

Fixes: 8b2faf1a4f3b ("drm/amdgpu: add error handle to avoid out-of-bounds")
Reviewed-by: Bob Zhou <bob.zhou@amd.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2017,7 +2017,7 @@ static int sdma_v4_0_process_trap_irq(st
 				      struct amdgpu_irq_src *source,
 				      struct amdgpu_iv_entry *entry)
 {
-	uint32_t instance;
+	int instance;
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);


