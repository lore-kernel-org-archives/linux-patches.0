Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D2214B942;
	Wed,  5 Feb 2025 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763766; cv=none; b=rA91RDLQcFn5lJ/2Oe2Enm8sICA5+KLCveUXlLHfBLhBwOTEcVqGsjWIb7ZwC4my4Vfzch/JzB9cUTxseGGAH7Jg0l0pSU4y7TBqqfzEECCNzbzDORzLU7vrUxXelh5ftszBMsVgCKtciyfnRfrVuNuIgR5k2WxYtqRT9e3N4SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763766; c=relaxed/simple;
	bh=2rI7zRWBdbR3CU2tJ3+JkAUQLGQOOx51B05gG/FrZN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xg1B3u2iV/WPs6TgdYcKetIXniBuU1c2nEIKBB/MBDYSwGKsuBJWC7K/1jFeY8q4SMYDqGMKQW2UDtZ61EjXt7QvSqPqXd00TeXCOuehWoNCi6BnlK7JA8EMirpD8HR/a6ZJrVd3mtTHGuj4ELAcQeAqhv525TQIkfZT4IXmwXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udr4i0xP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udr4i0xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B674FC4CED6;
	Wed,  5 Feb 2025 13:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763766;
	bh=2rI7zRWBdbR3CU2tJ3+JkAUQLGQOOx51B05gG/FrZN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udr4i0xPGdzEewTOsBRAZD5ryYcFccXbUwCtbf8t/i4q87BpVtGIbWgotoy5NflCd
	 bq047d7ApyW8HPZJvf3FwxufAnsHoIM8YUBw6pPSBw0t45AUgeke17fiQWx+0p6Qr5
	 lywXf77e04PyxPrKhwKDoXgnYjWAMShVACGzvKjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Bokun Zhang <bokun.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/590] drm/amdgpu/vcn: reset fw_shared under SRIOV
Date: Wed,  5 Feb 2025 14:36:50 +0100
Message-ID: <20250205134457.363052008@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bokun Zhang <bokun.zhang@amd.com>

[ Upstream commit 3676f37a88432132bcff55a17dc48911239b6d98 ]

- The previous patch only considered the case for baremetal
  and is not applicable for SRIOV code path. We also need to
  init fw_share for SRIOV VF

Fixes: 928cd772e18f ("drm/amdgpu/vcn: reset fw_shared when VCPU buffers corrupted on vcn v4.0.3")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Bokun Zhang <bokun.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index 6fca2915ea8fd..84c6b0f5c4c0b 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -943,6 +943,8 @@ static int vcn_v4_0_3_start_sriov(struct amdgpu_device *adev)
 	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
 		vcn_inst = GET_INST(VCN, i);
 
+		vcn_v4_0_3_fw_shared_init(adev, vcn_inst);
+
 		memset(&header, 0, sizeof(struct mmsch_v4_0_3_init_header));
 		header.version = MMSCH_VERSION;
 		header.total_size = sizeof(struct mmsch_v4_0_3_init_header) >> 2;
-- 
2.39.5



