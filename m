Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3E114A08E;
	Thu,  5 Sep 2024 09:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530055; cv=none; b=GA00Xr1sbW6SgZcaQV8JP4Si8TLsmETS/G6PJd9imfIHKQjSHlvsBGAz4zpEPi1+UlaYVTTSeheGI+2DTheBwxwdbvxBp104XzZXSrNCLOqS2m70zcqP8QPc0GdQhSiJxJOvBCKH46Yh2cx5aaf/TSa1NWlwnUzSoPA2Tm3st/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530055; c=relaxed/simple;
	bh=Sc9i6+wkx5SVsO8OCIO9kDzGyJfjiPYeiVivjbXv0T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRoM1CpdvorDU2vEPQ8H5F43O0Nn8v9A2vzBXP5r5Q1Ve3gsWvTloEeNytv9ANOF48DCnoVEfBOUiQd8cdCb7Tjb5fW+8BkBXWIsssErU+5uFnr/6Sxo2ob5314LKp01MX+KUZ1Q/BcR/idSM6vnZWV+fbeFpu0zgTIhFmpNnbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKCGxvJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKCGxvJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B8BC4CEC3;
	Thu,  5 Sep 2024 09:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530055;
	bh=Sc9i6+wkx5SVsO8OCIO9kDzGyJfjiPYeiVivjbXv0T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKCGxvJ5k8UDhiFIMZ9JHsv0UL7PoiyJlPNc0BilwTivXIqL60wRC8T0o6vnwBJwY
	 CMtrVuQDt4/THKpJFO6hFL2HnuBePVu3ZDC0DPUQyIY88RNSNCcS7syOIlZT85h49S
	 Emx9lg+FNEslngOaK3AUS8VxvPIQjREwjYx15jWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohaib Nadeem <sohaib.nadeem@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/132] drm/amd/display: Assign linear_pitch_alignment even for VM
Date: Thu,  5 Sep 2024 11:40:28 +0200
Message-ID: <20240905093723.856333348@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit 984debc133efa05e62f5aa1a7a1dd8ca0ef041f4 ]

[Description]
Assign linear_pitch_alignment so we don't cause a divide by 0
error in VM environments

Reviewed-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 72db370e2f21..50e643bfdfba 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1298,6 +1298,7 @@ struct dc *dc_create(const struct dc_init_data *init_params)
 		return NULL;
 
 	if (init_params->dce_environment == DCE_ENV_VIRTUAL_HW) {
+		dc->caps.linear_pitch_alignment = 64;
 		if (!dc_construct_ctx(dc, init_params))
 			goto destruct_dc;
 	} else {
-- 
2.43.0



