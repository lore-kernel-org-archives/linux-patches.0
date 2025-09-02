Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB7630505C;
	Tue,  2 Sep 2025 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819595; cv=none; b=q+QsMKFkYJ+6YYHJ7bDPHuY8ou006LmamqlR4L3Hl+IIzoSZYOFvh30vhP0rKuE7RBc+uAQ53rn/pd8EjQG3Ikt3U7kfSBKmzqUyYl8Qqj8NztCKw+JkLF0eF2xdB3zH9bdu8MZz4O/tdrU7LbwhwVsFi6IsYtblR3JmsbxL/pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819595; c=relaxed/simple;
	bh=8KIiT83VU7KgSXUMbF8BOnwduSKev54LtT8e9QFLK8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtjUT50cXaRglI2EZziTLUVG559mlh7Uaab393jlNfJKWGbnfCBP7Nb4qY5MI0EepgmhgbG17xyjgHHGuN9xq2zE4gIr9wbrwU3v3MCyPDj6dlTr43/Y8JNv6tV79/26sI5mOnSL1zG5b8UjUCdmyFXxJ40wROIa5WPlK4d2GXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al6CS409; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al6CS409"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4533CC4CEED;
	Tue,  2 Sep 2025 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819595;
	bh=8KIiT83VU7KgSXUMbF8BOnwduSKev54LtT8e9QFLK8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al6CS409z+4ZUFpg9pOZNd/nWkD0cOMz9m+/8m6uwaytB6aHw8jDxUrEpNGboSWX4
	 LrD+rRUrngpV6j4Q70plW5YxLIgTgVNn1VVcKcX/InygN/Dqfsl83Z7pMvQ+dlawRU
	 qh6bQtoXfgbR+PApg+7jyrKgY/qphFF2lqqKgmwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 081/142] net/mlx5: HWS, Fix pattern destruction in mlx5hws_pat_get_pattern error path
Date: Tue,  2 Sep 2025 15:19:43 +0200
Message-ID: <20250902131951.371339605@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit 00a50e4e8974cbf5d6a1dc91cfa5cce4aa7af05a ]

In mlx5hws_pat_get_pattern(), when mlx5hws_pat_add_pattern_to_cache()
fails, the function attempts to clean up the pattern created by
mlx5hws_cmd_header_modify_pattern_create(). However, it incorrectly
uses *pattern_id which hasn't been set yet, instead of the local
ptrn_id variable that contains the actual pattern ID.

This results in attempting to destroy a pattern using uninitialized
data from the output parameter, rather than the valid pattern ID
returned by the firmware.

Use ptrn_id instead of *pattern_id in the cleanup path to properly
destroy the created pattern.

Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args handling")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-5-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
index 622fd579f1407..d56271a9e4f01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
@@ -279,7 +279,7 @@ int mlx5hws_pat_get_pattern(struct mlx5hws_context *ctx,
 	return ret;
 
 clean_pattern:
-	mlx5hws_cmd_header_modify_pattern_destroy(ctx->mdev, *pattern_id);
+	mlx5hws_cmd_header_modify_pattern_destroy(ctx->mdev, ptrn_id);
 out_unlock:
 	mutex_unlock(&ctx->pattern_cache->lock);
 	return ret;
-- 
2.50.1



