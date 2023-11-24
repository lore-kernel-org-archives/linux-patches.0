Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F7A321AD;
	Fri, 24 Nov 2023 18:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkQv95MU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA007C433C7;
	Fri, 24 Nov 2023 18:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851519;
	bh=+KZFqlhw6zA/WRphMHHczzEFiO8Ewi90+zoklaCR11o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkQv95MU+Yn+rOvZVR+wLTiV1kgpcw700nnCNQ/PVa/2XZX3v7L0Vzd+Idi4sKMq6
	 gESoSErDOvAkoJkUbyKD9jX0taN+RBHVDlpdHdMuHW7UNZYSYcU2ExqocVx3DzxT40
	 NEnCv3ChEbJ5c54CYuch9ToizrGBqNfrC4SXmeAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 479/491] drm/amdgpu: add a retry for IP discovery init
Date: Fri, 24 Nov 2023 17:51:55 +0000
Message-ID: <20231124172039.033360992@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3938eb956e383ef88b8fc7d556492336ebee52df upstream.

AMD dGPUs have integrated FW that runs as soon as the
device gets power and initializes the board (determines
the amount of memory, provides configuration details to
the driver, etc.).  For direct PCIe attached cards this
happens as soon as power is applied and normally completes
well before the OS has even started loading.  However, with
hotpluggable ports like USB4, the driver needs to wait for
this to complete before initializing the device.

This normally takes 60-100ms, but could take longer on
some older boards periodically due to memory training.

Retry for up to a second.  In the non-hotplug case, there
should be no change in behavior and this should complete
on the first try.

v2: adjust test criteria
v3: adjust checks for the masks, only enable on removable devices
v4: skip bif_fb_en check

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2925
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -92,6 +92,7 @@
 MODULE_FIRMWARE(FIRMWARE_IP_DISCOVERY);
 
 #define mmRCC_CONFIG_MEMSIZE	0xde3
+#define mmMP0_SMN_C2PMSG_33	0x16061
 #define mmMM_INDEX		0x0
 #define mmMM_INDEX_HI		0x6
 #define mmMM_DATA		0x1
@@ -230,8 +231,26 @@ static int amdgpu_discovery_read_binary_
 static int amdgpu_discovery_read_binary_from_mem(struct amdgpu_device *adev,
 						 uint8_t *binary)
 {
-	uint64_t vram_size = (uint64_t)RREG32(mmRCC_CONFIG_MEMSIZE) << 20;
-	int ret = 0;
+	uint64_t vram_size;
+	u32 msg;
+	int i, ret = 0;
+
+	/* It can take up to a second for IFWI init to complete on some dGPUs,
+	 * but generally it should be in the 60-100ms range.  Normally this starts
+	 * as soon as the device gets power so by the time the OS loads this has long
+	 * completed.  However, when a card is hotplugged via e.g., USB4, we need to
+	 * wait for this to complete.  Once the C2PMSG is updated, we can
+	 * continue.
+	 */
+	if (dev_is_removable(&adev->pdev->dev)) {
+		for (i = 0; i < 1000; i++) {
+			msg = RREG32(mmMP0_SMN_C2PMSG_33);
+			if (msg & 0x80000000)
+				break;
+			msleep(1);
+		}
+	}
+	vram_size = (uint64_t)RREG32(mmRCC_CONFIG_MEMSIZE) << 20;
 
 	if (vram_size) {
 		uint64_t pos = vram_size - DISCOVERY_TMR_OFFSET;


