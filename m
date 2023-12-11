Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278F05102A;
	Mon, 11 Dec 2023 18:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MH5FUm3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A53C433C7;
	Mon, 11 Dec 2023 18:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320695;
	bh=Gsblf123Cl2eHGZHYQDvtKTkxxHTtherBDkhHoY9leI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MH5FUm3SWrVr7/Ehos/KJiaSmPvcq/t+ZYIosjLfWRp52kypcuQdY32hR0ae+/jwi
	 ZiLOPRBA9O9R7E8gdWUJR9CJpomYMBwgHdHvZU0leLY+AbkiYD1HwQKUyiPFBa5b45
	 0rG6LRFGeMftHCdkcMq6560fb2LVLcpPEuhgljwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/194] drm/amdgpu: Add EEPROM I2C address support for ip discovery
Date: Mon, 11 Dec 2023 19:22:27 +0100
Message-ID: <20231211182043.655028129@linuxfoundation.org>
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit c9bdc6c3cf39df6db9c611d05fc512b1276b1cc8 ]

1. Update EEPROM_I2C_MADDR_SMU_13_0_0 to EEPROM_I2C_MADDR_54H
2. Add EEPROM I2C address support for smu v13_0_0 and v13_0_10.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 7dc39154822c5..7268ae65c140c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -38,7 +38,7 @@
 #define EEPROM_I2C_MADDR_ARCTURUS_D342  0x0
 #define EEPROM_I2C_MADDR_SIENNA_CICHLID 0x0
 #define EEPROM_I2C_MADDR_ALDEBARAN      0x0
-#define EEPROM_I2C_MADDR_SMU_13_0_0     (0x54UL << 16)
+#define EEPROM_I2C_MADDR_54H            (0x54UL << 16)
 
 /*
  * The 2 macros bellow represent the actual size in bytes that
@@ -124,6 +124,19 @@ static bool __get_eeprom_i2c_addr_arct(struct amdgpu_device *adev,
 	return true;
 }
 
+static bool __get_eeprom_i2c_addr_ip_discovery(struct amdgpu_device *adev,
+				       struct amdgpu_ras_eeprom_control *control)
+{
+	switch (adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(13, 0, 0):
+	case IP_VERSION(13, 0, 10):
+		control->i2c_address = EEPROM_I2C_MADDR_54H;
+		return true;
+	default:
+		return false;
+	}
+}
+
 static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 				  struct amdgpu_ras_eeprom_control *control)
 {
@@ -163,13 +176,16 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 		control->i2c_address = EEPROM_I2C_MADDR_ALDEBARAN;
 		break;
 
+	case CHIP_IP_DISCOVERY:
+		return __get_eeprom_i2c_addr_ip_discovery(adev, control);
+
 	default:
 		return false;
 	}
 
 	switch (adev->ip_versions[MP1_HWIP][0]) {
 	case IP_VERSION(13, 0, 0):
-		control->i2c_address = EEPROM_I2C_MADDR_SMU_13_0_0;
+		control->i2c_address = EEPROM_I2C_MADDR_54H;
 		break;
 
 	default:
-- 
2.42.0



