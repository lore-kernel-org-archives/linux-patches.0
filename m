Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD70338399A;
	Tue, 21 Jul 2026 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658315; cv=none; b=g51OvjcCqCvFT1+s1yZBffv60BQD6TB7CV8c0FRrpk9zM791TVmC0Au4EuHMl3foV2j3w6BLeD+vzMfmA+vkLlIeruimGsHmAkG7kdAmHNsELtP/ZtWXNZAKmYQJPv7YkYHDbDbAg7zbjyOxdj2sPNn5gbZdtv14rVXjcfmH7Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658315; c=relaxed/simple;
	bh=TLnDTVIyn3paW4vmiVl5Z4l/d3C/JhNEFkvP7zctdis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ymh+JwuvGLhoeVAIAYMkjGCRobJwFEGrKaRFnynFXEb2K5ocN6wMwkVHka7h9s7mduIL7y6AfAsJDh+tEMSxBVsZlamIihNYzOHHiDZQBgYmsMmCGanADZxR8FRMazgYp2P2SNSzIPKoAMWkEa5GpPYqEEdQrIy2+rshB3L8/0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6euqkfm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6euqkfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E92E1F00A3A;
	Tue, 21 Jul 2026 18:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658314;
	bh=X2C6ynn4YLjOjqQA6An97kHU9DX+CO5Rqlu9tHgQGeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6euqkfmgyRWjX670E8FbHm+KCwDRVyu2cmX0Z7qvD0HnW35x7A9DEQWn/mo7r52X
	 YZN9N5/5V+WaWxw1HXko7oNE2jTK9WZJt8EQh4zYZOGf3AAxZTUrN8zPlnv3VroRob
	 r20HfIZnMpdlt0Ib7y+WFtML9tYj6970KuOjSfXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1096/1611] mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()
Date: Tue, 21 Jul 2026 17:20:12 +0200
Message-ID: <20260721152540.069598575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 41c8c1d65b32beacd8d916a22457b4f6e47f45af upstream.

When mlxsw_sp_port_lag_index_get() fails, mlxsw_sp_port_lag_join()
returns an error without releasing the lag reference obtained by
the earlier mlxsw_sp_lag_get().  All other error paths in the
function jump to the cleanup label that ends with
mlxsw_sp_lag_put(), so this is a single missed release.

Fix the leak by replacing the bare 'return err' with a goto to the
existing error cleanup label, which will drop the reference safely.

Cc: stable@vger.kernel.org
Fixes: 0d65fc13042f ("mlxsw: spectrum: Implement LAG port join/leave")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260609083709.209743-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4363,7 +4363,7 @@ static int mlxsw_sp_port_lag_join(struct
 	lag_id = lag->lag_id;
 	err = mlxsw_sp_port_lag_index_get(mlxsw_sp, lag_id, &port_index);
 	if (err)
-		return err;
+		goto err_lag_uppers_bridge_join;
 
 	err = mlxsw_sp_lag_uppers_bridge_join(mlxsw_sp_port, lag_dev,
 					      extack);


