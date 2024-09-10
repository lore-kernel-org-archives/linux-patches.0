Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D834C19DF67;
	Tue, 10 Sep 2024 10:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963432; cv=none; b=Lx8Mh0YhY76bM5M9A8xBdjlrt2Q0ZQ7bNltSJjbjW+SLFXMK3pTM4gyWgEmDxVD0qX/NH83aJ6R6uZSqAouCUB9DtqY0S8aqA+GQavNMLY1O1xxJUVdCRPrx5i2jO18olHwJC+8yKgAd7R38MAGEAIenkYpWRzULGY8wCI9l31g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963432; c=relaxed/simple;
	bh=AmC2IiVJcfUF5hJ3rxpKTKTPndEgku8Yo3lQrXsz/7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHfqFMByLEJP7VAolisvQRgPi3pmFxo/qFVyajxTZUORi7HnBCfD7/uaxyDqhw8+hJfzppYSlxTrJxMQktyPDw7zMi++Y9/Gn/pBztkP+1HlZc66dekxlQ/v93t2LTnxCACzL2lnDdYMJ2sdlAsk4c38Rs37KauzTru7Ju5PXHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+Gxui4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+Gxui4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591A1C4CECD;
	Tue, 10 Sep 2024 10:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963432;
	bh=AmC2IiVJcfUF5hJ3rxpKTKTPndEgku8Yo3lQrXsz/7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+Gxui4uxtB+mdbTCyAZQ6G3fnILexflW8EbyNTynirmVg0CXcJcEH1PT8TJWoptk
	 r3z8c0HDfM8/TAhfNHbueN/r4q0X3GHOL4QBVCIRICf8Q6YBjbAysL6XPTkUtrQE/S
	 GVK1CBUbwZXrLcVOfH5ZH+KyySGHnIk+RFXzakZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/214] drm/amdgpu: fix ucode out-of-bounds read warning
Date: Tue, 10 Sep 2024 11:30:50 +0200
Message-ID: <20240910092559.929971648@linuxfoundation.org>
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
index f1a050379190..682de88cf91f 100644
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



