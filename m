Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EEF32E159;
	Fri, 17 Oct 2025 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715375; cv=none; b=EbHgx+Cmzz14lWBcAy82MA9N7cIrEgbbJjhTxvUCxhb56q4uMDBIzZFRwggls/dN29c16FwUlIUlTQ17voW9A9fCVamoRt+zyqhGkQU01xV4NRSoZj/Fv0TeWD7/JkssxdcakLCpWKVRPzt/G+a3ugs14GTZV9Acm0Yfxh7GOsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715375; c=relaxed/simple;
	bh=P086DRZpWl0xU7KL3Ogz+51MHBdrJIzLycGLpWcc8JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZ5nsyphntOb+roIF/XGlho2ZDtcW3s9qnzFVnbqqH2SsasXo3auWyUGc+fDSFfwUwKdGroaEYLOCdzVeiAhRWWzgHsy/ckw7GpHjmOG06c/bMlfW8sa8qqyAkkYDElYvClSqIuAWuufwb4X1cKNrhDppGrInO+lrCymBZxOtyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0d+X0WUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0d+X0WUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FF5C113D0;
	Fri, 17 Oct 2025 15:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715375;
	bh=P086DRZpWl0xU7KL3Ogz+51MHBdrJIzLycGLpWcc8JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0d+X0WUYldQKCUsLA+k5q0aYAk4Jd8O6vc/k/gTCc5DK3Ym8kbxQA5wC0yst3QPqR
	 qZ9N0wG3THtJjjqXHgi9SSrjF6ZUtvTxnDK9Yxuxw5q2/uBgi1BbqKk2d7Zc5OJp0n
	 mZCrvenRP0kh2jYtYpHkq1f5R9MrP4L5wNHA4Nkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.17 193/371] drm/amd/display: Enable Dynamic DTBCLK Switch
Date: Fri, 17 Oct 2025 16:52:48 +0200
Message-ID: <20251017145208.910422483@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

commit 5949e7c4890c3cf65e783c83c355b95e21f10dba upstream.

[WHAT]
Since dcn35, DTBCLK can be disabled when no DP2 sink connected for
power saving purpose.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1956,6 +1956,10 @@ static int amdgpu_dm_init(struct amdgpu_
 
 	init_data.flags.disable_ips_in_vpb = 0;
 
+	/* DCN35 and above supports dynamic DTBCLK switch */
+	if (amdgpu_ip_version(adev, DCE_HWIP, 0) >= IP_VERSION(3, 5, 0))
+		init_data.flags.allow_0_dtb_clk = true;
+
 	/* Enable DWB for tested platforms only */
 	if (amdgpu_ip_version(adev, DCE_HWIP, 0) >= IP_VERSION(3, 0, 0))
 		init_data.num_virtual_links = 1;


