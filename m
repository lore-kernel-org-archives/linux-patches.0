Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F05143759;
	Wed,  5 Feb 2025 13:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763440; cv=none; b=OHa0Ty3McbfJ0j1Pc/ZOS/Gn0MO+0v63ku7vz7RN1TdNnzzhujR42YESymEC0VxLnXxdEX0ZsjJbJ5xxMp6uF+WjDhwpakm+m2j1wzq3U7Y50tA2unB5LjwGBakFEBOPNnv7jj/r8ChBd3WcJWUwt9UQ2yUKO9EgfKkkj4vvnwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763440; c=relaxed/simple;
	bh=w7XDseKQ0FGLUEqRoVvJKHaubq1MKjFTSuviiiywCCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cxylj66w0O+RnsSP6hFxTKiYTzz/BjrPG4fxD8b/NHqy4+Szn2flhOfnW3oL31qb5J9hLg7gEEpWsU0V0MuAzO5ZL9B3NF1mw+l2SYPOgMmOpnivNk1yR9kd46DUZuHNF6WA8f1kD3kf/1ISysAkh7WuZ3K6D4RaYO5W6EWq+VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkn0ypgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkn0ypgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A5FC4CED1;
	Wed,  5 Feb 2025 13:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763439;
	bh=w7XDseKQ0FGLUEqRoVvJKHaubq1MKjFTSuviiiywCCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkn0ypgk3h7xIlqSkYD08iGKb2nHZ6ErWPVjZVxYiRwZRkqsyK8zUB3WTbwK4JpIo
	 t0OMXjPCKIFN6KYjB3U8PvegUp9KxXAbtA24grNk2/z2Uon/Smyj6V33K2XDC4PRiF
	 EUcbCMbHrC4F81Uy2NAMyiMmVnTnp3G53F8W3g+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Bokun Zhang <bokun.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/393] drm/amdgpu/vcn: reset fw_shared under SRIOV
Date: Wed,  5 Feb 2025 14:39:14 +0100
Message-ID: <20250205134421.646767480@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e80c4f5b4f402..d1141a9baa916 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -896,6 +896,8 @@ static int vcn_v4_0_3_start_sriov(struct amdgpu_device *adev)
 	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
 		vcn_inst = GET_INST(VCN, i);
 
+		vcn_v4_0_3_fw_shared_init(adev, vcn_inst);
+
 		memset(&header, 0, sizeof(struct mmsch_v4_0_3_init_header));
 		header.version = MMSCH_VERSION;
 		header.total_size = sizeof(struct mmsch_v4_0_3_init_header) >> 2;
-- 
2.39.5



