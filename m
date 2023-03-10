Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B65847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BF6C433D2;
	Fri, 10 Mar 2023 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456170;
	bh=VKykDTUHooAK051sbc7bIWJbAFqQk3nuU3UA+vXmKdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIOLzhDWa5LUW3dHwOJn3d8UPOMyrk53UrPQyVnv4oKBMBEq3l+F3QGwyQUWSx4ve
	 1+MESnjoehGdLgeCR84iFoXDvYqSALZMU/8fq0aFV0Im0kMNEMIai3ZslBVE0rcJjq
	 uNVVSlmJUQoLfyEYKrYMu7jYZaybkwTGLFnovF74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 064/193] dm: remove flush_scheduled_work() during local_exit()
Date: Fri, 10 Mar 2023 14:37:26 +0100
Message-Id: <20230310133713.160515002@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 0b22ff5360f5c4e11050b89206370fdf7dc0a226 ]

Commit acfe0ad74d2e1 ("dm: allocate a special workqueue for deferred
device removal") switched from using system workqueue to a single
workqueue local to DM.  But it didn't eliminate the call to
flush_scheduled_work() that was introduced purely for the benefit of
deferred device removal with commit 2c140a246dc ("dm: allow remove to
be deferred").

Since DM core uses its own workqueue (and queue_work) there is no need
to call flush_scheduled_work() from local_exit().  local_exit()'s
destroy_workqueue(deferred_remove_workqueue) handles flushing work
started with queue_work().

Fixes: acfe0ad74d2e1 ("dm: allocate a special workqueue for deferred device removal")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e6689fd22730..e3facf14f6149 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -220,7 +220,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	kmem_cache_destroy(_rq_cache);
-- 
2.39.2



