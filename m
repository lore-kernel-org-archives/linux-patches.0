Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11629469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87570C433C8;
	Mon, 28 Aug 2023 10:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218908;
	bh=ki5xnY9fCWPhU2B5LWi3NM7BEOI3j4CSWvpRN5PqFGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ws6wH3I9TcPiFnKMql1OhckCD7WGx8wpHhx6f6mHtq99SrNQyMvXJTg64wcObpim1
	 vZG5OC6m/jIp2fS/S+SNvuKmDDEhydzgXo6vzUa9DeS/3V6SDa/fyD8Qv1wLBciLnT
	 ACMOd0vkU1PeV3u6a+4BcDMD6KMNkAsh2EQTEzTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Rob Clark <robdclark@chromium.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/122] dma-buf/sw_sync: Avoid recursive lock during fence signal
Date: Mon, 28 Aug 2023 12:13:52 +0200
Message-ID: <20230828101200.311507972@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



