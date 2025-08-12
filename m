Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227D92D46B3;
	Tue, 12 Aug 2025 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022480; cv=none; b=hwg8PjX4AYgH58rv4EA1tZDuHP4ImmzrmrDHFBMytX3O+FmhrzMbkpvvFyjtRuo8jCRRKYaSxUZu1egAnhFvD0FQXn8HqRCCiYVDnUa6sLxNQnRMRScCcIdgYq1M8Hw7+hvuRZ+UCQ+8lLZV/EwuUYFex+yXrochMzQvxNdtUso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022480; c=relaxed/simple;
	bh=JW31C43uVvJY2F/TgEroGph3crLXn/4QJYrY1bVLpVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq6YVEKUkmzseytd4ZTLnoS3MCKsxYVtD4d4Tbl1kanlvqgkK9bqAO5lqRhccW58jRziS6Ivlfhyl3FIuyFfvAYvRWTzyZyMipHgu6dhXJ7K16kdScBtWUAoq2N0a6vA/b0dGk72SGyPIP1tUe85IBvu42CZ7u4IR/uQMLe5XDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHznC6nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHznC6nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80894C4CEF0;
	Tue, 12 Aug 2025 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022480;
	bh=JW31C43uVvJY2F/TgEroGph3crLXn/4QJYrY1bVLpVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHznC6nYjXk7rsUiWIQa9pcRnYxup/xNLmsa4JOGGvnSPSdjikbCabOt7ysbfmnr+
	 wWGAjwokEmV/4B6kvfAQeMxzMayq4nsLWeSKvHQp5+sU9H42GbTu/qCNJRVKuekXbn
	 bEWsWXZ2f0ulTwWf7iYRLU4jB7FjnXe+f1NE/eFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/369] net/mlx5e: Clear Read-Only port buffer size in PBMC before update
Date: Tue, 12 Aug 2025 19:27:17 +0200
Message-ID: <20250812173020.040270490@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



