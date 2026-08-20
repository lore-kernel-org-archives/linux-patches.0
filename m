Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9E247F774;
	Thu, 20 Aug 2026 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248022; cv=none; b=C4BIqB08tRPR/2cllPbC37TLpMtuKickb/M42VABKYI24ceOZoGkHdXjY+DFSJ560JMyKyf6OqlmvSEq6MziOObcngYr3fEaduU3hH52qaZ8eVTFe76gqiKMgsqSVz6S2i3il6Lfmh22mBA9eJUPrUgOvqP6utARqb4il/jlCQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248022; c=relaxed/simple;
	bh=AxPTF6Mu2z2ZpavdFypm0wHDHfcziMH7OQkI7r7b5aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTnFd8KJhHzTpdcrEoonOlprfBKtfSFtMVqxNzxYTyGPA2+Kl7EX2ly99t7M8thfT1xeqR5FmTu3q4jA/FIEEVOPBuIkeDblSizHWl8N67+o86OJUkVUPC1fKHul/uiftN+VR/tLoRAdC814baej3GevlRzAhRUHiHIgEyJyrmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0N4l09hu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0N4l09hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D73C1F000E9;
	Thu, 20 Aug 2026 17:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248021;
	bh=JJBZwHy0XIvGk0I1MMygDC12qO0AvHiA1Qu/q9GECso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0N4l09huq2F4qghb4+vdQ22GZwakzU4zHZjhyx0CfMHO6nZLxQsg/St0bKXzX9YjB
	 Zo4DiEcMZeEjlWXhRWbfTZxMU479wCP+npK9hCkaSxrO9SpZ52ycxd7K4cDPAdU96X
	 +nRHwGkIcEXF+SctLVkTr/1c/Z5shMuUkYwX2PFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/303] mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()
Date: Thu, 20 Aug 2026 16:53:39 +0200
Message-ID: <20260820145255.655430050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 41c8c1d65b32beacd8d916a22457b4f6e47f45af ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4462,7 +4462,7 @@ static int mlxsw_sp_port_lag_join(struct
 
 	err = mlxsw_sp_port_lag_index_get(mlxsw_sp, lag_id, &port_index);
 	if (err)
-		return err;
+		goto err_lag_uppers_bridge_join;
 
 	err = mlxsw_sp_lag_uppers_bridge_join(mlxsw_sp_port, lag_dev,
 					      extack);


