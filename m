Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E369B4F96B5;
	Thu, 17 Sep 2026 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661313; cv=none; b=h+Z2Er+tWqzmfZm5iSiIvKddn9RgIzcK/zZcPX4qbTv5aTw8ovoRxRwyPHn9sftgmbBpVOi4OeOT887q7sjzuQKnBqGw/3u13R/RfOmubXuOY3Yf4T30H0kFzO4lGgNYKDbh+137l6AaTf2F9W24Flhp1JCVF6f7+vVN/+UBSiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661313; c=relaxed/simple;
	bh=9RBDWb1pLFbpUYWtXNGeLXWHr3UABS4FSFTjk+J8XLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEdLxPZAjyLqZ4z7Gbu9BDsm+YY/svf4KK+sNMBlbDqUQdOdQjzhee1X7jFMCfmq5LtJRX6qd2WDN75U+qronDcXg3S6TJAnfRGRbBEay+scJSr7ggScWAiAgIKZQxNnvLtjJbUtYOh/B3+McUWjEr1ijjcDP6SjoNLc0O0CEpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVNNLu2U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVNNLu2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CB31F000FF;
	Thu, 17 Sep 2026 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661311;
	bh=LxPUI3oB/IK3jkhtJf8yvxnkt02yraee/QFxatLR5C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVNNLu2U0yswjayeXUpD7VU4a+m6wohzdBDT/4JCUVaOuXz+Sod2nFiEjp8tt7kXK
	 jmc6u54RdJBKdm3OqgFPeUBHVx3sL0nWngBYBQWmPVPwnT8Learh38JbbI5NxXDZoN
	 /dvu50QJSruEZRPfUJWSW3CyJPuMBizTfc7XRNdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0153/1250] drm/amdgpu: Bound GPIO I2C table entry count from VBIOS
Date: Thu, 17 Sep 2026 15:59:08 +0100
Message-ID: <20260917151556.220392358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 24 +++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 763f2b8dcf13a..b8f7e3a18d324 100644
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
@@ -158,8 +171,7 @@ void amdgpu_atombios_oem_i2c_init(struct amdgpu_device *adev, u8 i2c_id)
 	if (amdgpu_atom_parse_data_header(ctx, index, &size, NULL, NULL, &data_offset)) {
 		i2c_info = (struct _ATOM_GPIO_I2C_INFO *)(ctx->bios + data_offset);
 
-		num_indices = (size - sizeof(ATOM_COMMON_TABLE_HEADER)) /
-			sizeof(ATOM_GPIO_I2C_ASSIGMENT);
+		num_indices = amdgpu_atombios_gpio_i2c_num_entries(size);
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
-- 
2.53.0



