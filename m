Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA0E17BB01;
	Tue, 10 Sep 2024 09:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962369; cv=none; b=CcJbOGSBT442OcHgLqXhUT478+xu8FjA3JOKuAANf2lK3QNQ/uSEytlqqNqMzeTrPkEe29le+M52B4cRXJcj4bHuxXzKj2UWiBgVU+ZqV2HUZHHRoYZpZjyupv7TysAK/81h4aTMDKheQR5RD4kkMpoc3aZubzw3RP3kytXLlwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962369; c=relaxed/simple;
	bh=kWrL4D7g5XSLPaaG0q7fdZEshyHv+BaE3ysAPeqQ+P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwcUCmNrs7j+Hca7tTvQmNP8Z33f1oWl8Ffb3TNTwtusaNHiTW39s2+mfgImQR97bSlryZjAn2IdPi0tmeY1DfcNK37qknlxvAVPRHdy3xVhVY/2MhRzNUV7pq+k5MTmJ6fJOgdpGh9WDLPrdvNjfdScJjg0E/jMtKJ8C0RhSvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wi+uu9RM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wi+uu9RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F8BC4CEC3;
	Tue, 10 Sep 2024 09:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962369;
	bh=kWrL4D7g5XSLPaaG0q7fdZEshyHv+BaE3ysAPeqQ+P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wi+uu9RM1PyqRJksqAnSvqL/Zc8wp7HpeWHKCfNFPY0/GSm4/5cRkvs+1RtSF+b7n
	 VhE7nCkgocC50jKB20ZzFbqea12y9BeHFmD9EnlFTRW+kZf3nGU3WZY0W/Ps/igM/W
	 Uq5atJPrdeyTpPSnmiRDXxysFDtIdbaeiKSb9ynY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/121] drm/amdgpu: fix mc_data out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:31:26 +0200
Message-ID: <20240910092546.286891397@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 51dfc0a4d609fe700750a62f41447f01b8c9ea50 ]

Clear warning that read mc_data[i-1] may out-of-bounds.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index c687432da426..89930a38b63e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1626,6 +1626,8 @@ int amdgpu_atombios_init_mc_reg_table(struct amdgpu_device *adev,
 										(u32)le32_to_cpu(*((u32 *)reg_data + j));
 									j++;
 								} else if ((reg_table->mc_reg_address[i].pre_reg_data & LOW_NIBBLE_MASK) == DATA_EQU_PREV) {
+									if (i == 0)
+										continue;
 									reg_table->mc_reg_table_entry[num_ranges].mc_data[i] =
 										reg_table->mc_reg_table_entry[num_ranges].mc_data[i - 1];
 								}
-- 
2.43.0



