Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4171C5783;
	Tue, 27 Aug 2024 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771587; cv=none; b=bJ5MO3UM5158Fs4BbbcmYstlsXJ5C9R4w3fxHkjUyChdOmqMdydkJfQ3iqLNw/o/moiLNpq+4p8cf34Kl+OhFYWLIbMexEhFCpQsXYL4ud09V3o+9HhODoBukXiinWbbiL8ONdW4wnpOoMzv9R8NZP2J9ruLcJfCpVB//fhk1x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771587; c=relaxed/simple;
	bh=kTa6RtsRCvsL5n73kTXjqHln/YauyRnpgfKXq/mS+EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcWAMjEUEx9Gps/D93pUq3eXOH1eewuONvZo5epL2NpuORAZup0fhrbfIasIN4nacByP8Rd386idQsf2bmzy5tUvHiBtp8Vh06kxJZCgaPzqE6Gz/mf69zPHVRgitpeK//6vo1OTzyLQYGzqgz8Qrv92IChJljU8n1RrXZM7MlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2IJ/XVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2IJ/XVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D526C61043;
	Tue, 27 Aug 2024 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771587;
	bh=kTa6RtsRCvsL5n73kTXjqHln/YauyRnpgfKXq/mS+EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2IJ/XVAcpV2NP+UPiN/DxCwS+CHOqvHtMQKGi+JuiXs9dAdELQQ7YtrJNZqmCR1p
	 Mv0hdHGMizWIMFoNmis8f/CXaC5EcmRmfHhynoVIBsKsYMZfPss8hxZYeUkj5K4pUO
	 mAwSsXkgyPuBB46zsRINhqM2DLm1Zja1RiYnSwSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 6.10 202/273] drm/msm: fix the highest_bank_bit for sc7180
Date: Tue, 27 Aug 2024 16:38:46 +0200
Message-ID: <20240827143841.096885368@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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
index fab6ad4e5107c..ec75274178028 100644
--- a/drivers/gpu/drm/msm/msm_mdss.c
+++ b/drivers/gpu/drm/msm/msm_mdss.c
@@ -577,7 +577,7 @@ static const struct msm_mdss_data sc7180_data = {
 	.ubwc_enc_version = UBWC_2_0,
 	.ubwc_dec_version = UBWC_2_0,
 	.ubwc_static = 0x1e,
-	.highest_bank_bit = 0x3,
+	.highest_bank_bit = 0x1,
 	.reg_bus_bw = 76800,
 };
 
-- 
2.43.0



