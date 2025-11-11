Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F53C248883;
	Tue, 11 Nov 2025 01:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823113; cv=none; b=s/6DngWp9cA+1vaSnpwp2XpGRMOrtE3hfmLAhTJp/mPUogRk/+/SWK1M5lh6jdmAMUdICO36UPoFcVi8tVvgRzHv5yekzjcPPksLNZFj1xkLLY3rv8+eE82DOG+Oq8lSFOrbyOjs3heq9H6HFA89mC2Akg4XlGXAwrVOsIewCbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823113; c=relaxed/simple;
	bh=sdMGPK8yLkeYyu/GwEY7j6bbZrRdbv6Jx+rpGjd6Yjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Valb9SM3GZPbeQY/kFaZ12As6T7LiY0tNUMyv/UkgDXp914SAECgIlUXl/GktKDDu/Cs2SzgXzTIdSSU04px5ZhVhLXE/whwXAKlLRlMvW98Aw72VdpYKMWRlYEtsDlE5RF+lxfqD/cWwHaKN8n8pz+UFycmIqi3C+/sjU59Ubo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFOLVgfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFOLVgfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7E5C113D0;
	Tue, 11 Nov 2025 01:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823113;
	bh=sdMGPK8yLkeYyu/GwEY7j6bbZrRdbv6Jx+rpGjd6Yjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFOLVgfLHCrjeXuh0Nl4kHJN36VDla73/Z2Y4WhFXFFtOVu1sd6uFq+bVOCig+Gik
	 zT7UvBsezoanvMBoQ2iqdKE/wnPkJ/4Abp//sl9VXi9muYyGQ9nDGbhwf3TCHCcnYG
	 GkvEIwTTFtozHxZ9lekUnDj+moDc+33WDXq351mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/565] drm/amdgpu: add range check for RAS bad page address
Date: Tue, 11 Nov 2025 09:40:30 +0900
Message-ID: <20251111004530.849459268@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 1a1395c5fff15..f5148027107bc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -134,9 +134,9 @@ enum amdgpu_ras_retire_page_reservation {
 
 atomic_t amdgpu_ras_in_intr = ATOMIC_INIT(0);
 
-static bool amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
+static int amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
 				uint64_t addr);
-static bool amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
+static int amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
 				uint64_t addr);
 #ifdef CONFIG_X86_MCE_AMD
 static void amdgpu_register_bad_pages_mca_notifier(struct amdgpu_device *adev);
@@ -167,18 +167,16 @@ static int amdgpu_reserve_page_direct(struct amdgpu_device *adev, uint64_t addre
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
 
@@ -511,22 +509,16 @@ static ssize_t amdgpu_ras_debugfs_ctrl_write(struct file *f,
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
 
@@ -2774,18 +2766,24 @@ static int amdgpu_ras_load_bad_pages(struct amdgpu_device *adev)
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
@@ -2793,11 +2791,11 @@ static bool amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
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



