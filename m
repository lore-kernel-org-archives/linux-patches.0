Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0511D9A42;
	Tue, 15 Oct 2024 11:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992307; cv=none; b=K8Fr4Hh8ycsSLHpRtSo8B8QK8Uo3IINrk4os/uhl2RVdwZ/pdnOt5WVig/gsOiOWmTx8z99dntC6iYV0evqIFB4FOyc/TYDwQc7dQbvauoaHQg9U7UkmvH9AFC4eJBEq+8JMuHnDu8ykwFjfqkivpw1XNJ+uap8/LvyjXAthfK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992307; c=relaxed/simple;
	bh=2ta5B0Vm32u/f1O64Hvr/MmNmExPsnJrY8TOWXzTC10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLYW2Or+Uadhpl6VstxlWnDGjw/lDMrjHrZj95vtfMbZhFykpIXe01598e555K4J4FIIt/wFYhxD0oWz8lVQtrRqaPEFoR2NGDGYRum9rdBD5E+P5r8jIqQjA/hqeDpLz7L4I5FzJM5bd4+Lwi/fjTZ4WwAuoUqKrqkIA2XgTJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WgJfOnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WgJfOnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A81C4CEC6;
	Tue, 15 Oct 2024 11:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992307;
	bh=2ta5B0Vm32u/f1O64Hvr/MmNmExPsnJrY8TOWXzTC10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WgJfOnqtIpE6uBY/Js7AivaYpiXgoEnJnHul7rrkUyg4Fr7CaQxy+JbuvTgvPW/D
	 O2dqC3mwulsEHvszLHA22jJ+4S4xDLEr51ITvT51JQpVI/GlwMwwK3TfqQH3V8KDEg
	 03VKQYRTOq/8+qyTOCPVPStgjkTByfMb0CBGCPM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Ariel Levkovich <lariel@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/691] net/mlx5: Add IFC bits and enums for flow meter
Date: Tue, 15 Oct 2024 13:19:55 +0200
Message-ID: <20241015112442.213392656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit f5d23ee137e51b4e5cd5d263b144d5e6719f6e52 ]

