Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86318801;
	Tue, 30 Apr 2024 11:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475963; cv=none; b=cN3rm7bP4EAEo2fKsK//Yl1P9xbDRVgSe47rMhd7MI9UiwonSPvS1K4N6bEVmjSa1QWq1F55YGqF1o7lZOZ6Nd9TbZClcOSRpLXzQekbdMiJqUyNqf9mRi/EF6KlcYPt3LOtKcdBGEAAwnmvD+l7wNGtbUv7cgdSL3XLxaVM0t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475963; c=relaxed/simple;
	bh=ZUrSv+8niwVcUG1YydACgILfw/tmxmCxMWCLLke6qpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlkRJ1CObxCdAmpg645Z3BkqD488LP+kdF+79Rsf0yKiJgBHDwjD1s6RI2muhzm209tESwakgkmy954Dn8O72u1yLGhbzeymxJcb8v+Ed+I665HXKQYX8VewRqQwjjeJtt6rJ8CffxbAsvzs+AITEYhSkySyTGp7JAPDhruJK9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7/81Szk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7/81Szk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D5EC2BBFC;
	Tue, 30 Apr 2024 11:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475963;
	bh=ZUrSv+8niwVcUG1YydACgILfw/tmxmCxMWCLLke6qpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7/81SzkwwgFW1XX1FTHMLyPqAsuhdvdQVLUleROoaiPRVYhpIbxPQaP2BnWrzGkO
	 ZZ0fG7xU1E8L93M6bEehIE5whJHxNqeKW1wTs6LsYq3VRxRJFPaRtM4M/ZeS+okgtC
	 Q6JLSlPHzv0SicEqlVcBJSf8M0Wl//jonG5PNAFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Alexander Zubkov <green@qrator.net>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/80] mlxsw: spectrum_acl_tcam: Rate limit error message
Date: Tue, 30 Apr 2024 12:40:05 +0200
Message-ID: <20240430103044.393937196@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5bcf925587e9b5d36420d572a0b4d131c90fb306 ]

In the rare cases when the device resources are exhausted it is likely
that the rehash delayed work will fail. An error message will be printed
whenever this happens which can be overwhelming considering the fact
that the work is per-region and that there can be hundreds of regions.

Fix by rate limiting the error message.

Fixes: e5e7962ee5c2 ("mlxsw: spectrum_acl: Implement region migration according to hints")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/c510763b2ebd25e7990d80183feff91cde593145.1713797103.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index a60d511f00eaa..cdad4772b60a0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1480,7 +1480,7 @@ mlxsw_sp_acl_tcam_vregion_rehash(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_sp_acl_tcam_vregion_migrate(mlxsw_sp, vregion,
 						ctx, credits);
 	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Failed to migrate vregion\n");
+		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to migrate vregion\n");
 		return;
 	}
 
-- 
2.43.0



