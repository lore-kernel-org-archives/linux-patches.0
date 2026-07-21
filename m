Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7862A3BED63;
	Tue, 21 Jul 2026 20:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666981; cv=none; b=aMYSc1Y+Z0OvyJYWgo97/aF7D1aozLrB9LLOK58FcnIE2YbLnwjMxnLMJILtiPub+0De8brCqxIriezgP4RJPti06hTH+RR+vf7keIDqurIBUTUyApvtlAC2QDYHA3UqH4ARG4lkkMi6vml0bLuQRn20F894BZI5IH/WWKYtaLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666981; c=relaxed/simple;
	bh=qiLEC/HJjyOJy9f6RR0MXeakt7H/dIlO4N7CJWeYM18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwDk0akE2VXQB+GUqSGliIMPx4oByPxsOk1CGfz1DbtY0Lf3tfn7TDfAlug9smlywEYV7naW7bzPRbv9OuiSkbrPDDxjS8PlLqJ1Gw+J3k95alyjEWB/ty2pNRaUYeVHesmyITbPPhmDWG4wIr7M7f/uJ/U5w8oC9Shsgwzzrsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Bp05EbQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Bp05EbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53121F00A3A;
	Tue, 21 Jul 2026 20:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666980;
	bh=H7EGNy72+nPFuzfmE+X8MbPS0tjVQz5uoc7UCw8og+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Bp05EbQ7I4pJIf+qltAFvviRag5Mv7JE97x5CbVFZQb3aqvQVjPVsKt+ZC0/ZR9/
	 oS1/KQSvoxutwAphuvcD5zxPielmLM6HPCUUT8b/H5qyaqXhrM0BlyLs/lPUkzbFKz
	 ssOvfVWe8YnFFP/OC9bkYQa03DMwUK4Aik2RNNAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0889/1266] mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()
Date: Tue, 21 Jul 2026 17:22:06 +0200
Message-ID: <20260721152501.742478964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -4427,7 +4427,7 @@ static int mlxsw_sp_port_lag_join(struct
 
 	err = mlxsw_sp_port_lag_index_get(mlxsw_sp, lag_id, &port_index);
 	if (err)
-		return err;
+		goto err_lag_uppers_bridge_join;
 
 	err = mlxsw_sp_lag_uppers_bridge_join(mlxsw_sp_port, lag_dev,
 					      extack);


