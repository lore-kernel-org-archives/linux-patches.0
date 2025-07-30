Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6020426E71A;
	Wed, 30 Jul 2025 09:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869090; cv=none; b=CAk5AJhqHcKfyRwHt5tRH5FDcHAg3dfPNsk0NaloINHXrXvpQrXNXMbBd5uTPJ8Awnni6md6b/EWQWhDloPZ91Vs3rmykRXLNRa8vyUzSbSAztBNeVDnK2K6ZRjLwTCXSX0qvfh9S0wVZK+UKHnASE+H5yv1fCexI3U7o82Lt/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869090; c=relaxed/simple;
	bh=6osrjUoo6bMjKzmIz2Bz8MQKpEdQcNcfo8V1kwfFq2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSac/UIHhaL1TFKMeaF0C4qJjY4BuKrIZzXzDEUjxGTvLCc2F7PR8eNlAxwR2YUdUPACKg8QjTgtQ0okjM+kg4VMaMwTbS17aeYyiWwUbVZkdxsoUOLzyCARMN+dUoj+eUjGd7TsZ0sIr1oin6u3l4E9V28NuvVZIKr99N9nxUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2SUVJBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2SUVJBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B83C4CEF5;
	Wed, 30 Jul 2025 09:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869090;
	bh=6osrjUoo6bMjKzmIz2Bz8MQKpEdQcNcfo8V1kwfFq2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2SUVJBhvjHpXhwq+QcF3eoqGkzX16Stf9Pel6PU9qT1X3zVML0yEipAEN6xll74u
	 DNs93rshCr55R4smGxO3vooQtTLDewAnDJgu0joHNaTVn8StR1z7zZ5iihV+c1x3Vn
	 C6Ez49FjKvh3mYpzFmE9eBI3Q1Al8uG0WdMfqhFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 07/92] RDMA/core: Rate limit GID cache warning messages
Date: Wed, 30 Jul 2025 11:35:15 +0200
Message-ID: <20250730093230.916876836@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 333e4d79316c9ed5877d7aac8b8ed22efc74e96d ]

The GID cache warning messages can flood the kernel log when there are
multiple failed attempts to add GIDs. This can happen when creating many
virtual interfaces without having enough space for their GIDs in the GID
table.

Change pr_warn to pr_warn_ratelimited to prevent log flooding while still
maintaining visibility of the issue.

Link: https://patch.msgid.link/r/fd45ed4a1078e743f498b234c3ae816610ba1b18.1750062357.git.leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 9979a351577f1..81cf3c902e819 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -582,8 +582,8 @@ static int __ib_cache_gid_add(struct ib_device *ib_dev, u32 port,
 out_unlock:
 	mutex_unlock(&table->lock);
 	if (ret)
-		pr_warn("%s: unable to add gid %pI6 error=%d\n",
-			__func__, gid->raw, ret);
+		pr_warn_ratelimited("%s: unable to add gid %pI6 error=%d\n",
+				    __func__, gid->raw, ret);
 	return ret;
 }
 
-- 
2.39.5



