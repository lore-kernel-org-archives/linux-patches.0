Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C74A35C6B2;
	Sat, 12 Sep 2026 09:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206261; cv=none; b=FahIxlQdshgND82r8vGHQmOUGd7V+SqUnQm6kHwOiTqM0ue26IrzdtdoutEAvJBYw9z2e10Ebzvd7GTcFNTizN5ZTo5e2Dp+Luag73vf9Qqv4ZhutAeBDpmzPnB3UXq4sXd/yBVhcZVlJd7YdHBoWqG9BrxlA9PUIGEUSIfKLjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206261; c=relaxed/simple;
	bh=Ly5+ji23Dq4kkJRlqJNXr5ijliFfB2imiXIvCW6CAEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqygaPlpsMmXJEnZxAzn+U2AmdfQCVKCfaVbjdmCK90Vk1v1QHzAjidcY1aPSrdodCtLZJ/otJg6xSvEcRnRHP6Sb7cMhExGlIeXlSnz/RRHYDfk1I9X3Iu/Ql6b5Zwzv1zZMm+qaBnToDGCPvMsbV6N7LBY505jvvq0/oG16Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2CnuxBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2CnuxBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7E21F000FF;
	Sat, 12 Sep 2026 09:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206258;
	bh=mrFoOrrMq9IKhGnkQ/CIv9CSQ/29FuGk15JmB+cjMLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2CnuxBIGJGSLY8v1y13rmT1NaWyr1vMBtiVlDCPWcEUfWkLjvyv8Ndb8S8TdfToP
	 ypBZrTLbfIpnz/GD/9EHYKvZv1kmMIjdayhJ/Zjk+WTMOreytOBMYUnsEjLwkyLCzN
	 XuN46MOcMv93wZbEjQ9UP7cHdxFf852rGyrTN4uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0169/1518] drm/amdgpu/pm/powerplay: bounds-check voltage index in Vega10 lookup
Date: Sat, 12 Sep 2026 08:38:58 +0200
Message-ID: <20260912065627.321055350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 6fa33f594e46e775a94097f71b486d7b006b6917 ]

vddInd, vddciInd and mvddInd from VBIOS-parsed tables index into vddc,
vddci and vddmem lookup tables without bounds checks across nine sites.
Return -EINVAL when any index is out of range.

Fixes: f83a9991648b ("drm/amd/powerplay: add Vega10 powerplay support (v5)")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 35 ++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 9ace863792d48..b3fed2a478aab 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -685,10 +685,18 @@ static int vega10_patch_voltage_dependency_tables_with_lookup_table(
 			case 3: vdt = table_info->vdd_dep_on_pixclk; break;
 			case 4: vdt = table_info->vdd_dep_on_dispclk; break;
 			case 5: vdt = table_info->vdd_dep_on_phyclk; break;
+			default:
+				continue;
 		}
 
 		for (entry_id = 0; entry_id < vdt->count; entry_id++) {
 			voltage_id = vdt->entries[entry_id].vddInd;
+			if (voltage_id >= table_info->vddc_lookup_table->count) {
+				pr_err("amdgpu: clk_dep[%u][%u] vddc index %u out of bounds (%u)\n",
+				       i, entry_id, voltage_id,
+				       table_info->vddc_lookup_table->count);
+				return -EINVAL;
+			}
 			vdt->entries[entry_id].vddc =
 					table_info->vddc_lookup_table->entries[voltage_id].us_vdd;
 		}
@@ -696,23 +704,48 @@ static int vega10_patch_voltage_dependency_tables_with_lookup_table(
 
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
+
 		voltage_id = mclk_table->entries[entry_id].vddciInd;
+		if (voltage_id >= table_info->vddci_lookup_table->count) {
+			pr_err("amdgpu: mclk[%u] vddci index %u out of bounds (%u)\n",
+			       entry_id, voltage_id,
+			       table_info->vddci_lookup_table->count);
+			return -EINVAL;
+		}
 		mclk_table->entries[entry_id].vddci =
 				table_info->vddci_lookup_table->entries[voltage_id].us_vdd;
+
 		voltage_id = mclk_table->entries[entry_id].mvddInd;
+		if (voltage_id >= table_info->vddmem_lookup_table->count) {
+			pr_err("amdgpu: mclk[%u] vddmem index %u out of bounds (%u)\n",
+			       entry_id, voltage_id,
+			       table_info->vddmem_lookup_table->count);
+			return -EINVAL;
+		}
 		mclk_table->entries[entry_id].mvdd =
 				table_info->vddmem_lookup_table->entries[voltage_id].us_vdd;
 	}
 
-
 	return 0;
 
 }
-- 
2.53.0



