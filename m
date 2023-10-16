Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C901B14288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwgoNivI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3DEC433C9;
	Mon, 16 Oct 2023 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467916;
	bh=gxnfP3rx6LqT+XpknAXg2pzj8E/vXRnJ1dcQcnN2V0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwgoNivIC6OzvJgWY3dBq89DE4Yud2E3J4n8gK/bGqKzhZotTdDcq1cKm36/8CH2+
	 jCZJL/u9u+/ExAfPqijiNzU8ssFvX+3TohbrvFl2Qdb8QUk8T4nm2vKkZkyQFzGwAk
	 psg5IF7uKwM6eM52GNmkRuuGu29TKFQCkpLB6tZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 091/191] workqueue: Override implicit ordered attribute in workqueue_apply_unbound_cpumask()
Date: Mon, 16 Oct 2023 10:41:16 +0200
Message-ID: <20231016084017.520011753@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit ca10d851b9ad0338c19e8e3089e24d565ebfffd7 ]

Commit 5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1
to be ordered") enabled implicit ordered attribute to be added to
WQ_UNBOUND workqueues with max_active of 1. This prevented the changing
of attributes to these workqueues leading to fix commit 0a94efb5acbb
("workqueue: implicit ordered attribute should be overridable").

However, workqueue_apply_unbound_cpumask() was not updated at that time.
So sysfs changes to wq_unbound_cpumask has no effect on WQ_UNBOUND
workqueues with implicit ordered attribute. Since not all WQ_UNBOUND
workqueues are visible on sysfs, we are not able to make all the
necessary cpumask changes even if we iterates all the workqueue cpumasks
in sysfs and changing them one by one.

Fix this problem by applying the corresponding change made
to apply_workqueue_attrs_locked() in the fix commit to
workqueue_apply_unbound_cpumask().

Fixes: 5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1 to be ordered")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e51ab3d4765eb..e4a37d7a6752d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5741,9 +5741,13 @@ static int workqueue_apply_unbound_cpumask(const cpumask_var_t unbound_cpumask)
 	list_for_each_entry(wq, &workqueues, list) {
 		if (!(wq->flags & WQ_UNBOUND))
 			continue;
+
 		/* creating multiple pwqs breaks ordering guarantee */
-		if (wq->flags & __WQ_ORDERED)
-			continue;
+		if (!list_empty(&wq->pwqs)) {
+			if (wq->flags & __WQ_ORDERED_EXPLICIT)
+				continue;
+			wq->flags &= ~__WQ_ORDERED;
+		}
 
 		ctx = apply_wqattrs_prepare(wq, wq->unbound_attrs, unbound_cpumask);
 		if (!ctx) {
-- 
2.40.1



