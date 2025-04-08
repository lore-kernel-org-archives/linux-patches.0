Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB5235973;
	Tue,  8 Apr 2025 11:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112283; cv=none; b=M1Oqj564AbPfl7KGis36XhefYuOowEMoAqVjCYbFpF8jXTQvek+CbS7WExOG5Ih31cP6OeoKsvu33Xfgnn5dIfiCKRBJ7secJzmgW8GTbzAKC1nz6wiGirKa2QGK6y/5BeOm+NxDcOth9Uz/QllibKBWpUcdjFKz5xfnu1XFgUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112283; c=relaxed/simple;
	bh=3girt8YbLmOudRa0sq8xx+csZiZ8RMpofI/yB//NtCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ri8PFs1L3SYbV4UYVa7zgRyz+U5AATZQ2yqxAFm72gcQW613KzgP3jFqAB+zKRZId7CNGSw1cGUQdxhuxia3F663v3ovf13Hm0Tw234cZljjrlZ5GGwMDFHl+MJBppJvZbsjjm1t5JlHeWAsB8DA5WKhPOugUDSxCpqDXv1imC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwD9pt03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwD9pt03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE15EC4CEE5;
	Tue,  8 Apr 2025 11:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112283;
	bh=3girt8YbLmOudRa0sq8xx+csZiZ8RMpofI/yB//NtCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwD9pt03xKak543vVbz98gi0b3YPspNdMuLc2PZk/jAjZYjsDczc7sPkkXSGIXuev
	 sX7A6z06pMV4KCUQrRUt1ojQbNsH5utNtQkHipF/jWlfTfeToLewttbJ8WFn406EXj
	 b58Yh+r7GPHpCDAZsX5WcuOxOPSVVYWHKPt6J790=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/279] net/mlx5: handle errors in mlx5_chains_create_table()
Date: Tue,  8 Apr 2025 12:46:35 +0200
Message-ID: <20250408104826.709960463@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit eab0396353be1c778eba1c0b5180176f04dd21ce ]

In mlx5_chains_create_table(), the return value of mlx5_get_fdb_sub_ns()
and mlx5_get_flow_namespace() must be checked to prevent NULL pointer
dereferences. If either function fails, the function should log error
message with mlx5_core_warn() and return error pointer.

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250307021820.2646-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index df58cba37930a..64c1071bece8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -196,6 +196,11 @@ mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 		ns = mlx5_get_flow_namespace(chains->dev, chains->ns);
 	}
 
+	if (!ns) {
+		mlx5_core_warn(chains->dev, "Failed to get flow namespace\n");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	ft_attr.autogroup.num_reserved_entries = 2;
 	ft_attr.autogroup.max_num_groups = chains->group_num;
 	ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
-- 
2.39.5



