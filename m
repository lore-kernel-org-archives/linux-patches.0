Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D126ED41;
	Fri,  9 Jan 2026 12:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961228; cv=none; b=ON/nBdAy7OxuKgfp1L8XMkQ4iQwas1rLIEYcuwu/3H8gVlQhURon2pnd63wjGb+v7fvywje9bSRKGFdq8pky50qF1n40s8MnPuPJZAt/OBPDnboXNKn2XmKyZzH1PVGCzemGoyNKJMu7pJoRij+m0zsGsgqrC73Db1ctuR4+tPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961228; c=relaxed/simple;
	bh=QPf9kjo/KbZjFH9KBKFNFFhPNg4aoaRDi8ASGqvq8ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNHY215zfUaQ1ka1RFyRU2OfM+Ty6LiGOuvztT1tsamV9PPiqTrDq5Pr80L4C/P1QqHnilly1YhTzgftZNNOtnOmvP4+ZkqhHbL4c+5op9/rNj9bCDvocVA4aPOZun94U84a50kLUuay6TFiN0wZUy25TD7XCTX96uK6wpNrsGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajlcOKCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajlcOKCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962E6C4CEF1;
	Fri,  9 Jan 2026 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961228;
	bh=QPf9kjo/KbZjFH9KBKFNFFhPNg4aoaRDi8ASGqvq8ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajlcOKCp54TlHP4WYXhiSiXzAAOptDHHezKt4kHG3PuE39QKLoAyvEQgCUPtR8gHu
	 eWa28ECu/ND5DFPWAZ3TyAJkQiLwTRgveKLZfRPLTipz0TbVnLFlbVuumw0SRNoHPy
	 FYr0IOEfUtaJKZxTCkRB28Cj+KuiF9HR0w2lmyGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?David=20Nystr=C3=B6m?= <david.nystrom@est.tech>
Subject: [PATCH 6.6 672/737] drm/amd/display: Fix null pointer deref in dcn20_resource.c
Date: Fri,  9 Jan 2026 12:43:31 +0100
Message-ID: <20260109112159.330731622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit ecbf60782662f0a388493685b85a645a0ba1613c ]

Fixes a hang thats triggered when MPV is run on a DCN401 dGPU:

mpv --hwdec=vaapi --vo=gpu --hwdec-codecs=all

and then enabling fullscreen playback (double click on the video)

The following calltrace will be seen:

[  181.843989] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  181.843997] #PF: supervisor instruction fetch in kernel mode
[  181.844003] #PF: error_code(0x0010) - not-present page
[  181.844009] PGD 0 P4D 0
[  181.844020] Oops: 0010 [#1] PREEMPT SMP NOPTI
[  181.844028] CPU: 6 PID: 1892 Comm: gnome-shell Tainted: G        W  OE      6.5.0-41-generic #41~22.04.2-Ubuntu
[  181.844038] Hardware name: System manufacturer System Product Name/CROSSHAIR VI HERO, BIOS 6302 10/23/2018
[  181.844044] RIP: 0010:0x0
[  181.844079] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[  181.844084] RSP: 0018:ffffb593c2b8f7b0 EFLAGS: 00010246
[  181.844093] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000004
[  181.844099] RDX: ffffb593c2b8f804 RSI: ffffb593c2b8f7e0 RDI: ffff9e3c8e758400
[  181.844105] RBP: ffffb593c2b8f7b8 R08: ffffb593c2b8f9c8 R09: ffffb593c2b8f96c
[  181.844110] R10: 0000000000000000 R11: 0000000000000000 R12: ffffb593c2b8f9c8
[  181.844115] R13: 0000000000000001 R14: ffff9e3c88000000 R15: 0000000000000005
[  181.844121] FS:  00007c6e323bb5c0(0000) GS:ffff9e3f85f80000(0000) knlGS:0000000000000000
[  181.844128] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  181.844134] CR2: ffffffffffffffd6 CR3: 0000000140fbe000 CR4: 00000000003506e0
[  181.844141] Call Trace:
[  181.844146]  <TASK>
[  181.844153]  ? show_regs+0x6d/0x80
[  181.844167]  ? __die+0x24/0x80
[  181.844179]  ? page_fault_oops+0x99/0x1b0
[  181.844192]  ? do_user_addr_fault+0x31d/0x6b0
[  181.844204]  ? exc_page_fault+0x83/0x1b0
[  181.844216]  ? asm_exc_page_fault+0x27/0x30
[  181.844237]  dcn20_get_dcc_compression_cap+0x23/0x30 [amdgpu]
[  181.845115]  amdgpu_dm_plane_validate_dcc.constprop.0+0xe5/0x180 [amdgpu]
[  181.845985]  amdgpu_dm_plane_fill_plane_buffer_attributes+0x300/0x580 [amdgpu]
[  181.846848]  fill_dc_plane_info_and_addr+0x258/0x350 [amdgpu]
[  181.847734]  fill_dc_plane_attributes+0x162/0x350 [amdgpu]
[  181.848748]  dm_update_plane_state.constprop.0+0x4e3/0x6b0 [amdgpu]
[  181.849791]  ? dm_update_plane_state.constprop.0+0x4e3/0x6b0 [amdgpu]
[  181.850840]  amdgpu_dm_atomic_check+0xdfe/0x1760 [amdgpu]

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David Nyström <david.nystrom@est.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2179,10 +2179,11 @@ bool dcn20_get_dcc_compression_cap(const
 		const struct dc_dcc_surface_param *input,
 		struct dc_surface_dcc_cap *output)
 {
-	return dc->res_pool->hubbub->funcs->get_dcc_compression_cap(
-			dc->res_pool->hubbub,
-			input,
-			output);
+	if (dc->res_pool->hubbub->funcs->get_dcc_compression_cap)
+		return dc->res_pool->hubbub->funcs->get_dcc_compression_cap(
+			dc->res_pool->hubbub, input, output);
+
+	return false;
 }
 
 static void dcn20_destroy_resource_pool(struct resource_pool **pool)


