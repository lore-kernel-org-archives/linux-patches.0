Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397B315703F;
	Mon, 29 Jan 2024 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548332; cv=none; b=fD+j8xHTPWdODLOpuhH4O4TtSRrFVHMxsVOg6L4jkp3ZxAvesIPWQU+NR+DMdslMbd1w6dPww87fsD8XYz+3IoG3AuTgNqIq4v7G637xQ2FD5W/XRgpuzeHV1F1lSVFzgme4B2rV2NU9WVjRiUhz3CILAN+dfkGoJjZet31gRY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548332; c=relaxed/simple;
	bh=unU0ZrwOjfnfy/X1s9piMgJVNyctT2pgYL7x7sphewQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1XvOKyAfWgfAXlXRzqsskM3I6Ykn2+eAxcweF+M0GshjZeIP1Frh0fpT++EFL2ID3sM14kFhxW87FCZyqtrLJ9fNhBvHJplTDP0sUjGmt06cuhj4MLj4kOUpxJm4nxYLRVd+tXWpwxzLPnbmsjT3pb2JdzQTPofYjbI+BV4PmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9Id/zIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9Id/zIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35B2C433C7;
	Mon, 29 Jan 2024 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548332;
	bh=unU0ZrwOjfnfy/X1s9piMgJVNyctT2pgYL7x7sphewQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9Id/zIfJVfeBwpHhdWDvJCHQOUevvsi61xU8Qf/40Q0E8Wf0O9WANvB/LXHEud2s
	 Ne1ugiiTCRxdPXagHGrVCOl+giFSdua7tlCcm6iug8SS9ehW7/VkIp0j8lwvdTWBYw
	 3YjBOS0CFlhJkQ/AqH3L4QhF8FEUMryCG+r7oaKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/185] net/mlx5e: fix a potential double-free in fs_any_create_groups
Date: Mon, 29 Jan 2024 09:05:00 -0800
Message-ID: <20240129170001.807948141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit aef855df7e1bbd5aa4484851561211500b22707e ]

When kcalloc() for ft->g succeeds but kvzalloc() for in fails,
fs_any_create_groups() will free ft->g. However, its caller
fs_any_create_table() will free ft->g again through calling
mlx5e_destroy_flow_table(), which will lead to a double-free.
Fix this by setting ft->g to NULL in fs_any_create_groups().

Fixes: 0f575c20bf06 ("net/mlx5e: Introduce Flow Steering ANY API")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
index e1283531e0b8..671adbad0a40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -436,6 +436,7 @@ static int fs_any_create_groups(struct mlx5e_flow_table *ft)
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
 		kfree(ft->g);
+		ft->g = NULL;
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.43.0



