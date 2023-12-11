Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CA351C35;
	Mon, 11 Dec 2023 18:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzaadiVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AA6C433C8;
	Mon, 11 Dec 2023 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320697;
	bh=dmXzMoEg545uc4yn6guq/0veCqpSrJywYl+keSZc25k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzaadiVGqYVw3GZhpxiJXunFMoJrXEb1nihBgFr1pBourfmhwZSixC66scHleEPtU
	 EbNTqzPsKn6dHbIjb3u0KnssO4RhdLC8hpvp58GPS/O3lHsfJIdGJ8kzR1uO6NghsU
	 hRG+X6UGcHMpAJkK4HHu6YL7RDzqAY25d/ueE/Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/194] drm/amdgpu: Remove redundant I2C EEPROM address
Date: Mon, 11 Dec 2023 19:22:28 +0100
Message-ID: <20231211182043.704328904@linuxfoundation.org>
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

[ Upstream commit da858deab88eb561f2196bc99b6dbd2320e56456 ]

Remove redundant EEPROM_I2C_MADDR_54H address, since we already have it
represented (ARCTURUS), and since we don't include the I2C device type
identifier in EEPROM memory addresses, i.e. that high up in the device
abstraction--we only use EEPROM memory addresses, as memory is continuously
represented by EEPROM device(s) on the I2C bus.

Add a comment describing what these memory addresses are, how they come
about and how they're usually extracted from the device address byte.

Cc: Candice Li <candice.li@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Alex Deucher <Alexander.Deucher@amd.com>
Fixes: c9bdc6c3cf39df ("drm/amdgpu: Add EEPROM I2C address support for ip discovery")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c    |  2 ++
 .../gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    | 24 ++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c
index 4d9eb0137f8c4..d6c4293829aab 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c
@@ -79,6 +79,8 @@
  * That is, for an I2C EEPROM driver everything is controlled by
  * the "eeprom_addr".
  *
+ * See also top of amdgpu_ras_eeprom.c.
+ *
  * P.S. If you need to write, lock and read the Identification Page,
  * (M24M02-DR device only, which we do not use), change the "7" to
  * "0xF" in the macro below, and let the client set bit 20 to 1 in
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 7268ae65c140c..1bb92a64f24af 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -33,12 +33,30 @@
 
 #include "amdgpu_reset.h"
 
+/* These are memory addresses as would be seen by one or more EEPROM
+ * chips strung on the I2C bus, usually by manipulating pins 1-3 of a
+ * set of EEPROM devices. They form a continuous memory space.
+ *
+ * The I2C device address includes the device type identifier, 1010b,
+ * which is a reserved value and indicates that this is an I2C EEPROM
+ * device. It also includes the top 3 bits of the 19 bit EEPROM memory
+ * address, namely bits 18, 17, and 16. This makes up the 7 bit
+ * address sent on the I2C bus with bit 0 being the direction bit,
+ * which is not represented here, and sent by the hardware directly.
+ *
+ * For instance,
+ *   50h = 1010000b => device type identifier 1010b, bits 18:16 = 000b, address 0.
+ *   54h = 1010100b => --"--, bits 18:16 = 100b, address 40000h.
+ *   56h = 1010110b => --"--, bits 18:16 = 110b, address 60000h.
+ * Depending on the size of the I2C EEPROM device(s), bits 18:16 may
+ * address memory in a device or a device on the I2C bus, depending on
+ * the status of pins 1-3. See top of amdgpu_eeprom.c.
+ */
 #define EEPROM_I2C_MADDR_VEGA20         0x0
 #define EEPROM_I2C_MADDR_ARCTURUS       0x40000
 #define EEPROM_I2C_MADDR_ARCTURUS_D342  0x0
 #define EEPROM_I2C_MADDR_SIENNA_CICHLID 0x0
 #define EEPROM_I2C_MADDR_ALDEBARAN      0x0
-#define EEPROM_I2C_MADDR_54H            (0x54UL << 16)
 
 /*
  * The 2 macros bellow represent the actual size in bytes that
@@ -130,7 +148,7 @@ static bool __get_eeprom_i2c_addr_ip_discovery(struct amdgpu_device *adev,
 	switch (adev->ip_versions[MP1_HWIP][0]) {
 	case IP_VERSION(13, 0, 0):
 	case IP_VERSION(13, 0, 10):
-		control->i2c_address = EEPROM_I2C_MADDR_54H;
+		control->i2c_address = EEPROM_I2C_MADDR_ARCTURUS;
 		return true;
 	default:
 		return false;
@@ -185,7 +203,7 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 
 	switch (adev->ip_versions[MP1_HWIP][0]) {
 	case IP_VERSION(13, 0, 0):
-		control->i2c_address = EEPROM_I2C_MADDR_54H;
+		control->i2c_address = EEPROM_I2C_MADDR_ARCTURUS;
 		break;
 
 	default:
-- 
2.42.0



