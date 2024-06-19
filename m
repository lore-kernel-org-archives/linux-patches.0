Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299554D9EA;
	Wed, 19 Jun 2024 13:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803563; cv=none; b=ndJqb0G/7BuIktfg61cn7iHXYa6D0+aObR0tJAFEnol/cm4JWqgWjEZX+wGtV1FfLHklHCTZxiKVsPUMbTcHEckgOKDwBNbr0EzifGYyNWxr4SlVmXI5gTtFLSeulIMavmzePMCkuKY84hCQC290rEzmMbcDh/RBQYTNK4jsuMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803563; c=relaxed/simple;
	bh=OKJFRf+PI+FHURzg47u9ESs7vejpTQ3aLufM4euzrhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUP7mVuLMIHanhk9/9oCs+V4YIdqeyerE8sBkfe8jQxRSyhEJ7zKoKX4iZdJgzPWYJsUBymDmsRQXr0/4WZQ3dpjV2oD+7RFewwNnhZUV8JKYlowObZQ+tiZyoaDnaRXh3hI4QjJV2ZLfdIAJX6WPME5WDLQMS6Xn9bHTNJSzjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuBmocrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuBmocrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647E6C2BBFC;
	Wed, 19 Jun 2024 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803562;
	bh=OKJFRf+PI+FHURzg47u9ESs7vejpTQ3aLufM4euzrhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuBmocrvWR4SBzECeXwAOPderlrZED7bQq+0bFXU1b/NoiGsfVb0WcOFJJmmUMSiy
	 PSyjdEfWy5JVgDjUZZPatoCoFlpX2PVShh+sLdG3VJEdchhaTezIgDWEtkPsLYTwX2
	 TRPo67Vw2qz7Jmnyst/gfRs3Us2Nk/U5foKNgHyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/217] net/mlx5: Fix tainted pointer delete is case of flow rules creation fail
Date: Wed, 19 Jun 2024 14:54:30 +0200
Message-ID: <20240619125557.697436539@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 229bedbf62b13af5aba6525ad10b62ad38d9ccb5 ]

In case of flow rule creation fail in mlx5_lag_create_port_sel_table(),
instead of previously created rules, the tainted pointer is deleted
deveral times.
Fix this bug by using correct flow rules pointers.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 352899f384d4 ("net/mlx5: Lag, use buckets in hash mode")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240604100552.25201-1-amishin@t-argos.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index 7d9bbb494d95b..005661248c7e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -88,9 +88,13 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 								      &dest, 1);
 			if (IS_ERR(lag_definer->rules[idx])) {
 				err = PTR_ERR(lag_definer->rules[idx]);
-				while (i--)
-					while (j--)
+				do {
+					while (j--) {
+						idx = i * ldev->buckets + j;
 						mlx5_del_flow_rules(lag_definer->rules[idx]);
+					}
+					j = ldev->buckets;
+				} while (i--);
 				goto destroy_fg;
 			}
 		}
-- 
2.43.0



