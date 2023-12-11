Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341EF5102A;
	Mon, 11 Dec 2023 18:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmmYy8nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF5DC433C8;
	Mon, 11 Dec 2023 18:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320703;
	bh=fWg4wigGuNZQKg3uq8D3fzpAYJR4vqXdgqcoEctc6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmmYy8nfL4B1hhNLrJkRSocEy1K4CfcdNXc8e+s7wbnebba3V7qJv+EylxAzsWoz9
	 fGcntI9Pq/QR/VWyMATjJHH+86VVetSU6X3AEieeRKHtNYw9FZLJWuiBa6TJXqTI8W
	 6ULBI2WIf7xYWI5A58IkvScHTgSmGrQT/sHKnCEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/194] drm/amdgpu: Decouple RAS EEPROM addresses from chips
Date: Mon, 11 Dec 2023 19:22:29 +0100
Message-ID: <20231211182043.738182769@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 3b8164f8084ff7888ed24970efa230ff5d36eda8 ]

Abstract RAS I2C EEPROM addresses from chip names, and set their macro
definition names to the address they set, not the chip they attach
to. Since most chips either use I2C EEPROM address 0 or 40000h for the RAS
table start offset, this leaves us with only two macro definitions as
opposed to five, and removes the redundancy of four.

Cc: Candice Li <candice.li@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 1bb92a64f24af..f63bd31e199c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -51,12 +51,11 @@
  * Depending on the size of the I2C EEPROM device(s), bits 18:16 may
  * address memory in a device or a device on the I2C bus, depending on
  * the status of pins 1-3. See top of amdgpu_eeprom.c.
+ *
+ * The RAS table lives either at address 0 or address 40000h of EEPROM.
  */
-#define EEPROM_I2C_MADDR_VEGA20         0x0
-#define EEPROM_I2C_MADDR_ARCTURUS       0x40000
-#define EEPROM_I2C_MADDR_ARCTURUS_D342  0x0
-#define EEPROM_I2C_MADDR_SIENNA_CICHLID 0x0
-#define EEPROM_I2C_MADDR_ALDEBARAN      0x0
+#define EEPROM_I2C_MADDR_0      0x0
+#define EEPROM_I2C_MADDR_4      0x40000
 
 /*
  * The 2 macros bellow represent the actual size in bytes that
@@ -135,9 +134,9 @@ static bool __get_eeprom_i2c_addr_arct(struct amdgpu_device *adev,
 	if (strnstr(atom_ctx->vbios_version,
 	            "D342",
 		    sizeof(atom_ctx->vbios_version)))
-		control->i2c_address = EEPROM_I2C_MADDR_ARCTURUS_D342;
+		control->i2c_address = EEPROM_I2C_MADDR_0;
 	else
-		control->i2c_address = EEPROM_I2C_MADDR_ARCTURUS;
+		control->i2c_address = EEPROM_I2C_MADDR_4;
 
 	return true;
 }
@@ -148,7 +147,7 @@ static bool __get_eeprom_i2c_addr_ip_discovery(struct amdgpu_device *adev,
 	switch (adev->ip_versions[MP1_HWIP][0]) {
 	case IP_VERSION(13, 0, 0):
 	case IP_VERSION(13, 0, 10):
-		control->i2c_address = EEPROM_I2C_MADDR_ARCTURUS;
+		control->i2c_address = EEPROM_I2C_MADDR_4;
 		return true;
 	default:
 		return false;
@@ -180,18 +179,18 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 
 	switch (adev->asic_type) {
 	case CHIP_VEGA20:
-		control->i2c_address = EEPROM_I2C_MADDR_VEGA20;
+		control->i2c_address = EEPROM_I2C_MADDR_0;
 		break;
 
 	case CHIP_ARCTURUS:
 		return __get_eeprom_i2c_addr_arct(adev, control);
 
 	case CHIP_SIENNA_CICHLID:
-		control->i2c_address = EEPROM_I2C_MADDR_SIENNA_CICHLID;
+		control->i2c_address = EEPROM_I2C_MADDR_0;
 		break;
 
 	case CHIP_ALDEBARAN:
-		control->i2c_address = EEPROM_I2C_MADDR_ALDEBARAN;
+		control->i2c_address = EEPROM_I2C_MADDR_0;
 		break;
 
 	case CHIP_IP_DISCOVERY:
@@ -203,7 +202,7 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 
 	switch (adev->ip_versions[MP1_HWIP][0]) {
 	case IP_VERSION(13, 0, 0):
-		control->i2c_address = EEPROM_I2C_MADDR_ARCTURUS;
+		control->i2c_address = EEPROM_I2C_MADDR_4;
 		break;
 
 	default:
-- 
2.42.0



