Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65AE2AE94;
	Thu, 23 May 2024 13:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470489; cv=none; b=SG1Wqam8154dJeUZbp0/jfIO27mKMP59r0tNi3zzeyRrwv4dl7AEe80HjP6eXFlcUwHr8720XFlox4ESHON7cpFTW9r94AzdBLVxvfsm7ATvI6e9MZkIMN1U27lWtGqT7O6b/tn/ud7Nw1g/KMsGu9Y/jjpEzVXYYKH+BsBEw/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470489; c=relaxed/simple;
	bh=/nNjaI5VRdcZpcJGML/zCMRBvWq8zXCDlrNNPaPDHjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6vZF0RKFIs2j6r5JQoLfWx0ynnOwqVNNC/DoBu4ytDkFXrW0FC9aTKnGpaNV4B9dPYNwz2XcpX7VFtoJAVTYesmpC4xCRswo+3hi0m2d+RKydI+n0Cl2zV6Yt6bBjGihlKRyCSUz+QpI2OAaZWe5aVSnWL49lFB+Mm3S849YOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZeyw8PD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZeyw8PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF1CC3277B;
	Thu, 23 May 2024 13:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470489;
	bh=/nNjaI5VRdcZpcJGML/zCMRBvWq8zXCDlrNNPaPDHjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZeyw8PDSQQ/FavfSckFfb8QBARZ+/wy73uM+WGzbkvyMgvsydi1kfraE+/IsKsgN
	 SyI3PDjGaBIaFd9sa26hMVE1ULwku8Mhx06RiIu42RyzLnHhipsQbzK1reWZBt4Tnv
	 xW/Zhb3MQzUeCkmYUQj+GcYKtmOeRb0yMzOds3YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Jose Fernandez <josef@netflix.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <mario.limonciello@amd.com>
Subject: [PATCH 6.8 01/23] drm/amd/display: Fix division by zero in setup_dsc_config
Date: Thu, 23 May 2024 15:13:28 +0200
Message-ID: <20240523130329.803582727@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
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
@@ -1050,7 +1050,12 @@ static bool setup_dsc_config(
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


