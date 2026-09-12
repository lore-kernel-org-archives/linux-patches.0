Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1896382292;
	Sat, 12 Sep 2026 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242301; cv=none; b=LVfXXoZ/Q6QsaZGFIryfG2oJoOi69+gyXZ6YvEp15dbloIeVX8KuNx7MCDTHxrqKdnEs/E3c7HZAoeIxDoUkLAas1MkIpzkfg80t6z5KHBdPPW5c2g+f59KJXitQ1a622mBnJMyh2qld5N3st/L6R0e7yRedYm9B8eiikrQnrx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242301; c=relaxed/simple;
	bh=186OD9O+eXWAZQb2uLxX6J9StiEUUd+LghmS5+xI2F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t93mT6Ij2Tj0rVgL8ztyjbY3zcXCCgZOe04eCN20ZWKyrw/duqIgiaBzbASrJpn14SJjsvyW5DJjclXR64dguDNzBanIPhA95SCtrUuWnaITvy5dpgVt9PXTBVnmt+XZ6KqaADuBB9nmy2aL+FLLA7lPi4OeQCGkSwgnQnSBfZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTjmsrHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTjmsrHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240951F000FF;
	Sat, 12 Sep 2026 19:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242299;
	bh=82K/Vq34yzf6yqgQUmIA4jol/zm0fRb3udLTCLcLNWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTjmsrHZOCnFdNgCBaF29UvVeUQLO/W+i1fn3goRsOFVjZeNdAuG/+NkG/xcUanlM
	 Tvwj4vnwQRQqOTnMk9WA6j57E/F41HoqDV5Sr8pTzm25x+skk/36evRAWmJNBPX8Md
	 SIjsukgvMSnmiC41X073E4H1qKKTFi1oOx5GIjzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/798] drm/amdgpu/pm/powerplay: bounds-check voltage index in SMU7 lookup
Date: Sat, 12 Sep 2026 08:59:44 +0200
Message-ID: <20260912065525.321205327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 3a8a05477cda6c8293e2b629495b42981dcaba32 ]

vddInd and vddcInd fields from VBIOS-parsed tables are used to index into
voltage lookup tables without a bounds check. Return -EINVAL when any
index is out of range.

Fixes: c82baa281843 ("drm/amd/powerplay: add Tonga dpm support (v3)")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index e2816c88cfe52..f2852e5c505ed 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -1949,12 +1949,24 @@ static int smu7_patch_voltage_dependency_tables_with_lookup_table(
 	if (data->vdd_gfx_control == SMU7_VOLTAGE_CONTROL_BY_SVID2) {
 		for (entry_id = 0; entry_id < sclk_table->count; ++entry_id) {
 			voltage_id = sclk_table->entries[entry_id].vddInd;
+			if (voltage_id >= table_info->vddgfx_lookup_table->count) {
+				pr_err("amdgpu: sclk[%u] vddgfx index %u out of bounds (%u)\n",
+				       entry_id, voltage_id,
+				       table_info->vddgfx_lookup_table->count);
+				return -EINVAL;
+			}
 			sclk_table->entries[entry_id].vddgfx =
 				table_info->vddgfx_lookup_table->entries[voltage_id].us_vdd;
 		}
 	} else {
 		for (entry_id = 0; entry_id < sclk_table->count; ++entry_id) {
 			voltage_id = sclk_table->entries[entry_id].vddInd;
+			if (voltage_id >= table_info->vddc_lookup_table->count) {
+				pr_err("amdgpu: sclk[%u] vddc index %u out of bounds (%u)\n",
+				       entry_id, voltage_id,
+				       table_info->vddc_lookup_table->count);
+				return -EINVAL;
+			}
 			sclk_table->entries[entry_id].vddc =
 				table_info->vddc_lookup_table->entries[voltage_id].us_vdd;
 		}
@@ -1962,12 +1974,24 @@ static int smu7_patch_voltage_dependency_tables_with_lookup_table(
 
 	for (entry_id = 0; entry_id < mclk_table->count; ++entry_id) {
 		voltage_id = mclk_table->entries[entry_id].vddInd;
+		if (voltage_id >= table_info->vddc_lookup_table->count) {
+			pr_err("amdgpu: mclk[%u] vddc index %u out of bounds (%u)\n",
+			       entry_id, voltage_id,
+			       table_info->vddc_lookup_table->count);
+			return -EINVAL;
+		}
 		mclk_table->entries[entry_id].vddc =
 			table_info->vddc_lookup_table->entries[voltage_id].us_vdd;
 	}
 
 	for (entry_id = 0; entry_id < mm_table->count; ++entry_id) {
 		voltage_id = mm_table->entries[entry_id].vddcInd;
+		if (voltage_id >= table_info->vddc_lookup_table->count) {
+			pr_err("amdgpu: mm[%u] vddc index %u out of bounds (%u)\n",
+			       entry_id, voltage_id,
+			       table_info->vddc_lookup_table->count);
+			return -EINVAL;
+		}
 		mm_table->entries[entry_id].vddc =
 			table_info->vddc_lookup_table->entries[voltage_id].us_vdd;
 	}
-- 
2.53.0



