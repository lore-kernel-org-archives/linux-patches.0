Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0393A19538A;
	Thu,  5 Sep 2024 09:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530157; cv=none; b=cztsQ+kukhRbK/yKZVf4qRLbeOdYWhIlARc2LMx3RLFrbpK4xtexx59lgVppdGelQBYZ64BERwk5zibLqcxBgICuyD3i6gQTkqztEKy6XdiYYtE3/8MQ5DAKOf17BwbTUiuBanfEZSLArXCahJMBDnnT/ExchZwFkaWJIdNF7u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530157; c=relaxed/simple;
	bh=FHgMs0NQB/fY0+ndG8nlbXHrGlLqudLOjexM82iFa9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fB2TD0n3ooiHlDCnDNsDKiWJ5srUpcsFdc+Wy01W3WOowD414I2co8bNK/YmOplWSYgKtrOS1y31xz7Nv5COhwasRzeRndtDmQIsRmtsYWnE/dym/5pitT/U3dx662TaD+cRq2xHShgyUIuiS0bfTGjlmT+wop2/yzEa39K78Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUqi4i4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUqi4i4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7240DC4CEC3;
	Thu,  5 Sep 2024 09:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530156;
	bh=FHgMs0NQB/fY0+ndG8nlbXHrGlLqudLOjexM82iFa9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUqi4i4p2RH1T4kIe3ve9x1siMilDLYyA/enNtr6lUE+28bmEj7NE2po8S5V449aM
	 s/xHR7nYtGyPZYCaPDgk9By7qinXxCxFOAoNiBF1+kY7YDVh1RqjyM+nqUoUdLqueM
	 rYC3Lfj5OLskGjc933GIeYsgmF6vwNzXwvbmkuLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/132] drm/amdgpu: fix ucode out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:40:59 +0200
Message-ID: <20240905093725.057065516@linuxfoundation.org>
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
index b8280be6225d..c3d89088123d 100644
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



