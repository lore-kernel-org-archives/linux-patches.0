Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FDB2E1EFC;
	Sun,  7 Jun 2026 10:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826850; cv=none; b=ek4mEPget0VarFcVU+xOyQ74xNKfef8CZUptvOkC+cOSstqZmNRETIFD/j3xmZ7+6LTq0w1PWs5RfTj9Th7wS2QXZD4gvndXEZJezW3jneEHwi1HmfY09/0jamtuBx2DPTwJ51Tzn5YcXy2m0zZcKjybo4lof1iZMSqEj49g4e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826850; c=relaxed/simple;
	bh=F7UnmbMUbioyiE1Brhm4OQaQkl+UPjuUCxaGjXdvlXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ7XNj1Ow2VVlh1tgGPkRd4r/j/k3aVGJLhy6OsI8sNBSYMfeUq9YTiqwTIH5fywkcBZ0DYPEudRJ6X/SmjCAm4xa3fz8tqyAFfSP+cbWcsgbDhArCvFc3ASekWcsI8eKK8I6fdIBngQjDU2hUmc2C5fyBwN+c8Iyce7w3N2YcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUX58veb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUX58veb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFBE1F00893;
	Sun,  7 Jun 2026 10:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826849;
	bh=QCBfputQ8McXlojNRN+WnuvzMe3xp7zayNeDQqbeTUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUX58vebO+7njzVi2xs324w8qmSZjmc+PGygIk0B5dz58/1Xf0HdrM5Ps084Id0xH
	 vZeulN6kFDk4wJ5tBnvsbZdRW8AfbEkh5/hOy+MLGvjEFs81rHJGX7FgQMgynaEJoU
	 p4HUiuHOZAHh+PiqVDmajmdZD/IzD6ss+miVpiOE=
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
Subject: [PATCH 7.0 035/332] net/mlx5: HWS: Reject unsupported remove-header action
Date: Sun,  7 Jun 2026 11:56:44 +0200
Message-ID: <20260607095729.388402266@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index aca77853abb81b..5a172c572a68f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -1320,8 +1320,10 @@ mlx5_cmd_hws_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
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



