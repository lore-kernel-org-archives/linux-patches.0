Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CDD3E716B;
	Tue, 17 Mar 2026 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765876; cv=none; b=puIEZF0L9KQpcW1kO5zd7a2LlNxrq+SdS84bT6r2GfYvKc34DFNXqL168dzxzPW2ky8vLS41XTvqLXgPE5wAWHFRPrErdHJtQUwqhN9JGQyyUctZjpkhfmcPl0vt+xxuyRm40mKtcSE1kJI9W5wlLyncANoSgITTjK/2Er7OgsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765876; c=relaxed/simple;
	bh=2sHMn0eqS6E0Ox7pbL9GsVNDDAN+5gu2R5dUwWSSnnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su1HTaUZkFwAKJolEOm49Zqxh26n7XBe14DzVni1LTCCWya1rxfZ8Pj/6Udu81YUhLDAAp4QiE9t0+PmDE4RjTbPPbJzdGy9aHnjXveIZPjTJHITbrYH34MVAaUHf2YxzDf0w0QKh49DSd+8b8N8aKtDWJGkoajXGrGXvFXcdYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gji1QmpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gji1QmpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79335C4CEF7;
	Tue, 17 Mar 2026 16:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765876;
	bh=2sHMn0eqS6E0Ox7pbL9GsVNDDAN+5gu2R5dUwWSSnnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gji1QmpTWrL4mBVDhtPHP/m1wSzDc1L9X2aFdfiIt0tG060gZcnDLwvkxp2y0xv31
	 +EaqlrYuZJfvzcJFfkyqYZgA6KiBZL5I12CNnMgnFpwRlLZ4/l1m8f3AMCJivSv0mA
	 jWUeKqPWObKiE3AF+bNCovpn536feAo+Q0xAYYH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Simon Liebold <simonlie@amazon.de>
Subject: [PATCH 6.19 114/378] drm/amdgpu: ensure no_hw_access is visible before MMIO
Date: Tue, 17 Mar 2026 17:31:11 +0100
Message-ID: <20260317163011.208625545@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Perry Yuan <perry.yuan@amd.com>

commit 31b153315b8702d0249aa44d83d9fbf42c5c7a79 upstream.

Add a full memory barrier after clearing no_hw_access in
amdgpu_device_mode1_reset() so subsequent PCI state restore
access cannot observe stale state on other CPUs.

Fixes: 7edb503fe4b6 ("drm/amd/pm: Disable MMIO access during SMU Mode 1 reset")
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5878,6 +5878,9 @@ int amdgpu_device_mode1_reset(struct amd
 	/* enable mmio access after mode 1 reset completed */
 	adev->no_hw_access = false;
 
+	/* ensure no_hw_access is updated before we access hw */
+	smp_mb();
+
 	amdgpu_device_load_pci_state(adev->pdev);
 	ret = amdgpu_psp_wait_for_bootloader(adev);
 	if (ret)


