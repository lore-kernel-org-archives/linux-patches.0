Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D71613C66A;
	Thu, 23 May 2024 13:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470234; cv=none; b=slcYJI1wGLQEp2DjfY9qY1EvOksb9BxatihAMfUJp6Tk2zhrmgYQTz97Ft9ByIbAtahfG1wmuzWrX2znGs8+STMFB98zN/7EIiAddNd8tQowJIqLFVBju7jdERMXoIu5ZnDi05IJtOUYt45CaIVGicjfEWUGNQfSOMN90BZ+res=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470234; c=relaxed/simple;
	bh=Xr5W1Y1vcss3vrjxFVUhmrsrP7AGCd8irn6EFmxERiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC3vmjd+Rtb4cuUXc5POdi0U305hSku8eGeuxWfShigFsL1JvfCIV14nxgRcHl2qSDyqWqxvrhlAGxlsQqI1emn18vv2IgwoWYCoTX7p+a3CVoKqbLWKnCu5+vOzw6/qX6u/bU6bV2t3X3xkaTwnlG/3R3u9sxvqfPU7eN28m2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1MSD8Gf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1MSD8Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB4CC3277B;
	Thu, 23 May 2024 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470234;
	bh=Xr5W1Y1vcss3vrjxFVUhmrsrP7AGCd8irn6EFmxERiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1MSD8GfEDAAc37LCOwKJ9QtetUz8CBqCyq7gWHLxxZ+pSyg4hzD0uf2NGIQEObT0
	 EVZMmxPBGvDioGfTKElditvfL8D7fIAxIf64TmN6gDJyPN3ClAV5W/3/5WYlL9vOtT
	 KOj+zxYCE0tjCBnlxkQyFnFmEOwKZ8d/0RrIy1wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Jose Fernandez <josef@netflix.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <mario.limonciello@amd.com>
Subject: [PATCH 6.9 04/25] drm/amd/display: Fix division by zero in setup_dsc_config
Date: Thu, 23 May 2024 15:12:49 +0200
Message-ID: <20240523130330.552973276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1055,7 +1055,12 @@ static bool setup_dsc_config(
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


