Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AB314EC4D;
	Tue,  9 Jul 2024 11:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523807; cv=none; b=sPkCRnEqWLLUACD3Jdv8T/6oOcs76skoB+ZeNpzoCFjvUwzoKg0MJc4GkiXZw/+RaFoR2IlJh9p8z5ygMx1iV3Eb/6W/fhLgAX25IR/+qUXqSFYWDA6mvoLIyjiHHwqBf0U1FK8i/Sr2MR7NSJKuqj6s6Kgrw9lGl8kOyK6ir4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523807; c=relaxed/simple;
	bh=QiKqo5ygEHcfPGpVp5zLKklf93kbXWNcn2DB/0sblnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3lGr58ffwSQy/Qg2+rv+5JvUUAP3F6rK6q1DSz5uN1E1RMVHyCSQhGyJEtX99oj1Am6fmNgLbquxJJEfvIPMzzQkxOiInjoJG8z7kjDA+2u8mTGTDY885D7iHuWJp5XP4gnrCDHdamqnh4y3NI+gVVD9eLYUdpwm8O6BP7DMFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFzW26t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFzW26t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7F9C3277B;
	Tue,  9 Jul 2024 11:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523807;
	bh=QiKqo5ygEHcfPGpVp5zLKklf93kbXWNcn2DB/0sblnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFzW26t5VBb+PCxIgj4SrgeQO3uNNFBlYurbpIblGz8IBKcXm+UFTMfsZt3i7xEqv
	 NgmvG9KK3+/C8iLJJw0s5j0ZGMaDID49kcDP9C0b00bwmqLMgVHCi3slDCG6n+Rg7T
	 USdnbAZbNmqbU4I0+t500QGiY6+XATyTTuIuD1IY=
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
Subject: [PATCH 6.6 085/139] mlxsw: core_linecards: Fix double memory deallocation in case of invalid INI file
Date: Tue,  9 Jul 2024 13:09:45 +0200
Message-ID: <20240709110701.460380756@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



