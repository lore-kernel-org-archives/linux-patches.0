Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6268837;
	Mon, 28 Oct 2024 06:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098287; cv=none; b=pDwfQHU29mrVYs4LJk0wNmRVcfkRyD7p0rx2I4ohmIkq94Crl0Byg6023wnBIxxzniyLWe7UDgo+1NYMd+xEvSO4HVnguMAn256xohlHmhitztIWv0iJURknaF26pWbCKvrA1J/DYjj9pilTl/Ur9hzR+w8HUOjhMoplL+mT5m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098287; c=relaxed/simple;
	bh=lKB4pbxOrcPOgWJUd9DqqStwQs/9ca39miCzl32v680=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6BUHqP+rKIr8NZ0fbb51V110CNiK04c9xILdfSSOUi8Mg/wZ4SyipKieUoPRwTUZfz8UhxQJ/FytIZ/BBiPfNi2m4aR3pQuh8+yCddS4JRhV1QzWlmiWDYR59+tpj97W9PujnQO5iFDc5kvygLZDBWgw0LzOv5XUIr5JPa397A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHwmmXUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHwmmXUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBE1C4CEC3;
	Mon, 28 Oct 2024 06:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098287;
	bh=lKB4pbxOrcPOgWJUd9DqqStwQs/9ca39miCzl32v680=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHwmmXUuO7p7CqPJgh9R8hHCtj5r3WFYENR/ZlghPRADSmv9dDEshyv8hGJLAJo9j
	 KsbkQP7SwD8XgCkZzcq2i834JSZdBTWLOxK1jxX/GEoG9mKMrTd2HlJfZT1BVIxj+3
	 XlTAb0bi9TUcEg3LThHS5rcJtAI70Uo5MNuookwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 160/261] mlxsw: spectrum_router: fix xa_store() error checking
Date: Mon, 28 Oct 2024 07:25:02 +0100
Message-ID: <20241028062316.018898727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit f7b4cf0306bbea500a613e4b618576452c1df4ba ]

It is meant to use xa_err() to extract the error encoded in the return
value of xa_store().

Fixes: 44c2fbebe18a ("mlxsw: spectrum_router: Share nexthop counters in resilient groups")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20241017023223.74180-1-yuancan@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 800dfb64ec830..7d6d859cef3f9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3197,7 +3197,6 @@ mlxsw_sp_nexthop_sh_counter_get(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_nexthop_group *nh_grp = nh->nhgi->nh_grp;
 	struct mlxsw_sp_nexthop_counter *nhct;
-	void *ptr;
 	int err;
 
 	nhct = xa_load(&nh_grp->nhgi->nexthop_counters, nh->id);
@@ -3210,12 +3209,10 @@ mlxsw_sp_nexthop_sh_counter_get(struct mlxsw_sp *mlxsw_sp,
 	if (IS_ERR(nhct))
 		return nhct;
 
-	ptr = xa_store(&nh_grp->nhgi->nexthop_counters, nh->id, nhct,
-		       GFP_KERNEL);
-	if (IS_ERR(ptr)) {
-		err = PTR_ERR(ptr);
+	err = xa_err(xa_store(&nh_grp->nhgi->nexthop_counters, nh->id, nhct,
+			      GFP_KERNEL));
+	if (err)
 		goto err_store;
-	}
 
 	return nhct;
 
-- 
2.43.0



