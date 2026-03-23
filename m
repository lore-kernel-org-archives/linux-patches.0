Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE842561A2;
	Mon, 23 Mar 2026 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278171; cv=none; b=EDPoYD+TCj1j++MRk2sD2+rVHIEl7LJA8bJwYbpWgZWXeRzflcIXnpySY0/PiO5kuWOM4A+CRVtkyJgf+1fgC9xHLg09CfK+gNp2RajbEa9QAoJajL4yS8IrEOKTRGENVmToaUxxAcf2mBGAI3zePLMGuo+9FgaVxTJviKhXhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278171; c=relaxed/simple;
	bh=8ux85OL4IQFE4oNKAg/oxeO+sV1wRKhDR95CsOn4Lww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrcS+LAac16X1yvx3bJ9QN3iR4M3fSjHVPDLA2YHs72NBGTdnBPQ9ztw8SkAA73+4UcdoyAkmtR8d80kCJZE+YMm8wgZ87GMe1W7lxBjNe1XoNxwTaLbj5N2UEkuW8wTuT9xpfaMPm2bo2MAuBPkDBRuaXUatMetpNHR++ig7dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kT6n9e6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kT6n9e6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8A5C4CEF7;
	Mon, 23 Mar 2026 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278171;
	bh=8ux85OL4IQFE4oNKAg/oxeO+sV1wRKhDR95CsOn4Lww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kT6n9e6hDHLos7jSmVluDQZNKUasR/AMhgImeO1ryWz8ny5C4Reg98gDz5cgSYFls
	 +Bs1XvG429g0pNFipurZfS8/5ZJz5HCrS2NYmrPDxAF4gYCMy4/iup+G76orU81/c/
	 AHgYaiAufT2HUsVpxO/s7eG8qKLmCMcSI1k5OtVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/567] net/mlx5: Query to see if host PF is disabled
Date: Mon, 23 Mar 2026 14:42:22 +0100
Message-ID: <20260323134539.323020565@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit 9e84de72aef9bcf0e751a0bff3ac91b0cf52366f ]

The host PF can be disabled, query firmware to check if the host PF of
this function exists.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1755112796-467444-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: aed763abf0e9 ("net/mlx5: Fix deadlock between devlink lock and esw->wq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 23 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 914b380fd3eeb..79fa78b188250 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1038,6 +1038,25 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	return ERR_PTR(err);
 }
 
+static int mlx5_esw_host_functions_enabled_query(struct mlx5_eswitch *esw)
+{
+	const u32 *query_host_out;
+
+	if (!mlx5_core_is_ecpf_esw_manager(esw->dev))
+		return 0;
+
+	query_host_out = mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(query_host_out))
+		return PTR_ERR(query_host_out);
+
+	esw->esw_funcs.host_funcs_disabled =
+		MLX5_GET(query_esw_functions_out, query_host_out,
+			 host_params_context.host_pf_not_exist);
+
+	kvfree(query_host_out);
+	return 0;
+}
+
 static void mlx5_eswitch_event_handler_register(struct mlx5_eswitch *esw)
 {
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS && mlx5_eswitch_is_funcs_handler(esw->dev)) {
@@ -1870,6 +1889,10 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		goto abort;
 	}
 
+	err = mlx5_esw_host_functions_enabled_query(esw);
+	if (err)
+		goto abort;
+
 	err = mlx5_esw_vports_init(esw);
 	if (err)
 		goto abort;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 3e58e731b5697..23e612dd329db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -315,6 +315,7 @@ struct mlx5_host_work {
 
 struct mlx5_esw_functions {
 	struct mlx5_nb		nb;
+	bool			host_funcs_disabled;
 	u16			num_vfs;
 	u16			num_ec_vfs;
 };
-- 
2.51.0



