Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B143917592;
	Tue, 30 Apr 2024 11:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476222; cv=none; b=hcshR9AhTwrXz9/rhGz1rYxDm2Pnp57ANTspBc13vYeWV1cMpXlxVeRRZ3d6bWoKWVuy+9wUNr7gR7hCTArEbJEysxfoQ/kiCJZQhFinKeebtDQCOoYmxLzE1DLxmZ+SgnLTZEvg7RiaCBK3zkPu8wx/pIRJDCDo3gW3uVziias=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476222; c=relaxed/simple;
	bh=MAw0mowXNLwC8o2bCrGjl8ztPd/LECfczMJHMrQIcB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2O+ogM8uriCjO+zX40hWYuOZAjgpGmdeLBMBOawerVaeTcMG7oz6Gzsom4TOEhhHZtQvMdr/gbaaAHdXLWRmNGjHsDaaKbU2Xh6UclwOOxmRIEJ0QsWMy9Z4XYZpT2vw9ZD9EFV+T8X2L2ERR8bEwmdWfYWurE7w9sWSwFbqvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjVZTkbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjVZTkbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2222DC2BBFC;
	Tue, 30 Apr 2024 11:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476222;
	bh=MAw0mowXNLwC8o2bCrGjl8ztPd/LECfczMJHMrQIcB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjVZTkbYhPPT8t3cP1pkSVxRqoVuPGyFLJsqdMny6nUB4mTahtw3QW6LtU2rPpzd3
	 MauoT8YrYhowz+03CzuUsxaSsCOSY3X6W6URAEFQ383wZxlfbTJllB7d6xykBBOVS4
	 alYUgrMKLQgXqflGABIr/7IAHwqrRjWRZ7eeezD4=
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
Subject: [PATCH 5.4 071/107] mlxsw: spectrum_acl_tcam: Rate limit error message
Date: Tue, 30 Apr 2024 12:40:31 +0200
Message-ID: <20240430103046.751572332@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7e5dc664c55c7..5175ed6cdae08 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1521,7 +1521,7 @@ mlxsw_sp_acl_tcam_vregion_rehash(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_sp_acl_tcam_vregion_migrate(mlxsw_sp, vregion,
 						ctx, credits);
 	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Failed to migrate vregion\n");
+		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to migrate vregion\n");
 		return;
 	}
 
-- 
2.43.0



