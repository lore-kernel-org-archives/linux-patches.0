Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437F8190676;
	Tue, 10 Sep 2024 10:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964768; cv=none; b=a4NeG8/WppXB1BA6vDlklxUMQ9zvBpizKhWaUhDNAiCiuQ/FdueJpM4xIl+4aNbJ2cqq63vbjBRATh6nrf++nUvynC0Yd5L5urwXO7AxZ+2/5T+zZs6exiDKe5LpwX5l/MaHDBy7bGDyZvLoh0Z6pRcMrCqKjDF02cqxu7kcyPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964768; c=relaxed/simple;
	bh=PI9Tp2IBAG0PPDErlX0JYOep7t8/TsSShR7O/2lNkIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFRRyMaoaCEBFz6+hSnoy0x/YU+1WzYdpTMITZlLX0hipMzusgdyDa3uULcmKV8tyov42KKcw+3VI5YlpSbVRucOvK6Dy6PYnV/6x1gZecSixz9EpVZFeZ3+8koJRaqdGK0fgzFI1TZUVEmqRbuLXXKHqv35o61a0nPrf3eNBbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbgeD30m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbgeD30m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FF2C4CEC6;
	Tue, 10 Sep 2024 10:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964768;
	bh=PI9Tp2IBAG0PPDErlX0JYOep7t8/TsSShR7O/2lNkIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbgeD30muVDjdxswYiPWURh1YS921fY9ZW7eODoIMizxoFNIPGvmucMwVkZpKkUX2
	 oPXKam2yLZFsc5ENOSahE+pji+EYEwuXOiA9ACkFviNDVdTe93WoP8NNL83blteQom
	 obMzMDXuLNw9dK2hHP68buaY23QMatmse8J3ADCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/186] drm/amdgpu: fix ucode out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:31:59 +0200
Message-ID: <20240910092555.611086972@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 78ac6dbe70d8..854b21860257 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c
@@ -213,6 +213,9 @@ static int amdgpu_cgs_get_firmware_info(struct cgs_device *cgs_device,
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



