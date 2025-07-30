Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976A0635;
	Wed, 30 Jul 2025 09:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868287; cv=none; b=X/l489hdu3sq2Mazy41zzaw67cBrz/0l1+Ape3qbrBPcLfCdPKJoIljJ6E/ajI5DkHFlBJPrz5FSBE1RGE+4tHb1pNXP7fTJDvq5JtRESRrTwyhsxS9g5P7W/anoWvY9KnEPlYHKOU2Cjjyzt1TDhIKBph+gmTFMAWEXKocdb2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868287; c=relaxed/simple;
	bh=CjRid3Nbq9NgLq4b/w2ebDFGntu3Kg1tEQNig5sFVSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qe3449SkgoA+KeMnhQZ0QG/77XcHjPT+QXtQev88efx9XZrD5BvRguRccpRLlNYcycrQqiuBOBDcj+eIlDgp9Up4XkQWne2s1cLZKUeaS+6wZxA+RJi9SZUAOBx1fIc10zLAGQCdiA0GbYnMv04W3iti/UkxGl/XxGZ2P1rlP5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3r/In3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3r/In3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85B7C4CEE7;
	Wed, 30 Jul 2025 09:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868287;
	bh=CjRid3Nbq9NgLq4b/w2ebDFGntu3Kg1tEQNig5sFVSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3r/In3n2bcatinJu6Rry2R6gPSt3C0tUrcISQx6OEXEj7QbmZQ+idaknqHgzRCiw
	 sY7qeYUov8oFl429zY6vsuzgK8C6Pq5NAt7EaaqTk6ELc9KlanhVJcnb5cSU8rizlN
	 6W+ywXxd+w78TsTUrr2wODfe9R0dKdlrRQJnXl6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/76] RDMA/core: Rate limit GID cache warning messages
Date: Wed, 30 Jul 2025 11:34:57 +0200
Message-ID: <20250730093227.028382181@linuxfoundation.org>
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
index 0b88203720b05..77c0b89259911 100644
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



