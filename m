Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9867E294A11;
	Wed, 30 Jul 2025 09:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868227; cv=none; b=nquN0XgTtZAfI8f4x+Np7yzidK4/qvlomQ28RN6RPvIq6vOcky3dQ3HKNpYD64yARKHxEq1e505RVwWC7844+PMZ6f/Tgr10a9HqJH6nCn1XEp/mmkJGR3gmld9Fn4uCMuRR4FXmsQYtKmUz21/R5lWCZfw4T0Fr8Dv6edb8cBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868227; c=relaxed/simple;
	bh=EToBX7FbBB2cQIFK+02l7lq610MDlj+yOgS9uJIhe8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVo4tTWgbSeRfLJEhqhUgSlsagyNIXlhOetEPjY5ea3TBulBi3aCnG2fazYWyQ0nkvqC+r+x9Umt9O279BiyACaWFVB/18vC8TQzLUVLKMgbffI+ZKGHsty9HKbvJBmawCPGIqdi1GPOhiKqMGOpsHuX5vAQ7oxe1z7guje1iX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orhUHVG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orhUHVG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EF4C4AF09;
	Wed, 30 Jul 2025 09:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868227;
	bh=EToBX7FbBB2cQIFK+02l7lq610MDlj+yOgS9uJIhe8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orhUHVG8C1GcAyfNdIBCgZCEgm6+OYk9zYAMbCW/nIO+grdhvvqzdnUrBrK2wdRWL
	 dyary28npmzu/2mDQpZv2tW4yYC4A3HrFe0rMDJxpX3JtuGldpFQV4K9csoF/XQKPr
	 0mlU+0H7J5++ywbrwU/CvbhDb5tLxOs/vNliMbjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Tereshkin <atereshkin@nvidia.com>,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/76] net/mlx5: Fix memory leak in cmd_exec()
Date: Wed, 30 Jul 2025 11:35:05 +0200
Message-ID: <20250730093227.328487120@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit 3afa3ae3db52e3c216d77bd5907a5a86833806cc ]

If cmd_exec() is called with callback and mlx5_cmd_invoke() returns an
error, resources allocated in cmd_exec() will not be freed.

Fix the code to release the resources if mlx5_cmd_invoke() returns an
error.

Fixes: f086470122d5 ("net/mlx5: cmdif, Return value improvements")
Reported-by: Alex Tereshkin <atereshkin@nvidia.com>
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1752753970-261832-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 3e6bd27f6315d..5a2126679415c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1916,8 +1916,8 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 
 	err = mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, context,
 			      pages_queue, token, force_polling);
-	if (callback)
-		return err;
+	if (callback && !err)
+		return 0;
 
 	if (err > 0) /* Failed in FW, command didn't execute */
 		err = deliv_status_to_err(err);
-- 
2.39.5



