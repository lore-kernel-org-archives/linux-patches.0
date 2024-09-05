Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0524C1494DB;
	Thu,  5 Sep 2024 10:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530674; cv=none; b=R1oq+cZa9ous1D7CgeNGDBx7zQyCcxBPTnKE5fJ1wtyfrJ5i3euf7pXziuGm0eC+jZvfC8Hj01FPJjpZnkFl3mpk3c4epbuPeutYGID/ezZGmjCZrUR9SvmiZqz04sWusA+6k042h6QxWGGwNea0UrE1bo4gYDsAl/rjE0lFAzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530674; c=relaxed/simple;
	bh=BPbZTcVyukJgY25b+TjhwTcrJ18ebXrK9h6kG2f6ab8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjEoXVg8WVUQuTxHrRtP6HyCxK3Lpq+CHEqjc+ymaiQJLap2l/FD6iMIs0yjNYnQIfKS5/xfNRHPvuZ+A7+qfZVO0DDk8xR9FWoFwMxY8xLflq6+kO2GABTLCcVl0IrHc14gM4FMRkIIoyu8MCOxu7DPfEb4GHFmMCJraGiU01M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W99nNh6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W99nNh6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0F1C4CEC3;
	Thu,  5 Sep 2024 10:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530673;
	bh=BPbZTcVyukJgY25b+TjhwTcrJ18ebXrK9h6kG2f6ab8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W99nNh6g1PXP/ov5ExNTttXhT9rTr62/C7BIP4CLGujqhhlmiHPKJNzdRJ2kAL/M5
	 YceC6Qt5SaGsSLK9i0N4sEKmQEKZI81N/UOUmPQz6ts46kyM9JLFwh3eOIDs9bBipS
	 PcVhvWbXOi6abq9REVZ4htKRiBSQloXnW+1YYtEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/101] drm/amdgpu: fix mc_data out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:41:28 +0200
Message-ID: <20240905093718.328853286@linuxfoundation.org>
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
index 9ba4817a9148..816014ea5381 100644
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



