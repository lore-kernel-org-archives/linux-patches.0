Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A925782862;
	Mon, 15 Apr 2024 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191267; cv=none; b=XRnMqbehMcmHnWD9Lb3TkDph8VPMcJ7Fm7EDpxP/e5Pt333dxeAMGZU15d3Tzgc+KDa/89aZ4MV+uZ8fstGEWxPxRuffVbKGghBQvim88CM3unzjjczHPcBT/B1bWFX9j53+jlazu8vnLySNQi/5rElv/iq2tFDJIbrKJEx8bJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191267; c=relaxed/simple;
	bh=91nVF60XfuASMTmO5Cnl9LzpoAlhQcuYLaZ7HmeTdCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlbvMVslTk6Ho+LAn2HHn3r71jKqD0kAwkr99faGt0A1APEn1S78gvAPcW9Tk1PZvxesF5YdDctPuXKs/meXTl/OKQdSg0WTWucK7mJieML2r5hR6Rit+oNgit+n66t6hmZ33fWAbewhzEdV3xLQNhZ+l5HRWLbpxQzu1WLNsgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtxZnFAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtxZnFAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31073C113CC;
	Mon, 15 Apr 2024 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191267;
	bh=91nVF60XfuASMTmO5Cnl9LzpoAlhQcuYLaZ7HmeTdCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtxZnFAu/PPRceL1MFJU+yBk89bq0MaTVCjw4IdI8x9jRQ9M7AAIDIGQHRwiCLNHz
	 KiWASL5wJ1MuG61M9l7so6P/U03PFHdC+vcdkrMtNtj6KclU8bA3nbazQV8cZmd248
	 zLSFGkxQjoiYaNFXJ9MycOKJJVmnIDrpdoi+kzxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 086/172] net/mlx5: Correctly compare pkt reformat ids
Date: Mon, 15 Apr 2024 16:19:45 +0200
Message-ID: <20240415142003.015215032@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 9eca93f4d5ab03905516a68683674d9c50ff95bd ]

struct mlx5_pkt_reformat contains a naked union of a u32 id and a
dr_action pointer which is used when the action is SW-managed (when
pkt_reformat.owner is set to MLX5_FLOW_RESOURCE_OWNER_SW). Using id
directly in that case is incorrect, as it maps to the least significant
32 bits of the 64-bit pointer in mlx5_fs_dr_action and not to the pkt
reformat id allocated in firmware.

For the purpose of comparing whether two rules are identical,
interpreting the least significant 32 bits of the mlx5_fs_dr_action
pointer as an id mostly works... until it breaks horribly and produces
the outcome described in [1].

This patch fixes mlx5_flow_dests_cmp to correctly compare ids using
mlx5_fs_dr_action_get_pkt_reformat_id for the SW-managed rules.

Link: https://lore.kernel.org/netdev/ea5264d6-6b55-4449-a602-214c6f509c1e@163.com/T/#u [1]

Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240409190820.227554-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 2a9421342a503..cf085a478e3e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1664,6 +1664,16 @@ static int create_auto_flow_group(struct mlx5_flow_table *ft,
 	return err;
 }
 
+static bool mlx5_pkt_reformat_cmp(struct mlx5_pkt_reformat *p1,
+				  struct mlx5_pkt_reformat *p2)
+{
+	return p1->owner == p2->owner &&
+		(p1->owner == MLX5_FLOW_RESOURCE_OWNER_FW ?
+		 p1->id == p2->id :
+		 mlx5_fs_dr_action_get_pkt_reformat_id(p1) ==
+		 mlx5_fs_dr_action_get_pkt_reformat_id(p2));
+}
+
 static bool mlx5_flow_dests_cmp(struct mlx5_flow_destination *d1,
 				struct mlx5_flow_destination *d2)
 {
@@ -1675,8 +1685,8 @@ static bool mlx5_flow_dests_cmp(struct mlx5_flow_destination *d1,
 		     ((d1->vport.flags & MLX5_FLOW_DEST_VPORT_VHCA_ID) ?
 		      (d1->vport.vhca_id == d2->vport.vhca_id) : true) &&
 		     ((d1->vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID) ?
-		      (d1->vport.pkt_reformat->id ==
-		       d2->vport.pkt_reformat->id) : true)) ||
+		      mlx5_pkt_reformat_cmp(d1->vport.pkt_reformat,
+					    d2->vport.pkt_reformat) : true)) ||
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&
 		     d1->ft == d2->ft) ||
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_TIR &&
-- 
2.43.0



