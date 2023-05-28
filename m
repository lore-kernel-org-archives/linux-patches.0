Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BAB569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87685C4339B;
	Sun, 28 May 2023 19:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302222;
	bh=7xFwNCjNfnSz8Oi433LP+2xgTQ/2cwcCMAeC0k9Ndao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJAwr7pHVQbFiWNfPr2LVWHcht3izqMVDKV4BIRyoLwprBXlH1lC5eokpi5T1KKLS
	 cgLGrhlWmRKpscPmSlNYJdytLgOp/8eUyn09HnKprL4EnoQkcp8voo4yw0qng8p5mG
	 FYb9crTn+pkSVfY2ehEe9gAo7DtBssaPAMiMXIwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Jonatas Esteves <jntesteves@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 049/127] drm/amd/pm: Fix output of pp_od_clk_voltage
Date: Sun, 28 May 2023 20:10:25 +0100
Message-Id: <20230528190837.949321802@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonatas Esteves <jntesteves@gmail.com>

commit 40baba5693b9af586dc1063af603d05a79e57a6b upstream.

Printing the other clock types should not be conditioned on being able
to print OD_SCLK. Some GPUs currently have limited capability of only
printing a subset of these.

Since this condition was introduced in v5.18-rc1, reading from
`pp_od_clk_voltage` has been returning empty on the Asus ROG Strix G15
(2021).

Fixes: 79c65f3fcbb1 ("drm/amd/pm: do not expose power implementation details to amdgpu_pm.c")
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Jonatas Esteves <jntesteves@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -869,13 +869,11 @@ static ssize_t amdgpu_get_pp_od_clk_volt
 	}
 	if (ret == -ENOENT) {
 		size = amdgpu_dpm_print_clock_levels(adev, OD_SCLK, buf);
-		if (size > 0) {
-			size += amdgpu_dpm_print_clock_levels(adev, OD_MCLK, buf + size);
-			size += amdgpu_dpm_print_clock_levels(adev, OD_VDDC_CURVE, buf + size);
-			size += amdgpu_dpm_print_clock_levels(adev, OD_VDDGFX_OFFSET, buf + size);
-			size += amdgpu_dpm_print_clock_levels(adev, OD_RANGE, buf + size);
-			size += amdgpu_dpm_print_clock_levels(adev, OD_CCLK, buf + size);
-		}
+		size += amdgpu_dpm_print_clock_levels(adev, OD_MCLK, buf + size);
+		size += amdgpu_dpm_print_clock_levels(adev, OD_VDDC_CURVE, buf + size);
+		size += amdgpu_dpm_print_clock_levels(adev, OD_VDDGFX_OFFSET, buf + size);
+		size += amdgpu_dpm_print_clock_levels(adev, OD_RANGE, buf + size);
+		size += amdgpu_dpm_print_clock_levels(adev, OD_CCLK, buf + size);
 	}
 
 	if (size == 0)


