Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2283D1AB5;
	Sat, 17 Oct 2026 16:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255373; cv=none; b=GgqM4Kv6Sp0vxCItGW8k5jlyKrIfy+09TXSpWGCQfNQhBdXvkFv1ygRCF5o4ymY4DzRsUtgaFK9rSTUrrwi8JcEdhp+4FfbA+tVw039b7NXwQi/vi5wlTOrhsaA4IqmXWJDhrmiQtsBgCEzZz1NTVLYoscsDbe/C4yztuvVOnJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255373; c=relaxed/simple;
	bh=C26ncGQZZID5rjJLhfPUa0S572g0GQlmLMUEB5ijass=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCO0Sb2LcS1IDj7ln6Ei/zWq1CbHhp9880OChrmnZgLP1shLzMHJYucMzeel/wmuzkd945LI6KJ3lFvcY9O64SSXIgR1s+lRspaNqlgiQGcQE0jp1WMI2lRv+re1eBPVQEJ4+O6AsqywBbVM3BIJBum7tB6LalkhsjCbwRAkvZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKUEyp4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKUEyp4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A611F000C4;
	Sat, 17 Oct 2026 16:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255371;
	bh=3yT3Rwqs1mlCqNF7ZR7EHpB8T42x2HT3sENlJRbeX7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKUEyp4B/O/oOVSS4rQRdBxlA74LcoclNm0ILMmI8nncmsF5aMxiNz3DhEjHgSQX+
	 Xb2NO7+hlWeGCbZD26cnF/P2ieMPMOukFF4IyYleLIUahonjScVG3BqxwVcFeeqntY
	 GPF7c0IrNq6ITOL53RBozx/IAYPQS8rpixUxR2cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 747/869] drm/amdgpu: Bound GPIO I2C table entry count from VBIOS
Date: Sat, 17 Oct 2026 17:59:48 +0200
Message-ID: <20261017160056.088762869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9297460706579..9254b85d4e70d 100644
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



