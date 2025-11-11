Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD41918DF80;
	Tue, 11 Nov 2025 01:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825532; cv=none; b=fvunGaQPJxDI8frEYwkpQQjpiyecoxQOaT6mUDqjzilPIXJPJCtAk4WjsLpE9lHVOmZpxGscjp11wS+wzK/8R8c+vJ2vxkw0PbKrh9kQ+jbIaXIH6HA9K3F/Upg4dBL9yHqY512ftlRisIZ77pP1Yj9OLrJoGYWtrbKDgSgiY8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825532; c=relaxed/simple;
	bh=xNo6MFK1GAftxy9g7PKbmWsuZCH+52iM00blEXI8FPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ky3rQ7dS9MXPT4vG8cPdeSBzMgcpL8pkQ6esXe8P1VUoU6aev6uc98GsAn0Klaoni04EFIK/NYAujdWPROnrWuyTJAyIqm9OsmRwx3qFJXEfCK9PxSr5ADIQeMZtFwtusO0AGDU94dQhoMYG3D1jUO1zHxF59OK0FnIk6x70zC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6ly9StY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6ly9StY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0548CC4CEFB;
	Tue, 11 Nov 2025 01:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825531;
	bh=xNo6MFK1GAftxy9g7PKbmWsuZCH+52iM00blEXI8FPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6ly9StYfF+V9DO5LNiSboAmK9c/uGZRpBLYgccOOowOMhQV7sZd1GModt9vy+j7x
	 /aH85sh5wl3GUVmHgoX0O0YR/ClSvVbBVA09cqwCBrhlWEFfRTTVcgLWG5FqJbCVsp
	 9hNpSpbI2kaPJQ7uEKWs22RjSdKTMJPsrEylHvqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 841/849] drm/amdgpu: Fix unintended error log in VCN5_0_0
Date: Tue, 11 Nov 2025 09:46:51 +0900
Message-ID: <20251111004556.754078226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

commit 46b0e6b9d749cfa891e6969d6565be1131c53aa2 upstream.

The error log is supposed to be gaurded under if failure condition.

Fixes: faab5ea08367 ("drm/amdgpu: Check vcn sram load return value")
Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -769,9 +769,10 @@ static int vcn_v5_0_0_start_dpg_mode(str
 
 	if (indirect) {
 		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
-		dev_err(adev->dev, "%s: vcn sram load failed %d\n", __func__, ret);
-		if (ret)
+		if (ret) {
+			dev_err(adev->dev, "%s: vcn sram load failed %d\n", __func__, ret);
 			return ret;
+		}
 	}
 
 	ring = &adev->vcn.inst[inst_idx].ring_enc[0];


