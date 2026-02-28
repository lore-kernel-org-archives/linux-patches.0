Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684394A33EE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300985; cv=none; b=L3plI/1yyL5TfuCUe1aWaVMrNFfMYcdy2MkcxQQ5Ay17ht+ep6EHMSATvXayEJEJekkHrLj+jI9qnvKCnjzClw0SGj5vIaOrG3etRCQVcoWDOnr8MnBB0vzxMCUILQ1tygu1o0pp+6LZrMNvImu0SV1wzINvtIfW76Z5fYTdk2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300985; c=relaxed/simple;
	bh=vSUd4wWkz5Yg4XC7aHqcb5FRGXR9ZILC6LQUuzVnqak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw4iuclLnPWitBh1VlIiIQUG/GqFKBd+Q0HY5Y+GxYg+9RbDW/39phVfq9niTZXkza1nl7WdPmsjR13gMbx80RAU+A5VcEmOzL1M1djxn+oBdGeCxZFYvnQEypocRWrCsqEB4kD1pyqhpOkLATYGOLoJmkuHzchr8lrH2EhgNR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQGy1v2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQGy1v2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A6BC19423;
	Sat, 28 Feb 2026 17:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300985;
	bh=vSUd4wWkz5Yg4XC7aHqcb5FRGXR9ZILC6LQUuzVnqak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQGy1v2wwTaLf6wjFT7XfGZQA9aPQNA4/cUA7DMQFEvhxDEG63dwY45y8XJWf8v+U
	 LsPv423VLPD9RE/gRBMJuQl/T74mIGlYQlnIGlnZWwvlPVgAttAR+L4KNLWUcnLMU8
	 99ILFQx4RG4cQs1qt3bpws3ERl09O1XkxA2Sf+YMCh3r82ALulJlhh5ORYkxrHiuC1
	 LhIXtjBeGP3QRnY0ohob9aZVUwbcuCwR4zfoGyBPmd02S5ndxN4DE8UmGyiAeTwA+8
	 4WN9FspOvhHcSUWIXqNwPY8mTHq0F0ZjNr2Wgpm1L1aria4eavju4pgzdn27j8vqxp
	 ZsDhuChPlBgaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/752] drm/amdgpu/ras: Move ras data alloc before bad page check
Date: Sat, 28 Feb 2026 12:37:06 -0500
Message-ID: <20260228174750.1542406-115-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit bd68a1404b6fa2e7e9957b38ba22616faba43e75 ]

In the rare event if eeprom has only invalid address entries,
allocation is skipped, this causes following NULL pointer issue
[  547.103445] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  547.118897] #PF: supervisor read access in kernel mode
[  547.130292] #PF: error_code(0x0000) - not-present page
[  547.141689] PGD 124757067 P4D 0
[  547.148842] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  547.158504] CPU: 49 PID: 8167 Comm: cat Tainted: G           OE      6.8.0-38-generic #38-Ubuntu
[  547.177998] Hardware name: Supermicro AS -8126GS-TNMR/H14DSG-OD, BIOS 1.7 09/12/2025
[  547.195178] RIP: 0010:amdgpu_ras_sysfs_badpages_read+0x2f2/0x5d0 [amdgpu]
[  547.210375] Code: e8 63 78 82 c0 45 31 d2 45 3b 75 08 48 8b 45 a0 73 44 44 89 f1 48 8b 7d 88 48 89 ca 48 c1 e2 05 48 29 ca 49 8b 4d 00 48 01 d1 <48> 83 79 10 00 74 17 49 63 f2 48 8b 49 08 41 83 c2 01 48 8d 34 76
[  547.252045] RSP: 0018:ffa0000067287ac0 EFLAGS: 00010246
[  547.263636] RAX: ff11000167c28130 RBX: ff11000127600000 RCX: 0000000000000000
[  547.279467] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ff11000125b1c800
[  547.295298] RBP: ffa0000067287b50 R08: 0000000000000000 R09: 0000000000000000
[  547.311129] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  547.326959] R13: ff11000217b1de00 R14: 0000000000000000 R15: 0000000000000092
[  547.342790] FS:  0000746e59d14740(0000) GS:ff11017dfda80000(0000) knlGS:0000000000000000
[  547.360744] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  547.373489] CR2: 0000000000000010 CR3: 000000019585e001 CR4: 0000000000f71ef0
[  547.389321] PKRU: 55555554
[  547.395316] Call Trace:
[  547.400737]  <TASK>
[  547.405386]  ? show_regs+0x6d/0x80
[  547.412929]  ? __die+0x24/0x80
[  547.419697]  ? page_fault_oops+0x99/0x1b0
[  547.428588]  ? do_user_addr_fault+0x2ee/0x6b0
[  547.438249]  ? exc_page_fault+0x83/0x1b0
[  547.446949]  ? asm_exc_page_fault+0x27/0x30
[  547.456225]  ? amdgpu_ras_sysfs_badpages_read+0x2f2/0x5d0 [amdgpu]
[  547.470040]  ? mas_wr_modify+0xcd/0x140
[  547.478548]  sysfs_kf_bin_read+0x63/0xb0
[  547.487248]  kernfs_file_read_iter+0xa1/0x190
[  547.496909]  kernfs_fop_read_iter+0x25/0x40
[  547.506182]  vfs_read+0x255/0x390

This also result in space left assigned to negative values.
Moving data alloc call before bad page check resolves both the issue.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index ca5f99df1ac20..e9ed1a3b135cc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2892,6 +2892,11 @@ static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 	struct ras_err_handler_data *data = con->eh_data;
 
 	for (j = 0; j < count; j++) {
+		if (!data->space_left &&
+		    amdgpu_ras_realloc_eh_data_space(adev, data, 256)) {
+			return -ENOMEM;
+		}
+
 		if (amdgpu_ras_check_bad_page_unlock(con,
 			bps[j].retired_page << AMDGPU_GPU_PAGE_SHIFT)) {
 			data->count++;
@@ -2899,11 +2904,6 @@ static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 			continue;
 		}
 
-		if (!data->space_left &&
-		    amdgpu_ras_realloc_eh_data_space(adev, data, 256)) {
-			return -ENOMEM;
-		}
-
 		amdgpu_ras_reserve_page(adev, bps[j].retired_page);
 
 		memcpy(&data->bps[data->count], &(bps[j]),
-- 
2.51.0

