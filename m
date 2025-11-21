Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6D933CE84;
	Fri, 21 Nov 2025 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730890; cv=none; b=cspry4EPZ4Rq1DAS9cIIH6ILDeeKCT+smEHhoruh8jUoaNxOx4/TqEKcr/nND5tBMplIigMoY6UCVkiz+qOQl0FhNEpQWk7XhdoaVwVBgcSx+cqbjFx/i+vjlSxSgtkOkESbeuEHNwfWEfQcN4x+/VTcdlKD69512vmeh2OAVX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730890; c=relaxed/simple;
	bh=6rSpLJ5HEaNMTFLa5YcUvuLwpDLKsjUGeFqkxAxX4CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQSt2RMqZjiy5DruAXnRd5mAUGmMPYC6mLjhtJqpA2m5C9zsIqUjy4/LDq/bVEFnFg+1HzEQqRMSr1TzKPPehtNvHij6sest7htUIKFL1UwtAXCGARswipVrvo2FkSK2F88hoiGkjeoQ3wWfPHoTCTabfd8BzF4j/bTv9mseE48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dm3iUhFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dm3iUhFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ADEC4CEF1;
	Fri, 21 Nov 2025 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730889;
	bh=6rSpLJ5HEaNMTFLa5YcUvuLwpDLKsjUGeFqkxAxX4CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dm3iUhFUYpqAVtDN6wQbyEOX95onD0c0/AIlACKihVYQ5ieqzhufjL8QEOYj3OdNL
	 21ZfAy9pPzE/Q0deLezmI0eljjYbtVMk3a49GIu7HSyIqU94IiZGguBlXWv5FfuYLs
	 GfHILBSJqKeHwr/OSrBH1dcwIUDARqGAHPx/T1X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 018/247] drm/amd: Disable ASPM on SI
Date: Fri, 21 Nov 2025 14:09:25 +0100
Message-ID: <20251121130155.255146464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 7bdd91abf0cb3ea78160e2e78fb58b12f6a38d55 ]

Enabling ASPM causes randoms hangs on Tahiti and Oland on Zen4.
It's unclear if this is a platform-specific or GPU-specific issue.
Disable ASPM on SI for the time being.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ddd0e7ab82be7..fdaf482c0c8a7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1880,6 +1880,13 @@ static bool amdgpu_device_pcie_dynamic_switching_supported(struct amdgpu_device
 
 static bool amdgpu_device_aspm_support_quirk(struct amdgpu_device *adev)
 {
+	/* Enabling ASPM causes randoms hangs on Tahiti and Oland on Zen4.
+	 * It's unclear if this is a platform-specific or GPU-specific issue.
+	 * Disable ASPM on SI for the time being.
+	 */
+	if (adev->family == AMDGPU_FAMILY_SI)
+		return true;
+
 #if IS_ENABLED(CONFIG_X86)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 
-- 
2.51.0



