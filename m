Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A2014F12C;
	Tue, 10 Sep 2024 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961042; cv=none; b=pAlLC+XUD5aucAF7bXn8dWZN8+uEEwrxwNK2UqooxUIIef5sl4aWrsn3enLHGS62hW9WRixrtnN91WLjog44euLurLiH1KinXcU5XI8vtYFtKUJW1PwuZr96SnQHCPbphEdTLUZwN1zYTmeTDY1IDIgyYlbr1w/qp3kQrkG6NpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961042; c=relaxed/simple;
	bh=3MoZljTzhp3v899DmGCaXg1M8piq9kKu6uh279LH55U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9rHBT4T+disXTgwNjwbJMrrp5401vgZQprrSzuGjL4SwRstflsT2nSPQA9FbtWwRtIK3kiWFOxyChLrU3azdrt3jsxJ8jouwLEYWMlvEOnu8n3wvmry6eMLCQXsKcBWRskD13RDPamEtPuzOC2DaCuI5Gk8PNhXb3bWiQVAZfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEBimrJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEBimrJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136C7C4CEC3;
	Tue, 10 Sep 2024 09:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961042;
	bh=3MoZljTzhp3v899DmGCaXg1M8piq9kKu6uh279LH55U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEBimrJ0+DkzwF3/0Hsckirskw+1t+KqRTjio3p/4HBaF/VXcrKIRnrCc6RZKGMfN
	 XnySBHhVvsrkauZR8GBnpdViDNPK3cDZDqe6nvTNIJiRe6Ep2gXKl9KKlCNUI0z70o
	 jkbBzy3eRZB1JpxXVLy9yD2mFCJ9RY26zBr9fuKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/96] drm/amdgpu: fix ucode out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:31:08 +0200
Message-ID: <20240910092541.669544632@linuxfoundation.org>
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

[ Upstream commit 8944acd0f9db33e17f387fdc75d33bb473d7936f ]

Clear warning that read ucode[] may out-of-bounds.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
index 387f1cf1dc20..9e768ff392fe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
@@ -212,6 +212,9 @@ static int amdgpu_cgs_get_firmware_info(struct cgs_device *cgs_device,
 		struct amdgpu_firmware_info *ucode;
 
 		id = fw_type_convert(cgs_device, type);
+		if (id >= AMDGPU_UCODE_ID_MAXIMUM)
+			return -EINVAL;
+
 		ucode = &adev->firmware.ucode[id];
 		if (ucode->fw == NULL)
 			return -EINVAL;
-- 
2.43.0



