Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35BC69973;
	Wed, 21 Feb 2024 13:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521139; cv=none; b=D0k2/I/1aM63Ok+xm3mFaaSprrBfRVTHcH4OxRxf0RBgg4def+SQNjs586jie6jvqYFSrY+AwKviaQ/DRNLnFHcYBu6X7pJOXPs9/2baHuyuSZXxUVx6cLh995KJLUPkuVwE9Uxtvt84U3gOjdaLqM8OIDtZWcf0hHmwe0Y/ooI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521139; c=relaxed/simple;
	bh=NbjUtI6UBzAZVkMoR4Sm7bpBU+VNUVrcmWKm94UCQDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIPHDOsX9ZAIaVmkAxSSxp5pzWCT1vypuqggdBDF+cBVPDOk5xgPV1itnql90WkH3QBsWJgU6mYlEGlwGKZuMremP+uuvZICXnvF8NAJJC4GhBupTRBIOHvirIaEuEVzEMxpMTrS12jm5wANnEevc8OIxgV+qp8sa7IvyZV7aHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSaoQaNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSaoQaNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C8EC433F1;
	Wed, 21 Feb 2024 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521139;
	bh=NbjUtI6UBzAZVkMoR4Sm7bpBU+VNUVrcmWKm94UCQDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSaoQaNyd6Bov+clGatIeta/4ShNbuSUH77v9Z2PdDBlnCBsxXN/y0c8hzXX7FIZv
	 Evjbe+RfCIMo3UDTa27LS+al10ELLEtgTAPnPvGgjlL5aJLiWuSFe+HqqnmqrUoUkw
	 vQmTp592kVEU3OxW4X8E6Wx30rS9MeTDa6mbGHPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Efremov <efremov@linux.com>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/202] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Date: Wed, 21 Feb 2024 14:05:33 +0100
Message-ID: <20240221125932.825703314@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov <efremov@linux.com>

[ Upstream commit 360000b26e37a75b3000bf0585b263809d96ffd3 ]

Use kfree() instead of kvfree() on ft->g in arfs_create_groups() because
the memory is allocated with kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Stable-dep-of: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index a4be04debe67..13496d93e7bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -229,7 +229,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 			sizeof(*ft->g), GFP_KERNEL);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
-		kvfree(ft->g);
+		kfree(ft->g);
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.43.0



