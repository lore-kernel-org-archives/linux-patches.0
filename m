Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5C2194A5B;
	Thu,  5 Sep 2024 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530160; cv=none; b=PoiRNwNpgkNThdI7o/8t8ppjnIMXZa9Le5RYzlpyDK8HgJvI37aTl8NC/2md9GVPGUXqLd16TsTydEHY7NHEW3ZlyWQ/sV8mn3knRiD8qTOCzkW15ZxtMKJe+CuAekq5ve829UkAddMjR8ZGg8Brz1cQWrItb4PYXo+jN3UVfao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530160; c=relaxed/simple;
	bh=pVrxgxMGjPhNXuAtiM2kegyWp/XYQVY8cudm2jIrgXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgD34Ijz94B+V7Hn+aIIjES4dqv6SdmWR5wXOkzLccHrHc9N5lGTtYdyX4vBMnEcRa+orcH+FJ+0ZajQmItKhYdrqD8ORTq6VWKzQCd0T9wcxTAbugxoD72CfUVXht5aBw5gpSbX4g8CTsqozR6CoCjEAyor4Yg/NxbuVKc+rpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hL/KSwvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hL/KSwvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D607EC4CEC3;
	Thu,  5 Sep 2024 09:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530160;
	bh=pVrxgxMGjPhNXuAtiM2kegyWp/XYQVY8cudm2jIrgXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hL/KSwvNrgYykPP7rIXDp8gb70tEY7jUzj1ZaAvI5MGzigTKCapZT3ECKU9OkV3JF
	 1ijhjYgqfpSYQNErEHYJXo+Pp8VWUflxx2RPlWdeuDKu4QN2AeRWIYdBoFfcUOIsTL
	 5hqUzh8dTibn2Spd1wUvka2OAcYr4smWfSxtC0FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/132] drm/amdgpu: fix mc_data out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:41:00 +0200
Message-ID: <20240905093725.094532921@linuxfoundation.org>
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
index dce9e7d5e4ec..a14a54a734c1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1476,6 +1476,8 @@ int amdgpu_atombios_init_mc_reg_table(struct amdgpu_device *adev,
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



