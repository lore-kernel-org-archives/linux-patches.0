Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D85272E53;
	Thu, 20 Aug 2026 16:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244140; cv=none; b=UAf0XZWbBD4leHuCY3QG3t3Sng/NWojYZbKBeGYZw3/J61byKW8OTUHjAeyShGLz5534UM57HsUyVE/HXHcFoCJQKJVeGXVVmbAXQQ+peofA/TXWjXVPHfTuSSS5+HR3PknuhOHem22iYRBanGmIE6kTMxTvT8WFrC1gf1DPJP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244140; c=relaxed/simple;
	bh=MtNbC0UCiXVrDG3L4Zpl/SXy12M1zdp9EdPAGX+ZpVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pr2L+672xuToahB1rv3c7VsAyKgyyAZJGbYYGJxZdBm4qjWIQot9Ec8hKcahA8zmEt3uP7qbsKIckrcwYFLEqZqrwZ9mcyhSP/dvqAxRu/VNg2yHVABNuWriAW6BFB+LiHKFDk90WDfafEnQN8mukACVUE7AcPnzuJ46TcYlowA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCU4j53u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCU4j53u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80D61F000E9;
	Thu, 20 Aug 2026 16:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244139;
	bh=ugYDaObthhmy87fc07HgdgYNF4f6LNmcjtPrdoMjZlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCU4j53uwMdpVkTJdyrALJGr/Yxh5FVlAjhueSwpbPWrb/6BSBgrm7o7qYr5GPzei
	 KsjV0sahPfb7o8Uy6WYK3uy7wmIHIIAVImH68uoudyHjUP5Eyd6fxqYGA9JdkgOrRW
	 TgHLjSV3RFh4BmuOy1nIN4lGih3hhsc1ZV/sZ5rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/235] mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()
Date: Thu, 20 Aug 2026 16:55:02 +0200
Message-ID: <20260820145218.448566273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -3654,7 +3654,7 @@ static int mlxsw_sp_port_lag_join(struct
 
 	err = mlxsw_sp_port_lag_index_get(mlxsw_sp, lag_id, &port_index);
 	if (err)
-		return err;
+		goto err_lag_uppers_bridge_join;
 
 	err = mlxsw_sp_lag_uppers_bridge_join(mlxsw_sp_port, lag_dev,
 					      extack);


