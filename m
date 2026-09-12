Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966FD37CD3E;
	Sat, 12 Sep 2026 19:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242303; cv=none; b=Cj6xZFeyPT9WgcyxUekLWA5wkF0xyccTak8B9CTxO8J3/s65hkafV6q/j0gVZ53t17U4InSKip4CyEyPXfX+fDBBRJK62gqjMlHF0d653lph3JeQaMQz9kEapdTJ80jvGKNROfXINUkNWG1n8ZpaKy13BlsleiDSAH1JV/t8ESc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242303; c=relaxed/simple;
	bh=Wh+qfJQJ/ApZhiF3icbC9DTLKDN24F5i9kxXEDIrw/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMF79QJkLFWPg1eUftzID6aHl548jQr0BWNV8s0tk5Aixh2e7Nd27V/y7GeZCQ0/ZvJemLs/HGZMLXGhhPWt3GcN4Sh88dDeJ+hvKAqW0zoWqEoMjT0f+n6yMucgAiSFb5ECPh1OAWBbLyhymtNthN/OjQHLt4yy8KlLCflCws0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHRk/PA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHRk/PA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DB51F000FF;
	Sat, 12 Sep 2026 19:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242302;
	bh=8iFYlCsf4Zhz/wI8qVAa8XlItvPZYqtLJJMZpFfyGRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHRk/PA4NNKzNWIS6MvFuYIq6Jimf+lUJQ+jqtdF1WLWfSjOQaFLjIDFumkTWsXHN
	 AJqnShoQXzQpnLMhbV/h+sCiNtdIUCG68M2eQzuDX5Uj5dx44iizO7zzX9Gi0ige03
	 p5JjmMJwH1yT1zhQqxvqxyd7pY0nBztwezGdJUf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/798] drm/amdgpu/pm/powerplay: bounds-check voltage index in Vega10 lookup
Date: Sat, 12 Sep 2026 08:59:45 +0200
Message-ID: <20260912065525.344427413@linuxfoundation.org>
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
index 79a41180adf13..6a4ee61612313 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -686,10 +686,18 @@ static int vega10_patch_voltage_dependency_tables_with_lookup_table(
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
@@ -697,23 +705,48 @@ static int vega10_patch_voltage_dependency_tables_with_lookup_table(
 
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



