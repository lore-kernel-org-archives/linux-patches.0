Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29071E497;
	Thu, 23 May 2024 13:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470289; cv=none; b=avrNbr1zRvCLvRHkviM9JvpaFKNyUllCzaNmYx3+nOf1xfZ4OwmQagz6+eLZkJkDuTntRPV81/DVtYgHqtWsiYm84d/O1tiJ0VFQWPBZLr4hfSaA5CZxvSFU5rllKow1l35drtKqX1tl9noN/F7lzVycsxiWrO2kaJRm5Js6NQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470289; c=relaxed/simple;
	bh=ofavnzkS8ATe8Yct3OyZNv++Q9edNFjSoHKheyXLWno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPM7UrO/2vTg5oyVL5RMdANiTU03TiEEhoK21GMVbuiBEL+rPvd1OV0QKkK7MCtS5KN83Y3gSUTiJ2bVWX1UPC/kCUSfqEhb1eXgmIwyE5h303wUrbB40L6qepxP3XNikCxYF9vOXOMmxXS9Haw2wDj4wcTdz3SzMyQm64NfSwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvAYYwkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvAYYwkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B355C2BD10;
	Thu, 23 May 2024 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470288;
	bh=ofavnzkS8ATe8Yct3OyZNv++Q9edNFjSoHKheyXLWno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvAYYwkpsbLppI4UcU4thCoVScblxj10RRVdxqnuTCATr+9bmODukKNFxlGqYbXtl
	 B9L+j7NPw6UjmA24CWHEypezvzncQNle2NahGTwSKruZBgrHgQFuh5wnSzs8kLiq7N
	 6sWrv+cetLo5Iajoe7yh6T/5MnB2CQ5PRRAkLMcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Jose Fernandez <josef@netflix.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <mario.limonciello@amd.com>
Subject: [PATCH 5.15 01/23] drm/amd/display: Fix division by zero in setup_dsc_config
Date: Thu, 23 May 2024 15:12:57 +0200
Message-ID: <20240523130328.014252014@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Fernandez <josef@netflix.com>

commit 130afc8a886183a94cf6eab7d24f300014ff87ba upstream.

When slice_height is 0, the division by slice_height in the calculation
of the number of slices will cause a division by zero driver crash. This
leaves the kernel in a state that requires a reboot. This patch adds a
check to avoid the division by zero.

The stack trace below is for the 6.8.4 Kernel. I reproduced the issue on
a Z16 Gen 2 Lenovo Thinkpad with a Apple Studio Display monitor
connected via Thunderbolt. The amdgpu driver crashed with this exception
when I rebooted the system with the monitor connected.

kernel: ? die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434 arch/x86/kernel/dumpstack.c:447)
kernel: ? do_trap (arch/x86/kernel/traps.c:113 arch/x86/kernel/traps.c:154)
kernel: ? setup_dsc_config (drivers/gpu/drm/amd/amdgpu/../display/dc/dsc/dc_dsc.c:1053) amdgpu
kernel: ? do_error_trap (./arch/x86/include/asm/traps.h:58 arch/x86/kernel/traps.c:175)
kernel: ? setup_dsc_config (drivers/gpu/drm/amd/amdgpu/../display/dc/dsc/dc_dsc.c:1053) amdgpu
kernel: ? exc_divide_error (arch/x86/kernel/traps.c:194 (discriminator 2))
kernel: ? setup_dsc_config (drivers/gpu/drm/amd/amdgpu/../display/dc/dsc/dc_dsc.c:1053) amdgpu
kernel: ? asm_exc_divide_error (./arch/x86/include/asm/idtentry.h:548)
kernel: ? setup_dsc_config (drivers/gpu/drm/amd/amdgpu/../display/dc/dsc/dc_dsc.c:1053) amdgpu
kernel: dc_dsc_compute_config (drivers/gpu/drm/amd/amdgpu/../display/dc/dsc/dc_dsc.c:1109) amdgpu

After applying this patch, the driver no longer crashes when the monitor
is connected and the system is rebooted. I believe this is the same
issue reported for 3113.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Jose Fernandez <josef@netflix.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3113
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
@@ -939,7 +939,12 @@ static bool setup_dsc_config(
 	if (!is_dsc_possible)
 		goto done;
 
-	dsc_cfg->num_slices_v = pic_height/slice_height;
+	if (slice_height > 0) {
+		dsc_cfg->num_slices_v = pic_height / slice_height;
+	} else {
+		is_dsc_possible = false;
+		goto done;
+	}
 
 	if (target_bandwidth_kbps > 0) {
 		is_dsc_possible = decide_dsc_target_bpp_x16(


