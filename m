Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529021D0414;
	Wed,  2 Oct 2024 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878361; cv=none; b=WPB5m+mep6QCGidaISxx64zdutre83Roz8lWY804GUoU9HCgY6P3VFVWl/CWR4uXy2bx9D7OOhCpRMmJDdYPGlzVacYIGi/znBjVUAiGs61H2DQuFGJ4f3r/cGEyGBf3rie10ghNNCHzNb2YooAzKnsFIBVK2iBs0FLqU98ZV6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878361; c=relaxed/simple;
	bh=xPy/4wr9dze7gcPA45YFxNKEluRy5zZNlpmLOTBXZG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7Y9ipHWC3Ah+VkD+wl9W24quI9UDAVez5xRM9bS1vCVfq/5uTZDQS73IPm1LdNPUiMm4R+fmAEBYrLejiWvUoFXzoszgYclsoBAximPH0/qC0pafBPAiKQ0aMNt+hk105ugHkrR+EtHMmakZb6Aw7R+NJMFKffize+PuOf/D+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNua77rV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNua77rV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18DFC4CEC2;
	Wed,  2 Oct 2024 14:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878361;
	bh=xPy/4wr9dze7gcPA45YFxNKEluRy5zZNlpmLOTBXZG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNua77rV4dy/5AJADEXD0L8PSd+j3X97J4b6WnO+1bq8cHUE+jR2ZvzpIGXSZkkR0
	 5S8sjV2AZP+99oxqGKXNNtNdUo0XX9QheXRW2NE0QYKpf+v1IqwKtje88loSmZnlpY
	 IxokD5QLImAtaH0ormMkOJGvWuzn4jLYdbnAp7Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 370/634] RDMA/mlx5: Drop redundant work canceling from clean_keys()
Date: Wed,  2 Oct 2024 14:57:50 +0200
Message-ID: <20241002125825.702836192@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 30e6bd8d3b5639f8f4261e5e6c0917ce264b8dc2 ]

The canceling of dealyed work in clean_keys() is a leftover from years
back and was added to prevent races in the cleanup process of MR cache.
The cleanup process was rewritten a few years ago and the canceling of
delayed work and flushing of workqueue was added before the call to
clean_keys().

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/943d21f5a9dba7b98a3e1d531e3561ffe9745d71.1725362530.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 7ebb00cea49d ("RDMA/mlx5: Fix MR cache temp entries cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b3a8dc9465c04..842e218cd0b5e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -779,7 +779,6 @@ static void clean_keys(struct mlx5_ib_dev *dev, struct mlx5_cache_ent *ent)
 {
 	u32 mkey;
 
-	cancel_delayed_work(&ent->dwork);
 	spin_lock_irq(&ent->mkeys_queue.lock);
 	while (ent->mkeys_queue.ci) {
 		mkey = pop_mkey_locked(ent);
-- 
2.43.0



