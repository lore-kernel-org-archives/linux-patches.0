Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BFE17E90E;
	Mon, 27 May 2024 19:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837210; cv=none; b=gLLrbSA+wg3IRI44UQQEUoqzpAF4ennLLtfniesmDG0sC09cWk/bvuip2HcIgJlneQnz9FUSD7RtH1zsnhXgNtns4oNV3wSE2vy6xnmGmxBQi5lJjrHQf7zHERHZaE+RSN7uM4lNn+I7KdIMZQN25MSR9iCUvq1+/D4Fnr2Wh+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837210; c=relaxed/simple;
	bh=K+t5/3UtA5iDTl/rDdyBeyrEJpfkjsij9JscobEbv4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyQWDeaTuefVBeWmZKu122wJ1hVxPlKgYz/jGisBLNL9M1JCuy/JySmiCqy4qoOXtFmtCgpUAWXBZGTUeWIRGyQcwkZ3kR5hs9aar2YqPfD1AQDcQMbSFSv1eXCmXQCd/6lUgEKGqFi7QcF0EeFoDBx5M4oF2nXOOU+WH3wYXOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/6CkRDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/6CkRDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF28EC32781;
	Mon, 27 May 2024 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837210;
	bh=K+t5/3UtA5iDTl/rDdyBeyrEJpfkjsij9JscobEbv4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/6CkRDC4RRX8tVzy5o5hQ9e5c3Q45AvVQ24xP1EW8B/1bTdc57lXsdkgnnvdAItI
	 8NGmsYZ8dRtamGdB16D2/+0hk1dtgeXxWpiKIimR8cmvJwFdgzCiKq4w5wG101TBRI
	 oR9teX4kKXi+pLNFEdVEkctZ/LgUt07G7aM75dJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 351/427] RDMA/mlx5: Adding remote atomic access flag to updatable flags
Date: Mon, 27 May 2024 20:56:38 +0200
Message-ID: <20240527185633.445268539@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 2ca7e93bc963d9ec2f5c24d117176851454967af ]

Currently IB_ACCESS_REMOTE_ATOMIC is blocked from being updated via UMR
although in some cases it should be possible. These cases are checked in
mlx5r_umr_can_reconfig function.

Fixes: ef3642c4f54d ("RDMA/mlx5: Fix error unwinds for rereg_mr")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Link: https://lore.kernel.org/r/24dac73e2fa48cb806f33a932d97f3e402a5ea2c.1712140377.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7f7b1f59b5f05..ecc111ed5d86e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1572,7 +1572,8 @@ static bool can_use_umr_rereg_access(struct mlx5_ib_dev *dev,
 	unsigned int diffs = current_access_flags ^ target_access_flags;
 
 	if (diffs & ~(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE |
-		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING))
+		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING |
+		      IB_ACCESS_REMOTE_ATOMIC))
 		return false;
 	return mlx5r_umr_can_reconfig(dev, current_access_flags,
 				      target_access_flags);
-- 
2.43.0



