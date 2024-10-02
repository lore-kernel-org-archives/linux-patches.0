Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAD71D07BA;
	Wed,  2 Oct 2024 13:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876715; cv=none; b=GAy5W1nooJkJKDe+rIlN7dxqsjtda6WhZ/RLYVM2Gc2dN5RADfYcFCWD8x5rh/y2paw/y2ZbDCMpMCUbmT9KTtUOLdzD3J+8Zoa6Fk7hoTiYbsxr8QLwrTYK+VPMLOPjzMKCSdsqesqESQafRWeC71HbTla2OpTMKZQsVpCWZSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876715; c=relaxed/simple;
	bh=xTSLNfHBpCgB7QxYse+CQ7/OvA8+yjvn3HJ7N9rk1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akCRMAsdjODRlfg0kWdZmPxT/yAJdXkrvw+jlYbuspYpPrgsaDBs0BjREbO+DdgwmhJpPb5mz9+BH7YhhvgjsVs6wYfD/Al7aQsGfNPftgLSKjZ0zTYa/F7Kmn4jOaxPSpVtzXI5e8OWZVEt4qEwfaOhHBzBS6FUr2iolkenci4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+L65Fsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+L65Fsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1687C4CEC5;
	Wed,  2 Oct 2024 13:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876715;
	bh=xTSLNfHBpCgB7QxYse+CQ7/OvA8+yjvn3HJ7N9rk1xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+L65FskZMeZkAaOG3LRfjWl9HohmrOTHdtIsmqYB8WF/+Ns0xgaFUZb1zgLly8sJ
	 a+pQlm3G4qjveG1Yrujw/8t+Dz0txLErr3qT4qLBv/h33RO2Tik6addCh4uqebPTrT
	 0H+lvxQY/FeufDmTV+gCwGebg+IhvBp6bnvIUqYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 539/695] drm/amd/display: Skip Recompute DSC Params if no Stream on Link
Date: Wed,  2 Oct 2024 14:58:57 +0200
Message-ID: <20241002125844.013859480@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

commit 8151a6c13111b465dbabe07c19f572f7cbd16fef upstream.

[why]
Encounter NULL pointer dereference uner mst + dsc setup.

BUG: kernel NULL pointer dereference, address: 0000000000000008
    PGD 0 P4D 0
    Oops: 0000 [#1] PREEMPT SMP NOPTI
    CPU: 4 PID: 917 Comm: sway Not tainted 6.3.9-arch1-1 #1 124dc55df4f5272ccb409f39ef4872fc2b3376a2
    Hardware name: LENOVO 20NKS01Y00/20NKS01Y00, BIOS R12ET61W(1.31 ) 07/28/2022
    RIP: 0010:drm_dp_atomic_find_time_slots+0x5e/0x260 [drm_display_helper]
    Code: 01 00 00 48 8b 85 60 05 00 00 48 63 80 88 00 00 00 3b 43 28 0f 8d 2e 01 00 00 48 8b 53 30 48 8d 04 80 48 8d 04 c2 48 8b 40 18 <48> 8>
    RSP: 0018:ffff960cc2df77d8 EFLAGS: 00010293
    RAX: 0000000000000000 RBX: ffff8afb87e81280 RCX: 0000000000000224
    RDX: ffff8afb9ee37c00 RSI: ffff8afb8da1a578 RDI: ffff8afb87e81280
    RBP: ffff8afb83d67000 R08: 0000000000000001 R09: ffff8afb9652f850
    R10: ffff960cc2df7908 R11: 0000000000000002 R12: 0000000000000000
    R13: ffff8afb8d7688a0 R14: ffff8afb8da1a578 R15: 0000000000000224
    FS:  00007f4dac35ce00(0000) GS:ffff8afe30b00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000008 CR3: 000000010ddc6000 CR4: 00000000003506e0
    Call Trace:
<TASK>
     ? __die+0x23/0x70
     ? page_fault_oops+0x171/0x4e0
     ? plist_add+0xbe/0x100
     ? exc_page_fault+0x7c/0x180
     ? asm_exc_page_fault+0x26/0x30
     ? drm_dp_atomic_find_time_slots+0x5e/0x260 [drm_display_helper 0e67723696438d8e02b741593dd50d80b44c2026]
     ? drm_dp_atomic_find_time_slots+0x28/0x260 [drm_display_helper 0e67723696438d8e02b741593dd50d80b44c2026]
     compute_mst_dsc_configs_for_link+0x2ff/0xa40 [amdgpu 62e600d2a75e9158e1cd0a243bdc8e6da040c054]
     ? fill_plane_buffer_attributes+0x419/0x510 [amdgpu 62e600d2a75e9158e1cd0a243bdc8e6da040c054]
     compute_mst_dsc_configs_for_state+0x1e1/0x250 [amdgpu 62e600d2a75e9158e1cd0a243bdc8e6da040c054]
     amdgpu_dm_atomic_check+0xecd/0x1190 [amdgpu 62e600d2a75e9158e1cd0a243bdc8e6da040c054]
     drm_atomic_check_only+0x5c5/0xa40
     drm_mode_atomic_ioctl+0x76e/0xbc0

[how]
dsc recompute should be skipped if no mode change detected on the new
request. If detected, keep checking whether the stream is already on
current state or not.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1344,6 +1344,9 @@ static bool is_dsc_need_re_compute(
 	DRM_DEBUG_DRIVER("%s: MST_DSC check on %d streams in current dc_state\n",
 			 __func__, dc->current_state->stream_count);
 
+	if (new_stream_on_link_num == 0)
+		return false;
+
 	/* check current_state if there stream on link but it is not in
 	 * new request state
 	 */


