Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9794BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5126AC433C8;
	Mon, 19 Jun 2023 10:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171682;
	bh=VXEv/PMPG9sHzKGA9zlWeLeTWAtVM8DyIuAfjtIizRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WleQ4ngToFDI9Nb5XOh+lSlp+05tKk99wLv/a+JpFmV+qieeLX2qkJFaJRNbIq3dP
	 rGTZ3hKzhYaXvT/I1k8nS5D5/HoRJQ9SvpVRY1108HaYf4ollQNJwp/FwWgLu2zcSs
	 vLAI0z+5+7AXUFaJCCRTjUKoY02MPGTn9ZJENStA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/166] IB/uverbs: Fix to consider event queue closing also upon non-blocking mode
Date: Mon, 19 Jun 2023 12:29:56 +0200
Message-ID: <20230619102200.616311392@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 62fab312fa1683e812e605db20d4f22de3e3fb2f ]

Fix ib_uverbs_event_read() to consider event queue closing also upon
non-blocking mode.

Once the queue is closed (e.g. hot-plug flow) all the existing events
are cleaned-up as part of ib_uverbs_free_event_queue().

An application that uses the non-blocking FD mode should get -EIO in
that case to let it knows that the device was removed already.

Otherwise, it can loose the indication that the device was removed and
won't recover.

As part of that, refactor the code to have a single flow with regards to
'is_closed' for both blocking and non-blocking modes.

Fixes: 14e23bd6d221 ("RDMA/core: Fix locking in ib_uverbs_event_read")
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/97b00116a1e1e13f8dc4ec38a5ea81cf8c030210.1685960567.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index d544340887277..fa937cd268219 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -222,8 +222,12 @@ static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_queue *ev_queue,
 	spin_lock_irq(&ev_queue->lock);
 
 	while (list_empty(&ev_queue->event_list)) {
-		spin_unlock_irq(&ev_queue->lock);
+		if (ev_queue->is_closed) {
+			spin_unlock_irq(&ev_queue->lock);
+			return -EIO;
+		}
 
+		spin_unlock_irq(&ev_queue->lock);
 		if (filp->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
@@ -233,12 +237,6 @@ static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_queue *ev_queue,
 			return -ERESTARTSYS;
 
 		spin_lock_irq(&ev_queue->lock);
-
-		/* If device was disassociated and no event exists set an error */
-		if (list_empty(&ev_queue->event_list) && ev_queue->is_closed) {
-			spin_unlock_irq(&ev_queue->lock);
-			return -EIO;
-		}
 	}
 
 	event = list_entry(ev_queue->event_list.next, struct ib_uverbs_event, list);
-- 
2.39.2



