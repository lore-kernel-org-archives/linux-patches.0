Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8DA194C7A;
	Thu,  5 Sep 2024 09:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529680; cv=none; b=RQdkRb8H64uvs4ErBlc996F9kXXCvQkZycVcmNVr/fCC144vJD4awxb22e7fVkMmgCXDN7sFBd+c3tjfer+J30Edbo22XDrAhzrH3GKk+hf3tTrmGDQBEGw+bqNXU8/fO2zwC1njvG5lEoGNzcPbxIM3tvXS47YhEBbnqg4Qa8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529680; c=relaxed/simple;
	bh=uCcNo1LSfsW3oVfc7rYpo9h8sCybSP/aDtqMNbdWKYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNoTmghfotetB4dcs7B50NOdBsHhgTBRTQ5nEe0gqXaO5wq6sDSjoS8dQSCdAbDBikVW2bkEEi5hrFLFv8x3bU0IbzYPDxy/8qFW3Mxqxe8bK+AFfPHuQAAkuKTZW42319Xt5Rbv9kfleBb3doW1l9+OI7pQV/AHfIzalyc0CRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiZ16kf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiZ16kf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A62C4CEC3;
	Thu,  5 Sep 2024 09:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529679;
	bh=uCcNo1LSfsW3oVfc7rYpo9h8sCybSP/aDtqMNbdWKYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiZ16kf1b+5/oeK9FwjV17ZiPmztLK25YrrkdHnKMyy6FfoiAmb53L9XAuOgMjwmC
	 33SNXJ6KUcW3Ir65bi/I5R24oEeTuYw6t0LbPZPgQ1nASdx0Imdb+Vuj111jBIFSha
	 f04NjJvD0Umw/JqUKU+k58/vvldOTbOlRhCLr5Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 092/184] drm/amdgpu: fix ucode out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:40:05 +0200
Message-ID: <20240905093735.834270428@linuxfoundation.org>
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



