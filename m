Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB712F83CB;
	Tue, 12 Aug 2025 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021353; cv=none; b=iEumixra43JWOh+LwzpfyDt2BSQQJpxV66ufno22UKYbCs52rnphVP6A42w1GA08wUWVJOwBX5ya5moS5hIhgTCtOUnTZAi2y8wp3XETQaLtFt23Z1GqDzVL9HOZLczGwFrwRrt1mQPR1hlsL+99fK++m85aXxOVx9To9CvQi+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021353; c=relaxed/simple;
	bh=Ykv7PJ/WewdvA2jZB2f859xgAbFeLabP4VqT+nWnPxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6Vs8fcjizH93u2fuoxBnJZeE/rnptffthGid9fQq9zKWW/ajUfqEMx0Jb6b0gNdB8RQlvTuUDN5GcBUsH6IkTDM2b1970796rqa2v8nzGEJteXkGEiNlk5zqGmPDla7vbK1gPb8+5yLAVuuSVFhqGlmc/hY4VCtlVCQeyb1wmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6LOB1zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6LOB1zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AEDC4CEF1;
	Tue, 12 Aug 2025 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021353;
	bh=Ykv7PJ/WewdvA2jZB2f859xgAbFeLabP4VqT+nWnPxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6LOB1ztQH1ZqJa1Qmx2o628tGOFp4/Kgf4rZiGIorCv7gAxmQ0HNj6QU6sM7Sq8z
	 o7Jp5cDo0CJGr7gJz5lgvJ1hpsA8LnYcRJt4Afy6+ArW7ZKxwlMe46VdumBn0TcEzW
	 pr4YEGIfnjGW57vG+6jpSmwdpmrbsylLUHxEW3Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/262] net/mlx5e: Clear Read-Only port buffer size in PBMC before update
Date: Tue, 12 Aug 2025 19:28:07 +0200
Message-ID: <20250812172957.304130944@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



