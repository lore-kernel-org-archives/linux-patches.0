Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB0C1662E7;
	Tue, 26 Aug 2025 14:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217208; cv=none; b=s2utZpi2UW3ARBn9D51vWzsZVzdFh5w104lqKmVynv9AbL7uiIl2xER7kWDqAdFO3nkXg09cuPMY6GBYA4NKWow0QhlEUkYZ4Gsul9/9TrAwxiWR3jkiULg6ee3GWnMdhtPhLGs9LtdXDx7CHl2hl0aYt7a71NlG9+BVFUTgbyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217208; c=relaxed/simple;
	bh=Q9Wv1eSWfqSEP2kZgJuYWtxZjR1Z6BFjJhIxh+GeeVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTwfoN7vxUWPNRMdkm+nKcy7NsApyLhW3M+xxi7hCHqi4DpD0iFsPuZ8zrYAB/f7ZAPcJ12hhknA0emJqL9dr3rbv/Qx/r/U3Mn8OkpmfRgT9/U5Ebc6OmyRLWrlmUiA/FMguSYA6SphOI5vu1tdX4RHNpe4DQPI/y6UAd+40G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6oC5SA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6oC5SA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90619C4CEF1;
	Tue, 26 Aug 2025 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217207;
	bh=Q9Wv1eSWfqSEP2kZgJuYWtxZjR1Z6BFjJhIxh+GeeVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6oC5SA3Dw+OtWi/DbpiBwxUQzyLBGAEQiE40bCGXXH1bzA4Q0552TSwY1jlTDUAX
	 jv3ydnE/eL0hUm8QzTGDlTV7XcTRWNTD4cLfcQvor2yupDwRWKD+9uw1UNo4fEePg+
	 XIiSXNxkr+4N2AntWQvHvag5PxFA/TDrTqgCkXlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/523] RDMA/core: Rate limit GID cache warning messages
Date: Tue, 26 Aug 2025 13:04:26 +0200
Message-ID: <20250826110925.972369931@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
index 7989b7e1d1c04..2bd9fb3195f5e 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -582,8 +582,8 @@ static int __ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
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



