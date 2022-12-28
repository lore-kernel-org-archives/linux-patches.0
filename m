Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1547C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D5EC433EF;
	Wed, 28 Dec 2022 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240689;
	bh=Tb/biD9tF9fdsYz9RjtBO/7A1mIYzWTOS+IRfhhp5iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RK+aNc3Ah03oG1K2lhNdl9JPHaE/mnfnkc0BCScVRy4hNjURfjsMx9NCg6sMqDgFQ
	 +7KROhgrfTXwC+AO9pZEdolq8n0emKzrZDqJDMkY+se1wlJuNLBTIh6vLUUMFRIjfN
	 qqLP9rn948ZlKLAkdO6ZUhggck248XtVKE+aob9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 386/731] RDMA/restrack: Release MR restrack when delete
Date: Wed, 28 Dec 2022 15:38:13 +0100
Message-Id: <20221228144307.750382496@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit dac153f2802db1ad46207283cb9b2aae3d707a45 ]

The MR restrack also needs to be released when delete it, otherwise it
cause memory leak as the task struct won't be released.

Fixes: 13ef5539def7 ("RDMA/restrack: Count references to the verbs objects")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/703db18e8d4ef628691fb93980a709be673e62e3.1667810736.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 1f935d9f6178..01a499a8b88d 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -343,8 +343,6 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
 	rt = &dev->res[res->type];
 
 	old = xa_erase(&rt->xa, res->id);
-	if (res->type == RDMA_RESTRACK_MR)
-		return;
 	WARN_ON(old != res);
 
 out:
-- 
2.35.1



