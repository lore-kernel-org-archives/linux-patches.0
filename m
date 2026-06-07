Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EACF1DE8AE;
	Sun,  7 Jun 2026 10:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827002; cv=none; b=JFAbwhEfrSk3S3Xxh2hn8H7poyYkxJoxecnH0anUu3o3WL6NbbhhcdGNxeOwjxsXZSIIbxgOtlVPdS8qgSidolRr71RXIYCKt39/xu7TxH/PAJ7PJMYWgbllYAGlauZ+dl4h7i7708EKSzigASGi1F5THtVtKLmpBtH/KPNnBSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827002; c=relaxed/simple;
	bh=LFnebFQn8lbRXfxHEx1N+839qd8CQ185Q8BE3vtdEak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5kOjRsadrrM/JHBooXJdS9TVj+POtFAhdXbcmYmjpY6XyeOkDroLYfuqUYV7SKIs99f3D7LhHY/bzg1acfceRKxF5ekmEkrwNsN8YZhfSEhHSdg0oeuy0hk8FPshLLufgK8zoQXOBlYOVthzcBOJlov4Bo2b/ZNkz6RAffzmp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljeUitIc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljeUitIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37EC1F00893;
	Sun,  7 Jun 2026 10:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827001;
	bh=kbT+qqjjLyjygQi7YX1iR2gprIj/f9DHiak+SF6qwQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljeUitIcKpdYJy0O4vSncgj+mlpjlJPWxarO1xHEYqvWPWU/X0enlR4/ZAc1D6PDt
	 +QOkH5jlRro/onmNP60FVdFpKPaqNL6iM2rdwjhN7uSBykzkn9KyFRc0liB2AlFLif
	 WXlOY30zk7KE9yg9EO6i/nWJZ8m04s0bDYEnZvJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/315] net/mlx5: HWS: Reject unsupported remove-header action
Date: Sun,  7 Jun 2026 11:56:58 +0200
Message-ID: <20260607095728.662050244@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit 86f1d0f063e423a5c1982db1e5e7a8eac511e603 ]

mlx5_cmd_hws_packet_reformat_alloc() handles
MLX5_REFORMAT_TYPE_REMOVE_HDR by looking up a matching HWS remove-header
action.

If mlx5_fs_get_action_remove_header_vlan() returns NULL, the code only
logs an error and continues. The function then returns success with a NULL
HWS action stored in the packet-reformat object.

Return an error when no matching remove-header action is available.

Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260506000054.51797-1-prathameshdeshpande7@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 6a4c4cccd64342..c45a7ca66ad8ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -1323,8 +1323,10 @@ mlx5_cmd_hws_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 		break;
 	case MLX5_REFORMAT_TYPE_REMOVE_HDR:
 		hws_action = mlx5_fs_get_action_remove_header_vlan(fs_ctx, params);
-		if (!hws_action)
+		if (!hws_action) {
 			mlx5_core_err(dev, "Only vlan remove header supported\n");
+			return -EOPNOTSUPP;
+		}
 		break;
 	default:
 		mlx5_core_err(ns->dev, "Packet-reformat not supported(%d)\n",
-- 
2.53.0



