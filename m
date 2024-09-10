Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A176C18FDA9;
	Tue, 10 Sep 2024 10:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963353; cv=none; b=uPHQZG21XtyY1Y7b38FAfVvoJunwYD39gtqV84gMFTeNYCocy2Ms2b5NEcli+uilfBRxT2CmmiFhduNLF+6C8sT5TvPXymPcQR8fA4PSrRh8s7RwFuiJwvmbRVv6oJKCVqTuU7qa0ecWEHJJOHlSzWfaM3sxD3QER3FyuLL7pIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963353; c=relaxed/simple;
	bh=4VKpKzSTMcD4q2/rtkcKt+fhY5PVXhXMx8YGPIwnRJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJPB+oeQibXIQ5vIFUdEscfAH9WSE3v2h2kXuGciloMWskq0SILw70hnHMtdkfw9aM/8PiLrzlYmdC/lbgIYo9Ajst2Nq7BIcaAwsn4yGaQpseWXlZcCcUVtAieEP3b3gx2CxQwZD2RY9s+IdF9FI4MBhYzEyRqVcEIl0jYYgyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkgcgrrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkgcgrrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBC3C4CEC3;
	Tue, 10 Sep 2024 10:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963353;
	bh=4VKpKzSTMcD4q2/rtkcKt+fhY5PVXhXMx8YGPIwnRJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkgcgrrBmqn80rOzt4NRVBNwk0wNzcUv+8t4/v9j/8eX9GpyXcBqvdlAlHw+hcB/P
	 0S0hevFKaUzJVRW0jTBjmPk1bWPsclhM9EZC6onDM9WhsACVMzUHod+wssP37iGT8n
	 fjWfd/dW35qc7Jx3AldhnHs/uSE8EQpL2ehe9CwM=
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
Subject: [PATCH 5.15 008/214] drm/amd/display: Assign linear_pitch_alignment even for VM
Date: Tue, 10 Sep 2024 11:30:30 +0200
Message-ID: <20240910092559.045233106@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ef151a1bc31c..12e4beca5e84 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1107,6 +1107,7 @@ struct dc *dc_create(const struct dc_init_data *init_params)
 		return NULL;
 
 	if (init_params->dce_environment == DCE_ENV_VIRTUAL_HW) {
+		dc->caps.linear_pitch_alignment = 64;
 		if (!dc_construct_ctx(dc, init_params))
 			goto destruct_dc;
 	} else {
-- 
2.43.0



