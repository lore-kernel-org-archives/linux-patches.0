Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D35E20125F;
	Mon, 23 Mar 2026 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273834; cv=none; b=VGe+94B19XgPyWCzhEo8XrW+AS13bUYbREP/fyJ2Dp1P8q9NSpzr0Lmn+XWoY+MhAL7FBQ6EsDkmZvIQP0rc/+roQwzY57MzPksBUDVSXQLKLdnVtMPOyR0pS+nZT6jFAhdayJWC/p9lPauQbzHP277DC579absfUtScV3qLbsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273834; c=relaxed/simple;
	bh=5t4M1XlwLUSorJna0EilYbU/ionyLIzSJxruZ7Lxv7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRsmsr9+BNWQDvdp8cKzVBbYeAOMeKwMJnuStg8Ogzx7sa42HBY4Wi6+qYc4RwQ4g4s7MBGM91KemmCxQTV0LDu+sEZgcFFa3pZJjA/xtPu25Kv1ZahdBKSBsoTBdSqLL2tQDhJnM7GHgMdzjuy8pXyw9YHlN+51wHCx3ryWfew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VR1jSAYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VR1jSAYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61328C4CEF7;
	Mon, 23 Mar 2026 13:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273833;
	bh=5t4M1XlwLUSorJna0EilYbU/ionyLIzSJxruZ7Lxv7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VR1jSAYPaER+5KbRELbK7+ratmmM18mtCvQmuZfbg8fEyeQvsyEK5ThFVeYXF0myY
	 5R9KC4AKt4c2t18UgCQnOHKOb7AQwYMlwaoFbiiiXke54n/bYD3SauCXkDVmUbumYH
	 VpBXASb3dUz4z+NfYbJU7tsIDxH2vHK7rGUIo8xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cal Peake <cp@absolutedigital.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.19 023/220] drm/amd: Fix hang on amdgpu unload by using pci_dev_is_disconnected()
Date: Mon, 23 Mar 2026 14:43:20 +0100
Message-ID: <20260323134505.316223428@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit f7afda7fcd169a9168695247d07ad94cf7b9798f upstream.

The commit 6a23e7b4332c ("drm/amd: Clean up kfd node on surprise
disconnect") introduced early KFD cleanup when drm_dev_is_unplugged()
returns true. However, this causes hangs during normal module unload
(rmmod amdgpu).

The issue occurs because drm_dev_unplug() is called in amdgpu_pci_remove()
for all removal scenarios, not just surprise disconnects. This was done
intentionally in commit 39934d3ed572 ("Revert "drm/amdgpu: TA unload
messages are not actually sent to psp when amdgpu is uninstalled"") to
fix IGT PCI software unplug test failures. As a result,
drm_dev_is_unplugged() returns true even during normal module unload,
triggering the early KFD cleanup inappropriately.

The correct check should distinguish between:
- Actual surprise disconnect (eGPU unplugged): pci_dev_is_disconnected()
  returns true
- Normal module unload (rmmod): pci_dev_is_disconnected() returns false

Replace drm_dev_is_unplugged() with pci_dev_is_disconnected() to ensure
the early cleanup only happens during true hardware disconnect events.

Cc: stable@vger.kernel.org
Reported-by: Cal Peake <cp@absolutedigital.net>
Closes: https://lore.kernel.org/all/b0c22deb-c0fa-3343-33cf-fd9a77d7db99@absolutedigital.net/
Fixes: 6a23e7b4332c ("drm/amd: Clean up kfd node on surprise disconnect")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5081,7 +5081,7 @@ void amdgpu_device_fini_hw(struct amdgpu
 	 * before ip_fini_early to prevent kfd locking refcount issues by calling
 	 * amdgpu_amdkfd_suspend()
 	 */
-	if (drm_dev_is_unplugged(adev_to_drm(adev)))
+	if (pci_dev_is_disconnected(adev->pdev))
 		amdgpu_amdkfd_device_fini_sw(adev);
 
 	amdgpu_device_ip_fini_early(adev);
@@ -5093,7 +5093,7 @@ void amdgpu_device_fini_hw(struct amdgpu
 
 	amdgpu_gart_dummy_page_fini(adev);
 
-	if (drm_dev_is_unplugged(adev_to_drm(adev)))
+	if (pci_dev_is_disconnected(adev->pdev))
 		amdgpu_device_unmap_mmio(adev);
 
 }


