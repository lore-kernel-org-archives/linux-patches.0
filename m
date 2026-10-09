Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333372D77F5;
	Fri,  9 Oct 2026 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557610; cv=none; b=BbouqjKeZQbZvPNyJDXTaQHD+sIQdosGtdleChmpXgHp1MoaUNAVfl/gOP99zd44Oi8Pw6dwR1717+oNqk0Swr/dwBL9FT+Ck5W7pIo6KHAWW043g11ocfoWFqsdZfjae6moY/LbWNEmJN4fSnIq6P+I/MM9EozydABziufJrhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557610; c=relaxed/simple;
	bh=53Za0YIRXdJAA/A2Jj8z3wtGqTspq2eMgwBChiVMiGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYLJu+RSKO6vczmV0UVmf2+0rWyjiI0x4jcS/pSDa4L4fnNIxhPiCW7tmOhs7yrSFId1Hm+f24cYR701X7j5fnGs8B0/vuHmaBYSpQgngZBvjMNBey1WpvtF7fnJzIADSp7S5/UPdugeYM4Q6+7WO7EVed30F1UWcVVh6Goyy9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hH3VqWWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hH3VqWWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E3B1F000FF;
	Fri,  9 Oct 2026 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557608;
	bh=/YztRbbV6wDpa8Ku7X2Rnq+0/g5ZSf37KuqDLKiXNWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hH3VqWWka4EOBsy8d1yuczJACvMP8IMcCPgKcncIoEy8txzGCgVfZYk222JgTnpmG
	 4XE3UZqKkoJWIENTVLA0MWX85A0q08wsJqV9Qi5IfHrE6YrvkCdwwvkyISrktEknmy
	 CgzO1II6RGn18qO8NRg45kNuFlLmaswNmYDfkH3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Morlock <me@freddy.us>,
	Andre Eikmeyer <dev@deq.rocks>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 419/428] drm/amdgpu: reset VI ASIC on MacBookPro15,1
Date: Fri,  9 Oct 2026 16:12:36 +0200
Message-ID: <20261009140955.441854080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Eikmeyer <dev@deq.rocks>

[ Upstream commit a5be7ad8f5f0e067613e9197638f216f46252946 ]

After S3, reloading amdgpu on MacBookPro15,1 systems with a Radeon Pro
555X or 560X fails while loading the SMU firmware. The existing SMC
register check does not request a reset because the registers do not
reliably reflect the stale SMU state on these machines.

Frederick Morlock found that forcing a VI ASIC reset allows the driver to
initialize again. This patch limits his workaround to the exact PCI
device, Apple subsystem device and revision combinations used by these
two GPUs, leaving other VI hardware unchanged.

Suggested-by: Frederick Morlock <me@freddy.us>
Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a22e5e4f2ebb ("drm/amdgpu: reset VI ASIC on MacBookPro14,3")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vi.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1407,10 +1407,30 @@ static uint64_t vi_get_pcie_replay_count
 	return (nak_r + nak_g);
 }
 
+struct vi_reset_quirk {
+	u16 device;
+	u16 subsystem_vendor;
+	u16 subsystem_device;
+	u8 revision;
+};
+
+static const struct vi_reset_quirk vi_reset_quirks[] = {
+	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x0190, 0xe3 }, /* Radeon Pro 555X */
+	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x018f, 0xc2 }, /* Radeon Pro 560X */
+};
+
 static bool vi_need_reset_on_init(struct amdgpu_device *adev)
 {
+	unsigned int i;
 	u32 clock_cntl, pc;
 
+	for (i = 0; i < ARRAY_SIZE(vi_reset_quirks); i++)
+		if (adev->pdev->device == vi_reset_quirks[i].device &&
+		    adev->pdev->subsystem_vendor == vi_reset_quirks[i].subsystem_vendor &&
+		    adev->pdev->subsystem_device == vi_reset_quirks[i].subsystem_device &&
+		    adev->pdev->revision == vi_reset_quirks[i].revision)
+			return true;
+
 	if (adev->flags & AMD_IS_APU)
 		return false;
 


