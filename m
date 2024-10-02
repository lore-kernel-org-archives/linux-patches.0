Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E576E9475;
	Wed,  2 Oct 2024 14:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880305; cv=none; b=nAXTkjNJPVk8jPNn8nEp8SKK4cQYv+tcz8BwEKhwCguITJNGC79POOvzVOPuIUHiRLI1fwrw5nG34YgQEN6CoSmwHedL32p3hY2d4Vsh+JcZbaAXzlvvjDY5gFLEkZQcbGBZLJ66UJTlAx6raRbllouWvnCQGpfKwGJdcPsXIFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880305; c=relaxed/simple;
	bh=C9GkLqwTdaRHMLoXr4bVrvCFG5CIejomy+UOnLTqmQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhyXRfqqUYM4VTE+EVudsyWkpcs8KlMbJisBBqmdSzHkASFkgYlg7/EJdYdhPiIpBiOD8n5CAhQ5U1xUlSfkSIGWtOjtY7IlEH/rLMqM9IP/BdkWdcPqT9O7dqpm4ncy70HHsHhzrUKp6kva92EZzzd/Ox8qGWvu8S9hQssxos0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INccJpCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INccJpCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E67AC4CEC2;
	Wed,  2 Oct 2024 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880304;
	bh=C9GkLqwTdaRHMLoXr4bVrvCFG5CIejomy+UOnLTqmQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INccJpCdEzgE9KFMlX5/ia+uUlcEOtCv1TDyU5wKCpjOBTXRFTBMtwgGukd0Gs4yN
	 LYEcKE3xDoxZGxToy5tayvEZWHKYkMcfInrFSkslORPkvsjYXELCNoNuGdiZVE33oy
	 G1WCqaDMSga7zHyWzqxpqRJJUrb1ZvP01WPMkH10=
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
Subject: [PATCH 6.6 414/538] drm/amd/display: Skip Recompute DSC Params if no Stream on Link
Date: Wed,  2 Oct 2024 15:00:53 +0200
Message-ID: <20241002125808.775019329@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1269,6 +1269,9 @@ static bool is_dsc_need_re_compute(
 	if (new_stream_on_link_num == 0)
 		return false;
 
+	if (new_stream_on_link_num == 0)
+		return false;
+
 	/* check current_state if there stream on link but it is not in
 	 * new request state
 	 */


