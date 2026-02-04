Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A9228CF49;
	Wed,  4 Feb 2026 14:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216545; cv=none; b=O0TH8YpA4suBcgXNClVLX+flkj4KTX0QgLIHSh4F45Gy03qEgAEhD3wje6V0y9VwpnfrP45wUCr8/za8n923GalcjCLFRZHnjSZ02EYNG/rQfRorxgFHcGgmZwpE4N3GgU7D7A35NtRXgyZQIpLQ05kthlf2VqdI1wcpvVsi/kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216545; c=relaxed/simple;
	bh=ti7yJwUqYAC/+4Ul8IfCrS3zTtM7nf690GxLXC9zxXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlO/1FWVjACWHv8LCiUIACzIdRyn7wkntR1FJT7q/rw/9xYlOTR8HbhVR+r9tmw5T2MYDdEBak9LMdatl/D8373qcI/jw8dDgyxiCCjbZKKkcwB6/tZjzMBLsnZb1R+MzQPp/S7nzvRAYZQI57CChlRN2pQsoCdb1CodqYIklSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r62/5/Jn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r62/5/Jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D39C116C6;
	Wed,  4 Feb 2026 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216545;
	bh=ti7yJwUqYAC/+4Ul8IfCrS3zTtM7nf690GxLXC9zxXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r62/5/JnpJjKx+dCuX7S/igddweefI+IJ2ikP7JpUTE8ICH22dqeH7P9pZnwnTtS2
	 Rt/ZHFbJ2Vl72B4GIGpdD7sreAR27S3DHEqOou5eJYKY0FxbRk3I3H+oyIl76Uce1n
	 BQU6YjTzco9W8JZ1ukPEpkw126vxTFglL2fYE2OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/161] net/mlx5: Fix memory leak in esw_acl_ingress_lgcy_setup()
Date: Wed,  4 Feb 2026 15:39:42 +0100
Message-ID: <20260204143856.028898923@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 108948f723b13874b7ebf6b3f1cc598a7de38622 ]

In esw_acl_ingress_lgcy_setup(), if esw_acl_table_create() fails,
the function returns directly without releasing the previously
created counter, leading to a memory leak.

Fix this by jumping to the out label instead of returning directly,
which aligns with the error handling logic of other paths in this
function.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 07bab9502641 ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260120134640.2717808-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index 45570d0a58d2f..02b2ab7958543 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -185,7 +185,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		if (IS_ERR(vport->ingress.acl)) {
 			err = PTR_ERR(vport->ingress.acl);
 			vport->ingress.acl = NULL;
-			return err;
+			goto out;
 		}
 
 		err = esw_acl_ingress_lgcy_groups_create(esw, vport);
-- 
2.51.0



