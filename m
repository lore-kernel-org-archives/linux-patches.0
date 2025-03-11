Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B8D1E98FB;
	Tue, 11 Mar 2025 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706141; cv=none; b=gvfTjEJAawh6F0xd5utmgLTX5wZ/Bvew3wTvxvhYGh2YKu+enn6z9P8+sWijBkOP5NVjYJu/vuJwUgkjdC3xlnZxNMIdVcWsU0V+IktRv6xGN2CqjYNYbkPQNjPlMXYwq3ckXwceZe8zCSwmQ7FQB7dmNjYxp1TehyVexJAdmdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706141; c=relaxed/simple;
	bh=DJ7V9WYhIEm1c8DxoQrtOCNJGZvJUKth2A6yEc2dbpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSZ3Ysdv65te1+PsAEih7ATmUrbbFKUSI5zFRZFTE6AXT0haY1MKNjS2snT/V/mL6Y941972IH2fiJAIx4V18OfSvtIaFLFeqAi1cj3hR5L43UjtOJJXIvAFttemMU4c7CUM8lQRNHQZpVygxsHYTreAGb0tComifdDcFe/GFiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PzApdFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PzApdFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B23BC4CEE9;
	Tue, 11 Mar 2025 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706140;
	bh=DJ7V9WYhIEm1c8DxoQrtOCNJGZvJUKth2A6yEc2dbpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PzApdFw48upKtJrVounqpD3ZWP+xjmpBySFMUBSMDW+zC7KKh95Ic3LxaaCYPnFZ
	 klRG3Rq/iLUgPL0xQM/I1JSZZYCKk9k77frAx9etUVvajwZBaCw377adW5vZ9BC+a9
	 cVsw3tkymeyE8DIRwbgtdw0w//PMJHunWh+nWNUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 276/328] drm/amdgpu: skip BAR resizing if the bios already did it
Date: Tue, 11 Mar 2025 16:00:46 +0100
Message-ID: <20250311145725.883983495@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit b7221f2b4655bb9a95ed6f86658713c8dd543d41 ]

No need to do it again.

Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 099bffc7cadf ("drm/amdgpu: disable BAR resize on Dell G5 SE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9dcb38bab0e10..49fcb69ca4a1b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -766,6 +766,11 @@ int amdgpu_device_resize_fb_bar(struct amdgpu_device *adev)
 	if (amdgpu_sriov_vf(adev))
 		return 0;
 
+	/* skip if the bios has already enabled large BAR */
+	if (adev->gmc.real_vram_size &&
+	    (pci_resource_len(adev->pdev, 0) >= adev->gmc.real_vram_size))
+		return 0;
+
 	/* Check if the root BUS has 64bit memory resources */
 	root = adev->pdev->bus;
 	while (root->parent)
-- 
2.39.5



