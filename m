Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565611C2DB1;
	Tue, 27 Aug 2024 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770749; cv=none; b=INLypyAEHGEmYRaL9o34GDZE4r55JYVxJGT5cNtJH++y3Y7ZNI3SZAT2Orpzv44dPBTw/DTQc7ZEqp6R5BhYzkZKABuws/aC+yCC3lX/Nfs5VFQqP6TtXX/o604CfkocY9dKX6mo6cEhvja+MsKaZSHOPp4RIntUjK5/u9BYbi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770749; c=relaxed/simple;
	bh=7x5e7ouBBb82insgZn1ZGbYCvYg8HEm9w/RZMzCvmXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOIecnOn+XMVgbQoV3pXzOVAWGxiAmoykdVWezhQnfGPILGd/KYW9iglwhONBf/BbQODx/Pygnbc7YsdxLcb1I8i7uryLMylsM0tZ6zQNLtPZKRBa2n7DS7WEizmJ44Q1gT54MR3pHsqkyk5UiVknytDJahmjdEvMwnABUIiQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNWemmXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNWemmXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A28C4AF1A;
	Tue, 27 Aug 2024 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770749;
	bh=7x5e7ouBBb82insgZn1ZGbYCvYg8HEm9w/RZMzCvmXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNWemmXXA9v1aPvrzaNcbqc7GKMqOW99BOrCtlhWJ9UB5VwUHlnpb4YWMUKB8jfEM
	 Gei1DZYiXEw0FoMdyWDRD2bjWC0fUX2jRJkNAz8qNsIOmg5Gr0qe24nQJfMDyQY93C
	 lH2RzTMHvkKK1EHVsnfBs1T3onALX4URiHtEnlwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 6.6 291/341] drm/msm: fix the highest_bank_bit for sc7180
Date: Tue, 27 Aug 2024 16:38:42 +0200
Message-ID: <20240827143854.467790946@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 3e30296b374af33cb4c12ff93df0b1e5b2d0f80b ]

sc7180 programs the ubwc settings as 0x1e as that would mean a
highest bank bit of 14 which matches what the GPU sets as well.

However, the highest_bank_bit field of the msm_mdss_data which is
being used to program the SSPP's fetch configuration is programmed
to a highest bank bit of 16 as 0x3 translates to 16 and not 14.

Fix the highest bank bit field used for the SSPP to match the mdss
and gpu settings.

Fixes: 6f410b246209 ("drm/msm/mdss: populate missing data")
Reviewed-by: Rob Clark <robdclark@gmail.com>
Tested-by: Stephen Boyd <swboyd@chromium.org> # Trogdor.Lazor
Patchwork: https://patchwork.freedesktop.org/patch/607625/
Link: https://lore.kernel.org/r/20240808235227.2701479-1-quic_abhinavk@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_mdss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_mdss.c b/drivers/gpu/drm/msm/msm_mdss.c
index 222b72dc52269..69d10acd8ca74 100644
--- a/drivers/gpu/drm/msm/msm_mdss.c
+++ b/drivers/gpu/drm/msm/msm_mdss.c
@@ -531,7 +531,7 @@ static const struct msm_mdss_data sc7180_data = {
 	.ubwc_enc_version = UBWC_2_0,
 	.ubwc_dec_version = UBWC_2_0,
 	.ubwc_static = 0x1e,
-	.highest_bank_bit = 0x3,
+	.highest_bank_bit = 0x1,
 	.reg_bus_bw = 76800,
 };
 
-- 
2.43.0



