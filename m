Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D35013AD0C;
	Thu, 11 Apr 2024 10:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830284; cv=none; b=FvzFWTBFL3b8cg/QopquC3Z63a434SezS1X2xtXzF5gwsrASI3rrpDMhNLyIeRBY0TJXbE3LIEINGgB6ovyJbU0tlGjZTLY3/dim/4+YpZ6FMegt4vM03NA/tmEfoqtlZIde8oE66x5Dg7P79sCm+p0h39EcWHNh3Od6eIIdmmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830284; c=relaxed/simple;
	bh=fe2ze4O1m0HiUfP9+lye0sMPFFyQkJZH9xVBBcylFNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3SCSuBNUw6d/isKqql79gy7PWAzUz+p1ISYU1UO0dzYn2AicY++yGuCNdpFBtDuNq/HoL4OJhFnbppcHj54P20HCpnRXvS1IzC3uexrvzGDZ2JSmzvsfINA2jozxLGVq+QRg8Nf7lUTAaEy7eW3MjskeckkMJTOQCFKTazxdT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJB1XYvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJB1XYvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C64C433C7;
	Thu, 11 Apr 2024 10:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830284;
	bh=fe2ze4O1m0HiUfP9+lye0sMPFFyQkJZH9xVBBcylFNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJB1XYvYEKT4vfd7CrQkDoXMSTb4CMXBR1a2ZcZFAggNNIWw3NKx/cQSu66sIuxgM
	 bQ3ZxuJJKDex4PEe9nkWAB9+hwpEJvYrvRcsWE+/+U5G1KeXPzcjaSRKrXQujQpB/w
	 ad9zUOtn4sRJj7ooRTkS3O5BjQbOGke6hQY7LosI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 059/143] drm/amdgpu: Skip do PCI error slot reset during RAS recovery
Date: Thu, 11 Apr 2024 11:55:27 +0200
Message-ID: <20240411095422.692924784@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley.Yang <Stanley.Yang@amd.com>

[ Upstream commit 601429cca96b4af3be44172c3b64e4228515dbe1 ]

