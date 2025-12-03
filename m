Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F816340D82;
	Wed,  3 Dec 2025 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781174; cv=none; b=cxotxKUYamAbiGzRKcbz0rkdZDMcMfNA3qUeALQQ4pb+mLSwmE650Ub+Sr556Ws45JvmlQORQQf3B+p4yxh+giapPLIye8twJHgOXKNR4vo1mHCfcYImfkQIqX+sQ2GT0gBMHPV7iewSJVIxWA4VX+0FRwdYJxNqIpcC9vRA1ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781174; c=relaxed/simple;
	bh=BGylPvOORLef03dHop1tMjX2zwrhsMAEQ6cRObpLt5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTpKIJKX899EBkuc/1yxXf3hY+tgDUNYQbdEPC9wZ8/I4Zw9eV47hvqU95Egt4bEWfTsZnRma4G4HAAp9zzTV453MlJVyN5SZBlqxcrprN7jgrMDxmG4IbOPwKbjRGsPZ0ehlRB6uizQAktfcKJjyqb3rGvz9Pvt8FFg93lG2hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEMiT1+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEMiT1+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A15C4CEF5;
	Wed,  3 Dec 2025 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781173;
	bh=BGylPvOORLef03dHop1tMjX2zwrhsMAEQ6cRObpLt5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEMiT1+54aFd7h8HvtFIjXFjshEOLhRYvdnI5VbI1hALOmKvEgjiEJQ8Q7K6NUY/z
	 osjtRpwcY6HbDh2eaethXn5jV0HZpmnGwyjWuh40iAmxeUDITzwqo0W3mhBKjXKQTy
	 MiSPZ9Oo2vU+O5qC1fo7xyDXzd7UTSwQbsOcvRsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.6 72/93] drm/amd/display: Check NULL before accessing
Date: Wed,  3 Dec 2025 16:30:05 +0100
Message-ID: <20251203152339.185528014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 3ce62c189693e8ed7b3abe551802bbc67f3ace54 upstream.

[WHAT]
IGT kms_cursor_legacy's long-nonblocking-modeset-vs-cursor-atomic
fails with NULL pointer dereference. This can be reproduced with
both an eDP panel and a DP monitors connected.

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP NOPTI
 CPU: 13 UID: 0 PID: 2960 Comm: kms_cursor_lega Not tainted
6.16.0-99-custom #8 PREEMPT(voluntary)
 Hardware name: AMD ........
 RIP: 0010:dc_stream_get_scanoutpos+0x34/0x130 [amdgpu]
 Code: 57 4d 89 c7 41 56 49 89 ce 41 55 49 89 d5 41 54 49
 89 fc 53 48 83 ec 18 48 8b 87 a0 64 00 00 48 89 75 d0 48 c7 c6 e0 41 30
 c2 <48> 8b 38 48 8b 9f 68 06 00 00 e8 8d d7 fd ff 31 c0 48 81 c3 e0 02
 RSP: 0018:ffffd0f3c2bd7608 EFLAGS: 00010292
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffd0f3c2bd7668
 RDX: ffffd0f3c2bd7664 RSI: ffffffffc23041e0 RDI: ffff8b32494b8000
 RBP: ffffd0f3c2bd7648 R08: ffffd0f3c2bd766c R09: ffffd0f3c2bd7760
 R10: ffffd0f3c2bd7820 R11: 0000000000000000 R12: ffff8b32494b8000
 R13: ffffd0f3c2bd7664 R14: ffffd0f3c2bd7668 R15: ffffd0f3c2bd766c
 FS:  000071f631b68700(0000) GS:ffff8b399f114000(0000)
knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 00000001b8105000 CR4: 0000000000f50ef0
 PKRU: 55555554
 Call Trace:
 <TASK>
 dm_crtc_get_scanoutpos+0xd7/0x180 [amdgpu]
 amdgpu_display_get_crtc_scanoutpos+0x86/0x1c0 [amdgpu]
 ? __pfx_amdgpu_crtc_get_scanout_position+0x10/0x10[amdgpu]
 amdgpu_crtc_get_scanout_position+0x27/0x50 [amdgpu]
 drm_crtc_vblank_helper_get_vblank_timestamp_internal+0xf7/0x400
 drm_crtc_vblank_helper_get_vblank_timestamp+0x1c/0x30
 drm_crtc_get_last_vbltimestamp+0x55/0x90
 drm_crtc_next_vblank_start+0x45/0xa0
 drm_atomic_helper_wait_for_fences+0x81/0x1f0
 ...

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 621e55f1919640acab25383362b96e65f2baea3c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -634,9 +634,14 @@ bool dc_stream_get_scanoutpos(const stru
 {
 	uint8_t i;
 	bool ret = false;
-	struct dc  *dc = stream->ctx->dc;
-	struct resource_context *res_ctx =
-		&dc->current_state->res_ctx;
+	struct dc  *dc;
+	struct resource_context *res_ctx;
+
+	if (!stream->ctx)
+		return false;
+
+	dc = stream->ctx->dc;
+	res_ctx = &dc->current_state->res_ctx;
 
 	for (i = 0; i < MAX_PIPES; i++) {
 		struct timing_generator *tg = res_ctx->pipe_ctx[i].stream_res.tg;


