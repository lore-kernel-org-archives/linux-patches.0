Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982AE27713;
	Tue,  9 Jul 2024 11:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524397; cv=none; b=OMkOifosU+StYgVXkpyda2YzqhoNBZnRGuMAA+2L7O+Pbhe/E5UAiGpGbBtH6YlvsVhq7TyBFkYDpxhvUsDTjuOM3+xBIysHcAtUvcSRQ5R2UE5QglndYsh4h41UmB3AJaicGXf2UoSHTynEoDwvWq4BALtlWlfH7SgjcF0TsKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524397; c=relaxed/simple;
	bh=u9Xfj/Ajk58n06i206iEB1LpaIm1VEeMirtaFV18L/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkOM/uaBLl7iYoku1wT9DwNZiu1ZlYfLJoUr9gZNjYpa75Wp+admYt9/c5+5DZiDVHvg5FymUjjWPwLHg1RCm6F/o8M7TfGQZHEtUM7NTIe9nC6Ki681JSbvq0tWy1+H6OxKNZXwrg6aA0UG/mZgbRQ3QthoAx/4DmuePSeaFKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOIzaBnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOIzaBnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D36FC32786;
	Tue,  9 Jul 2024 11:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524397;
	bh=u9Xfj/Ajk58n06i206iEB1LpaIm1VEeMirtaFV18L/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOIzaBnrWTHbhCbpkqRK75RMd+RWOxfGAVjJ7nSRJFyPwcX8Z7+du0JB/CTr5QvH3
	 5ipOxv61wehjFHFsXM98VhYD4wDXnjgQ36vSlmU4o5B1puDeRSl+MFpKTmxlhFjik7
	 mcirLRl09b5gVotaco42NrNjTTRLFoG2hiMvZ9Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 128/197] mlxsw: core_linecards: Fix double memory deallocation in case of invalid INI file
Date: Tue,  9 Jul 2024 13:09:42 +0200
Message-ID: <20240709110713.907207217@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 8ce34dccbe8fa7d2ef86f2d8e7db2a9b67cabfc3 ]

In case of invalid INI file mlxsw_linecard_types_init() deallocates memory
but doesn't reset pointer to NULL and returns 0. In case of any error
occurred after mlxsw_linecard_types_init() call, mlxsw_linecards_init()
calls mlxsw_linecard_types_fini() which performs memory deallocation again.

Add pointer reset to NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b217127e5e4e ("mlxsw: core_linecards: Add line card objects and implement provisioning")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://patch.msgid.link/20240703203251.8871-1-amishin@t-argos.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_linecards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 025e0db983feb..b032d5a4b3b84 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -1484,6 +1484,7 @@ static int mlxsw_linecard_types_init(struct mlxsw_core *mlxsw_core,
 	vfree(types_info->data);
 err_data_alloc:
 	kfree(types_info);
+	linecards->types_info = NULL;
 	return err;
 }
 
-- 
2.43.0



