Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AC3156F4C;
	Mon, 16 Sep 2024 12:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488210; cv=none; b=HSXv4SDQ3gSQJBw/4n46afwVnrt7YTs7PIt9Ua5QaItXx8e1xlkKt7dF9QtUNFDVxBqZSihSaua7zPfUxrNsaI9DMmmrUuCmKJAlB7/Uivo3rLNY/t4q7hrMHAjXc9L63ZNOKRbopvwd6irBgCdfeMYCYJegbzudx1phbDQfwRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488210; c=relaxed/simple;
	bh=i0o1/9JEA9Sm81MGBsrzH6xRdp0nOfxW61lhFJeGum4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC9Ujj9Vt8uLi1MTbPxEqP8+37iYWtpB3yR5h7UlVSf2Q4fPv58rzOL2zZXFOU5W15+fDp22yGm7+7oPH3PKlEgkUxvTJuCOpWDhAjaB4n9skgDCXvSU3bZcQ99TxWoMbTqe6MNpbYuaduDlsbK1j5QQYGHURtT/whIyXFHKv48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIl0H4o5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIl0H4o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0F5C4CECC;
	Mon, 16 Sep 2024 12:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488210;
	bh=i0o1/9JEA9Sm81MGBsrzH6xRdp0nOfxW61lhFJeGum4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIl0H4o5F97kTsqa0xK1UDnT3OB5v+PINKvB6HjjltwzTeSphyDCglebnGNeikkEb
	 nsVhZOq5rjzommGxt4GG9hh7poipUXKRhaIBm2fMuuRkHJ5+HNgdOzbWC+6nDSBCfe
	 Aru1Hxzxg89VUC52v4inCMeYLLnAGHEpxY2g09cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 033/121] drm/msm/adreno: Fix error return if missing firmware-name
Date: Mon, 16 Sep 2024 13:43:27 +0200
Message-ID: <20240916114230.126164778@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 624ab9cde26a9f150b4fd268b0f3dae3184dc40c ]

-ENODEV is used to signify that there is no zap shader for the platform,
and the CPU can directly take the GPU out of secure mode.  We want to
use this return code when there is no zap-shader node.  But not when
there is, but without a firmware-name property.  This case we want to
treat as-if the needed fw is not found.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/604564/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 074fb498706f..b93ed15f04a3 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -99,7 +99,7 @@ static int zap_shader_load_mdt(struct msm_gpu *gpu, const char *fwname,
 		 * was a bad idea, and is only provided for backwards
 		 * compatibility for older targets.
 		 */
-		return -ENODEV;
+		return -ENOENT;
 	}
 
 	if (IS_ERR(fw)) {
-- 
2.43.0



