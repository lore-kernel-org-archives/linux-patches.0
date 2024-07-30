Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A021D183CDB;
	Tue, 30 Jul 2024 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356534; cv=none; b=FdCvS6ErX3Ozpxb1gPbsg7Z5l4y4dsM5o/YcZqs/hFQBZNPS053JauXAuWhxqCDpseMlteY2nbvxJB+BXEms1m5kyKDn7xpAV34Jw8hHlilAUbM+tz9Op6jxyfZTwLVcdvH2jgWZsawMZbGWaDZcwpAqy6V7s31xiYL1W6mwCtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356534; c=relaxed/simple;
	bh=WMd0wKByz8DEspVXXWO23q1aSu2eiHRvs2ITxFEuWvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxnM5t+0zvc+qaRS+NC4WE5reBB3N5ZYFQVIf9P+mqMSzET8wR4eL/kZMnA4JER9AKxkasLZAnsfS1UA7G+ATd7JjF7YT1XRg7GGG3TKLJuAyQQiRYyehW6mxtOI5gLV38RtgjWhmRmfwsOELR+z6AYRWFWsHuX1vTz3TT/EcXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAOhF2hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAOhF2hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1394AC4AF0A;
	Tue, 30 Jul 2024 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356534;
	bh=WMd0wKByz8DEspVXXWO23q1aSu2eiHRvs2ITxFEuWvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAOhF2hn7yH4s7FjKiihK3wjad7Rhu7dkkdjaVz1kBMhAjfGtVa8r19RKTh59KR7p
	 X4ZYPFouqDKiSfyY6yMaZYkrJWo4byhPdOp2SfSUcE0Ac2JFdTkR7gJSUo5X/H2xAS
	 EkpVzIqM/zp35l4X5dJpyVBjZzFso+b8GXeGV8n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/440] RDMA/mlx5: Use sq timestamp as QP timestamp when RoCE is disabled
Date: Tue, 30 Jul 2024 17:47:13 +0200
Message-ID: <20240730151623.684340692@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 0c5275bf75ec3708d95654195ae4ed80d946d088 ]

When creating a QP, one of the attributes is TS format (timestamp).
In some devices, we have a limitation that all QPs should have the same
ts_format. The ts_format is chosen based on the device's capability.
The qp_ts_format cap resides under the RoCE caps table, and the
cap will be 0 when RoCE is disabled. So when RoCE is disabled, the
value that should be queried is sq_ts_format under HCA caps.

Consider the case when the system supports REAL_TIME_TS format (0x2),
some QPs are created with REAL_TIME_TS as ts_format, and afterwards
RoCE gets disabled. When trying to construct a new QP, we can't use
the qp_ts_format, that is queried from the RoCE caps table, Since it
leads to passing 0x0 (FREE_RUNNING_TS) as the value of the qp_ts_format,
which is different than the ts_format of the previously allocated
QPs REAL_TIME_TS format (0x2).

Thus, to resolve this, read the sq_ts_format, which also reflect
the supported ts format for the QP when RoCE is disabled.

Fixes: 4806f1e2fee8 ("net/mlx5: Set QP timestamp mode to default")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Link: https://lore.kernel.org/r/32801966eb767c7fd62b8dea3b63991d5fbfe213.1718554199.git.leon@kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/qp.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index ca0eee571ad7b..15e8d7fd3879f 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -566,9 +566,12 @@ static inline const char *mlx5_qp_state_str(int state)
 
 static inline int mlx5_get_qp_default_ts(struct mlx5_core_dev *dev)
 {
-	return !MLX5_CAP_ROCE(dev, qp_ts_format) ?
-		       MLX5_TIMESTAMP_FORMAT_FREE_RUNNING :
-		       MLX5_TIMESTAMP_FORMAT_DEFAULT;
+	u8 supported_ts_cap = mlx5_get_roce_state(dev) ?
+			      MLX5_CAP_ROCE(dev, qp_ts_format) :
+			      MLX5_CAP_GEN(dev, sq_ts_format);
+
+	return supported_ts_cap ? MLX5_TIMESTAMP_FORMAT_DEFAULT :
+	       MLX5_TIMESTAMP_FORMAT_FREE_RUNNING;
 }
 
 #endif /* MLX5_QP_H */
-- 
2.43.0



