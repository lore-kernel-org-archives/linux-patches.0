Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B56518E377;
	Wed,  5 Feb 2025 14:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767030; cv=none; b=VAB01w4co4ZB0C+DcBrGYad/WD4FJ8oz0FDkV4EXPGlBvIX+fGWwteF9pItAgyYbzxrg8cFvqqj2rXMvodAE5++u44L5bwAtK+uKBbrA70eZJx9uOg9hh4cFa8DD6BILjTYNAGwt6DOiMSV6A/0Yk3aP+6rwkTHIWpe2ydKFE9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767030; c=relaxed/simple;
	bh=Majpy2VhXsZxLAEIWBS8EXyuyv9RhR3u8Xd8NVu1sDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtRmAHPC9Jkb4AnFR5EaQ0a/pz1Ak+HB3znJr8eZqNFcsye/XaBFk3TB7HgLzcU8JXr0mlWoTcvgYmrudVImfIcqh2+/hTG95BzIveSFvdFcpNpfkU52SiIABGG58ZXB1GidjGOuys6JmPFrtZHqF9LlNlIzLZLlutGBnIle4cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGccKLBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGccKLBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85184C4CED1;
	Wed,  5 Feb 2025 14:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767030;
	bh=Majpy2VhXsZxLAEIWBS8EXyuyv9RhR3u8Xd8NVu1sDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGccKLBkNcuBTldWbJmwyJ2lDNYmeGADAb826AExQBF59yzXOVlivvYKHzSRK/y/Q
	 DtvSG4p23aAjUGVlDIQ331Sx2YJQtJoBkJdZjtIjazFFxnH1anaUc6P3ZiXwa4dQy9
	 K0VlL1c0BqXSJo2C1U+/GfCTCHrKIh29qyGgqkF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 342/623] RDMA/mlx4: Avoid false error about access to uninitialized gids array
Date: Wed,  5 Feb 2025 14:41:24 +0100
Message-ID: <20250205134509.311307811@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/infiniband/hw/mlx4/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 529db874d67c6..b1bbdcff631d5 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -351,7 +351,7 @@ static int mlx4_ib_del_gid(const struct ib_gid_attr *attr, void **context)
 	struct mlx4_port_gid_table   *port_gid_table;
 	int ret = 0;
 	int hw_update = 0;
-	struct gid_entry *gids;
+	struct gid_entry *gids = NULL;
 
 	if (!rdma_cap_roce_gid_table(attr->device, attr->port_num))
 		return -EINVAL;
@@ -389,10 +389,10 @@ static int mlx4_ib_del_gid(const struct ib_gid_attr *attr, void **context)
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



