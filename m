Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24280355F30;
	Wed,  8 Apr 2026 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674170; cv=none; b=N1+8tdD1PyLEgQ1jEM6J2eRWTCGZvyRIV8S0+EhYNxcz29WoM8K86EvWBxZ4f9hIa1HRq97LZMVpcAYYXWhN0OxFL81DBKE6k7nRvAuRHrM62crDrpJxorzZG+htzh+CBs1WNXC/ejARtyTgVVxKeIeS1BxhNXAi576ZJaLrw18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674170; c=relaxed/simple;
	bh=YzfXmmprFyZkNxb46lGbXwrvljm7HpwJi6W9k38C9os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uze22DQ+TjlkYTl0+Squ6auvcV7ZZIcsBqH0kx5WXp8Ot86FE+dLuisSNofx4b6ZxeOt9tdAcqBGEeaf3IF6mLQ1rf5wGq5FebJHc82od7onhQOA/IKXnczt+tMMyHtLCnT0f4DQVEizoyBvvY/+FZSTXnqe+GVx8Pjeqhfyjao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qY6LYIDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qY6LYIDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF97C19421;
	Wed,  8 Apr 2026 18:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674170;
	bh=YzfXmmprFyZkNxb46lGbXwrvljm7HpwJi6W9k38C9os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qY6LYIDa7BQZQYb1Uzz4q+XHH/5b+/l9vSxJHPDTr1T3/JoLUb7t/+PE7MkoVQt1D
	 2Pl6zeiGm6zI+MdFOIoB0li5S1pvPWx8kXfNKENN0Q3RXoytAu4pTzPJG/inuh7w3o
	 IcJ3MjUpiD7uKTAEoDPUSSP/jOFWB1oMCp2EHdvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rosen Penev <rosenp@gmail.com>
Subject: [PATCH 6.12 235/242] drm/amd: Disable ASPM on SI
Date: Wed,  8 Apr 2026 20:04:35 +0200
Message-ID: <20260408175935.898813542@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 7bdd91abf0cb3ea78160e2e78fb58b12f6a38d55 ]

Enabling ASPM causes randoms hangs on Tahiti and Oland on Zen4.
It's unclear if this is a platform-specific or GPU-specific issue.
Disable ASPM on SI for the time being.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1761,6 +1761,13 @@ static bool amdgpu_device_pcie_dynamic_s
 
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
 


