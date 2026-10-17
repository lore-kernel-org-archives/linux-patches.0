Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE85394470;
	Sat, 17 Oct 2026 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260479; cv=none; b=YBEoquEp+4LaiTB9yRjl3CANrXgWsVhRU/auQgItqVRPJfCmhaQPujVEjGTW2jOItinHcPOjHpBh/kln4HqDcQlOb/KZWCT/y91xJFF8FB1ydngrDp6tXCjQ25Uwjdc1Vv8i2QTFGVyl4d2V/Zbrle8QofU49yg1fLJtAS6Dft8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260479; c=relaxed/simple;
	bh=rQpD91eb9pmZ1zrB5c8g9CAtHUMn4g6u9VgUXih7zpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8dQOPj0d731c8LF6KoDD140W3psJkuModezgdmQHA0j3NydolA/TL03LC4SrKikVDXnqDbdaIIDu+BFOQu++2U0GNdl2rmImYil2T9pjdM0vOfMYQxaRUop9v29ckO/F0WZaFonzIaMI11JlXaRYlRr5DTXp2M8VywBcvGlmTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofHoFVc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofHoFVc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5501F000C4;
	Sat, 17 Oct 2026 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260478;
	bh=YS3CQMjSn8F0q9LfUyUk2FK4jQR5FDX2MIbk4lGmkDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofHoFVc/zTaCcx0rcFoJ88S77kKtMdYSOWnGNQsouha1ZsBXxLxHz9/z49mIASXfi
	 YX/lgUkdyE5p1aZFjFslv0wK2fD4Aw+dLLO64XjCniFzcnh965LX8aUt+OILaNf4Eu
	 kxAhbDet1OYdoT+74rvUcuPjJhBHX/10G8AvrIBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1541/1674] drm/amdgpu: Bound GPIO I2C table entry count from VBIOS
Date: Sat, 17 Oct 2026 18:03:33 +0200
Message-ID: <20261017160510.667986782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

[ Upstream commit a99cd231cd924b7160fecb9fb3a94b801522323b ]

Reject undersized tables and cap the derived entry count
to AMDGPU_MAX_I2C_BUS so we do not overrun adev->i2c_bus[]
or walk an absurd number of entries on corrupt size fields.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 21 ++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 31d12c1cf6aeb..fd9e4f1054b58 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -36,6 +36,21 @@
 #include "atombios_encoders.h"
 #include "bif/bif_4_1_d.h"
 
+/* VBIOS-reported table size is unchecked against the image; cap iterations and
+ * adev->i2c_bus[] indexing to AMDGPU_MAX_I2C_BUS.
+ */
+static int amdgpu_atombios_gpio_i2c_num_entries(uint16_t size)
+{
+	u32 bytes;
+
+	if (size < sizeof(ATOM_COMMON_TABLE_HEADER))
+		return 0;
+
+	bytes = size - sizeof(ATOM_COMMON_TABLE_HEADER);
+	return (int)min_t(u32, bytes / sizeof(ATOM_GPIO_I2C_ASSIGMENT),
+			  AMDGPU_MAX_I2C_BUS);
+}
+
 static struct amdgpu_i2c_bus_rec amdgpu_atombios_get_bus_rec_for_i2c_gpio(ATOM_GPIO_I2C_ASSIGMENT *gpio)
 {
 	struct amdgpu_i2c_bus_rec i2c;
@@ -96,8 +111,7 @@ struct amdgpu_i2c_bus_rec amdgpu_atombios_lookup_i2c_gpio(struct amdgpu_device *
 	if (amdgpu_atom_parse_data_header(ctx, index, &size, NULL, NULL, &data_offset)) {
 		i2c_info = (struct _ATOM_GPIO_I2C_INFO *)(ctx->bios + data_offset);
 
-		num_indices = (size - sizeof(ATOM_COMMON_TABLE_HEADER)) /
-			sizeof(ATOM_GPIO_I2C_ASSIGMENT);
+		num_indices = amdgpu_atombios_gpio_i2c_num_entries(size);
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
@@ -127,8 +141,7 @@ void amdgpu_atombios_i2c_init(struct amdgpu_device *adev)
 	if (amdgpu_atom_parse_data_header(ctx, index, &size, NULL, NULL, &data_offset)) {
 		i2c_info = (struct _ATOM_GPIO_I2C_INFO *)(ctx->bios + data_offset);
 
-		num_indices = (size - sizeof(ATOM_COMMON_TABLE_HEADER)) /
-			sizeof(ATOM_GPIO_I2C_ASSIGMENT);
+		num_indices = amdgpu_atombios_gpio_i2c_num_entries(size);
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
-- 
2.53.0



