Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B43C19884A;
	Thu,  5 Sep 2024 09:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529715; cv=none; b=bELX3HlKn5AXEK4oVjbivSicNV7ppEDtX96nRC0+CNodBtxOCXO6pIOwsTv8NLWw3haEZ8pWinrfqP3cXv9wCKyWJtXfZgRo0WTbSd9u2qfovpL/jVE3T8zmh01wtB773OIUY2N0QOHvAZjotmeKafUenED5hFB1b0na2ojWq0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529715; c=relaxed/simple;
	bh=z6aIbhkez88722s3WPZM5k4/X8bXBH4pv50yZvr4vPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO5XkQ5ifdHY5e5XbHAW+2pwjYH+xDzuw5kaQIqQhWYEffmh4+Uki+SXaoM0mO7wWAZZmf31XGz0jTsWY4spkG12jhu0vfnAfZKGyEJViA3nFWVL1sMTIag/8G+hM62AdI1eIirUag3RRP/GBkIkuhN+kj58O+q4WJfbcA+ZcnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpVqP7eb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpVqP7eb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20CAC4CEC3;
	Thu,  5 Sep 2024 09:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529715;
	bh=z6aIbhkez88722s3WPZM5k4/X8bXBH4pv50yZvr4vPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpVqP7ebAzDcb7TfRU3dYU13gKLV4JPQsO7OA2k7ObXLKfAiubGwOm1nAoJJhc/mH
	 BJkhFAE5lpa4cfRAd8OXnKFrafhZy3jzoCq6VeslDIsNafNsFGifjFXbmiHkph8Wt5
	 qcDmz/xU0ODF/NL6CLNappJMxjN/zYHNAo0xcVq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 093/184] drm/amdgpu: fix mc_data out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:40:06 +0200
Message-ID: <20240905093735.872299249@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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
index 52b12c1718eb..7dc102f0bc1d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1484,6 +1484,8 @@ int amdgpu_atombios_init_mc_reg_table(struct amdgpu_device *adev,
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



