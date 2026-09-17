Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A264F96B6;
	Thu, 17 Sep 2026 16:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661319; cv=none; b=jzT0EA0CysRNfJowGZdvGdZmwzdDJoV0gKwqfEHI+84ZXc8JZlAwhzq5kqEe0dMDWxTbmXN0nlWRW8OZYQbosXV2+LYxb/mBfXxQvYky+69JaCpeN1OKspf3qlAj/iV1tVemTafXnx5E27JWblHKN0JHrL0xFV9a90xnIVmTuZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661319; c=relaxed/simple;
	bh=z/+K3pn2XldUU4U1LX0VdtBqh4ihoPbhcvISBdu/j8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giYs7bEjc/Sh5v/nLFGZcSGZiZW65WnCTleUGInAlB6lfDLwaDekyCMeiGW1egT8zKSeaPUKzs+MuhV2sx5XJahqceF8aU2d6OjT0mL76vWTfjR0jEKQzeut/bQTX7eZWgZdGK/3s07CQ+o0eGlqlMWH5Fsptj2YpmpKjfES6Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GT9OII5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GT9OII5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E55A1F00899;
	Thu, 17 Sep 2026 16:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661317;
	bh=QaPTzZ8uKT2BSVu1BL4WAyFtgqMdKt/knT6sp22yJik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GT9OII5gAl0XOvaGMQYIilkAzWBowCDJCR9V0yF8E0UpLAHzmvh4b1TKdSkv1f0gU
	 BB60aYFp/kW7iLrEW7OqwbDsVJsHICrdjjN0G/b/iKGRdJg1xop5qKJ2DYMQjtm9KP
	 u+gcnJnccuEF7Ae9Wq32lp1gqyDa6GhvJA/yqW2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0155/1250] drm/amdgpu: check and drop invalid bad page records
Date: Thu, 17 Sep 2026 15:59:10 +0100
Message-ID: <20260917151556.279936734@linuxfoundation.org>
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

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit 3999aa4a04a04167d70bfe4dc3ba239257e5b5df ]

Check and drop invalid bad page records.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 27 +++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 9df691364a18c..4c1a65fffede7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2884,6 +2884,25 @@ static int amdgpu_ras_mca2pa(struct amdgpu_device *adev,
 		return  -EINVAL;
 }
 
+static bool __check_record_in_range(struct amdgpu_device *adev,
+			struct eeprom_table_record *bps, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (bps[i].retired_page >=
+			(adev->gmc.real_vram_size >> AMDGPU_GPU_PAGE_SHIFT)) {
+			dev_warn(adev->dev,
+				"Recorded address out of range: 0x%llx, 0x%llx, 0x%x, 0x%x\n",
+				bps[i].address, bps[i].retired_page,
+				bps[i].mem_channel, bps[i].mcumc_id);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 					struct eeprom_table_record *bps, int count)
 {
@@ -2891,6 +2910,9 @@ static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
 	struct ras_err_handler_data *data = con->eh_data;
 
+	if (!__check_record_in_range(adev, bps, count))
+		return 0;
+
 	for (j = 0; j < count; j++) {
 		if (!data->space_left &&
 		    amdgpu_ras_realloc_eh_data_space(adev, data, 256)) {
@@ -5370,6 +5392,11 @@ int amdgpu_ras_reserve_page(struct amdgpu_device *adev, uint64_t pfn)
 	uint64_t start = pfn << AMDGPU_GPU_PAGE_SHIFT;
 	int ret = 0;
 
+	if (pfn >= (adev->gmc.real_vram_size >> AMDGPU_GPU_PAGE_SHIFT)) {
+		dev_warn(adev->dev, "Ignoring out-of-range bad page 0x%llx", start);
+		return 0;
+	}
+
 	if (amdgpu_ras_check_critical_address(adev, start))
 		return 0;
 
-- 
2.53.0



