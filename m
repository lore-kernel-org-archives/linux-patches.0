Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E748119CD1F;
	Thu,  6 Jun 2024 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683078; cv=none; b=mIhtE48GCXq4KHpSklHNmLXn1chyUSxXUiNlbino8vzSoEFHwIfEspwZeWmCI76gVPWp0qiU8PUTTTtcivp+JA+3h9Bc1J1VJzhqpI8oXpS3K2eHwdAevQVPrMVWx8VcyASj29/d429upFMPkFdJ3+Z32tz13pjCChyJGpoea1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683078; c=relaxed/simple;
	bh=JuULKSaMVKvRL7boeLYje8iQ4XWhUITij80ZT83B9is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mel+tIKPZ0ENmw0wIfwJLLeV9oPUqV8ptxXZtrwFJYspNutfdjGohGQLeqdz/L0JfcLqPaqmvn4zllYNzuP2o3MegLepO+F6UdJBVc63BEKkHHdd3yZZWqZFzzFYCV4RBgK5aiMubPxrtr1WZsB8wCREh6VH1UDeJ7eko7BD0oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZUwD2Z8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZUwD2Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84D7C32786;
	Thu,  6 Jun 2024 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683077;
	bh=JuULKSaMVKvRL7boeLYje8iQ4XWhUITij80ZT83B9is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZUwD2Z84yuTxos0EIm6Gvm0NfKnxAD2hR3UbwrJdXMNaaonku3GLrIRcxP7yZAyQ
	 7dZY3n4/03V8NJIv7UHHV9cDYHjTnEOv3MFJU98BHoaHcaWp+TadGxXoYf8mfO2fvH
	 CRIwTPepIJ3B3oODrVAEgXxasgmog3bsd/MYm9ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 345/374] drm/amdgpu: Adjust logic in amdgpu_device_partner_bandwidth()
Date: Thu,  6 Jun 2024 16:05:24 +0200
Message-ID: <20240606131703.419123480@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ba46b3bda296c4f82b061ac40b90f49d2a00a380 ]

Use current speed/width on devices which don't support
dynamic PCIe switching.

Fixes: 466a7d115326 ("drm/amd: Use the first non-dGPU PCI device for BW limits")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3289
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 7753a2e64d411..941d6e379b8a6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5809,13 +5809,18 @@ static void amdgpu_device_partner_bandwidth(struct amdgpu_device *adev,
 	*speed = PCI_SPEED_UNKNOWN;
 	*width = PCIE_LNK_WIDTH_UNKNOWN;
 
-	while ((parent = pci_upstream_bridge(parent))) {
-		/* skip upstream/downstream switches internal to dGPU*/
-		if (parent->vendor == PCI_VENDOR_ID_ATI)
-			continue;
-		*speed = pcie_get_speed_cap(parent);
-		*width = pcie_get_width_cap(parent);
-		break;
+	if (amdgpu_device_pcie_dynamic_switching_supported(adev)) {
+		while ((parent = pci_upstream_bridge(parent))) {
+			/* skip upstream/downstream switches internal to dGPU*/
+			if (parent->vendor == PCI_VENDOR_ID_ATI)
+				continue;
+			*speed = pcie_get_speed_cap(parent);
+			*width = pcie_get_width_cap(parent);
+			break;
+		}
+	} else {
+		/* use the current speeds rather than max if switching is not supported */
+		pcie_bandwidth_available(adev->pdev, NULL, speed, width);
 	}
 }
 
-- 
2.43.0



