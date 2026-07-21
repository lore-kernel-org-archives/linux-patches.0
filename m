Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FB247012C;
	Tue, 21 Jul 2026 19:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663394; cv=none; b=Dv1b0u9JgI3oFdX+NnW4xNrqqXHngQGUZ6xm4RoIn6fc59S16+2rEzJEl6prWh+3iCK1wzpJ8RIyaKvK18YsKfLnWdiqqmmmTuyS9nPCVSju8ccBs5GFBKMAT3+S0pFfB9zbIMqplusnIsr8Jg6rv9M2dmm8glHzrLAyunOKknk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663394; c=relaxed/simple;
	bh=x+46CTF2Jla2lMTZyMFuFR4UrQ3PSIw1tLI1WCweoM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8Qp0QY59gkEywHD5WGfftyfTMPTMJ5mlmE324ew5Tik/oNQMQU5LA2oZo0JZHZ1f8Mn2MglEaUaO4okz8m48jIfwOUCy01zhJAOouvl6MgVd4nMsU0KzMFveEnF+g6VTb5XOYS69Cy7gRoE43s3Tlh03+cr/TrVKxfkc/pGVKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hghaw2H4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hghaw2H4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A07F1F00A3F;
	Tue, 21 Jul 2026 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663393;
	bh=D+PTr1Q5FqSxTfrWbz685RjjAkJ6DZ8zWPzduDIlIF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hghaw2H4XCivH08pTThUyCJcJ+u4DnTdKk69z9GUS1867ssnBzdtAlDaGbRe0tKZp
	 tgufkn4YzikQvsJ/zBGFsYYCgLYoVK1o2mkYtwleEAEKpmdpKpgW+VJgLYHwN0wNbI
	 HktkGbOEBdxtkgT5uKxE9qxm9eL6OiaJzSgpG+o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0806/1276] mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()
Date: Tue, 21 Jul 2026 17:20:49 +0200
Message-ID: <20260721152504.108230390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4507,7 +4507,7 @@ static int mlxsw_sp_port_lag_join(struct
 	lag_id = lag->lag_id;
 	err = mlxsw_sp_port_lag_index_get(mlxsw_sp, lag_id, &port_index);
 	if (err)
-		return err;
+		goto err_lag_uppers_bridge_join;
 
 	err = mlxsw_sp_lag_uppers_bridge_join(mlxsw_sp_port, lag_dev,
 					      extack);


