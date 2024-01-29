Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32E2157050;
	Mon, 29 Jan 2024 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548327; cv=none; b=A5egl1LjacLjSYZArafwlGskOQ/oiK63JcyLJSO6F417jjTiQlNQXrm71x1djAYjz54fxEq4oV6dBPLDF5bR2eUPqWFcWOThKRGnaNfyuXPVUOgIki8yLvUNX+adf25btdhjrx8OMgna6BwCMpqFM7uL192K1wQP9tVuoBMu+FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548327; c=relaxed/simple;
	bh=Qh9rWMqoTt8AUEKp994S1ezu1S/kjr788/4kt1WRoAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHnyL6HeRVzd/ub/S5ClSjvM5MGfOIB1eJ57JSm4TRKBEdw2oMMbr9vgoY5Y5UoIecDxKDBNTOSs7DPbUj3oBDn/UXHwVtgjR7DRRHAu1v2+5bCwXwowcHdrNp0Goec0P4zmI9cH8fMlFAZis/f1xLKjUPYDMs9ue9G09Vj6UZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBED6ni4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBED6ni4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A24AC43390;
	Mon, 29 Jan 2024 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548327;
	bh=Qh9rWMqoTt8AUEKp994S1ezu1S/kjr788/4kt1WRoAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBED6ni401bs0BtGRgHF02PZP4A+wGPoxYxLxtIBPmHjyXhnUufdUDET2gZqCvcOc
	 yyXwycccW0xWmGTzt+cIzL/ogBYlCcnD5AHGtOodJ0ASsqQQe/6hIgSmqogR9poiQP
	 mlxLVE7ib3phUxNsmoKTPB76ozga6ne54Le01FYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 327/346] platform/mellanox: mlxbf-pmc: Fix offset calculation for crspace events
Date: Mon, 29 Jan 2024 09:05:58 -0800
Message-ID: <20240129170026.094233353@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravan Kumar Ramani <shravankr@nvidia.com>

[ Upstream commit 732c35ce6d4892f7b07cc9aca61a6ad0fd400a26 ]

The event selector fields for 2 counters are contained in one
32-bit register and the current logic does not account for this.

Fixes: 423c3361855c ("platform/mellanox: mlxbf-pmc: Add support for BlueField-3")
Signed-off-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/8834cfa496c97c7c2fcebcfca5a2aa007e20ae96.1705485095.git.shravankr@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 1dd84c7a79de..b1995ac268d7 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1170,7 +1170,7 @@ static int mlxbf_pmc_program_crspace_counter(int blk_num, uint32_t cnt_num,
 	int ret;
 
 	addr = pmc->block[blk_num].mmio_base +
-		(rounddown(cnt_num, 2) * MLXBF_PMC_CRSPACE_PERFSEL_SZ);
+		((cnt_num / 2) * MLXBF_PMC_CRSPACE_PERFSEL_SZ);
 	ret = mlxbf_pmc_readl(addr, &word);
 	if (ret)
 		return ret;
@@ -1413,7 +1413,7 @@ static int mlxbf_pmc_read_crspace_event(int blk_num, uint32_t cnt_num,
 	int ret;
 
 	addr = pmc->block[blk_num].mmio_base +
-		(rounddown(cnt_num, 2) * MLXBF_PMC_CRSPACE_PERFSEL_SZ);
+		((cnt_num / 2) * MLXBF_PMC_CRSPACE_PERFSEL_SZ);
 	ret = mlxbf_pmc_readl(addr, &word);
 	if (ret)
 		return ret;
-- 
2.43.0



