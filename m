Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E313B1422B8;
	Wed, 19 Jun 2024 13:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802882; cv=none; b=BJJlunsehCk6chbiPi4pWeLdyG32zxjIKPd8HgVgjSpHTXWtDOpsi7JutEGxHTJ7yutyAIjATMGTLuWNWTInXGXYeymE/8xN/zjxOSxkRNMZq01buvziGvDcrjD7y4cWctU13jxR54MOETYl6a7BwKnhV+rUafRHiR27e4X6BeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802882; c=relaxed/simple;
	bh=2pdgWBIgKltdG5lQPg00fvjcEbcKv6t94NZqHrASowY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJwL4O7p9uOLp2CNR6UTpyCzXqyY8Vsexcrv1vfoSYf4/UxSQLTFbh8X2m3O0fW/17zseakbjzLLQPy/IbeaxCKWehVG9kkxK+4QEVqm14s7ATMvt6i8UEq2nmE0fSUHFD0IVGknxYe7U3Vro6OG7hcg3xMeZLEpyNf4lMwRUTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWyqqJjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWyqqJjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A792C2BBFC;
	Wed, 19 Jun 2024 13:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802880;
	bh=2pdgWBIgKltdG5lQPg00fvjcEbcKv6t94NZqHrASowY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWyqqJjEAIOl4WMz6OZ0T2ssrwdbsyAvRjSGAx9umYJr/clniJ5vM3mfu04K0XAfm
	 N0KCP8opTxHo0f5kqCod8BZ5Y4p5vb7QIHOXA85yMLWSyWeVORYz2BIH//iN5RJ3Pa
	 Iw+QsA2JKZQ/yQJiGUE7inC3/ziDDQxiAaSmB+b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 047/281] net/mlx5: Fix tainted pointer delete is case of flow rules creation fail
Date: Wed, 19 Jun 2024 14:53:26 +0200
Message-ID: <20240619125611.660182598@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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
index 101b3bb908638..e12bc4cd80661 100644
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



