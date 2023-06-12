Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB10FBF2
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D4FC433EF;
	Mon, 12 Jun 2023 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566545;
	bh=D407yoHy8k15nn4A+GJw2lD3h6C6R2U50/wzyNSiIwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8XqOLDjGLRStYCkwqsjy+HZqjQh+eSa1u0k6attaW4f4HcQrLzQhueeGcGK1WPib
	 IHDXpH9QAEY+dbKgcd9GsWvu3gNQ1QUrizXabpQi18TuUaDfOljLSldinzos8T2hWt
	 PJp9GfanrApeeiaBa0KN7YLHB7oD5mxT7JRkivcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 073/132] drm/amdgpu: fix xclk freq on CHIP_STONEY
Date: Mon, 12 Jun 2023 12:26:47 +0200
Message-ID: <20230612101713.607945315@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chia-I Wu <olvaffe@gmail.com>

commit b447b079cf3a9971ea4d31301e673f49612ccc18 upstream.

According to Alex, most APUs from that time seem to have the same issue
(vbios says 48Mhz, actual is 100Mhz).  I only have a CHIP_STONEY so I
limit the fixup to CHIP_STONEY

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vi.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -542,8 +542,15 @@ static u32 vi_get_xclk(struct amdgpu_dev
 	u32 reference_clock = adev->clock.spll.reference_freq;
 	u32 tmp;
 
-	if (adev->flags & AMD_IS_APU)
-		return reference_clock;
+	if (adev->flags & AMD_IS_APU) {
+		switch (adev->asic_type) {
+		case CHIP_STONEY:
+			/* vbios says 48Mhz, but the actual freq is 100Mhz */
+			return 10000;
+		default:
+			return reference_clock;
+		}
+	}
 
 	tmp = RREG32_SMC(ixCG_CLKPIN_CNTL_2);
 	if (REG_GET_FIELD(tmp, CG_CLKPIN_CNTL_2, MUX_TCLK_TO_XCLK))


