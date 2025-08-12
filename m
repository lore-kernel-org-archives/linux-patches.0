Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C112F7461;
	Tue, 12 Aug 2025 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020239; cv=none; b=RBFG56/lqCjzgOQq7rxT1rGo/j5OM9slDAjuMsLcTRFf0Z9Sx3+xlcze59z7tYpktT/jp8fPd4XecLoK1mJrXb5YrQnlCqtO8OcnZ8CiiU5QK9ccKPSgvAd+CSzXgYRUgEpsZPsokXo/aFikh/14CBfseHQ4JBS/4ehDhVbnl+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020239; c=relaxed/simple;
	bh=Q7ES/FM+r34ehyaciCTJtMjHse6lv3m2vOGWpJJvOJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFPd2I8bnZFD7g+4WrpXixRkSRxnTfsmN9gar5MtseYNMc2sv2PX9mWT17Wln8tH5uB5Q63GTKOVNKriGSThlOKswqoVVklfNenj+xDbKWN+luazzXM/M5vKxsDloxPQ++Mw1J++j4Sso8EqgkwrneMOs+fM38pHJhFP8EaRq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyF8gkst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyF8gkst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88DEC4CEF0;
	Tue, 12 Aug 2025 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020239;
	bh=Q7ES/FM+r34ehyaciCTJtMjHse6lv3m2vOGWpJJvOJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyF8gkstLW0uTjhSse9tmD1rL+WIBE09EqGxgD/IVULJKNzrVnHMkwz8pLYuFz8wR
	 VxTWDTwtShJMsZLY57O9Khgj0sXsbC4zH2qFc+0SK21TZmz2I6LKYJRyq6vNw00gHi
	 TBYHDZ39tJnkM2lT1kPJkyJwaJCtYV68Ys+gNde4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/253] RDMA/core: Rate limit GID cache warning messages
Date: Tue, 12 Aug 2025 19:26:31 +0200
Message-ID: <20250812172948.828795304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 873988e5c5280..0023aad0e7e43 100644
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



