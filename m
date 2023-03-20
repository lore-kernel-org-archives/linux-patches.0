Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A041C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF2BC433EF;
	Mon, 20 Mar 2023 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326236;
	bh=lLXBj/bdFjlolTNbeU1Pf/BTwvc7xwlXeLyYxAFGWso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnKKgG3mrDLcgINmyDxhy5dNXMqftCuF5lI0vHPbypeqcauy22425+fUkOCC3jK9L
	 2t5UPXfTN48b4gMNQNglp03vafMboDTWqMNWZhZmDa9+KYooWawXCvVIGS6pcVy3Uf
	 xuLYvQZboMkJI/tk3aSzrWsvuRPTP6QVIf6sr+tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Zhu <James.Zhu@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 168/211] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh broken BIOSes
Date: Mon, 20 Mar 2023 15:55:03 +0100
Message-Id: <20230320145520.487160109@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

commit 542a56e8eb4467ae654eefab31ff194569db39cd upstream.

The VCN firmware loading path enables the indirect SRAM mode if it's
advertised as supported. We might have some cases of FW issues that
prevents this mode to working properly though, ending-up in a failed
probe. An example below, observed in the Steam Deck:

[...]
[drm] failed to load ucode VCN0_RAM(0x3A)
[drm] psp gfx command LOAD_IP_FW(0x6) failed and response status is (0xFFFF0000)
amdgpu 0000:04:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring vcn_dec_0 test failed (-110)
[drm:amdgpu_device_init.cold [amdgpu]] *ERROR* hw_init of IP block <vcn_v3_0> failed -110
amdgpu 0000:04:00.0: amdgpu: amdgpu_device_ip_init failed
amdgpu 0000:04:00.0: amdgpu: Fatal error during GPU init
[...]

Disabling the VCN block circumvents this, but it's a very invasive
workaround that turns off the entire feature. So, let's add a quirk
on VCN loading that checks for known problematic BIOSes on Vangogh,
so we can proactively disable the indirect SRAM mode and allow the
HW proper probe and VCN IP block to work fine.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2385
Fixes: 82132ecc5432 ("drm/amdgpu: enable Vangogh VCN indirect sram mode")
Cc: stable@vger.kernel.org
Cc: James Zhu <James.Zhu@amd.com>
Cc: Leo Liu <leo.liu@amd.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -26,6 +26,7 @@
 
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/debugfs.h>
 #include <drm/drm_drv.h>
@@ -222,6 +223,24 @@ int amdgpu_vcn_sw_init(struct amdgpu_dev
 		return r;
 	}
 
+	/*
+	 * Some Steam Deck's BIOS versions are incompatible with the
+	 * indirect SRAM mode, leading to amdgpu being unable to get
+	 * properly probed (and even potentially crashing the kernel).
+	 * Hence, check for these versions here - notice this is
+	 * restricted to Vangogh (Deck's APU).
+	 */
+	if (adev->ip_versions[UVD_HWIP][0] == IP_VERSION(3, 0, 2)) {
+		const char *bios_ver = dmi_get_system_info(DMI_BIOS_VERSION);
+
+		if (bios_ver && (!strncmp("F7A0113", bios_ver, 7) ||
+		     !strncmp("F7A0114", bios_ver, 7))) {
+			adev->vcn.indirect_sram = false;
+			dev_info(adev->dev,
+				"Steam Deck quirk: indirect SRAM disabled on BIOS %s\n", bios_ver);
+		}
+	}
+
 	hdr = (const struct common_firmware_header *)adev->vcn.fw->data;
 	adev->vcn.fw_version = le32_to_cpu(hdr->ucode_version);
 


