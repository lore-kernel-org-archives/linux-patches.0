Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E9E4FC338;
	Tue, 13 Oct 2026 12:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895494; cv=none; b=ssVtvJ1l1wcQWQ30qQlOFs4ILJsn9cHNUfbO6BjKL2X1uvqW678YNgJQBcLHJTOKSUG9wzvYhNG5jOer9Bh2VxAIldZYd/fV9jnvJl8nwM2H0PkcGzCsxVjxXcxP+1cRZAgsGC5gO2WRxS8k7oPASMD5VsuNhSVp7FrC9psxbOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895494; c=relaxed/simple;
	bh=gYcFDatz7NPgxKv39jniw8iLJ6bsploPHhHoDeGz1/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqFdbx8cYS2JpvYRR2yj+Nz2DduiH0nnu70b59TB+ArgVIhdAV64easJVH+FXVoysn/stuPG6IF4sifprpyf9pGcIZgcCgno7MYZRKDgRruX9cZSdp7xNttFO2ZU6ywVFIaWWMexe6rQp51TDmB1T2A3NKTvCudKFluszHIWyWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzJVjH81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzJVjH81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3FF1F00898;
	Tue, 13 Oct 2026 12:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895493;
	bh=P7pifXPXJJisBdsdrvb/wh2UdlO2Xd5cEDDMy0AUDTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzJVjH81h0xgVONjxEo0MiEQjEApPxxU6G8zLi+LGUHt154TdlJGJAij0GqR+Uxop
	 9YFfWWf5UYTXK1YxCa3DDLrDpeUZMXaZ2zznTcCxMZD1h75BBNWcx2iEVzxeyOHgIr
	 oytuQB7mHHTMdWKJawfAZ5AsItUEPj8OyrpMWz7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Morlock <me@freddy.us>,
	Andre Eikmeyer <dev@deq.rocks>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/497] drm/amdgpu: reset VI ASIC on MacBookPro15,1
Date: Tue, 13 Oct 2026 13:37:40 +0200
Message-ID: <20261013112914.851256567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/gpu/drm/amd/amdgpu/vi.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 80d06a7c1db7e..012edca8517ae 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1408,10 +1408,30 @@ static uint64_t vi_get_pcie_replay_count(struct amdgpu_device *adev)
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
 
-- 
2.53.0



