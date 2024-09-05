Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A9719413B;
	Thu,  5 Sep 2024 10:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530558; cv=none; b=ZYach0A8A/iroO5K1jjH6gKev7cTnHwbG6PYxPc5kMYZmeBveF7Nt7D2RYllJ7dmrRm53zUrE4yZklS/7eu5Gn91MO779Wqr4aBWM7Rd7YDOBau8Yc5hxJPnTZSQ+sok4pDuH4ivDteVLrIRltsggcu4nXxukH1j03RIikGe59E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530558; c=relaxed/simple;
	bh=Abext7Esebq3PJhNzwCHdfmIpYXMpWTlBxNW/t9bIRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsYTX2LYLvQzpX1QoXLhauRCtV5fwtKvwMTMFCTDCnc7OCEdELL73Yunk4waLuSYqjE+NNiu7qv+rF6150EQvVA/wQpnb+QaB/PB8C8U5cpqvPww0yzV/2HfDqVnjnCxPCqXs8h+JZJ5n3dy5QjxSbBQ2PmVSNcSkEpJI6Qc9o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHVZ/xVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHVZ/xVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F45C4CEC3;
	Thu,  5 Sep 2024 10:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530557;
	bh=Abext7Esebq3PJhNzwCHdfmIpYXMpWTlBxNW/t9bIRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHVZ/xVMr3Su+rHFMywf78hIalqUpM0fwzFm8yybMFGYEt8DU1o4P8uXqNd2ZP6CW
	 e4fpnTigBswndYPcdKM46MigV2WuYuJFVrq5Nuf2J49MqDUdPfp872f63htwODuMpS
	 R7Pqa9zZ5GQnkvLbKJDcmRxGI7tet74joEHSGeM4=
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
Subject: [PATCH 6.1 030/101] drm/amd/display: Assign linear_pitch_alignment even for VM
Date: Thu,  5 Sep 2024 11:41:02 +0200
Message-ID: <20240905093717.307329574@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f415733f1a97..d7bca680805d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1265,6 +1265,7 @@ struct dc *dc_create(const struct dc_init_data *init_params)
 		return NULL;
 
 	if (init_params->dce_environment == DCE_ENV_VIRTUAL_HW) {
+		dc->caps.linear_pitch_alignment = 64;
 		if (!dc_construct_ctx(dc, init_params))
 			goto destruct_dc;
 	} else {
-- 
2.43.0



