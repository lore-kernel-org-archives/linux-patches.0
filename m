Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C381E9B06;
	Tue, 11 Mar 2025 15:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706497; cv=none; b=NNvxO1wggL3RKMWqlWRKNEFDF6YnPv1gdI2afyxkrmSJ/EY7wxG3qgAbsVeTSGHMINCkG2qTo3HxC93XjyWisoqvl/1HXQSD10vbb02DqN9M9HsRqs++cXAAVDebPR4Lp1BOo4C1jPkItRGW9WRebGe3TvuGz4K+8ddKSGxikP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706497; c=relaxed/simple;
	bh=Y8yYrhap6xKmPJyqjUNYg4/UMk7eLtIocfGb49+pdtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rcv/IOIQNUhlYw/dU61lemPaHhqYyGcH6xGrQ7Jrqm3uuuWnhgsDBJfcFoz0tVgASlmqzl4+739FNS46z7pGiE1vmMrEdR9LqMbD11QGRjiJxRglMPeoVjWqancw4TyuY0PffsqLVTAa0r6ETwJMwTDwOMOAKvud7NDp1C4yIRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6QzEMWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6QzEMWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A22C4CEED;
	Tue, 11 Mar 2025 15:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706497;
	bh=Y8yYrhap6xKmPJyqjUNYg4/UMk7eLtIocfGb49+pdtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6QzEMWMHMDRlRN4+yhcpwl3maJ0hzuH5MVt1xm6PKmCQT/D9Zh4kCoNT8ocwpIKj
	 I7ktSsBQjLTF97rrMMbfMwBeCZhHcwqenHn9APu3m5mYgWsEL64P9A53I7QDaDYgiJ
	 ED8Vjk2gx0WOjFOS5p+CYxlwlVlz8X5mcHghlyDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/462] RDMA/mlx4: Avoid false error about access to uninitialized gids array
Date: Tue, 11 Mar 2025 15:55:34 +0100
Message-ID: <20250311145801.037438288@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 1f53d88cbb0dcc7df235bf6611ae632b254fccd8 ]

Smatch generates the following false error report:
drivers/infiniband/hw/mlx4/main.c:393 mlx4_ib_del_gid() error: uninitialized symbol 'gids'.

Traditionally, we are not changing kernel code and asking people to fix
the tools. However in this case, the fix can be done by simply rearranging
the code to be more clear.

Fixes: e26be1bfef81 ("IB/mlx4: Implement ib_device callbacks")
Link: https://patch.msgid.link/6a3a1577463da16962463fcf62883a87506e9b62.1733233426.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c62cdd6456962..0c49f3f5e6247 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -391,10 +391,10 @@ static int mlx4_ib_del_gid(const struct ib_gid_attr *attr, void **context)
 	}
 	spin_unlock_bh(&iboe->lock);
 
-	if (!ret && hw_update) {
+	if (gids)
 		ret = mlx4_ib_update_gids(gids, ibdev, attr->port_num);
-		kfree(gids);
-	}
+
+	kfree(gids);
 	return ret;
 }
 
-- 
2.39.5



