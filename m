Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29DB51C2D;
	Mon, 11 Dec 2023 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WC6QRNIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E49C433C8;
	Mon, 11 Dec 2023 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320713;
	bh=wPKTliAX0d9yq66RTNaWiPVR4ECGsw9evyB0Lter8z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WC6QRNIfMlbTEcafj+k47/uBmseK837+qq6ZEtYQAaNx+PeCyLB1glRML9nNW91L+
	 JcCoqiL9zpF/qH6hHzXIFrsIrACuJdldFaCcEX1xqmM6ObZDwzjF3wCS32tJpFouaQ
	 4DmsqSA7AFMwVjoyseVdDp928d8n7yMlGw/7KmOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/194] drm/amdgpu: simplify amdgpu_ras_eeprom.c
Date: Mon, 11 Dec 2023 19:22:33 +0100
Message-ID: <20231211182043.921313420@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 6246059a19d4cd32ef1af42a6ab016b779cd68c4 ]

All chips that support RAS also support IP discovery, so
use the IP versions rather than a mix of IP versions and
asic types.  Checking the validity of the atom_ctx pointer
is not required as the vbios is already fetched at this
point.

v2: add comments to id asic types based on feedback from Luben

Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Luben Tuikov <luben.tuikov@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    | 72 ++++++-------------
 1 file changed, 20 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 40cd9d8c4e870..c2827edb9d3d9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -106,48 +106,13 @@
 #define to_amdgpu_device(x) (container_of(x, struct amdgpu_ras, eeprom_control))->adev
 
 static bool __is_ras_eeprom_supported(struct amdgpu_device *adev)
-{
-	if (adev->asic_type == CHIP_IP_DISCOVERY) {
-		switch (adev->ip_versions[MP1_HWIP][0]) {
-		case IP_VERSION(13, 0, 0):
-		case IP_VERSION(13, 0, 10):
-			return true;
-		default:
-			return false;
-		}
-	}
-
-	return  adev->asic_type == CHIP_VEGA20 ||
-		adev->asic_type == CHIP_ARCTURUS ||
-		adev->asic_type == CHIP_SIENNA_CICHLID ||
-		adev->asic_type == CHIP_ALDEBARAN;
-}
-
-static bool __get_eeprom_i2c_addr_arct(struct amdgpu_device *adev,
-				       struct amdgpu_ras_eeprom_control *control)
-{
-	struct atom_context *atom_ctx = adev->mode_info.atom_context;
-
-	if (!control || !atom_ctx)
-		return false;
-
-	if (strnstr(atom_ctx->vbios_version,
-	            "D342",
-		    sizeof(atom_ctx->vbios_version)))
-		control->i2c_address = EEPROM_I2C_MADDR_0;
-	else
-		control->i2c_address = EEPROM_I2C_MADDR_4;
-
-	return true;
-}
-
-static bool __get_eeprom_i2c_addr_ip_discovery(struct amdgpu_device *adev,
-				       struct amdgpu_ras_eeprom_control *control)
 {
 	switch (adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(11, 0, 2): /* VEGA20 and ARCTURUS */
+	case IP_VERSION(11, 0, 7): /* Sienna cichlid */
 	case IP_VERSION(13, 0, 0):
+	case IP_VERSION(13, 0, 2): /* Aldebaran */
 	case IP_VERSION(13, 0, 10):
-		control->i2c_address = EEPROM_I2C_MADDR_4;
 		return true;
 	default:
 		return false;
@@ -178,29 +143,32 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 		return true;
 	}
 
-	switch (adev->asic_type) {
-	case CHIP_VEGA20:
-		control->i2c_address = EEPROM_I2C_MADDR_0;
+	switch (adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(11, 0, 2):
+		/* VEGA20 and ARCTURUS */
+		if (adev->asic_type == CHIP_VEGA20)
+			control->i2c_address = EEPROM_I2C_MADDR_0;
+		else if (strnstr(atom_ctx->vbios_version,
+				 "D342",
+				 sizeof(atom_ctx->vbios_version)))
+			control->i2c_address = EEPROM_I2C_MADDR_0;
+		else
+			control->i2c_address = EEPROM_I2C_MADDR_4;
 		return true;
-
-	case CHIP_ARCTURUS:
-		return __get_eeprom_i2c_addr_arct(adev, control);
-
-	case CHIP_SIENNA_CICHLID:
+	case IP_VERSION(11, 0, 7):
 		control->i2c_address = EEPROM_I2C_MADDR_0;
 		return true;
-
-	case CHIP_ALDEBARAN:
+	case IP_VERSION(13, 0, 2):
 		if (strnstr(atom_ctx->vbios_version, "D673",
 			    sizeof(atom_ctx->vbios_version)))
 			control->i2c_address = EEPROM_I2C_MADDR_4;
 		else
 			control->i2c_address = EEPROM_I2C_MADDR_0;
 		return true;
-
-	case CHIP_IP_DISCOVERY:
-		return __get_eeprom_i2c_addr_ip_discovery(adev, control);
-
+	case IP_VERSION(13, 0, 0):
+	case IP_VERSION(13, 0, 10):
+		control->i2c_address = EEPROM_I2C_MADDR_4;
+		return true;
 	default:
 		return false;
 	}
-- 
2.42.0



