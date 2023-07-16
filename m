Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E20E8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A4AC433C8;
	Sun, 16 Jul 2023 20:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539075;
	bh=Wurn+r556/jIlXNtGm+2w9JWEvWDpDuLTsSnhF38Wlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+wwrS9bsIPZ5d/nNIIC+Mgmq6IS0hUc+t8CMhsSToiCCy0umWyXoO0FMcwTxPvCe
	 vNoKYPUBLRWTSFhj3qIKtzHiK2hzp7wseB9p0S1Pvhge5ejaRaKg85geCQZC9XaDke
	 GoOjeEGRFp+Zf2WPOxn5qkdk1wniQu4Tazxo/roY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 678/800] mlxsw: minimal: fix potential memory leak in mlxsw_m_linecards_init
Date: Sun, 16 Jul 2023 21:48:51 +0200
Message-ID: <20230716195004.874585531@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 08fc75735fda3be97194bfbf3c899c87abb3d0fe ]

The line cards array is not freed in the error path of
mlxsw_m_linecards_init(), which can lead to a memory leak. Fix by
freeing the array in the error path, thereby making the error path
identical to mlxsw_m_linecards_fini().

Fixes: 01328e23a476 ("mlxsw: minimal: Extend module to port mapping with slot index")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20230630012647.1078002-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 6b56eadd736e5..6b98c3287b497 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -417,6 +417,7 @@ static int mlxsw_m_linecards_init(struct mlxsw_m *mlxsw_m)
 err_kmalloc_array:
 	for (i--; i >= 0; i--)
 		kfree(mlxsw_m->line_cards[i]);
+	kfree(mlxsw_m->line_cards);
 err_kcalloc:
 	kfree(mlxsw_m->ports);
 	return err;
-- 
2.39.2



