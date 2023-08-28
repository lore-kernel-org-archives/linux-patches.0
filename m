Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E1011C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2F8C433C7;
	Mon, 28 Aug 2023 10:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218176;
	bh=bdGFGJ1+lun/kLHLH1UOP8ArW9jsiJudUsZzfBY16C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPBFE0gf525Zr/GzVi5gIOYgBrkoZypFjqIo7EO1/hRf6mQZHOy8NX1Cu0Q3UB3j2
	 2A1tVDmEp/gHJIA1NNQNBd6ufdnac9bfmFNc0UafR3r5SIm10gUUraL2LvYFco2DAc
	 wYwAf09GlntOnSFcidDlavFqtGBE5bpRH3LIUGYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Rob Clark <robdclark@chromium.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 122/129] dma-buf/sw_sync: Avoid recursive lock during fence signal
Date: Mon, 28 Aug 2023 12:13:21 +0200
Message-ID: <20230828101201.458721376@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit e531fdb5cd5ee2564b7fe10c8a9219e2b2fac61e ]

If a signal callback releases the sw_sync fence, that will trigger a
deadlock as the timeline_fence_release recurses onto the fence->lock
(used both for signaling and the the timeline tree).

To avoid that, temporarily hold an extra reference to the signalled
fences until after we drop the lock.

(This is an alternative implementation of https://patchwork.kernel.org/patch/11664717/
which avoids some potential UAF issues with the original patch.)

v2: Remove now obsolete comment, use list_move_tail() and
    list_del_init()

Reported-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Fixes: d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230818145939.39697-1-robdclark@gmail.com
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/sw_sync.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 348b3a9170fa4..7f5ed1aa7a9f8 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -191,6 +191,7 @@ static const struct dma_fence_ops timeline_fence_ops = {
  */
 static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 {
+	LIST_HEAD(signalled);
 	struct sync_pt *pt, *next;
 
 	trace_sync_timeline(obj);
@@ -203,21 +204,20 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 		if (!timeline_fence_signaled(&pt->base))
 			break;
 
-		list_del_init(&pt->link);
+		dma_fence_get(&pt->base);
+
+		list_move_tail(&pt->link, &signalled);
 		rb_erase(&pt->node, &obj->pt_tree);
 
-		/*
-		 * A signal callback may release the last reference to this
-		 * fence, causing it to be freed. That operation has to be
-		 * last to avoid a use after free inside this loop, and must
-		 * be after we remove the fence from the timeline in order to
-		 * prevent deadlocking on timeline->lock inside
-		 * timeline_fence_release().
-		 */
 		dma_fence_signal_locked(&pt->base);
 	}
 
 	spin_unlock_irq(&obj->lock);
+
+	list_for_each_entry_safe(pt, next, &signalled, link) {
+		list_del_init(&pt->link);
+		dma_fence_put(&pt->base);
+	}
 }
 
 /**
-- 
2.40.1



