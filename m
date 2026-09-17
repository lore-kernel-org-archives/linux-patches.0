Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C31C4D487C;
	Thu, 17 Sep 2026 19:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671827; cv=none; b=H//jkhkoIlgF42BZnXCeiJ47NAAWACArDx9WvhJdEjE/EmHb5Ro8AR8JrnibAIGWO5m8tvevhrVZgpE+n+MTR7VT6YYEUzpyEl4GYvGBLpfdJWYT0MeIZoeZ2Xa98WBO6bkP4mWIrt7PEeNur1gwSLPSTxVD6zpKfuxOhucVyGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671827; c=relaxed/simple;
	bh=ruE3kpxzf3+/kBB6bgy0NTQ0JRsBktmfrpI+Ll+g514=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHVGTPMDP1UAIfiFopntL3ReldYBNgRBXCLV2BQLJDJzC2hHl3M/l6x8ixvJuCBz9QTSFo0u3MoDi9f5oytmWKOh0+FZ4k3ZMw+v8rnseYantMwHqrOxheUcrYXeNI2V7/hnxCR5mSYjS0nfM3NKAjpEmLw2uHTt7BXaQ2LrG5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohdxhyfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohdxhyfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E171F000FF;
	Thu, 17 Sep 2026 19:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671825;
	bh=TI+jbajjWZedNKDFYEKizaL4TC7bDyAPF3JihiDkb3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohdxhyfDdTT7m3GehMFndfQbm21AWrdymGSM9HHusMqP0DQndousLLCkyvhWerI3S
	 AxdUH9LHyefT2NliEU4lBBXkAXhTF6ZcNEtxXFC+JsNkItmebMyyWBR8G7HCuTRJ6q
	 VktXG8bM/GgFUwKd9q+kQCzwXppJ5CVbiJo1yzhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.12 1102/1102] sched/eevdf: Fix augmented max_slice
Date: Thu, 17 Sep 2026 16:17:25 +0100
Message-ID: <20260917151608.541445217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

commit 9a8bc9bb4c3fb3218b4f151f98a722fbeb5b5c34 upstream.

Similarly to se->min_slice, init se->max_slice with se->slice before
enqueueing the entity so the augmented callback computes it correctly
at parent level.

Fixes: 6e3c0a4e1ad1 ("sched/fair: Fix lag clamp")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://patch.msgid.link/20260907123855.1297976-1-vincent.guittot@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -887,6 +887,8 @@ static void __enqueue_entity(struct cfs_
 	avg_vruntime_add(cfs_rq, se);
 	se->min_vruntime = se->vruntime;
 	se->min_slice = se->slice;
+	se->max_slice = se->slice;
+
 	rb_add_augmented_cached(&se->run_node, &cfs_rq->tasks_timeline,
 				__entity_less, &min_vruntime_cb);
 }


