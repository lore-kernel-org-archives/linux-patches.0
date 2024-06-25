Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1B612EBEA;
	Tue, 25 Jun 2024 09:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308591; cv=none; b=ZnP/SNT559681q35l73Upckbrqb6NMiX1s4v3WK5OdrOqhQSJNNcXqjVzwnPr8+TEjC8Pq1rPgw2FhDKjfh5m0L7rr04v49FQyu+LE6vdRw68pYfTkpF2hTlQwOYV1Nt80A95ulDl/1S5C8ZrJzfAGozAi0ov6/hXkeEDZYQbZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308591; c=relaxed/simple;
	bh=dl43RsRTsfsF0pPYbazWh3lNrTUedq6LYjsRqS5lCD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYt7o7TvykWhfIiedafNY7t9PBCzD4uFpCTVZIqui+X0WEpgz9F3X0l4UI/HuK60Rmt1AlgRhRkeMQxTvRkgu0yzaOK+DMaYHSlnthrAMEnwet7NIBOpUM959PoYBEJbrhLNHv8uEP7iQM4I/wK6UOdCCjXFaSnsc/hDwcgLTnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMo7X+Aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMo7X+Aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5793EC32781;
	Tue, 25 Jun 2024 09:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308591;
	bh=dl43RsRTsfsF0pPYbazWh3lNrTUedq6LYjsRqS5lCD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMo7X+AaS3mGiwqyEtvDbc4doXu9Tvh23gbP9pXViioOGJGbHDhnzuSHSLitYZEC7
	 eQmJFes+wwHRH9y6V42w7+SYQjyuuWm870SkCVKevK3xvTZ8wzXzTtPagiG9iSwGLs
	 ToCrXAO4M8L8FqpxGb8kC+yyeHHYR9+n4oGMJd5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 174/250] RDMA/mlx5: Fix unwind flow as part of mlx5_ib_stage_init_init
Date: Tue, 25 Jun 2024 11:32:12 +0200
Message-ID: <20240625085554.730538705@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 81497c148b7a2e4a4fbda93aee585439f7323e2e ]

Fix unwind flow as part of mlx5_ib_stage_init_init to use the correct
goto upon an error.

Fixes: 758ce14aee82 ("RDMA/mlx5: Implement MACsec gid addition and deletion")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://lore.kernel.org/r/aa40615116eda14ec9eca21d52017d632ea89188.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c2b557e642906..9fb8a544236d7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3760,10 +3760,10 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	spin_lock_init(&dev->dm.lock);
 	dev->dm.dev = mdev;
 	return 0;
-err:
-	mlx5r_macsec_dealloc_gids(dev);
 err_mp:
 	mlx5_ib_cleanup_multiport_master(dev);
+err:
+	mlx5r_macsec_dealloc_gids(dev);
 	return err;
 }
 
-- 
2.43.0



