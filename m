Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD662F291B;
	Tue, 12 Aug 2025 18:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024201; cv=none; b=HbQCLyNw1mmbuUKmi8yLwyye8QUC0BiFYR122OdFzdXBIIewhQbhOVYuuNWVfsHGskDhsEAIpBOop6if8UMtBBxN/BpJ1chMEUXLU+VcwCegb25Xguw5efJfvi5uTY/I7eO4p+CU/E3BBU5/PN4CwYLjxrtWbby+//lCpNRn8nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024201; c=relaxed/simple;
	bh=xv6OklFF9XwF/TpKxcRq0PPBtATK8yglN17sEUBM1Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umPeZDzs5ZtlOrpuTiBjdCAy8g11RjTQPpqwulvLw9cqSYHey1EQvF79vsEHpVaoYo/XTIUPcIfAong3/LN3E222pMW8t13BsW/ZigcxbNqM+ZpM1mdvJIUKaOfLx5xeTbbi2AlSqZYKRWIgSzREYRXciuczwzMQNX7X3n3t/Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/Zihosi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/Zihosi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C34C4CEF0;
	Tue, 12 Aug 2025 18:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024200;
	bh=xv6OklFF9XwF/TpKxcRq0PPBtATK8yglN17sEUBM1Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/ZihositbDJVRaXUGnPRpQQsgZelk1nv0RGKst4C/NZdZChRxlcdr5CS6be5VbqO
	 49A4Nzz/kInuvodg4IXTYEfHTVndSxXScA0GpHXsbJtey7Mf/xXD3BY+nwfwHevkpF
	 xkpz1JZwFP1GMi0ZJAa5c2SxZ7J4V69oUXc9Bmt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 276/627] net/mlx5e: Clear Read-Only port buffer size in PBMC before update
Date: Tue, 12 Aug 2025 19:29:31 +0200
Message-ID: <20250812173429.808886861@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit fd4b97246a23c1149479b88490946bcfbd28de63 ]

When updating the PBMC register, we read its current value,
modify desired fields, then write it back.

The port_buffer_size field within PBMC is Read-Only (RO).
If this RO field contains a non-zero value when read,
attempting to write it back will cause the entire PBMC
register update to fail.

This commit ensures port_buffer_size is explicitly cleared
to zero after reading the PBMC register but before writing
back the modified value.
This allows updates to other fields in the PBMC register to succeed.

Fixes: 0696d60853d5 ("net/mlx5e: Receive buffer configuration")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1753256672-337784-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 8e25f4ef5ccc..5ae787656a7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -331,6 +331,9 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 	if (err)
 		goto out;
 
+	/* RO bits should be set to 0 on write */
+	MLX5_SET(pbmc_reg, in, port_buffer_size, 0);
+
 	err = mlx5e_port_set_pbmc(mdev, in);
 out:
 	kfree(in);
-- 
2.39.5



