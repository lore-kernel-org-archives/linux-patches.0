Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898B0263F52;
	Tue, 11 Nov 2025 01:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823118; cv=none; b=GZR2p2IExDioopOo83OsCBi5du6hSjyyw8jVremp1UXBpyY7QRkcyaOqFOAEPmYdOAuf0flkTxuiEDsANLSE0Me8pD1Qg4GyS8OKVG75O94WyR894kC07OfBXLAwcSBb48tQdgGUyW5Jn3k4NKCP4o/dMXJHl4OSSnF/0jnlB9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823118; c=relaxed/simple;
	bh=9JzFAF/UyELePe+9H0mR1BHy1hEsu5ajBZQcyAs4IYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGa9dZphSkk+274C4/MgH8RI6EcHZHNq8dqff0RF3QKzbmoGgCNFokT6MVTytiGOLIS56EbIKP7y+azq1qvfuWKsUBrknMribciwnY5cOpAcXvgS8MDkF/Ye01Dlxk8Qnd7JpWzQU3UDyT+NuR/Efl4wj3szrIElvOas6txy6Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brV1zsQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brV1zsQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0639DC4CEF5;
	Tue, 11 Nov 2025 01:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823118;
	bh=9JzFAF/UyELePe+9H0mR1BHy1hEsu5ajBZQcyAs4IYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brV1zsQSDP5bJ0HAz5XqJwwiPnqMstYvl2NfawG7Kf8T7XyY2pOddGZZkvUjpMYg+
	 buIzI4atT0E3fwJPJQCTqYD4u8m/Q7CwqX1yfQBDeAvCTmvsW9VcUzmMRTbLtjyGyY
	 y4m6gZXZrvVl6is9c0j8uLAnfZX97w+bRYG2VbCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 234/849] drm/amdgpu: add range check for RAS bad page address
Date: Tue, 11 Nov 2025 09:36:44 +0900
Message-ID: <20251111004542.102422506@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit 2b17c240e8cd9ac61d3c82277fbed27edad7f002 ]

Exclude invalid bad pages.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 58 ++++++++++++-------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 540817e296da6..c88123302a071 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -136,9 +136,9 @@ enum amdgpu_ras_retire_page_reservation {
 
 atomic_t amdgpu_ras_in_intr = ATOMIC_INIT(0);
 
-static bool amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
+static int amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
 				uint64_t addr);
-static bool amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
+static int amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
 				uint64_t addr);
 #ifdef CONFIG_X86_MCE_AMD
 static void amdgpu_register_bad_pages_mca_notifier(struct amdgpu_device *adev);
@@ -169,18 +169,16 @@ static int amdgpu_reserve_page_direct(struct amdgpu_device *adev, uint64_t addre
 	struct eeprom_table_record err_rec;
 	int ret;
 
-	if ((address >= adev->gmc.mc_vram_size) ||
-	    (address >= RAS_UMC_INJECT_ADDR_LIMIT)) {
+	ret = amdgpu_ras_check_bad_page(adev, address);
+	if (ret == -EINVAL) {
 		dev_warn(adev->dev,
-		         "RAS WARN: input address 0x%llx is invalid.\n",
-		         address);
+			"RAS WARN: input address 0x%llx is invalid.\n",
+			address);
 		return -EINVAL;
-	}
-
-	if (amdgpu_ras_check_bad_page(adev, address)) {
+	} else if (ret == 1) {
 		dev_warn(adev->dev,
-			 "RAS WARN: 0x%llx has already been marked as bad page!\n",
-			 address);
+			"RAS WARN: 0x%llx has already been marked as bad page!\n",
+			address);
 		return 0;
 	}
 
@@ -513,22 +511,16 @@ static ssize_t amdgpu_ras_debugfs_ctrl_write(struct file *f,
 		ret = amdgpu_ras_feature_enable(adev, &data.head, 1);
 		break;
 	case 2:
-		if ((data.inject.address >= adev->gmc.mc_vram_size &&
-		    adev->gmc.mc_vram_size) ||
-		    (data.inject.address >= RAS_UMC_INJECT_ADDR_LIMIT)) {
-			dev_warn(adev->dev, "RAS WARN: input address "
-					"0x%llx is invalid.",
+		/* umc ce/ue error injection for a bad page is not allowed */
+		if (data.head.block == AMDGPU_RAS_BLOCK__UMC)
+			ret = amdgpu_ras_check_bad_page(adev, data.inject.address);
+		if (ret == -EINVAL) {
+			dev_warn(adev->dev, "RAS WARN: input address 0x%llx is invalid.",
 					data.inject.address);
-			ret = -EINVAL;
 			break;
-		}
-
-		/* umc ce/ue error injection for a bad page is not allowed */
-		if ((data.head.block == AMDGPU_RAS_BLOCK__UMC) &&
-		    amdgpu_ras_check_bad_page(adev, data.inject.address)) {
-			dev_warn(adev->dev, "RAS WARN: inject: 0x%llx has "
-				 "already been marked as bad!\n",
-				 data.inject.address);
+		} else if (ret == 1) {
+			dev_warn(adev->dev, "RAS WARN: inject: 0x%llx has already been marked as bad!\n",
+					data.inject.address);
 			break;
 		}
 
@@ -3134,18 +3126,24 @@ static int amdgpu_ras_load_bad_pages(struct amdgpu_device *adev)
 	return ret;
 }
 
-static bool amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
+static int amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
 				uint64_t addr)
 {
 	struct ras_err_handler_data *data = con->eh_data;
+	struct amdgpu_device *adev = con->adev;
 	int i;
 
+	if ((addr >= adev->gmc.mc_vram_size &&
+	    adev->gmc.mc_vram_size) ||
+	    (addr >= RAS_UMC_INJECT_ADDR_LIMIT))
+		return -EINVAL;
+
 	addr >>= AMDGPU_GPU_PAGE_SHIFT;
 	for (i = 0; i < data->count; i++)
 		if (addr == data->bps[i].retired_page)
-			return true;
+			return 1;
 
-	return false;
+	return 0;
 }
 
 /*
@@ -3153,11 +3151,11 @@ static bool amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
  *
  * Note: this check is only for umc block
  */
-static bool amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
+static int amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
 				uint64_t addr)
 {
 	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
-	bool ret = false;
+	int ret = 0;
 
 	if (!con || !con->eh_data)
 		return ret;
-- 
2.51.0