Why:
    The PCI error slot reset maybe triggered after inject ue to UMC multi times, this
    caused system hang.
    [  557.371857] amdgpu 0000:af:00.0: amdgpu: GPU reset succeeded, trying to resume
    [  557.373718] [drm] PCIE GART of 512M enabled.
    [  557.373722] [drm] PTB located at 0x0000031FED700000
    [  557.373788] [drm] VRAM is lost due to GPU reset!
    [  557.373789] [drm] PSP is resuming...
    [  557.547012] mlx5_core 0000:55:00.0: mlx5_pci_err_detected Device state = 1 pci_status: 0. Exit, result = 3, need reset
    [  557.547067] [drm] PCI error: detected callback, state(1)!!
    [  557.547069] [drm] No support for XGMI hive yet...
    [  557.548125] mlx5_core 0000:55:00.0: mlx5_pci_slot_reset Device state = 1 pci_status: 0. Enter
    [  557.607763] mlx5_core 0000:55:00.0: wait vital counter value 0x16b5b after 1 iterations
    [  557.607777] mlx5_core 0000:55:00.0: mlx5_pci_slot_reset Device state = 1 pci_status: 1. Exit, err = 0, result = 5, recovered
    [  557.610492] [drm] PCI error: slot reset callback!!
    ...
    [  560.689382] amdgpu 0000:3f:00.0: amdgpu: GPU reset(2) succeeded!
    [  560.689546] amdgpu 0000:5a:00.0: amdgpu: GPU reset(2) succeeded!
    [  560.689562] general protection fault, probably for non-canonical address 0x5f080b54534f611f: 0000 [#1] SMP NOPTI
    [  560.701008] CPU: 16 PID: 2361 Comm: kworker/u448:9 Tainted: G           OE     5.15.0-91-generic #101-Ubuntu
    [  560.712057] Hardware name: Microsoft C278A/C278A, BIOS C2789.5.BS.1C11.AG.1 11/08/2023
    [  560.720959] Workqueue: amdgpu-reset-hive amdgpu_ras_do_recovery [amdgpu]
    [  560.728887] RIP: 0010:amdgpu_device_gpu_recover.cold+0xbf1/0xcf5 [amdgpu]
    [  560.736891] Code: ff 41 89 c6 e9 1b ff ff ff 44 0f b6 45 b0 e9 4f ff ff ff be 01 00 00 00 4c 89 e7 e8 76 c9 8b ff 44 0f b6 45 b0 e9 3c fd ff ff <48> 83 ba 18 02 00 00 00 0f 84 6a f8 ff ff 48 8d 7a 78 be 01 00 00
    [  560.757967] RSP: 0018:ffa0000032e53d80 EFLAGS: 00010202
    [  560.763848] RAX: ffa00000001dfd10 RBX: ffa0000000197090 RCX: ffa0000032e53db0
    [  560.771856] RDX: 5f080b54534f5f07 RSI: 0000000000000000 RDI: ff11000128100010
    [  560.779867] RBP: ffa0000032e53df0 R08: 0000000000000000 R09: ffffffffffe77f08
    [  560.787879] R10: 0000000000ffff0a R11: 0000000000000001 R12: 0000000000000000
    [  560.795889] R13: ffa0000032e53e00 R14: 0000000000000000 R15: 0000000000000000
    [  560.803889] FS:  0000000000000000(0000) GS:ff11007e7e800000(0000) knlGS:0000000000000000
    [  560.812973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  560.819422] CR2: 000055a04c118e68 CR3: 0000000007410005 CR4: 0000000000771ee0
    [  560.827433] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [  560.835433] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
    [  560.843444] PKRU: 55555554
    [  560.846480] Call Trace:
    [  560.849225]  <TASK>
    [  560.851580]  ? show_trace_log_lvl+0x1d6/0x2ea
    [  560.856488]  ? show_trace_log_lvl+0x1d6/0x2ea
    [  560.861379]  ? amdgpu_ras_do_recovery+0x1b2/0x210 [amdgpu]
    [  560.867778]  ? show_regs.part.0+0x23/0x29
    [  560.872293]  ? __die_body.cold+0x8/0xd
    [  560.876502]  ? die_addr+0x3e/0x60
    [  560.880238]  ? exc_general_protection+0x1c5/0x410
    [  560.885532]  ? asm_exc_general_protection+0x27/0x30
    [  560.891025]  ? amdgpu_device_gpu_recover.cold+0xbf1/0xcf5 [amdgpu]
    [  560.898323]  amdgpu_ras_do_recovery+0x1b2/0x210 [amdgpu]
    [  560.904520]  process_one_work+0x228/0x3d0
How:
    In RAS recovery, mode-1 reset is issued from RAS fatal error handling and expected
    all the nodes in a hive to be reset. no need to issue another mode-1 during this procedure.

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 1fbaf7b81d69a..d0afb9ba3789c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6109,6 +6109,20 @@ pci_ers_result_t amdgpu_pci_slot_reset(struct pci_dev *pdev)
 	struct amdgpu_reset_context reset_context;
 	u32 memsize;
 	struct list_head device_list;
+	struct amdgpu_hive_info *hive;
+	int hive_ras_recovery = 0;
+	struct amdgpu_ras *ras;
+
+	/* PCI error slot reset should be skipped During RAS recovery */
+	hive = amdgpu_get_xgmi_hive(adev);
+	if (hive) {
+		hive_ras_recovery = atomic_read(&hive->ras_recovery);
+		amdgpu_put_xgmi_hive(hive);
+	}
+	ras = amdgpu_ras_get_context(adev);
+	if ((amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 3)) &&
+		 ras && (atomic_read(&ras->in_recovery) || hive_ras_recovery))
+		return PCI_ERS_RESULT_RECOVERED;
 
 	DRM_INFO("PCI error: slot reset callback!!\n");
 
-- 
2.43.0



