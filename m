Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB66B19DF67;
	Tue, 10 Sep 2024 10:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963435; cv=none; b=kVo7aTYS1EmS5LLoN5A/kCNPdC95zwTXT2q5i8YKDkuhjaN5OiBRqScgVMgWbSTmY3VCHaEPg0k1xvQD3MPS44CyzqCDRW3xEPFdhcYlwHt7cA0dUnnTn6MVqsyqu9bpB5vjrFlYyD1tGNlmIueUmK9KTNNz0obOXxeY+M/cSO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963435; c=relaxed/simple;
	bh=Rw8NMzfkqf/b3xhjokbTwBKsjud+LNNTKVcPRfW1eM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isR1ARydujQy7PVwaipDCevF6Emcw7siPc3hul87FKD2feBiLma890LvM2xUQbHSCWX9TQuSdaMg+CSdjRt1m/JOFtAr/Nucdb5YZoh5uvwQpYWiuVoRdbVHeuwWufUc2xekydKYSbU7bOcWmMkdAjg3E6J7A/NaHqudQh+otcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1uijIkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1uijIkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E16C4CECE;
	Tue, 10 Sep 2024 10:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963435;
	bh=Rw8NMzfkqf/b3xhjokbTwBKsjud+LNNTKVcPRfW1eM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1uijIkzKiG5h8vS/nDhaWFZwgMFO4vxvvt9hSc7kX/iuDCZ87nEbFiM7NfRKKXWq
	 6VmRMN+//VfTDjlcmarYJ+o6FKHQoOfPbu9IThbaUcLnr+PUio4U6dDRWInQZ0J0b9
	 SbZVypE3hvxBMpsR2ClfNw/7+tcJS/n9PwDxarMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/214] drm/amdgpu: fix mc_data out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:30:51 +0200
Message-ID: <20240910092559.977230996@linuxfoundation.org>
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
index 96b7bb13a2dd..07b1d2460a85 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1475,6 +1475,8 @@ int amdgpu_atombios_init_mc_reg_table(struct amdgpu_device *adev,
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



