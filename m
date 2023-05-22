Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2C9171A8
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE48BC4339B;
	Mon, 22 May 2023 19:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783447;
	bh=8L0YUmQisuwdiCTcNyYLilgshNpv6wm2b+pOlg6m8to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUV7ECPZNxHvoKicDTTqPo6Ic0pbg1BJ671EyMxOQ4/CI2eeVYNqSTwxpT13ak80U
	 aYlj+9F7nwdOdIgyYl3A4AflOkg/DdVloZuCZFRYdhlEBFgE493Oxl/ygXvxkZXp5I
	 CHtqM2lj71HuWqhI4WVPRq1OtueME2c98/nmSQqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <Harry.Wentland@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/292] drm/amd/display: Use DC_LOG_DC in the trasform pixel function
Date: Mon, 22 May 2023 20:06:43 +0100
Message-Id: <20230522190407.060091671@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 7222f5841ff49709ca666b05ff336776e0664a20 ]

[Why & How]
DC now uses a new commit sequence which is more robust since it
addresses cases where we need to reorganize pipes based on planes and
other parameters. As a result, this new commit sequence reset the DC
state by cleaning plane states and re-creating them accordingly with the
need. For this reason, the dce_transform_set_pixel_storage_depth can be
invoked after a plane state is destroyed and before its re-creation. In
this situation and on DCE devices, DC will hit a condition that will
trigger a dmesg log that looks like this:

Console: switching to colour frame buffer device 240x67
------------[ cut here ]------------
[..]
Hardware name: System manufacturer System Product Name/PRIME X370-PRO, BIOS 5603 07/28/2020
RIP: 0010:dce_transform_set_pixel_storage_depth+0x3f8/0x480 [amdgpu]
[..]
RSP: 0018:ffffc9000202b850 EFLAGS: 00010293
RAX: ffffffffa081d100 RBX: ffff888110790000 RCX: 000000000000000c
RDX: ffff888100bedbf8 RSI: 0000000000001a50 RDI: ffff88810463c900
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000007
R10: 0000000000000001 R11: 0000000000000f00 R12: ffff88810f500010
R13: ffff888100bedbf8 R14: ffff88810f515688 R15: 0000000000000000
FS:  00007ff0159249c0(0000) GS:ffff88840e940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff01528e550 CR3: 0000000002a10000 CR4: 00000000003506e0
Call Trace:
 <TASK>
 ? dm_write_reg_func+0x21/0x80 [amdgpu 340dadd3f7c8cf4be11cf0bdc850245e99abe0e8]
 dc_stream_set_dither_option+0xfb/0x130 [amdgpu 340dadd3f7c8cf4be11cf0bdc850245e99abe0e8]
 amdgpu_dm_crtc_configure_crc_source+0x10b/0x190 [amdgpu 340dadd3f7c8cf4be11cf0bdc850245e99abe0e8]
 amdgpu_dm_atomic_commit_tail+0x20a8/0x2a90 [amdgpu 340dadd3f7c8cf4be11cf0bdc850245e99abe0e8]
 ? free_unref_page_commit+0x98/0x170
 ? free_unref_page+0xcc/0x150
 commit_tail+0x94/0x120
 drm_atomic_helper_commit+0x10f/0x140
 drm_atomic_commit+0x94/0xc0
 ? drm_plane_get_damage_clips.cold+0x1c/0x1c
 drm_client_modeset_commit_atomic+0x203/0x250
 drm_client_modeset_commit_locked+0x56/0x150
 drm_client_modeset_commit+0x21/0x40
 drm_fb_helper_lastclose+0x42/0x70
 amdgpu_driver_lastclose_kms+0xa/0x10 [amdgpu 340dadd3f7c8cf4be11cf0bdc850245e99abe0e8]
 drm_release+0xda/0x110
 __fput+0x89/0x240
 task_work_run+0x5c/0x90
 do_exit+0x333/0xae0
 do_group_exit+0x2d/0x90
 __x64_sys_exit_group+0x14/0x20
 do_syscall_64+0x5b/0x80
 ? exit_to_user_mode_prepare+0x1e/0x140
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff016ceaca1
Code: Unable to access opcode bytes at RIP 0x7ff016ceac77.
RSP: 002b:00007ffe7a2357e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007ff016e15a00 RCX: 00007ff016ceaca1
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffff78 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff016e15a00
R13: 0000000000000000 R14: 00007ff016e1aee8 R15: 00007ff016e1af00
 </TASK>

Since this issue only happens in a transition state on DC, this commit
replace BREAK_TO_DEBUGGER with DC_LOG_DC.

Reviewed-by: Harry Wentland <Harry.Wentland@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
index d9fd4ec60588f..670d5ab9d9984 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -1009,7 +1009,7 @@ static void dce_transform_set_pixel_storage_depth(
 		color_depth = COLOR_DEPTH_101010;
 		pixel_depth = 0;
 		expan_mode  = 1;
-		BREAK_TO_DEBUGGER();
+		DC_LOG_DC("The pixel depth %d is not valid, set COLOR_DEPTH_101010 instead.", depth);
 		break;
 	}
 
@@ -1023,8 +1023,7 @@ static void dce_transform_set_pixel_storage_depth(
 	if (!(xfm_dce->lb_pixel_depth_supported & depth)) {
 		/*we should use unsupported capabilities
 		 *  unless it is required by w/a*/
-		DC_LOG_WARNING("%s: Capability not supported",
-			__func__);
+		DC_LOG_DC("%s: Capability not supported", __func__);
 	}
 }
 
-- 
2.39.2



