Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1511A6190;
	Tue, 30 Jul 2024 16:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356736; cv=none; b=eoiRd6i4hhVlxMlvN1MYfxSyeS7D3VSMxk/dtWkRmBlCVeMoVwEZUSFaHy2kUcO4p2NQiCFiitrbpjd8moGP5KFbHRKggQKo0utqdy4kKl642moX4C8eoPqhPeyZVP3UYtFSuEesoszQBSjs+MVXjx+cFMt6ywVe/m1X6QMkEa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356736; c=relaxed/simple;
	bh=r1KtwNsca5ZZYOAuXRcu0Q8tPPLj4ev4/JzmS5urC9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyNVpqWJnwDYPW8G67jmr3jqqY5uoLQjc0N5QEG+FsPp9G3YwmesMor73/QyI9A8zvUEPHeT4mBK9lz6V8uA1hesA30RVUcDungxrcsTG5NKsHpstw9JyJrk/y1PFq6sGYzYimwfuVPEunGUSxnKjK5CE2bMBU8m/E8aiF2+atE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=paW46zKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="paW46zKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16E0C32782;
	Tue, 30 Jul 2024 16:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356736;
	bh=r1KtwNsca5ZZYOAuXRcu0Q8tPPLj4ev4/JzmS5urC9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paW46zKANNPu2sD85YsOBHQ3MuRBkknNijityv3jnIYg3P0pwpZd3c/nnBueWSSI/
	 xL4MVbjYnO8/R0e5O/qhZNOIJ2wgEqQg1YxaI6xX1X5IYMPFsKVnJNfD55lTpHRjOY
	 r5NVzO6yYvRWMpd6YNmQYdSY1XCj9f9wBYzxDTD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/440] RDMA/mlx4: Fix truncated output warning in alias_GUID.c
Date: Tue, 30 Jul 2024 17:47:12 +0200
Message-ID: <20240730151623.645721925@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 5953e0647cec703ef436ead37fed48943507b433 ]

drivers/infiniband/hw/mlx4/alias_GUID.c: In function ‘mlx4_ib_init_alias_guid_service’:
drivers/infiniband/hw/mlx4/alias_GUID.c:878:74: error: ‘%d’ directive
output may be truncated writing between 1 and 11 bytes into a region of
size 5 [-Werror=format-truncation=]
  878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
      |                                                                          ^~
drivers/infiniband/hw/mlx4/alias_GUID.c:878:63: note: directive argument in the range [-2147483641, 2147483646]
  878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
      |                                                               ^~~~~~~~~~~~~~
drivers/infiniband/hw/mlx4/alias_GUID.c:878:17: note: ‘snprintf’ output
between 12 and 22 bytes into a destination of size 15
  878 |                 snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Fixes: a0c64a17aba8 ("mlx4: Add alias_guid mechanism")
Link: https://lore.kernel.org/r/1951c9500109ca7e36dcd523f8a5f2d0d2a608d1.1718554641.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 111fa88a3be44..9a439569ffcf3 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -829,7 +829,7 @@ void mlx4_ib_destroy_alias_guid_service(struct mlx4_ib_dev *dev)
 
 int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
 {
-	char alias_wq_name[15];
+	char alias_wq_name[22];
 	int ret = 0;
 	int i, j;
 	union ib_gid gid;
-- 
2.43.0



