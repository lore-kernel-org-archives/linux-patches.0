Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E60611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74743C433D2;
	Sun, 28 May 2023 19:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303405;
	bh=D90cq3eO9uwJcCKf0JHbP8pA8mXhz6vqOoPP+nBkA1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfjKi6ubr9A4tUqu8VTQlGMqb/a3lQ82bUef5MXgysCyQd/+TDrV5XA457OIaA7xN
	 bfswNsN1rQwNfd4kzDef7xKrTo2nxGkuDKB5O27V1GsVRkT+vohDOIWtiPMgzFnsF6
	 svGc186yx4URBmOrBhynAygzqxQwttGgASnCxyJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itamar Gozlan <igozlan@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 62/69] net/mlx5: DR, Check force-loopback RC QP capability independently from RoCE
Date: Sun, 28 May 2023 20:12:22 +0100
Message-Id: <20230528190830.702851285@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

commit c7dd225bc224726c22db08e680bf787f60ebdee3 upstream.

SW Steering uses RC QP for writing STEs to ICM. This writingis done in LB
(loopback), and FL (force-loopback) QP is preferred for performance. FL is
available when RoCE is enabled or disabled based on RoCE caps.
This patch adds reading of FL capability from HCA caps in addition to the
existing reading from RoCE caps, thus fixing the case where we didn't
have loopback enabled when RoCE was disabled.

Fixes: 7304d603a57a ("net/mlx5: DR, Add support for force-loopback QP")
Signed-off-by: Itamar Gozlan <igozlan@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c |    4 +++-
 include/linux/mlx5/mlx5_ifc.h                             |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -117,6 +117,8 @@ int mlx5dr_cmd_query_device(struct mlx5_
 	caps->gvmi		= MLX5_CAP_GEN(mdev, vhca_id);
 	caps->flex_protocols	= MLX5_CAP_GEN(mdev, flex_parser_protocols);
 	caps->sw_format_ver	= MLX5_CAP_GEN(mdev, steering_format_version);
+	caps->roce_caps.fl_rc_qp_when_roce_disabled =
+		MLX5_CAP_GEN(mdev, fl_rc_qp_when_roce_disabled);
 
 	if (MLX5_CAP_GEN(mdev, roce)) {
 		err = dr_cmd_query_nic_vport_roce_en(mdev, 0, &roce_en);
@@ -124,7 +126,7 @@ int mlx5dr_cmd_query_device(struct mlx5_
 			return err;
 
 		caps->roce_caps.roce_en = roce_en;
-		caps->roce_caps.fl_rc_qp_when_roce_disabled =
+		caps->roce_caps.fl_rc_qp_when_roce_disabled |=
 			MLX5_CAP_ROCE(mdev, fl_rc_qp_when_roce_disabled);
 		caps->roce_caps.fl_rc_qp_when_roce_enabled =
 			MLX5_CAP_ROCE(mdev, fl_rc_qp_when_roce_enabled);
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1513,7 +1513,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         rc[0x1];
 
 	u8         uar_4k[0x1];
-	u8         reserved_at_241[0x9];
+	u8         reserved_at_241[0x7];
+	u8         fl_rc_qp_when_roce_disabled[0x1];
+	u8         regexp_params[0x1];
 	u8         uar_sz[0x6];
 	u8         reserved_at_248[0x2];
 	u8         umem_uid_0[0x1];