Add/extend structure layouts and defines for flow meter.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 452ef7f86036 ("net/mlx5: Add missing masks and QoS bit masks for scheduling elements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/device.h   |   1 +
 include/linux/mlx5/mlx5_ifc.h | 114 ++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 3e72133545ca..1bb4945885ce 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -454,6 +454,7 @@ enum {
 
 	MLX5_OPCODE_UMR			= 0x25,
 
+	MLX5_OPCODE_ACCESS_ASO		= 0x2d,
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5151573da9b2..e42d6d2d8ecb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -434,7 +434,9 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         max_modify_header_actions[0x8];
 	u8         max_ft_level[0x8];
 
-	u8         reserved_at_40[0x20];
+	u8         reserved_at_40[0x6];
+	u8         execute_aso[0x1];
+	u8         reserved_at_47[0x19];
 
 	u8         reserved_at_60[0x2];
 	u8         reformat_insert[0x1];
@@ -889,7 +891,17 @@ struct mlx5_ifc_qos_cap_bits {
 
 	u8         max_tsar_bw_share[0x20];
 
-	u8         reserved_at_100[0x700];
+	u8         reserved_at_100[0x20];
+
+	u8         reserved_at_120[0x3];
+	u8         log_meter_aso_granularity[0x5];
+	u8         reserved_at_128[0x3];
+	u8         log_meter_aso_max_alloc[0x5];
+	u8         reserved_at_130[0x3];
+	u8         log_max_num_meter_aso[0x5];
+	u8         reserved_at_138[0x8];
+
+	u8         reserved_at_140[0x6c0];
 };
 
 struct mlx5_ifc_debug_cap_bits {
@@ -3156,6 +3168,7 @@ enum {
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 = 0x800,
 	MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT = 0x1000,
 	MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT = 0x2000,
+	MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO = 0x4000,
 };
 
 enum {
@@ -3171,6 +3184,38 @@ struct mlx5_ifc_vlan_bits {
 	u8         vid[0xc];
 };
 
+enum {
+	MLX5_FLOW_METER_COLOR_RED	= 0x0,
+	MLX5_FLOW_METER_COLOR_YELLOW	= 0x1,
+	MLX5_FLOW_METER_COLOR_GREEN	= 0x2,
+	MLX5_FLOW_METER_COLOR_UNDEFINED	= 0x3,
+};
+
+enum {
+	MLX5_EXE_ASO_FLOW_METER		= 0x2,
+};
+
+struct mlx5_ifc_exe_aso_ctrl_flow_meter_bits {
+	u8        return_reg_id[0x4];
+	u8        aso_type[0x4];
+	u8        reserved_at_8[0x14];
+	u8        action[0x1];
+	u8        init_color[0x2];
+	u8        meter_id[0x1];
+};
+
+union mlx5_ifc_exe_aso_ctrl {
+	struct mlx5_ifc_exe_aso_ctrl_flow_meter_bits exe_aso_ctrl_flow_meter;
+};
+
+struct mlx5_ifc_execute_aso_bits {
+	u8        valid[0x1];
+	u8        reserved_at_1[0x7];
+	u8        aso_object_id[0x18];
+
+	union mlx5_ifc_exe_aso_ctrl exe_aso_ctrl;
+};
+
 struct mlx5_ifc_flow_context_bits {
 	struct mlx5_ifc_vlan_bits push_vlan;
 
@@ -3202,7 +3247,9 @@ struct mlx5_ifc_flow_context_bits {
 
 	struct mlx5_ifc_fte_match_param_bits match_value;
 
-	u8         reserved_at_1200[0x600];
+	struct mlx5_ifc_execute_aso_bits execute_aso[4];
+
+	u8         reserved_at_1300[0x500];
 
 	union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits destination[];
 };
@@ -5825,7 +5872,9 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 
 	u8         obj_id[0x20];
 
-	u8         reserved_at_60[0x20];
+	u8         reserved_at_60[0x3];
+	u8         log_obj_range[0x5];
+	u8         reserved_at_68[0x18];
 };
 
 struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
@@ -11190,12 +11239,14 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = BIT_ULL(0x24),
 };
 
 enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 };
 
 enum {
@@ -11270,6 +11321,61 @@ struct mlx5_ifc_create_encryption_key_in_bits {
 	struct mlx5_ifc_encryption_key_obj_bits encryption_key_object;
 };
 
+enum {
+	MLX5_FLOW_METER_MODE_BYTES_IP_LENGTH		= 0x0,
+	MLX5_FLOW_METER_MODE_BYTES_CALC_WITH_L2		= 0x1,
+	MLX5_FLOW_METER_MODE_BYTES_CALC_WITH_L2_IPG	= 0x2,
+	MLX5_FLOW_METER_MODE_NUM_PACKETS		= 0x3,
+};
+
+struct mlx5_ifc_flow_meter_parameters_bits {
+	u8         valid[0x1];
+	u8         bucket_overflow[0x1];
+	u8         start_color[0x2];
+	u8         both_buckets_on_green[0x1];
+	u8         reserved_at_5[0x1];
+	u8         meter_mode[0x2];
+	u8         reserved_at_8[0x18];
+
+	u8         reserved_at_20[0x20];
+
+	u8         reserved_at_40[0x3];
+	u8         cbs_exponent[0x5];
+	u8         cbs_mantissa[0x8];
+	u8         reserved_at_50[0x3];
+	u8         cir_exponent[0x5];
+	u8         cir_mantissa[0x8];
+
+	u8         reserved_at_60[0x20];
+
+	u8         reserved_at_80[0x3];
+	u8         ebs_exponent[0x5];
+	u8         ebs_mantissa[0x8];
+	u8         reserved_at_90[0x3];
+	u8         eir_exponent[0x5];
+	u8         eir_mantissa[0x8];
+
+	u8         reserved_at_a0[0x60];
+};
+
+struct mlx5_ifc_flow_meter_aso_obj_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x40];
+
+	u8         reserved_at_80[0x8];
+	u8         meter_aso_access_pd[0x18];
+
+	u8         reserved_at_a0[0x160];
+
+	struct mlx5_ifc_flow_meter_parameters_bits flow_meter_parameters[2];
+};
+
+struct mlx5_ifc_create_flow_meter_aso_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits hdr;
+	struct mlx5_ifc_flow_meter_aso_obj_bits flow_meter_aso_obj;
+};
+
 struct mlx5_ifc_sampler_obj_bits {
 	u8         modify_field_select[0x40];
 
-- 
2.43.0



