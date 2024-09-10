Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7A246444;
	Tue, 10 Sep 2024 09:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961045; cv=none; b=NbOM6TLIw0E6HLxblEmdBDsuS0UsJxF7b2hLSukyq9WYrNO7GuDedB7nWe86YrPRZSUXo555CIhFdO3ejaLxEpJz/lsofJPUDhDNuP5OPN0El/tKwFNX0FHjJK2iqcIt5LzuHX//gbbDypbVpGsoDnByVfreVTVXRMTQ8IVoGo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961045; c=relaxed/simple;
	bh=XqqqsLzzSdaqmUmmc2l8itT18AieNLq2hkbL32iptHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMxV2urayhZzrjzc2tlN49Vh6I8MSoxYTaNVQDiO5ZCPhmH2QidLXXvfhMSi7I0aTKDCorok+H7PzfUWLpsFZk2bHz7lVNYC5irhZQXtsZPG+tCdwBYD8JmwtSSNqkUg11+0dBl9W78hNfgbMaHrixPtBTDO+Wm1ghMU8XxvQjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzL2JkXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzL2JkXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D90C4CEC3;
	Tue, 10 Sep 2024 09:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961045;
	bh=XqqqsLzzSdaqmUmmc2l8itT18AieNLq2hkbL32iptHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzL2JkXSo4wM2PBt0R27MoLDMu/GlssaQjvTaAAncSPe6348mn4bo3m4vbaEuzJRP
	 S10CzwPf/v3Q6eu0LnJzSoFzazjfRWI+xrkWFiAfax5OCZ+eFhLxS7Of/qyqZrnW8K
	 zCFv6auw8iCnRtYTaaysNRQAK4O+0laJFCEG5lS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/96] drm/amdgpu: fix mc_data out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:31:09 +0200
Message-ID: <20240910092541.711486948@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 95f7bb22402f..fe01df99445d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1625,6 +1625,8 @@ int amdgpu_atombios_init_mc_reg_table(struct amdgpu_device *adev,
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



