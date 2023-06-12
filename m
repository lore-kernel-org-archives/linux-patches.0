Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451F61950B
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E10C4339B;
	Mon, 12 Jun 2023 10:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566039;
	bh=1UOIqz1iTqv2375eoaSSz28/ueW4S4fzHEmXuq+nGyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfIyQWG71goHnXrhbc36zGHBJ97TKq2DTSosdWEpq0Nz5OQ/84qEzvLY4Nn9GzdNB
	 9Dbo+uoMfGjwMG0MA9Q3I2Rhffi9kyMduns/C2DONJm880kJGijSf7LtmJsRVxIUgE
	 GVbYSQPNXNaS7mWjq4rb7+ubFz3ncdMupT9V8oCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 40/68] drm/amdgpu: fix xclk freq on CHIP_STONEY
Date: Mon, 12 Jun 2023 12:26:32 +0200
Message-ID: <20230612101700.071403085@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
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
@@ -329,8 +329,15 @@ static u32 vi_get_xclk(struct amdgpu_dev
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


