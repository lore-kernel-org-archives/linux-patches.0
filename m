Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5D4F510;
	Wed,  5 Feb 2025 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764279; cv=none; b=HivrtgTpbBSyYuTloyWR/tc5ZFqRpJGvv8W80KZAvk17KrMUl4AA1US3DP1Cd4tLf8lbPKZi6Mm5vjqDPeN8YVB9HkMHMkIUTrjT3/274n6wb8rVPSO986C+z0ydxsVJOcil0Jw1QmPsg9r/YsbLVF4hT9T+qC46BoZLBBeM0GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764279; c=relaxed/simple;
	bh=+giVa4inJzKJdiCINseYQ5C+3et3+unmC2EmsERKGnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZE4WsZnvmuWAFxnusXtAOc3IoL9zjWYOqQ5sBMt4UrEY/sXzzHjvAl/lyUhJyaByLvqDxO38YHtZ4Dx1S7F/m8UqKD9Sa2sL7VgqBpNdF1TmCnMZsVdw30eyeaF5sZZsJp4Mu33S+bftNeSrS9t0QfsP56XRvdnTLSy8qlJRQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFS3Wee7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFS3Wee7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FD1C4CED1;
	Wed,  5 Feb 2025 14:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764278;
	bh=+giVa4inJzKJdiCINseYQ5C+3et3+unmC2EmsERKGnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFS3Wee7++IAR6YdIN18UmmqXYSuWQoyA/nrbkqmhkhtsmWRFLvdoxtm1pWPp8S4T
	 s7YQnCLwUM+oGTVQy70UUaxGXTVrhgAaJBHvFaTZv1SBpEWJQ/n44J4/62C7Nto8yr
	 fOfkwxRT116aQiQj7Ev2vMUYexbuf1otZB5b4sU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Bokun Zhang <bokun.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 063/623] drm/amdgpu/vcn: reset fw_shared under SRIOV
Date: Wed,  5 Feb 2025 14:36:45 +0100
Message-ID: <20250205134458.636130422@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3f69b9b2bcd07..18cc1aefb2a2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -957,6 +957,8 @@ static int vcn_v4_0_3_start_sriov(struct amdgpu_device *adev)
 	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
 		vcn_inst = GET_INST(VCN, i);
 
+		vcn_v4_0_3_fw_shared_init(adev, vcn_inst);
+
 		memset(&header, 0, sizeof(struct mmsch_v4_0_3_init_header));
 		header.version = MMSCH_VERSION;
 		header.total_size = sizeof(struct mmsch_v4_0_3_init_header) >> 2;
-- 
2.39.5



