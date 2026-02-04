Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50DD2D5C91;
	Wed,  4 Feb 2026 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219226; cv=none; b=HdeZO8Se15Tjmb6NZ7xmHTBxC9pOxKvCSMH3DpNim2xbmN/6ZuW3ZbTtCf2n75PTx0aC4rlyY2RH74puEPwLjsFfzq8YSwTmTtqEcXwSBFT1n6zts/K64KXpyCeJWDmcpO3fY8lBRqXFCg13ZV7K8ezFnFhLYr0xZYyTHTbEwMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219226; c=relaxed/simple;
	bh=zzaNYIGKO5JeOtOVL1vQTeKoVJnpFPAwVRoyUV72nNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zjsaefwl+Vj6yRJluy/t71nf7ZfuD3HvKgQd5Vfpn+HtaqJUZjkEyBDnaxHyj1P5ypMHEl0o4zB4PzYHVJTBpZ/UPDEJ4BKu6BolI/i7LAl6pmze7CJFwsRZkLMSdkxeBmqt20CIU6lKvtoeXPke5cbgyN4x85yZXOiGJw9iPFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGbd58o0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGbd58o0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C7CC4CEF7;
	Wed,  4 Feb 2026 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219225;
	bh=zzaNYIGKO5JeOtOVL1vQTeKoVJnpFPAwVRoyUV72nNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGbd58o0YAONmW6nOJbXUO9/CtYImdhhT1w0mShzYnUCKOp7GqPG5ODOnA7T+0y/2
	 r2gdR1ppmbIK8XH/gUzt/p3rseu4F6xFXfNjtuny1QEpVVJOpPiI+7XSE9Wfrk94NE
	 H5M98rI+qiyd8XZMVohen4KNO0XhEWl2eyC01iSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 105/122] drm/amd/pm: fix smu v13 soft clock frequency setting issue
Date: Wed,  4 Feb 2026 15:41:27 +0100
Message-ID: <20260204143855.630597080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

commit c764b7af15289051718b4859a67f9a3bc69d3fb2 upstream.

v1:
resolve the issue where some freq frequencies cannot be set correctly
due to insufficient floating-point precision.

v2:
patch this convert on 'max' value only.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6194f60c707e3878e120adeb36997075664d8429)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h   |    1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -56,6 +56,7 @@
 #define SMUQ10_TO_UINT(x) ((x) >> 10)
 #define SMUQ10_FRAC(x) ((x) & 0x3ff)
 #define SMUQ10_ROUND(x) ((SMUQ10_TO_UINT(x)) + ((SMUQ10_FRAC(x)) >= 0x200))
+#define SMU_V13_SOFT_FREQ_ROUND(x)	((x) + 1)
 
 extern const int pmfw_decoded_link_speed[5];
 extern const int pmfw_decoded_link_width[7];
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -1555,6 +1555,7 @@ int smu_v13_0_set_soft_freq_limited_rang
 		return clk_id;
 
 	if (max > 0) {
+		max = SMU_V13_SOFT_FREQ_ROUND(max);
 		if (automatic)
 			param = (uint32_t)((clk_id << 16) | 0xffff);
 		else


